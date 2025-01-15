vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remove search from buffer
vim.keymap.set("n", "<C-n>", ":let @/=''<CR>")

-- No idea why this was invented
vim.keymap.set("n", "Q", "<nop>")

-- Movement between windows
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Make file executable
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quick fix window remap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = 0 })
    -- vim.keymap.set("n", "<C-t>", "", { buffer = 0 })
  end,
})

-- start searching for current word
vim.keymap.set('n', '<leader>/', function()
    vim.fn.feedkeys('/'..vim.fn.expand('<cword>'))
end)

-- start searching for current WORD
vim.keymap.set('n', '<leader>?', function()
    vim.fn.feedkeys('/'..vim.fn.expand('<cWORD>'))
end)

-- Force refresh colours
vim.keymap.set('n', '<leader>R', function()
    print("Refreshing")
    ColorMyPencils()
end)

vim.keymap.set('n', 'zfaf', function()
    local ts = vim.treesitter

    local parser = ts.get_parser()
    local tree = parser:parse()[1]
    local root = tree:root()

    local bufnr = vim.api.nvim_get_current_buf()
    local lang =vim.bo[bufnr].filetype

    local query = vim.treesitter.query.get(lang, "folds")

    if not query then
        return
    end

    local current_max = 0

    for _, node in query:iter_captures(root, 0, 0, -1) do
        local fold_start, _, fold_end, _ = node:range()

        if fold_start > current_max and fold_start+1 < fold_end-1 then
            vim.cmd(string.format("%d,%dfold", fold_start+2, fold_end))
            current_max = fold_start
        end
    end
end)

local function find_current_fold(current_line)
    current_line = current_line - 1 -- make it zero indexed for tree
    local bufnr = vim.api.nvim_get_current_buf()
    local lang =vim.bo[bufnr].filetype

    local query = vim.treesitter.query.get(lang, "folds")

    if not query then
        print("No folds found for filtype"..lang)
        return
    end

    local parser = vim.treesitter.get_parser(bufnr, lang)
    local tree = parser:parse()[1]
    local root = tree:root()

    local latest_start = 0
    local latest_end = 0

    for _, match, _ in query:iter_matches(root, bufnr) do
        for id, node in pairs(match) do
            if query.captures[id] == "fold" then
                local start_i, _, end_i, _ = node:range() -- not sero indexed
                if start_i <= current_line and current_line <= end_i and start_i ~= end_i then
                    latest_start = start_i
                    latest_end = end_i
                end
            end
        end
    end

    return latest_start + 1, latest_end + 1
end

vim.keymap.set('n', 'zif', function()
    local current_cursor = vim.api.nvim_win_get_cursor(0)

    local fold_start, fold_end = find_current_fold(current_cursor[1])

    if fold_end ~= 0 then
        local set_line = math.floor((fold_end - fold_start)/2 + fold_start)

        local winid = vim.api.nvim_get_current_win()

        vim.api.nvim_win_set_cursor(winid, {set_line, 0}) -- Temporarily set cursor
        vim.cmd("normal! zz")
        vim.api.nvim_win_set_cursor(winid, current_cursor) -- Move cursor back
    else
        print("Could not find the current fold")
    end
end, { noremap = true, silent = true })

vim.keymap.set('n', 'zfif', function()
    local current_cursor = vim.api.nvim_win_get_cursor(0)

    local fold_start, fold_end = find_current_fold(current_cursor[1])

    if fold_end ~= 0 and fold_start+1 <= fold_end-1 then
        vim.cmd(string.format("%d,%dfold", fold_start+1, fold_end-1))
    else
        print("Could not find the current fold")
    end
end, { noremap = true, silent = true })

vim.keymap.set('n', 'gcif', function()
    local current_cursor = vim.api.nvim_win_get_cursor(0)

    local fold_start, fold_end = find_current_fold(current_cursor[1])

    if fold_end ~= 0 and fold_start <= fold_end then
        vim.cmd(string.format("%d,%dCommentary", fold_start, fold_end))
    else
        print("Could not find the current fold")
    end
end, {noremap = true, silent = true })
