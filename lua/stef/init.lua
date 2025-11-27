require("stef.remap")
require("stef.packer")
require("stef.set")
require('telescope').setup{
    defaults = {
        file_ignore_patterns = {
            "node_modules", -- Ignore node_modules directory
            "%.env",        -- Ignore files ending with .env
            "%.o",
            "bin/",
            "obj/",
            "%.log",        -- Ignore files ending with .log
        },
    },
}
