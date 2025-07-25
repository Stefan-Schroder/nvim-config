vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.clipboard = { 'unnamedplus', 'unnamed' }

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.cursorline = true

vim.opt.smartcase = true
vim.opt.ignorecase = true

-- vim.cmd('syntax off')

-- set the timeout of pattern matching
vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2

-- Enable filetype detection, plugins, and indentation
vim.cmd('filetype plugin indent on')

-- Set the commentstring for C, C++, C#, and Java filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "cs", "java" },
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})
