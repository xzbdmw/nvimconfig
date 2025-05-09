return {
    "echasnovski/mini.snippets",
    dependencies = { "rafamadriz/friendly-snippets" },
    keys = function()
        local jump = function(direction)
            _G.no_animation(_G.CI)
            if require("multicursor-nvim").numCursors() > 1 then
                return
            end

            local cur = vim.api.nvim_win_get_cursor(0)
            MiniSnippets.session.jump(direction)
            vim.schedule(function()
                if vim.deep_equal(cur, vim.api.nvim_win_get_cursor(0)) then
                    MiniSnippets.session.jump(direction)
                end
            end)
            if vim.bo.filetype == "lua" then
                require("cmp.config").set_onetime({ sources = {} })
            end
        end
        return {
            {
                "<C-n>",
                mode = { "i" },
                function()
                    if not require("config.utils").mini_snippets_active_session() then
                        vim.g.constran_minisnippets = true
                        jump("next")
                        jump("prev")
                    else
                        jump("next")
                    end
                end,
                { silent = true },
            },
            {
                "<C-p>",
                mode = { "i" },
                function()
                    jump("prev")
                end,
                { silent = true },
            },
        }
    end,
    config = function()
        local gen_loader = require("mini.snippets").gen_loader

        local snippets = require("mini.snippets")
        local insert = function(snippet)
            -- Do not match with whitespace to cursor's left
            return snippets.default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
        end

        require("mini.snippets").setup({
            snippets = {
                -- Load custom file with global snippets first (adjust for Windows)
                gen_loader.from_file("~/.config/nvim/snippets/global.json"),

                -- Load snippets based on current language by reading files from
                -- "snippets/" subdirectories from 'runtimepath' directories.
                gen_loader.from_lang(),
            },
            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Expand snippet at cursor position. Created globally in Insert mode.
                expand = "<f1>",

                -- Interact with default `expand.insert` session.
                -- Created for the duration of active session(s)
                jump_next = "<C-8>",
                jump_prev = "<C-9>",
                stop = "<C-c>",
            },

            -- Functions describing snippet expansion. If `nil`, default values
            -- are `MiniSnippets.default_<field>()`.
            expand = {
                -- Resolve raw config snippets at context
                prepare = nil,
                -- Match resolved snippets at cursor position
                match = nil,
                -- Possibly choose among matched snippets
                select = nil,
                -- Insert selected snippet
                insert = insert,
            },
        })
    end,
}
