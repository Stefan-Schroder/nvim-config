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


----------------------------TREE SITTER FUNCTIONS------------------------------------
vim.keymap.set('n', 'zfaf', function() -- Fold all of the functions
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

local function find_current_body() -- Finds the first parent body (could be a function or a if statement)
    local ts_utils = require 'nvim-treesitter.ts_utils'
    local node = ts_utils.get_node_at_cursor()

    if not node then
        print("There is no node under cursor")
        return
    end

    while node do
        local type = node:type()
        print(type)
        if type == "compound_statement" or type == "block" then
            local start_row, _, end_row, _ = node:range()
            print("start: "..start_row.." end: "..end_row)
            return start_row + 1, end_row + 1
        end
        node = node:parent()
    end
    print("Never found a compound_statement")
end

vim.keymap.set('n', 'zif', function() -- Center the screen on the function
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local fold_start, fold_end = find_current_body()

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

vim.keymap.set('n', 'zfif', function() -- Fold the inner function
    local fold_start, fold_end = find_current_body()

    if fold_end ~= 0 and fold_start+1 <= fold_end-1 then
        vim.cmd(string.format("%d,%dfold", fold_start+1, fold_end-1))
    else
        print("Could not find the current fold")
    end
end, { noremap = true, silent = true })

vim.keymap.set('n', 'gcif', function() -- Comment out the inner block
    local fold_start, fold_end = find_current_body()

    if fold_end ~= 0 and fold_start <= fold_end then
        vim.cmd(string.format("%d,%dCommentary", fold_start, fold_end))
    else
        print("Could not find the current fold")
    end
end, {noremap = true, silent = true })

vim.keymap.set('n', '<leader>cse', function ()
    local fold_start, fold_end = find_current_body()

    if fold_end == 0 or fold_start > fold_end then
        print("Could not find the current fold")
        return
    end


end, {noremap = true, silent = true})
