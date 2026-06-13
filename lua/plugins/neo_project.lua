local datafile = vim.fn.stdpath("data") .. "/neovim-project/projects.json"
local lrufile = vim.fn.stdpath("data") .. "/neovim-project/project_lru.json"
local deletedfile = vim.fn.stdpath("data") .. "/neovim-project/project_deleted.json"
local lrulockdir = lrufile .. ".lock"

local function contains(tbl, value)
    return vim.tbl_contains(tbl, value)
end

local function project_key(project)
    if type(project) ~= "string" or project == "" then
        return nil
    end

    local absolute = vim.fn.fnamemodify(vim.fn.expand(project), ":p")
    absolute = absolute:gsub("/+$", "")

    if absolute == "" then
        absolute = "/"
    end

    local resolved = vim.fn.resolve(absolute)
    if resolved ~= "" then
        absolute = resolved:gsub("/+$", "")
    end

    if vim.fn.has("macunix") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
        absolute = absolute:lower()
    end

    return absolute
end

local function normalize_project(dir)
    local expanded = vim.fn.expand(dir)
    local absolute = vim.fn.fnamemodify(expanded, ":p")
    absolute = absolute:gsub("/+$", "")

    if absolute == "" then
        absolute = "/"
    end

    if vim.fn.isdirectory(absolute) ~= 1 then
        return nil, ("Project directory does not exist: %s"):format(dir)
    end

    return vim.fn.fnamemodify(absolute, ":~")
end

local function dedupe_projects(projects)
    local seen = {}
    local deduped = {}

    for _, project in ipairs(projects) do
        local key = project_key(project)
        if key ~= nil and not seen[key] then
            seen[key] = true
            table.insert(deduped, project)
        end
    end

    return deduped
end

local function read_dynamic_projects()
    if vim.fn.filereadable(datafile) ~= 1 then
        return {}
    end

    local ok, lines = pcall(vim.fn.readfile, datafile)
    if not ok then
        return {}
    end

    local raw = table.concat(lines, "\n")
    if raw == "" then
        return {}
    end

    local decoded_ok, decoded = pcall(vim.json.decode, raw)
    if not decoded_ok or type(decoded) ~= "table" then
        vim.notify("Failed to decode neovim-project dynamic projects", vim.log.levels.WARN)
        return {}
    end

    local projects = {}
    for _, project in ipairs(decoded) do
        local normalized = normalize_project(project)
        if normalized ~= nil then
            table.insert(projects, normalized)
        end
    end

    return dedupe_projects(projects)
end

local function write_dynamic_projects(projects)
    vim.fn.mkdir(vim.fn.fnamemodify(datafile, ":h"), "p")
    vim.fn.writefile({ vim.json.encode(dedupe_projects(projects)) }, datafile)
end

local function read_json_list(file)
    if vim.fn.filereadable(file) ~= 1 then
        return {}
    end

    local ok, lines = pcall(vim.fn.readfile, file)
    if not ok then
        return {}
    end

    local raw = table.concat(lines, "\n")
    if raw == "" then
        return {}
    end

    local decoded_ok, decoded = pcall(vim.json.decode, raw)
    if not decoded_ok or type(decoded) ~= "table" then
        return {}
    end

    return decoded
end

local function write_json_list(file, items)
    local dir = vim.fn.fnamemodify(file, ":h")
    local uv = vim.uv or vim.loop
    local tmpfile = ("%s.tmp.%d.%d"):format(file, vim.fn.getpid(), uv.hrtime())

    vim.fn.mkdir(dir, "p")
    vim.fn.writefile({ vim.json.encode(items) }, tmpfile)
    vim.fn.rename(tmpfile, file)
end

local function read_lru_projects()
    local projects = {}

    for _, project in ipairs(read_json_list(lrufile)) do
        local normalized = normalize_project(project)
        if normalized ~= nil then
            table.insert(projects, normalized)
        end
    end

    return dedupe_projects(projects)
end

local function write_lru_projects(projects)
    write_json_list(lrufile, dedupe_projects(projects))
end

local function read_deleted_projects()
    return dedupe_projects(read_json_list(deletedfile))
end

local function write_deleted_projects(projects)
    write_json_list(deletedfile, dedupe_projects(projects))
end

local with_lru_lock

local function remove_project(projects, target)
    local target_key = project_key(target)
    if target_key == nil then
        return projects
    end

    local filtered = {}
    for _, project in ipairs(projects) do
        if project_key(project) ~= target_key then
            table.insert(filtered, project)
        end
    end

    return filtered
end

local function clear_deleted_project(project)
    write_deleted_projects(remove_project(read_deleted_projects(), project))
end

local function mark_project_deleted(project)
    local normalized = normalize_project(project) or project

    with_lru_lock(function()
        local deleted_projects = remove_project(read_deleted_projects(), normalized)
        table.insert(deleted_projects, 1, normalized)
        write_deleted_projects(deleted_projects)

        write_lru_projects(remove_project(read_lru_projects(), normalized))
        write_dynamic_projects(remove_project(read_dynamic_projects(), normalized))
    end)
end

local function filter_deleted_projects(projects)
    local deleted = {}
    for _, project in ipairs(read_deleted_projects()) do
        local key = project_key(project)
        if key ~= nil then
            deleted[key] = true
        end
    end

    local filtered = {}
    for _, project in ipairs(projects) do
        if not deleted[project_key(project)] then
            table.insert(filtered, project)
        end
    end

    return filtered
end

with_lru_lock = function(fn)
    vim.fn.mkdir(vim.fn.fnamemodify(lrufile, ":h"), "p")

    for _ = 1, 20 do
        if vim.fn.mkdir(lrulockdir) == 1 then
            local ok, result = pcall(fn)
            vim.fn.delete(lrulockdir, "d")
            if not ok then
                error(result)
            end
            return result
        end
        vim.wait(10)
    end

    return fn()
end

local function touch_project_lru(project)
    local normalized = normalize_project(project)
    if normalized == nil then
        return
    end

    with_lru_lock(function()
        clear_deleted_project(normalized)

        local projects = read_lru_projects()
        table.insert(projects, 1, normalized)

        if #projects > 100 then
            projects = vim.list_slice(dedupe_projects(projects), 1, 100)
        end

        write_lru_projects(projects)
    end)
end

local function seed_project_lru()
    if vim.fn.filereadable(lrufile) == 1 then
        return
    end

    local history = require("neovim-project.utils.history")
    local recent_projects = history.get_recent_projects()
    local projects = {}

    for index = #recent_projects, 1, -1 do
        table.insert(projects, recent_projects[index])
    end

    write_lru_projects(projects)
end

local function extend_projects(projects)
    local merged = read_dynamic_projects()
    vim.list_extend(merged, vim.deepcopy(projects or {}))
    return dedupe_projects(merged)
end

local function get_project_visit_rank()
    local rank = {}
    local recent_projects = read_lru_projects()

    for index, project in ipairs(recent_projects) do
        local key = project_key(project)
        if key ~= nil then
            rank[key] = index
        end
    end

    return rank, #recent_projects
end

local function project_visit_time_sorter(opts)
    local sorters = require("telescope.sorters")
    local conf = require("telescope.config").values
    local fuzzy_sorter = conf.generic_sorter(opts or {})
    local visit_rank = {}
    local fallback_rank = 1

    return sorters.Sorter:new({
        init = function()
            local recent_count
            visit_rank, recent_count = get_project_visit_rank()
            fallback_rank = recent_count + 1
            fuzzy_sorter:_init()
        end,
        start = function(_, prompt)
            if prompt == "" then
                local recent_count
                visit_rank, recent_count = get_project_visit_rank()
                fallback_rank = recent_count + 1
            end
            fuzzy_sorter:_start(prompt)
        end,
        finish = function(_, prompt)
            fuzzy_sorter:_finish(prompt)
        end,
        destroy = function()
            fuzzy_sorter:_destroy()
        end,
        discard = fuzzy_sorter.discard,
        scoring_function = function(_, prompt, line, entry, cb_add, cb_filter)
            if prompt == "" then
                return visit_rank[project_key(entry.value)] or fallback_rank
            end
            return fuzzy_sorter:scoring_function(prompt, line, entry, cb_add, cb_filter)
        end,
        highlighter = function(_, prompt, display)
            if prompt == "" or fuzzy_sorter.highlighter == nil then
                return {}
            end
            return fuzzy_sorter:highlighter(prompt, display)
        end,
    })
end

local function patch_runtime_project_source()
    local path = require("neovim-project.utils.path")
    if path._dynamic_projects_patched then
        return
    end

    path.short_path = function(project_path)
        local absolute = vim.fn.fnamemodify(project_path, ":p")
        absolute = absolute:gsub("/+$", "")
        if absolute == "" then
            absolute = "/"
        end
        return vim.fn.fnamemodify(absolute, ":~")
    end

    local original_get_all_projects = path.get_all_projects
    path.get_all_projects = function()
        local projects = read_dynamic_projects()
        vim.list_extend(projects, original_get_all_projects())
        return dedupe_projects(projects)
    end
    path._dynamic_projects_patched = true
end

local function patch_project_visit_tracking()
    local project = require("neovim-project.project")
    local history = require("neovim-project.utils.history")
    if project._visit_tracking_patched then
        return
    end

    if not history._lru_visit_tracking_patched then
        local original_add_session_project = history.add_session_project
        history.add_session_project = function(dir)
            touch_project_lru(dir)
            return original_add_session_project(dir)
        end
        history._lru_visit_tracking_patched = true
    end

    if not history._shared_delete_patched then
        local original_delete_project = history.delete_project
        history.delete_project = function(dir)
            mark_project_deleted(dir)
            return original_delete_project(dir)
        end
        history._shared_delete_patched = true
    end

    local original_switch_project = project.switch_project
    project.switch_project = function(dir)
        if dir ~= nil then
            touch_project_lru(dir)
        end
        return original_switch_project(dir)
    end

    project._visit_tracking_patched = true
end

local function patch_history_dynamic_projects()
    local history = require("neovim-project.utils.history")
    if history._dynamic_projects_patched then
        return
    end

    local original_get_recent_projects = history.get_recent_projects
    history.get_recent_projects = function()
        local projects = original_get_recent_projects()
        local dynamic_projects = read_dynamic_projects()
        local lru_projects = read_lru_projects()

        -- The history picker reverses this list before displaying it. Appending
        -- shared projects from oldest to newest keeps newly added projects first.
        for index = #dynamic_projects, 1, -1 do
            table.insert(projects, dynamic_projects[index])
        end
        for index = #lru_projects, 1, -1 do
            table.insert(projects, lru_projects[index])
        end

        return filter_deleted_projects(dedupe_projects(projects))
    end

    history._dynamic_projects_patched = true
end

local function patch_project_telescope_sorter()
    local extension = require("telescope").extensions["neovim-project"]
    if extension._lru_sorter_patched then
        return
    end

    for _, name in ipairs({ "neovim-project", "history", "discover" }) do
        local original = extension[name]
        extension[name] = function(opts)
            opts = vim.tbl_extend("force", opts or {}, {
                sorter = project_visit_time_sorter(opts),
            })
            return original(opts)
        end
    end

    extension._lru_sorter_patched = true
end

local function create_add_command()
    local uv = vim.uv or vim.loop

    if vim.fn.exists(":NeovimProjectAdd") == 2 then
        vim.api.nvim_del_user_command("NeovimProjectAdd")
    end

    vim.api.nvim_create_user_command("NeovimProjectAdd", function(args)
        local target = args.args ~= "" and args.args or uv.cwd()
        local normalized, err = normalize_project(target)
        if normalized == nil then
            vim.notify(err, vim.log.levels.ERROR)
            return
        end

        local path = require("neovim-project.utils.path")
        local config = require("neovim-project.config")
        local history = require("neovim-project.utils.history")
        local all_projects = path.get_all_projects()
        if contains(all_projects, normalized) then
            vim.notify(("Project already registered: %s"):format(normalized), vim.log.levels.INFO)
            return
        end

        local dynamic_projects = read_dynamic_projects()
        table.insert(dynamic_projects, 1, normalized)
        write_dynamic_projects(dynamic_projects)
        table.insert(config.options.projects, normalized)
        history.add_session_project(normalized)

        vim.notify(("Added project: %s"):format(normalized), vim.log.levels.INFO)
    end, {
        nargs = "?",
        complete = "dir",
        desc = "Add a project to neovim-project dynamically",
    })
end

return {
    "coffebar/neovim-project",
    commit = "db586796f67e206f0494b1d64492b1db8c109589",
    -- commit = "33a5d6ef5f9e035470c80cbec0bbfe23e776543c",
    opts = {
        filetype_autocmd_timeout = 0,
        last_session_on_startup = true,
        projects = { -- define project roots
            -- "/usr/local/share/nvim/runtime/lua/vim",
            "/Users/xzb/Project/lua/lua/fzf-lua",
            "/Users/xzb/Project/lua/fork/*",
            "/Users/xzb/.config/fish/",
            "/Users/xzb/Project/lua/origin/nvim-cmp",
            "/Users/xzb/Project/lua/oricmp/nvim-cmp",
            "/Users/xzb/Project/js",
            "/Users/xzb/Project/lua/color/nvim-cmp",
            "~/Project/rust/*",
            "~/raycast/*",
            "/Users/xzb/Project/Rust/myneovide/hello/",
            "/Users/xzb/Project/Python/engine/sglang/python/sglang",
            "/Users/xzb/Project/Python/engine/vllm/vllm/",
            "/Users/xzb/Project/Python/engine/vllm/vllm_go",
            -- "/Users/xzb/Project/Python/woa/*",
            "/Users/xzb/Project/tencent/demo/*",
            "/opt/homebrew/lib/python3.11/site-packages/transformers/",
            "/Users/xzb/Project/obsidian/tencent_notes",
            "/Users/xzb/Downloads/nvim-macos-arm64/share/nvim/runtime",
            "/Users/xzb/Project/tencent/*",
            "/Users/xzb/Project/Python/engine/*",
            "/Users/xzb/Project/Python/engine/sglang_visual",
            "/Users/xzb/Project/Rust/my_repo_neovide/neovide/",
            "/Users/xzb/Project/Python/PaddleX/Paddle/paddle/",
            "/Users/xzb/Project/Python/PaddleX/paddlex_processors_rust",
            "/Users/xzb/Documents/xzbdmw的副本",
            "~/Project/vim/*",
            "~/Project/lua/*",
            "~/Project/Typescript/*",
            "~/Project/Go/*",
            "~/Project/C/*",
            "~/Project/C++/*",
            -- "/Users/xzb/Downloads/nvim-macos-arm64/share/nvim/runtime/lua/vim",
            "/Users/xzb/neovim/share/nvim/runtime/lua/vim",
            "/Users/xzb/Downloads/lih-admin_2",
            "/Users/xzb/.local/share/nvim/lazy/*",
            "/Users/xzb/.local/share/nvimlazy/lazy/LazyVim",
            -- "/Users/xzb/.local/share/nvim_rust/lazy/*",
            "~/Project/java/*",
            "~/Projects/*",
            "~/Project/Swift/*",
            "~/Project/Js/*",
            "~/Project/zig/*",
            "~/Project/Typescript/*",
            "~/Project/Python/*",
            "~/.config/*",
        },
        session_manager_opts = {
            autosave_ignore_dirs = {
                vim.fn.expand("~"), -- don't create a session for $HOME/
                "/tmp",
            },
            autosave_ignore_filetypes = {
                -- All buffers of these file types will be closed before the session is saved
                "ccc-ui",
                "gitcommit",
                "gitrebase",
                "qf",
                "toggleterm",
            },
        },
    },
    config = function(_, opts)
        opts.projects = extend_projects(opts.projects)
        require("neovim-project").setup(opts)
        patch_runtime_project_source()
        seed_project_lru()
        patch_project_visit_tracking()
        patch_history_dynamic_projects()
        patch_project_telescope_sorter()
        create_add_command()
    end,
    cond = function()
        return not vim.g.scrollback
    end,
    init = function()
        -- enable saving the state of plugins in the session
        vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
        { "Shatur/neovim-session-manager" },
        { "nvim-tree/nvim-tree" },
        -- { dir = "~/Project/lua/telescope.nvim/" },
    },
    lazy = false,
    priority = 10000000,
}
