return {
    "akinsho/bufferline.nvim",
    opts = {
        options = {
            left_trunc_marker = "",
            right_trunc_marker = "",
            separator_style = { "", "" },
            color_icons = false,
            always_show_bufferline = true,
            show_close_icon = false,
            show_buffer_close_icons = false,
            indicator = {
                style = "underline",
            },
            show_buffer_icons = false,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = function()
                        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                    end,
                    text_align = "center",
                },
            },
        },
    },
}
