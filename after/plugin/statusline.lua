local function git_status()
    local git_branch = vim.fn["fugitive#statusline"]()
    if string.len(git_branch) == 0 then
        return ""
    end

    return "%#PmenuThumb# "..(string.sub(git_branch, 6, -3)).." %#StatusLine# "
end

vim.defer_fn(function()
    vim.opt.statusline = ""

    vim.opt.statusline:append(git_status())

    local file_name = "%f"
    local help_buffer = "%h"
    local preview_flag = "%w"
    local modified_flag = "%m"
    local read_only_flag = "%r"
    local separation = "%="
    local filetype = "%y"
    local line_column = "%-14.(%l,%c%V%)"
    local percentage_through_file = "%P"

    vim.opt.statusline:append(file_name .. " ")
    vim.opt.statusline:append(help_buffer)
    vim.opt.statusline:append(preview_flag)
    vim.opt.statusline:append(modified_flag)
    vim.opt.statusline:append(read_only_flag)
    vim.opt.statusline:append(separation)
    vim.opt.statusline:append(filetype .. " ")
    vim.opt.statusline:append(line_column .. " ")
    vim.opt.statusline:append(percentage_through_file)
end, 0)
