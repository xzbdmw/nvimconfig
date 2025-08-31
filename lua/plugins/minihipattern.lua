return {
    "echasnovski/mini.hipatterns",
    version = false,
    -- enabled = false,
    config = function()
        local hipatterns = require("mini.hipatterns")

        local print_highlighter = {
            pattern = { "^%s*print.*", ".*time.*time.*", ".*nvtx.*" },
            group = "@weakcomment",
            extmark_opts = { priority = 5000 },
        }

        local print_dim_enabled = false

        vim.keymap.set("n", "<leader>tp", function()
            if print_dim_enabled then
                hipatterns.setup({
                    highlighters = { print_dim = nil },
                })
                print_dim_enabled = false
                vim.notify("Print dimming disabled", vim.log.levels.WARN)
            else
                hipatterns.setup({
                    highlighters = { print_dim = print_highlighter },
                })
                print_dim_enabled = true
                vim.notify("Print dimming enabled")
            end

            -- Refresh all enabled buffers
            for _, buf_id in ipairs(hipatterns.get_enabled_buffers()) do
                local byte_size = vim.api.nvim_buf_get_offset(buf_id, vim.api.nvim_buf_line_count(buf_id))
                local ft = vim.bo[buf_id].filetype
                if byte_size > 1024 * 1024 or ft == "text" then -- 1 Megabyte max
                    goto continue
                end
                hipatterns.disable(buf_id)
                hipatterns.enable(buf_id)
                ::continue::
            end
        end, { desc = "Toggle print dimming globally" })
    end,
}
