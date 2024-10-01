vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'gd', function()
        -- Use LSP to get the definition location
        local result = vim.lsp.buf_request_sync(0, "textDocument/definition", vim.lsp.util.make_position_params(), 1000)

        if not result or vim.tbl_isempty(result) then
            print("No definition found. Stef maybe check fallbacks")
            return
        end

        -- local target_uri = result[1].result[1].uri
        local target_file = vim.uri_to_fname(result[1].result[1].uri)
        local target_line = result[1].result[1].range.start.line + 1
        local target_char = result[1].result[1].range.start.character

        -- Iterate through all buffers and check if the target file is already open in another tab
        for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.api.nvim_buf_get_name(buf)

                if bufname == target_file then
                    vim.api.nvim_set_current_tabpage(tabnr)
                    vim.api.nvim_set_current_win(win)
                    vim.api.nvim_win_set_cursor(win, {target_line, target_char})
                    return
                end
            end
        end

        -- If the file isn't open in any other tab, use LSP to go to the definition
        vim.lsp.util.jump_to_location(result[1].result[1])
    end,
    { noremap = true, silent = true })
    -- vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
  end,
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'ts_ls', 'rust_analyzer'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = lsp_capabilities,
      })
    end,
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = {'vim'},
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              }
            }
          }
        }
      })
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  }, {
    {name = 'buffer'},
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, {"i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, {"i", "s"}),
}),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
