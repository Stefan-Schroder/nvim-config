local builtin = require('telescope.builtin')
local previous_search = ""
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gl', builtin.live_grep, {})

vim.keymap.set('n', '<leader>gp', function()
    previous_search = vim.fn.input("Grep > ")
    builtin.grep_string({search = previous_search})
end)

-- Needs the override so that i can store previous search
vim.keymap.set('v', '<leader>gp', function()
    vim.cmd('normal! "ty')
    previous_search = vim.fn.getreg('t')
    builtin.grep_string({search = previous_search})
end)

vim.keymap.set('n', '<leader>gP', function()
    if previous_search == "" then
        print("No previous search was recorded")
        return
    end
    print("Previous search: "..previous_search)
    builtin.grep_string({search = previous_search})
end)
