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
