vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

local function is_git_repo()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    if handle == nil then
        print("fugitive.lua: Error checking if git repo")
        return
    end
    local result = handle:read("*a")
    handle:close()
    return result:match("true") ~= nil
end

vim.keymap.set("n", "<leader>gys", function()
    local filename = vim.api.nvim_buf_get_name(0) local git_start, git_end = string.find(filename, "/.git/")
    local sha = ""
    if  git_start == nil then
        if is_git_repo() then
            local handler = io.popen("git rev-parse HEAD")
            if handler == nil then
                print("fugitive.lua: Error performing 'git rev-parse HEAD'")
                return
            end
            sha = handler:read("*a")
            handler:close()
            sha = sha:gsub("%s+", "")
        else
            print("Not a git repo")
            return
        end
    else
        sha = string.sub(filename, git_end+2, string.find(filename, '/', git_end+2)-1)
    end
    if sha == "" then
        return
    end

    print(sha)
    vim.fn.setreg('+', sha)
end);
