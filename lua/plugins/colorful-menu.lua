return {
    dir = "~/Project/lua/colorful-menu.nvim/",
    opts = {
        ls = {
            gopls = {
                preserve_type_when_truncate = true,
            },
            ["clangd"] = {
                -- Such as (as Iterator), (use std::io).
                extra_info_hl = "@comment",
                align_type_to_right = true,
                preserve_type_when_truncate = true,
            },
        },
    },
}
