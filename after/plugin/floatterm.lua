-- Install floaterm via packer.nvim or your plugin manager
-- For packer.nvim:
-- use 'voldikss/vim-floaterm'

-- Configure Floaterm
vim.g.floaterm_width = 0.8       -- Floaterm width as 80% of the screen
vim.g.floaterm_height = 0.8      -- Floaterm height as 80% of the screen
vim.g.floaterm_autoinsert = 1    -- Automatically enter insert mode when opening
vim.g.floaterm_wintype = 'float' -- Use floating window for floaterm
vim.g.floaterm_borderchars = '─│─│╭╮╯╰' -- Set border style

-- Key mappings to open/close the terminal
vim.api.nvim_set_keymap('n', '<leader>t', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<leader><C-t>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })

-- Close terminal with Esc in terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Key mapping to open new floaterm terminal
vim.api.nvim_set_keymap('n', '<leader>tn', ':FloatermNew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<leader>tn', '<C-\\><C-n>:FloatermNew<CR>', { noremap = true, silent = true })


-- Key mapping to cycle between open floaterm windows
vim.api.nvim_set_keymap('n', '<leader>tp', ':FloatermPrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tn', ':FloatermNext<CR>', { noremap = true, silent = true })
