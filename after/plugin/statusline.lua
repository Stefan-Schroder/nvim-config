local function git_status() -- this might be slow as crep... had trouble with the normal fugitive#statusline
    local handle = io.popen("git rev-parse --abbrev-ref HEAD")
    if handle == nil then
        print("fugitive.lua: Error checking if git repo")
        return
    end
    local result = handle:read("*a")
    result = result:gsub("%s+", "")
    handle:close()
    return "["..result.."] "

    -- return "["..vim.fn['fugitive#statusline']().."] "
end

vim.opt.statusline = ""
vim.opt.statusline:append(git_status())
vim.opt.statusline:append("%<%f %h%w%m%r%=%-14.(%l,%c%V%) %P")
