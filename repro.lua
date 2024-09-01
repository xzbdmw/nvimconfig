-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- ssssssssss
-- Add any additional options here
vim.g.root_spec = { "cwd" }
vim.o.shell = "/opt/homebrew/bin/fish"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.synmaxcol = 300
-- https://github.com/Shatur/neovim-session-manager/issues/47#issuecomment-1195760661
vim.o.sessionoptions = "folds,buffers,curdir,help,tabpages,terminal,winsize,winpos,resize"
vim.opt.relativenumber = true
-- vim.opt.inccommand = "split"
vim.opt.pumblend = 0
vim.opt.shiftwidth = 4
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.list = false
vim.opt.backupcopy = "yes"
vim.g.editorconfig = false
vim.opt.backupdir = "/Users/xzb/.local/state/nvim/backup//"
vim.opt.tabstop = 4
vim.opt.jumpoptions = "stack,view"
-- vim.o.guifont = "menlo,Symbols Nerd Font:h18.5"
--[[ vim.o.guifont = "mcv sans mono,Symbols Nerd Font:h18.5"
vim.o.guifont = "JetBrains Mono light,Symbols Nerd Font:h19"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-subpixelantialias:#h-none"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20:#e-antialias:#h-normal"
vim.o.guifont = "hack,Symbols Nerd Font:h20:#e-subpixelantialias:#h-full"
vim.o.guifont = "JetBrains Mono freeze freeze,Symbols Nerd Font:h20"
vim.g.winblend = 0
vim.opt.linespace = 11 ]]
vim.opt.linespace = 5
vim.o.conceallevel = 0
vim.opt.guicursor = "n-sm-ve:block,i-c-ci:ver18,r-cr-v-o:hor7"
vim.opt.timeoutlen = 500
vim.opt.laststatus = 0
vim.o.scrolloff = 6
vim.g.neovide_text_gamma = 1.4
vim.opt.swapfile = false
-- vim.o.incsearch = false
-- vim.opt.inccommand = "split"
local str = string.rep(" ", vim.api.nvim_win_get_width(0))
vim.opt.statusline = str
vim.g.loaded_matchparen = 1
-- vim.opt.linebreak = true
vim.g.cmp_completion = true
-- Neovide
vim.g.neovide_unlink_border_highlights = false
vim.g.neovide_transparency = 1
vim.g.neovide_remember_window_size = true
vim.g.neovide_position_animation_length = 0
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_floating_shadow = true
vim.g.neovide_underline_stroke_scale = 2
vim.g.neovide_flatten_floating_zindex = "20,30,51,52"
vim.g.neovide_floating_z_height = 18
vim.g.neovide_light_angle_degrees = 180
-- vim.g.neovide_light_radius = 90
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_touch_deadzone = 0
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
vim.g.neovide_hide_mouse_when_typing = true
vim.g.rustaceanvim = {
    server = {
        cmd = function()
            return { "rust-analyzer" }
        end,
        -- trace = {
        --     server = "verbose",
        -- },
        settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
                -- trace = {
                --     server = "verbose",
                -- },
                -- server = {
                --     extraEnv = {
                --         RA_LOG = "info",
                --         RA_LOG_FILE = "/Users/xzb/Downloads/ra.log",
                --     },
                -- },
                completion = {
                    -- callable = {
                    --     snippets = "add_parentheses",
                    -- },
                    fullFunctionSignatures = {
                        enable = true,
                    },
                    privateEditable = {
                        enable = true,
                    },
                },
                procMacro = {
                    ignored = {
                        tokio_macros = {
                            "main",
                            "test",
                        },
                        tracing_attributes = {
                            "instrument",
                        },
                    },
                },
                inlayHints = {
                    parameterHints = false,
                    closureReturnTypeHints = "with_block",
                },
                workspace = {
                    symbol = {
                        search = {
                            -- scope = "workspace_and_dependencies",
                            -- scope = "workspace",
                        },
                    },
                },
            },
        },
    },
    tools = {
        hover_actions = {
            replace_builtin_hover = true,
        },
        float_win_config = {
            border = "none",
            max_width = 140,
            max_height = 15,
            auto_focus = false,
            winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
        },
    },
}
local root = vim.fn.fnamemodify("./.repro", ":p")

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)
local CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}
local function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then
        return nil
    else
        return i - 1
    end
end

--[[ local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
        end
        local last = findLast(detail, "%:")
        if last then
            local last_item = detail:sub(last + 1, #detail - 1)
            detail = detail:sub(1, last - 2)
            detail = last_item .. " " .. detail
            detail = "(" .. detail .. ")"
        else
            detail = "(" .. detail
        end
    end
    return detail
end ]]
local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
            detail = "(" .. detail
        end
    end
    return detail
end

local function match_fn(description)
    return string.match(description, "^pub fn")
        or string.match(description, "^fn")
        or string.match(description, "^unsafe fn")
        or string.match(description, "^pub unsafe fn")
        or string.match(description, "^pub const unsafe fn")
        or string.match(description, "^const fn")
        or string.match(description, "^pub const fn")
end

local function rust_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local completion_item = entry:get_completion_item()
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number

    local label_detail = completion_item.labelDetails
    if item_kind == 3 or item_kind == 2 then -- Function/Method
        --[[ labelDetails.
        function#function#if detail: {
          description = "pub fn shl(self, rhs: Rhs) -> Self::Output",
          detail = " (use std::ops::Shl)"
        } ]]
        if label_detail then
            local detail = label_detail.detail
            detail = trim_detail(detail)
            local description = label_detail.description
            if description then
                if string.sub(description, #description, #description) == "," then
                    description = description:sub(1, #description - 1)
                end
            end
            if
                (detail and vim.startswith(detail, "macro")) or (description and vim.startswith(description, "macro"))
            then
                kind.concat = kind.abbr
                goto OUT
            end
            if detail and description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "(", nil, true)
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                -- description: "macro simd_swizzle"
                -- detail: " (use std::simd::simd_swizzle)"
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " " .. detail
                    kind.concat = "fn " .. prefix .. description .. "{}//" .. detail
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                end
            elseif detail then
                kind.concat = "fn " .. kind.abbr .. "{}//" .. detail
                kind.abbr = kind.abbr .. " " .. detail
            elseif description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "%(")
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " "
                    kind.concat = "fn " .. prefix .. description .. "{}//"
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. description
                    kind.abbr = kind.abbr .. " " .. description
                end
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 15 then
    elseif item_kind == 5 then -- Field
        local detail = completion_item.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "struct S {" .. kind.abbr .. ": " .. detail .. "}"
            kind.abbr = kind.abbr .. ": " .. detail
        else
            kind.concat = "struct S {" .. kind.abbr .. ": String" .. "}"
        end
        kind.offset = 10
    elseif item_kind == 6 or item_kind == 21 then -- variable constant
        if label_detail then
            local detail = label_detail.description
            if detail then
                kind.concat = "let " .. kind.abbr .. ": " .. detail
                kind.abbr = kind.abbr .. ": " .. detail
                kind.offset = 4
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 9 then -- Module
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
            kind.offset = 0
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 8 then -- Trait
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "trait " .. kind.abbr .. "{}//" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = "trait " .. kind.abbr .. "{}"
            kind.abbr = kind.abbr
        end
        kind.offset = 6
    elseif item_kind == 22 then -- Struct
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 1 then -- "Text"
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 14 then
        if kind.abbr == "mut" then
            kind.concat = "let mut"
            kind.offset = 4
        else
            kind.concat = kind.abbr
        end
    else
        --[[ if label_detail then
            local detail = label_detail.detail
            local description = label_detail.description
            if detail then
                kind.abbr = kind.abbr .. " " .. detail
            end
            if description then
                kind.abbr = kind.abbr .. " " .. description
            end
        end
        if completion_item.detail then
            kind.abbr = kind.abbr .. " " .. completion_item.detail
        end ]]
        kind.concat = kind.abbr
    end
    if item_kind == 15 then
        kind.concat = ""
    end
    ::OUT::
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 60 then
        kind.abbr = kind.abbr:sub(1, 60)
    end

    return kind
end

local function lua_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    if item_kind == 5 then -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local function c_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()
    if item_kind == 5 then -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local function go_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()

    local detail = completion_item.detail
    if item_kind == 5 then -- Field
        if detail then
            local last = findLast(kind.abbr, "%.")
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "type T struct{" .. space_hole .. catstr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            else
                kind.concat = "type T struct{" .. kind.abbr .. " " .. detail .. "}"
                kind.offset = 14
                kind.abbr = kind.abbr .. " " .. detail
            end
        else
            kind.concat = "type T struct{" .. kind.abbr .. " " .. "}"
            kind.offset = 14
            kind.abbr = kind.abbr .. " " .. detail
        end
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 6 or item_kind == 21 then -- Variable
        local last = findLast(kind.abbr, "%.")
        if detail then
            if last then
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "var " .. space_hole .. catstr .. " " .. detail
                kind.offset = 4
                kind.abbr = kind.abbr .. " " .. detail
            else
                if detail then
                    kind.concat = "var " .. kind.abbr .. " " .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                    kind.offset = 4
                end
            end
        end
    elseif item_kind == 22 then -- Struct
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " struct{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " struct{}"
        else
            kind.concat = "type " .. kind.abbr .. " struct{}"
            kind.abbr = kind.abbr .. " struct{}"
            kind.offset = 5
        end
    elseif item_kind == 3 or item_kind == 2 then -- Function/Method
        local last = findLast(kind.abbr, "%.")
        if last then
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                local catstr = kind.abbr:sub(last + 1, #kind.abbr)
                local space_hole = string.rep(" ", last)
                kind.concat = "func " .. space_hole .. catstr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.offset = 5
            end
        else
            if detail then
                detail = detail:sub(5, #detail)
                kind.abbr = kind.abbr .. detail
                kind.concat = "func " .. kind.abbr .. "{}"
                kind.offset = 5
            else
                kind.concat = "func " .. kind.abbr .. "(){}"
                kind.abbr = kind.abbr
                kind.offset = 5
            end
        end
    elseif item_kind == 9 then -- Module
        if detail then
            kind.offset = 6 - #kind.abbr
            kind.abbr = kind.abbr .. " " .. detail
            kind.concat = "import " .. detail
        end
    elseif item_kind == 8 then -- Interface
        local last = findLast(kind.abbr, "%.")
        if last then
            local catstr = kind.abbr:sub(last + 1, #kind.abbr)
            local space_hole = string.rep(" ", last)
            kind.concat = "type " .. space_hole .. catstr .. " interface{}"
            kind.offset = 5
            kind.abbr = kind.abbr .. " interface{}"
        else
            kind.concat = "type " .. kind.abbr .. " interface{}"
            kind.abbr = kind.abbr .. " interface{}"
            kind.offset = 5
        end
    else
        kind.concat = kind.abbr
    end
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = ""
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local expand = true

-- install plugins
local plugins = {
    -- do not remove the colorscheme!
    { "folke/tokyonight.nvim" },
    {
        "otavioschwanck/arrow.nvim",
        enabled = false,
        -- commit = "f3d8470580ecbd5778a68091eca8d5da304f2e2a",
        -- dir = "/Users/xzb/Project/lua/arrow.nvim/",
        -- dir = "/Users/xzb/Project/lua/fork/arrow.nvim/",
        -- event = "VeryLazy",
        -- keys = {
        --     { "," },
        -- },
        lazy = false,
        opts = {
            per_buffer_config = {
                sort_automatically = true,
                treesitter_context = {
                    line_shift_down = 1,
                },
                satellite = {
                    enable = true,
                    overlap = true,
                    priority = 1000,
                },
                lines = 7,
                zindex = 20,
            },
            buffer_leader_key = "'",
            show_icons = true,
            leader_key = ";", -- Recommended to be a single key
            -- index_keys = "123jklafghAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
            hide_handbook = true,
            window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
                width = "auto",
                height = "auto",
                row = 10,
                col = 62,
                border = "none",
            },
        },
        config = function(_, opts)
            require("arrow").setup(opts)
            vim.keymap.set("n", "mn", "<cmd>Arrow next_buffer_bookmark<CR>")
            vim.keymap.set("n", "mp", "<cmd>Arrow prev_buffer_bookmark<CR>")
        end,
    },
    { dir = "/Users/xzb/.local/share/nvim/lazy/cmp-nvim-lsp" },
    {
        -- "hrsh7th/nvim-cmp",
        -- enabled = false,
        version = false, -- last release is way too old
        event = { "InsertEnter", "CmdlineEnter" },
        dir = "/Users/xzb/.local/share/nvim/lazy/nvim-cmp",
        dependencies = {
            "zbirenbaum/copilot-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
        },
        opts = function()
            local reverse_prioritize = function(entry1, entry2)
                local is_snip = entry1.get_completion_item().insertTextFormat == 2
                if entry1.source.name == "copilot" and entry2.source.name ~= "copilot" then
                    return false
                elseif entry2.copilot == "copilot" and entry1.source.name ~= "copilot" then
                    return true
                end
            end
            local put_down_snippet = function(entry1, entry2)
                local types = require("cmp.types")
                local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
                local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
                kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
                kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
                if kind1 ~= kind2 then
                    if kind1 == types.lsp.CompletionItemKind.Snippet then
                        return false
                    end
                    if kind2 == types.lsp.CompletionItemKind.Snippet then
                        return true
                    end
                end
                return nil
            end
            local cmp = require("cmp")
            local compare = cmp.config.compare
            return {
                --[[ enabled = function()
                local ft = vim.bo.filetype
                if ft == nil or ft == "" then
                    return true
                end
            end, ]]
                preselect = cmp.PreselectMode.None,
                window = {
                    completion = cmp.config.window.bordered({
                        border = "none",
                        side_padding = 0,
                        col_offset = -3,
                        winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalFloat",
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "none",
                        winhighlight = "CursorLine:MyCursorLine,Normal:MyNormalDocFloat",
                        col_offset = 0,
                        side_padding = 0,
                    }),
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
                    docs = {
                        auto_open = false,
                    },
                },
                performance = {
                    debounce = 0,
                    throttle = 0,
                    fetching_timeout = 10000,
                    confirm_resolve_timeout = 80,
                    async_budget = 1,
                    max_view_entries = 20,
                },
                snippet = {
                    expand = function(args)
                        if not expand then
                            local function remove_bracket_contents(input)
                                local pattern = "^(.*)%b().*$"
                                local result = string.gsub(input, pattern, "%1")
                                return result
                            end
                            args.body = remove_bracket_contents(args.body)
                            expand = true
                        end
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<D-d>"] = cmp.mapping(function()
                        if cmp.visible_docs() then
                            cmp.close_docs()
                        else
                            cmp.open_docs()
                        end
                    end),
                    ["<right>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            expand = false
                            cmp.confirm()
                        else
                            fallback()
                        end
                        _G.has_moved_up = false
                    end),
                    ["<space>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.close()
                            fallback()
                        else
                            fallback()
                        end
                        pcall(_G.indent_update)
                        pcall(_G.mini_indent_auto_draw)
                        _G.has_moved_up = false
                    end),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        end
                        _G.has_moved_up = false
                        vim.schedule(fallback)
                    end),
                    ["<f7>"] = cmp.mapping(function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end),
                    ["<C-9>"] = cmp.mapping.complete(),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        fallback()
                    end, { "i", "v", "n" }),
                    ["<down>"] = function(fallback)
                        if cmp.visible() then
                            if cmp.core.view.custom_entries_view:is_direction_top_down() then
                                -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                                cmp.select_next_item()
                            else
                                cmp.select_prev_item()
                            end
                        else
                            fallback()
                        end
                    end,
                    ["<up>"] = function(fallback)
                        if cmp.visible() then
                            if cmp.core.view.custom_entries_view:is_direction_top_down() then
                                cmp.select_prev_item()
                            else
                                cmp.select_next_item()
                            end
                        else
                            fallback()
                        end
                    end,
                    ["<C-e>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        else
                            fallback()
                        end
                        _G.has_moved_up = false
                    end),
                    ["<C-7>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.close_docs()
                        else
                            fallback()
                        end
                    end),
                    -- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        -- cmp.complete()
                        else
                            fallback()
                        end
                        pcall(_G.indent_update)
                        pcall(_G.mini_indent_auto_draw)
                        _G.has_moved_up = false
                    end),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = "path" },
                    -- { name = "luasnip" },
                    -- { name = "copilot" },
                }, {
                    -- { name = "buffer" },
                }),
                formatting = {
                    -- kind is icon, abbr is completion name, menu is [Function]
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local function commom_format(e, item)
                            local kind = require("lspkind").cmp_format({
                                mode = "symbol_text",
                                -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                            })(e, item)
                            local strings = vim.split(kind.kind, "%s", { trimempty = true })
                            kind.kind = " " .. (strings[1] or "") .. " "
                            kind.menu = ""
                            kind.concat = kind.abbr
                            return kind
                        end
                        if vim.bo.filetype == "rust" then
                            return rust_fmt(entry, vim_item)
                        elseif vim.bo.filetype == "lua" then
                            return lua_fmt(entry, vim_item)
                        elseif vim.bo.filetype == "go" then
                            return go_fmt(entry, vim_item)
                        else
                            return commom_format(entry, vim_item)
                        end
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                    -- ghost_text = false,
                },
                sorting = {
                    compare.order,
                    comparators = {
                        cmp.config.compare.exact,
                        put_down_snippet,
                        compare.score,
                        compare.recently_used,
                        compare.locality,
                        compare.offset,
                    },
                },
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup.filetype({ "markdown" }, {
                completion = {
                    autocomplete = false,
                },
            })

            cmp.setup.filetype({ "query" }, {
                sources = {
                    { name = "treesitter" },
                },
            })
            for _, source in ipairs(opts.sources) do
                source.group_index = source.group_index or 1
            end
            cmp.setup.cmdline("/", {
                -- completion = {
                --     autocomplete = false,
                -- },
                mapping = cmp.mapping.preset.cmdline({
                    ["<CR>"] = cmp.mapping({
                        i = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ select = false }),
                    }),
                    ["<down>"] = {
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<up>"] = {
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i", "c" }),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i", "c" }),
                }),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline({
                    ["<CR>"] = cmp.mapping({
                        i = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ select = false }),
                    }),
                    ["<Down>"] = {
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<up>"] = {
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end,
                    },
                    ["<Esc>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.close()
                            else
                                vim.api.nvim_feedkeys(
                                    vim.api.nvim_replace_termcodes("<C-c>", true, true, true),
                                    "n",
                                    true
                                )
                            end
                        end,
                    }),

                    ["<C-p>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i", "c" }),
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i", "c" }),
                }),
                sources = cmp.config.sources({
                    { name = "cmdline", keyword_length = 2 },
                    { name = "path" },
                }),
            })
            require("cmp").setup(opts)
            --[[ local capabilities = require("cmp_nvim_lsp").default_capabilities() --nvim-cmp
        -- Setup lspconfig.
        local nvim_lsp = require("lspconfig")

        -- setup languages
        -- GoLang
        nvim_lsp["gopls"].setup({
            cmd = { "gopls" },
            -- on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        -- parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    semanticTokens = true,
                    experimentalPostfixCompletions = false,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = false,
                },
            },
            init_options = {
                -- usePlaceholders = false,
                usePlaceholders = true,
                completeFunctionCalls = true,
            },
        }) ]]
        end,
    },
    {
        { "mfussenegger/nvim-lint", enabled = false },
        { "folke/todo-comments.nvim", enabled = false },
        { "folke/flash.nvim", enabled = false },
        { "nvim-focus/focus.nvim", enabled = false },
        { "echasnovski/mini.indentscope", enabled = false },
        { "echasnovski/mini.ai", enabled = false },
        -- { "nvim-treesitter/nvim-treesitter", enabled = false },
        { "nvim-ts-autotag", enabled = false },
        { "novim/nvim-lspconfig", enabled = false },
        { "williamboman/mason.nvim", enabled = false },
        { "williamboman/mason-lspconfig.nvim", enabled = false },
        { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
        { "nvimdev/dashboard-nvim", enabled = false },
        { "folke/noice.nvim", enabled = false },
        { "nvim-treesitter/nvim-treesitter-context", enabled = false },
        { "folke/which-key.nvim", enabled = false },
        { "RRethy/vim-illuminate", enabled = false },
        { "nvim-pack/nvim-spectre", enabled = false },
        { "lewis6991/gitsigns.nvim", enabled = false },
        { "ggandor/leap.nvim", enabled = false },
        { "rcarriga/nvim-notify", enabled = false },
        { "mg979/vim-visual-multi", enabled = false },
        { "folke/persistence.nvim", enabled = false },
        { "lukas-reineke/indent-blankline.nvim", enabled = false },
        { "nvim-neo-tree/neo-tree.nvim", enabled = false },
        { "akinsho/bufferline.nvim", enabled = false },
        { "kawre/neotab.nvim", enabled = false },
        { "mfussenegger/nvim-dap", enabled = false },
        { "rcarriga/nvim-dap-ui", enabled = false },
        { "leoluz/nvim-dap-go", enabled = false },
        { "theHamsta/nvim-dap-virtual-text", enabled = false },
        { "Bekaboo/dropbar.nvim", enabled = false },
        { "nvim-lualine/lualine.nvim", enabled = false },
        { "echasnovski/mini.pairs", enabled = false },
        { "shellRaining/hlchunk.nvim", enabled = false },
        { "neoclide/coc.nvim", enabled = false },
        { "folke/neodev.nvim", enabled = false },
        { "folke/neoconf.nvim", enabled = false },
        { "luukvbaal/nnn.nvim", enabled = false },
        { "jinh0/eyeliner.nvim", enabled = false },
        { "nvim-telescope/telescope-file-browser.nvim", enabled = false },
        { "neanias/everforest-nvim", enabled = false },
        { "rktjmp/lush.nvim", enabled = false },
        { "nvim-pack/nvim-spectre", enabled = false },
        -- { "lewis6991/gitsigns.nvim", enabled = false },
        { "rcarriga/nvim-notify", enabled = false },
        { "nvimdev/dashboard-nvim", enabled = false },
        -- { "mg979/vim-visual-multi", enabled = false },
        { "folke/persistence.nvim", enabled = false },
        { "lukas-reineke/indent-blankline.nvim", enabled = false },
        { "nvim-neo-tree/neo-tree.nvim", enabled = false },
        { "akinsho/bufferline.nvim", enabled = false },
        -- { "kawre/neotab.nvim", enabled = false },
        { "mfussenegger/nvim-dap", enabled = false },
        { "rcarriga/nvim-dap-ui", enabled = false },
        { "leoluz/nvim-dap-go", enabled = false },
        { "theHamsta/nvim-dap-virtual-text", enabled = false },
        -- { "Bekaboo/dropbar.nvim", enabled = false },
        -- { "norcalli/nvim-colorizer.lua", enabled = false },
        -- { "L3MON4D3/LuaSnip", enabled = false },
        -- { "folke/noice.nvim", enabled = false },
        { "nvim-lualine/lualine.nvim", enabled = false },
        -- { "shortcuts/no-neck-pain.nvim", enabled = false },
        -- { "nvim-treesitter/nvim-treesitter-context", enabled = false },
        { "echasnovski/mini.pairs", enabled = false },
        -- { "shellRaining/hlchunk.nvim", enabled = false },
        -- { "neoclide/coc.nvim", enabled = false },
        { "folke/neodev.nvim", enabled = false },
        -- { "rafamadriz/friendly-snippets", enabled = false },
        { "folke/neoconf.nvim", enabled = false },
        -- { "barbecue", enabled = false },
        { "luukvbaal/nnn.nvim", enabled = false },
        { "jinh0/eyeliner.nvim", enabled = false },
        { "nvim-telescope/telescope-file-browser.nvim", enabled = false },
        { "neanias/everforest-nvim", enabled = false },
        { "rktjmp/lush.nvim", enabled = false },
        { "echasnovski/mini.comment", enabled = false },
        -- { "nvim-treesitter/nvim-treesitter", enabled = false },
    },
    {
        "onsails/lspkind.nvim",
        config = function()
            require("lspkind").init({
                symbol_map = {
                    Array = "  ",
                    Boolean = " 󰨙 ",
                    Class = " 󰯳 ",
                    Codeium = " 󰘦 ",
                    Color = "  ",
                    Control = "  ",
                    Collapsed = " > ",
                    Constant = " 󰯱 ",
                    Constructor = "  ",
                    Copilot = "  ",
                    Enum = " 󰯹 ",
                    EnumMember = "  ",
                    Event = "  ",
                    Field = "  ",
                    File = "  ",
                    Folder = "  ",
                    Function = " 󰡱 ",
                    Interface = " 󰰅 ",
                    Key = "  ",
                    Keyword = " 󱕴 ",
                    Method = " 󰰑 ",
                    Module = " 󰆼 ",
                    Namespace = " 󰰔 ",
                    Null = "  ",
                    Number = " 󰰔 ",
                    Object = " 󰲟 ",
                    Operator = "  ",
                    Package = " 󰰚 ",
                    Property = " 󰲽 ",
                    Reference = " 󰰠 ",
                    Snippet = "  ",
                    String = "  ",
                    Struct = " 󰰣 ",
                    TabNine = " 󰏚 ",
                    Text = " 󱜥 ",
                    TypeParameter = " 󰰦 ",
                    Unit = " 󱜥 ",
                    Value = "  ",
                    Variable = " 󰄛 ",
                },
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        version = false,
        keys = function()
            return {
                --[[ {
                "<Tab>",
                function()
                    return "<Plug>(neotab-out-luasnip)"
                end,
                expr = true,
                silent = true,
                mode = "i",
            }, ]]
                {
                    "<C-n>",
                    mode = { "i", "s" },
                    function()
                        local luasnip = require("luasnip")
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                            -- FeedKeys("<C-e>", "t")
                        end
                    end,
                    { silent = true },
                },
                {
                    "<C-p>",
                    mode = { "i", "s" },
                    function()
                        local luasnip = require("luasnip")
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                            -- FeedKeys("<C-e>", "t")
                        end
                    end,
                    { silent = true },
                },
            }
        end,
        build = "make install_jsregexp",
        config = function()
            local types = require("luasnip.util.types")
            local ls = require("luasnip")

            local fmta = require("luasnip.extras.fmt").fmta
            local rep = require("luasnip.extras").rep

            local s = ls.snippet
            local c = ls.choice_node
            local d = ls.dynamic_node
            local i = ls.insert_node
            local f = ls.function_node
            local t = ls.text_node
            local sn = ls.snippet_node
            local postfix = require("luasnip.extras.postfix").postfix
            -- Map of default values for types.
            --  Some have a bit more complicated default values,
            --  but that's OK :) Lua is flexible enough!
            local default_values = {
                int = "0",
                bool = "false",
                string = '""',

                error = function(_, info)
                    if info then
                        info.index = info.index + 1

                        return c(info.index, {
                            t(info.err_name),
                            t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
                        })
                    else
                        return t("err")
                    end
                end,

                -- Types with a "*" mean they are pointers, so return nil
                [function(text)
                    return string.find(text, "*", 1, true) ~= nil
                end] = function(_, _)
                    return t("nil")
                end,

                -- Convention: Usually no "*" and Capital is a struct type, so give the option
                -- to have it be with {} as well.
                [function(text)
                    return not string.find(text, "*", 1, true)
                        and string.upper(string.sub(text, 1, 1)) == string.sub(text, 1, 1)
                end] = function(text, info)
                    info.index = info.index + 1
                    return c(info.index, {
                        t(text .. "{}"),
                        t(text),
                    })
                end,
            }

            --- Transforms some text into a snippet node
            ---@param text string
            ---@param info table
            local transform = function(text, info)
                --- Determines whether the key matches the condition
                local condition_matches = function(condition, ...)
                    if type(condition) == "string" then
                        return condition == text
                    else
                        return condition(...)
                    end
                end

                -- Find the matching condition to get the correct default value
                for condition, result in pairs(default_values) do
                    if condition_matches(condition, text, info) then
                        if type(result) == "string" then
                            return t(result)
                        else
                            return result(text, info)
                        end
                    end
                end

                -- If no matches are found, just return the text, can fix up easily
                return t(text)
            end

            -- Maps a node type to a handler function.
            local handlers = {
                parameter_list = function(node, info)
                    local result = {}

                    local count = node:named_child_count()
                    for idx = 0, count - 1 do
                        local matching_node = node:named_child(idx)
                        local type_node = matching_node:field("type")[1]
                        table.insert(result, transform(vim.treesitter.get_node_text(type_node, 0), info))
                        if idx ~= count - 1 then
                            table.insert(result, t({ ", " }))
                        end
                    end

                    return result
                end,

                type_identifier = function(node, info)
                    local text = vim.treesitter.get_node_text(node, 0)
                    return { transform(text, info) }
                end,
            }

            --- Gets the corresponding result type based on the
            --- current function context of the cursor.
            ---@param info table
            local function go_result_type(info)
                local function_node_types = {
                    function_declaration = true,
                    method_declaration = true,
                    func_literal = true,
                }

                -- Find the first function node that's a parent of the cursor
                local node = vim.treesitter.get_node()
                while node ~= nil do
                    if function_node_types[node:type()] then
                        break
                    end

                    node = node:parent()
                end

                -- Exit if no match
                if not node then
                    vim.notify("Not inside of a function")
                    return t("")
                end

                -- This file is in `queries/go/return-snippet.scm`
                local query = assert(vim.treesitter.query.get("go", "return-snippet"), "No query")
                for _, capture in query:iter_captures(node, 0) do
                    if handlers[capture:type()] then
                        return handlers[capture:type()](capture, info)
                    end
                end
            end

            local go_return_values = function(args)
                return sn(
                    nil,
                    go_result_type({
                        index = 0,
                        err_name = "err",
                        func_name = args[1][1],
                    })
                )
            end

            ls.add_snippets("go", {
                s(
                    "efi",
                    fmta(
                        [[
<val>, err := <f>
if err != nil {
	return <result>
}
<finish>
]],
                        {
                            val = i(1, "v"),
                            f = i(2),
                            result = d(3, go_return_values, { 2 }),
                            finish = i(0),
                        }
                    )
                ),
                s("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = i(1, "err") })),
            })

            ls.add_snippets("go", {
                s(
                    "eff",
                    fmta(
                        [[
<val>, err := <f>
<finish>
]],
                        {
                            val = i(2, "val"),
                            f = i(1),
                            finish = i(0),
                        }
                    )
                ),
                s("ie", fmta("if err != nil {\n\treturn <err>\n}", { err = i(1, "err") })),
            })
            ls.add_snippets("go", {
                postfix(".byte", {
                    f(function(_, parent)
                        return "[]byte(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                    end, {}),
                }),
                postfix(".u32", {
                    f(function(_, parent)
                        return "uint32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                    end, {}),
                }),
                postfix(".u64", {
                    f(function(_, parent)
                        return "uint64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                    end, {}),
                }),
                postfix(".i32", {
                    f(function(_, parent)
                        return "int32(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                    end, {}),
                }),
                postfix(".i64", {
                    f(function(_, parent)
                        return "int64(" .. parent.snippet.env.POSTFIX_MATCH .. ")"
                    end, {}),
                }),
            })
            ls.setup({
                ext_base_prio = 200,
                ext_prio_increase = 2,
                history = true,
                updateevents = "TextChanged,TextChangedI",
                ext_opts = {
                    [types.insertNode] = {
                        --[[ active = {
                        -- highlight the text inside the node red.
                        hl_group = "LualineCursorLine",
                        priority = 1,
                    }, ]]
                        --[[ these ext_opts are applied when the node is not active, but
                the snippet still is.
                passive = {
                    hl_group = "Unvisited",
                    -- add virtual text on the line of the node, behind all text.
                    -- virt_text = { { "virtual text!!", "GruvboxBlue" } },
                }, ]]
                        unvisited = {
                            hl_group = "Unvisited",
                            priority = 1,
                        },
                        -- visited = {
                        --     hl_group = "Unvisited",
                        -- },
                    },
                    -- Add this to also have a placeholder in the final tabstop.
                    -- See the discussion below for more context.
                    --[[ [types.exitNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                }, ]]
                },
            })
        end,
    },
    {
        "folke/noice.nvim",
        config = function()
            local noice = require("noice")
            noice.setup({
                routes = {
                    {
                        filter = { event = "msg_show", find = "'modifiable' is off" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "notify", find = "Plugin" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "Pattern not found" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "sentiment" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "_watch" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "room" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "BufLeave" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "notify", find = "VenvSelect" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "jdtls" },
                        opts = { skip = true },
                    },
                    {
                        filter = { event = "msg_show", find = "winminwidth" },
                        opts = { skip = true },
                    },
                    -- {
                    --     filter = { event = "msg_show", find = "%--" },
                    --     opts = { skip = true },
                    -- },
                },
                presets = { inc_rename = true },
                messages = {
                    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                    -- This is a current Neovim limitation.
                    enabled = true, -- enables the Noice messages UI
                    view = "mini", -- default view for messages
                    view_error = "notify", -- view for errors
                    view_warn = "notify", -- view for warnings
                    view_history = "vsplit", -- view for :messages
                    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
                },
                cmdline = {
                    enabled = true, -- enables the Noice cmdline UI
                    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                    format = {
                        cmdline = {
                            pattern = "^:",
                            icon = "> ",
                            lang = "vim",
                            conceal = true,
                            opts = {
                                border = {
                                    style = "none",
                                    padding = { 0, 1 },
                                },
                                position = {
                                    row = "30%",
                                    col = "50%",
                                },
                                size = {
                                    width = 40,
                                    height = "auto",
                                },
                            }, -- global options for the cmdline. See section on views
                        },
                        search_down = {
                            kind = "search",
                            pattern = "^/",
                            icon = "?",
                            lang = "regex",
                            conceal = true,
                            opts = {
                                border = {
                                    style = "none",
                                    padding = { 0, 1 },
                                },
                                position = {
                                    row = "30%",
                                    col = "50%",
                                },
                                size = {
                                    width = 40,
                                    height = "auto",
                                },
                            }, -- global options for the cmdline. See section on views
                        },
                        filter = { pattern = "^:%s*!", icon = "$", lang = "bash", conceal = true },
                        lua = {
                            pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                            icon = "",
                            lang = "lua",
                            conceal = true,
                            opts = {
                                border = {
                                    style = "none",
                                    padding = { 0, 1 },
                                },
                                position = {
                                    row = "30%",
                                    col = "50%",
                                },
                                size = {
                                    width = 40,
                                    height = "auto",
                                },
                            }, -- global options for the cmdline. See section on views
                        },
                        help = {
                            pattern = "^:%s*he?l?p?%s+",
                            icon = "?",
                            conceal = true,
                            opts = {
                                border = {
                                    style = "none",
                                    padding = { 0, 1 },
                                },
                                position = {
                                    row = "30%",
                                    col = "50%",
                                },
                                size = {
                                    width = 40,
                                    height = "auto",
                                },
                            },
                        },
                        input = {}, -- Used by input()
                    },
                },
                lsp = {
                    message = {
                        -- Messages shown by lsp servers
                        enabled = true,
                        view = "mini",
                        opts = {},
                    },
                    progress = {
                        enabled = true,
                        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                        -- See the section on formatting for more details on how to customize.
                        format = "lsp_progress",
                        format_done = "lsp_progress_done",
                        throttle = 1000 / 30, -- frequency to update lsp progress message
                        view = "mini",
                    },
                    signature = {
                        enabled = false,
                        opts = {
                            size = {
                                max_height = 10,
                            },
                        },
                    },
                    hover = {
                        view = nil,
                        enabled = true,
                        win_options = {
                            wrap = true,
                            linebreak = false,
                            winblend = 10,
                        },
                        opts = {
                            size = {
                                max_height = 15,
                                max_width = 80,
                            },
                            border = {
                                style = "none",
                                padding = { 0, 1 },
                            },
                            -- position = { row = 2, col = 0 },
                        },
                    },
                },
                views = {
                    cmdline_popup = {
                        border = {
                            style = "rounded",
                            padding = { 0, 1 },
                        },
                        position = {
                            row = 10,
                            col = "50%",
                        },
                        size = {
                            width = 20,
                            height = "auto",
                        },
                    },
                    vsplit = {
                        win_options = {
                            winhighlight = { Normal = "Normal", FloatBorder = "NoiceSplitBorder" },
                            wrap = true,
                        },
                        view = "split",
                        enter = true,
                        position = "right",
                        size = {
                            width = 65,
                        },
                    },
                    mini = {
                        focusable = false,
                        timeout = 2000,
                    },
                },
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        -- enabled = false,
        -- version = "^3", -- Recommended
        -- commit = "d08053f7fbda681b92a074a81e59d22539124cab",
        -- commit = "d6fd0b78e49ff4dd37070155e9f14fd26f2ef53f",
        ft = { "rust" },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        -- enabled = false,
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = { "VeryLazy" },
        -- lazy = false,
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thins that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment selection", false },
            { "<bs>", desc = "Decrement selection", false },
        },
        -- -@type TSConfig
        opts = {
            disable = function(_, bufnr) -- Disable in files with more than 5K
                return vim.api.nvim_buf_line_count(bufnr) > 5000
                -- return vim.bo.filetype == "rust"
            end,
            highlight = { enable = true, disable = { "markdown" } },
            indent = { enable = true },
            auto_install = false,
            ensure_installed = {
                "rust",
                "vue",
                "java",
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    -- scope_incremental = "<S-CR>",
                    node_decremental = "<C-d>",
                },
            },
            textobjects = {
                move = {
                    enable = false,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                },
            },
        },
        -- -@param opts TSConfig
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "dnlhc/glance.nvim",
        -- dir = "~/Project/lua/glance.nvim/",
        -- aaaaaaaaa
        event = "VeryLazy",
        config = function()
            local glance = require("glance")
            local actions = glance.actions
            local function clear_and_restore()
                for bufnr, _ in pairs(_G.glance_buffer) do
                    vim.api.nvim_buf_del_keymap(bufnr, "n", "<CR>")
                    vim.api.nvim_buf_del_keymap(bufnr, "n", "<esc>")
                    vim.api.nvim_buf_del_keymap(bufnr, "n", "q")
                end
                vim.keymap.set("v", "<CR>", function()
                    vim.cmd([[:'<,'>lua require("nvim-treesitter.incremental_selection").node_incremental()]])
                end)
                vim.keymap.set("n", "<CR>", function()
                    vim.cmd([[:lua require("nvim-treesitter.incremental_selection").init_selection()]])
                end)
                _G.reference = false
            end
            local function quickfix()
                clear_and_restore()
                actions.quickfix()
            end
            function Jump()
                clear_and_restore()
                actions.jump()
            end

            function Close_with_q()
                clear_and_restore()
                vim.defer_fn(actions.close, 1)
            end

            function OpenAndKeepHighlight()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local lnum = cursor[1]
                local col = cursor[2]

                local filename = vim.fn.expand("%:p")

                clear_and_restore()
                vim.schedule(function()
                    local uri = vim.uri_from_fname(filename)
                    local bufnr = vim.uri_to_bufnr(uri)
                    vim.api.nvim_win_set_buf(0, bufnr)
                    vim.schedule(function()
                        vim.api.nvim_win_set_cursor(0, { lnum, col })
                        require("illuminate.engine").keep_highlight(bufnr)
                    end)
                end)
                actions.close()
            end
            function Open()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local lnum = cursor[1]
                local col = cursor[2]
                local filename = vim.fn.expand("%:p")

                clear_and_restore()
                vim.schedule(function()
                    local uri = vim.uri_from_fname(filename)
                    local bufnr = vim.uri_to_bufnr(uri)
                    vim.api.nvim_win_set_buf(0, bufnr)
                    vim.schedule(function()
                        vim.api.nvim_win_set_cursor(0, { lnum, col })
                        vim.cmd("norm zz")
                    end)
                end)
                actions.close()
            end

            require("glance").setup({
                use_trouble_qf = true,
                height = 18, -- Height of the window
                zindex = 10,
                preview_win_opts = { -- Configure preview window options
                    cursorline = true,
                    number = true,
                    wrap = false,
                },
                border = {
                    enable = false, -- Show window borders. Only horizontal borders allowed
                    top_char = "―",
                    bottom_char = "―",
                },
                list = {
                    position = "right", -- Position of the list window 'left'|'right'
                    -- width = 0.19, -- 33% width relative to the active window, min 0.1, max 0.5
                    width = 0.25, -- 33% width relative to the active window, min 0.1, max 0.5
                },
                theme = { -- This feature might not work properly in nvim-0.7.2
                    enable = false, -- Will generate colors for the plugin based on your current colorscheme
                    mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
                },
                mappings = {
                    list = {
                        ["j"] = actions.next, -- Bring the cursor to the next item in the list
                        ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
                        ["<Down>"] = actions.next,
                        ["<Up>"] = actions.previous,
                        ["<C-u>"] = actions.preview_scroll_win(5),
                        ["<C-d>"] = actions.preview_scroll_win(-5),
                        ["v"] = actions.jump_vsplit,
                        ["s"] = actions.jump_split,
                        ["t"] = actions.jump_tab,
                        ["<CR>"] = Jump,
                        ["o"] = actions.jump,
                        ["l"] = actions.open_fold,
                        ["n"] = actions.next_location,
                        ["h"] = actions.close_fold,
                        ["<Tab>"] = actions.enter_win("preview"), -- Focus preview window
                        ["q"] = Close_with_q,
                        ["Q"] = Close_with_q,
                        ["<Esc>"] = Close_with_q,
                        ["<C-t>"] = quickfix,
                        -- ['<Esc>'] = false -- disable a mapping
                    },
                    preview = {
                        ["n"] = actions.next_location,
                        ["<C-t>"] = quickfix,
                        ["N"] = actions.previous_location,
                        ["<C-f>"] = actions.enter_win("list"),
                        ["<Tab>"] = actions.enter_win("list"), -- Focus list window
                    },
                },
                hooks = {
                    before_open = function(result, open, jump, method)
                        if method == "definitions" and #result >= 1 then
                            vim.cmd("normal! m'")
                            jump(result[1])
                        elseif method == "implementations" then
                            vim.cmd("normal! m'")
                            open(result)
                        elseif method == "references" then
                            if #result == 1 then
                                vim.cmd("normal! m'")
                                jump(result[1])
                            elseif #result == 2 then
                                print("2")
                                vim.cmd("normal! m'")
                                local lnum = vim.api.nvim_win_get_cursor(0)[1]
                                local locations = vim.tbl_filter(function(v)
                                    return not (v.range.start.line + 1 == lnum)
                                end, vim.F.if_nil(result, {}))
                                vim.cmd("normal! m'")
                                if locations ~= nil and #locations ~= 0 then
                                    jump(locations[1])
                                else
                                    print("can't find reference")
                                end
                            else
                                vim.cmd("normal! m'")
                                open(result)
                                FeedKeys("<Tab>", "t")
                            end
                            return
                        end
                    end,
                    before_close = function()
                        _G.glance_list_method = nil
                        _G.glance_listnr = nil
                    end,
                },
                folds = {
                    fold_closed = ">",
                    fold_open = "󱞩",
                    folded = false, -- Automatically fold list on startup
                },
                indent_lines = {
                    enable = true,
                    icon = " ",
                },
                winbar = {
                    enable = false, -- Available strating from nvim-0.8+
                },
            })
        end,
    },
    {
        "ojroques/nvim-bufdel",
        config = function()
            local function isBufferInCwd(bufinfo)
                local filePath = vim.fn.expand("#" .. bufinfo.bufnr .. ":p")
                return vim.startswith(filePath, cwd)
            end
            require("bufdel").setup({
                quit = false, -- quit Neovim when last buffer is closed
            })
            vim.keymap.set("n", "<leader>D", "<cmd>BufDelOthers<CR>")
        end,
    },
    {
        "stevearc/profile.nvim",
    },
    -- add any other pugins here
}
local keymap = vim.keymap.set
-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.keymap.set("i", "h", function()
    _G.start_ttt = vim.uv.hrtime()
    return "h"
end, { expr = true })
vim.keymap.set("n", "<space>q", function()
    vim.cmd("q!")
end)
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.type_definition()
end)

keymap("n", "<space>d", function()
    vim.cmd("Glance definitions")
end)
vim.opt.swapfile = false
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
    require("profile").instrument_autocmds()
    if should_profile:lower():match("^start") then
        require("profile").start("*")
    else
        require("profile").instrument("*")
    end
end
local function toggle_profile()
    local prof = require("profile")
    if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
                prof.export(filename)
                vim.notify(string.format("Wrote %s", filename))
            end
        end)
    else
        prof.start("*")
    end
end
vim.keymap.set("", "<space>tp", toggle_profile)
require("lazy").setup({
    root = root .. "/plugins",
    spec = {
        { import = "plugins" },
    },
})
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        ["gopls"] = {
            usePlaceholders = true,
            completeFunctionCalls = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                -- parameterNames = true,
                rangeVariableTypes = true,
            },
            semanticTokens = false,
            experimentalPostfixCompletions = false,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = false,
        },
    },
})
_G.Time1 = function(start, msg)
    local file = io.open("/Users/xzb/.config/nvim/example.txt", "w")
    msg = msg or ""
    local duration = 0.000001 * (vim.loop.hrtime() - start)
    if file then
        file:write(msg .. [==[duration:]==], vim.inspect(duration))
    end
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print(msg .. [==[duration:]==], vim.inspect(duration)) -- __AUTO_GENERATED_PRINT_VAR_END__
end
lspconfig.lua_ls.setup({
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                library = {
                    -- "/Users/xzb/.local/share/nvim/lazy/neodev.nvim/types/stable",
                    -- "/Users/xzb/.local/share/nvim/lazy/neodev.nvim/types/nightly",
                    "/usr/local/share/nvim/runtime",
                    -- "/Users/xzb/.local/share/nvim/lazy/neoconf.nvim/types",
                    -- "/Users/xzb/.local/share/nvim/lazy/nvim-cmp/lua/cmp/",
                    -- "/Users/xzb/.local/share/nvim/lazy/nvim-treesitter/",
                    -- "/Users/xzb/.local/share/nvim/lazy/telescope.nvim/lua/telescope/",
                    -- "/Users/xzb/.local/share/nvim/lazy/LuaSnip/lua/luasnip/",
                },
                -- library = vim.api.nvim_get_runtime_file("", true),
            },
            hint = {
                enable = true,
                ["setType"] = true,
                ["paramType"] = true,
            },
        },
    },
})
