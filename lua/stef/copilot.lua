require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = false,
    debounce = 75,
    keymap = {
      accept = "<M-Space>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})

-- copilot chat
local chat = require("CopilotChat")
chat.setup({
    debug = true,
    mappings = {
        -- complete = {
        --     detail = 'Use @<Tab> or /<Tab> for options.',
        --     insert ='<Tab>',
        -- },
        close = {
            normal = 'q',
            -- insert = '<C-c>'
        },
        reset = {
            normal ='<C-r>',
            -- insert = '<C-l>'
        },
        submit_prompt = {
            normal = '<CR>',
            insert = '<C-CR>'
        },
        accept_diff = {
            normal = '<C-y>',
            insert = '<C-y>'
        },
        yank_diff = {
            normal = 'gy',
            register = '"',
        },
        show_diff = {
            normal = 'gd'
        },
        show_system_prompt = {
            normal = 'gp'
        },
        show_user_selection = {
            normal = 'gs'
        },
    },
})


-- vim.keymap.set({'n', 'v'}, '<leader>ct', chat.toggle, {desc='AI toggle'})
vim.keymap.set({'n', 'v'}, '<leader>ct', function()
    chat.toggle({
        window = {
            layout = 'float',
            title = 'ChatGPT in my screen',
            relative = 'editor',
            row = 0,
            col = 0,
            width = vim.o.columns,
            height = 25,
        },
    })
end)
