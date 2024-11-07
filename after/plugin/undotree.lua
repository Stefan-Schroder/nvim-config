vim.keymap.set('n', '<leader>ut', function()
    vim.cmd.UndotreeShow()
    vim.cmd.UndotreeFocus()
end)
