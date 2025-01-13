return {
    "folke/snacks.nvim",
    branch = "picker",
    -- enabled = false,
    -- priority = 1000,
    -- lazy = false,
    ---@type snacks.Config
    opts = {
        scroll = {
            animate = {
                duration = { step = 15, total = 250 },
                easing = "linear",
            },
            -- faster animation when repeating scroll after delay
            animate_repeat = {
                delay = 100, -- delay in ms before using the repeat animation
                duration = { step = 5, total = 50 },
                easing = "linear",
            },
            enabled = true,
            -- what buffers to animate
            filter = function(buf)
                if vim.g.scroll then
                    return false
                end
                return vim.g.snacks_scroll ~= false
                    and vim.b[buf].snacks_scroll ~= false
                    and vim.bo[buf].buftype ~= "terminal"
                    and buf ~= vim.api.nvim_get_current_buf()
            end,
        },
        picker = { enabled = true },
    },
}
