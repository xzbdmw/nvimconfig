local util = require("lspconfig.util")

return {
    default_config = {
        cmd = {
            "buffer-language-server",
        },
        filetypes = { "*" },
        single_file_support = true,
        root_dir = util.root_pattern(".git"),
    },
}
