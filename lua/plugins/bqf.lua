return {
    "kevinhwang91/nvim-bqf",
    event = "FileType qf",
    config = function()
        require("bqf").setup({
            preview = {
                winblend = 5,
                delay_syntax = 5,
                win_height = 20,
            },
            -- stylua: ignore
            func_map = { open = "", openc = "", drop = "", split = "", vsplit = "", tab = "", tabb = "", tabc = "", tabdrop = "", ptogglemode = "", ptoggleitem = "", ptoggleauto = "", pscrollup = "<c-u>", pscrolldown = "<c-d>", pscrollorig = "", prevfile = "", nextfile = "", prevhist = "", nexthist = "", lastleave = [[']], stoggleup = "", stoggledown = "", stogglevm = "", stogglebuf = "", sclear = "", filter = "zn", filterr = "zN", fzffilter = "zf" },
        })
    end,
}
