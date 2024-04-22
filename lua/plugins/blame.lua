return {
    "FabijanZulj/blame.nvim",
    config = function()
        require("blame").setup({
            date_format = "%d.%m.%Y",
            virtual_style = "right_align",
            -- views = {
            --     default = "virtual",
            -- },
            merge_consecutive = false,
            max_summary_width = 30,
            colors = nil,
            commit_detail_view = "vsplit",
            -- format_fn = formats.commit_date_author_fn,
            mappings = {
                commit_info = "i",
                stack_push = "<leader>gh",
                stack_pop = "<leader>gl",
                show_commit = "<leader>gc",
                close = { "<esc>", "q" },
            },
        })
    end,
}
