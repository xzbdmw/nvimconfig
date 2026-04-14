local util = require("lspconfig.util")

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
}

return {
    default_config = {
        cmd = { "ty", "server" },
        filetypes = { "python" },
        single_file_support = true,
        root_dir = util.root_pattern(unpack(root_files)),
    },
}
