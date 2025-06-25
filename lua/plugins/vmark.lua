return {
    "jake-stewart/vmark.nvim",
    event = "BufRead",
    config = function()
        local vmark = require("vmark")

        vmark.setup({
            format = function(details)
                -- see `:h nvim_buf_set_extmark()` for configuration options
                return {
                    virt_text = { { " ◼ " .. details.text .. " ", "DiagnosticInfo" } },
                    hl_mode = "combine",
                    virt_text_pos = "eol",
                    sign_hl_group = "DiagnosticInfo",
                    sign_text = ">>",
                }
            end,
        })

        -- create a new vmark at the cursor position
        vim.keymap.set("n", "mn", vmark.create)

        -- delete the vmark at the cursor position
        vim.keymap.set("n", "mD", vmark.removeUnderCursor)

        -- open the quickfix with all marks found recursively from current directory
        vim.keymap.set("n", "mq", vmark.recursiveQuickfix)

        -- print the vmark text at the cursor position
        vim.keymap.set("n", "me", vmark.echoUnderCursor)

        -- jump to the next/prev vmark in the document
        vim.keymap.set({ "n", "v", "o" }, "mk", function()
            vmark.prev()
            vim.cmd("norm! ^")
        end)
        vim.keymap.set({ "n", "v", "o" }, "mj", function()
            vmark.next()
            vim.cmd("norm! ^")
        end)
    end,
}
