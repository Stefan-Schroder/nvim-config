vim.g.floaterm_width = 0.8       -- Floaterm width as 80% of the screen
vim.g.floaterm_height = 0.4      -- Floaterm height as 80% of the screen
vim.g.floaterm_autoinsert = 1    -- Automatically enter insert mode when opening
vim.g.floaterm_wintype = 'float' -- Use floating window for floaterm
vim.g.floaterm_borderchars = '─│─│╭╮╯╰' -- Set border style

-- Key mappings to open/close the terminal
vim.keymap.set('n', '<leader>t', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })

-- Close terminal with Esc in terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Key mapping to open new floaterm terminal
vim.keymap.set('n', '<leader>tn', ':FloatermNew<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-n>n', '<C-\\><C-n>:FloatermNew<CR>', { noremap = true, silent = true })

-- Key mapping to cycle between open floaterm windows
vim.keymap.set('n', '<leader>tp', ':FloatermPrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tn', ':FloatermNext<CR>', { noremap = true, silent = true })

--- Make compile terminal
vim.cmd('FloatermKill!') -- kill all previously opened terms

local function make_compile_term()
    vim.cmd('FloatermNew --name=compiler --title="compiler($1/$2)" --silent')
end
make_compile_term()
vim.keymap.set('n', '<leader>tc', function() make_compile_term() end, { noremap = true, silent = true })

-- the start of a compiler terminal
vim.keymap.set('n', '<leader>tmi', function()
      vim.cmd("FloatermSend --name=compiler mi")
      vim.cmd("FloatermShow --name=compiler")
end, {noremap=true, silent=true})

vim.keymap.set('n', '<leader>test', function()
    local hi = vim.cmd("FloatermSend --name=compiler ls /home")
    print("new:")
    print(hi)
end)
