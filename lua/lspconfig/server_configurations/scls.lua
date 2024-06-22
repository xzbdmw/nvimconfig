local util = require("lspconfig.util")

return {
    default_config = {
        cmd = {
            "simple-completion-language-server",
        },
        filetypes = { "*" },
        single_file_support = true,
        root_dir = util.root_pattern(".git"),
        settings = {
            scls = {
                max_completion_items = 20,
                feature_words = true,
                feature_snippets = false,
                snippets_first = false,
                feature_unicode_input = false,
                feature_paths = false,
            },
        },
    },
}
