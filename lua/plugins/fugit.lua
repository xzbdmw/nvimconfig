return {
    "SuperBo/fugit2.nvim",
    enabled = false,
    opts = {
        width = 70,
        libgit2_path = "/opt/homebrew/Cellar/libgit2/1.7.2/lib/libgit2.dylib",
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },
    cmd = { "Fugit2", "Fugit2Blame", "Fugit2Diff", "Fugit2Graph" },
    keys = {
        { "<leader>F", mode = "n", "<cmd>Fugit2<cr>" },
    },
}
