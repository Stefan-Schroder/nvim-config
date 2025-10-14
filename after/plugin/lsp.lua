-- ================================
-- LSP + Autocompletion Setup
-- ================================

-- Ensure Mason + LSP servers are configured
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls", "rust_analyzer", "lua_ls" },
})

-- =========================================
-- LSP on_attach: keymaps + buffer settings
-- =========================================
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true, noremap = true }

    local keymap = vim.keymap.set

    --- LSP keymaps ---
    vim.keymap.set('n', 'gd', function()
        -- Use LSP to get the definition location
        local result = vim.lsp.buf_request_sync(0, "textDocument/definition", vim.lsp.util.make_position_params(), 1000)

        if not result or vim.tbl_isempty(result) then
            print("No definition found. Stef maybe check fallbacks")
            return
        end

        -- Stop clang from marking unused regions of code
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- if client.name == "clangd" then
        if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
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

    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)
    keymap("n", "[d", vim.diagnostic.goto_next, opts)
    keymap("n", "]d", vim.diagnostic.goto_prev, opts)
    keymap("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    keymap("n", "<leader>vrr", vim.lsp.buf.references, opts)
    keymap("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    keymap("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    -- Disable semantic tokens for clangd (fixes annoying highlights)
    if client.name == "clangd" and client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- ============================
-- Capabilities for nvim-cmp
-- ============================
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ============================
-- Setup all servers
-- ============================
-- assume on_attach and capabilities already defined above
local lspconfig = require("lspconfig")
local mlsp = require("mason-lspconfig")

-- servers you want installed / configured
local servers = { "ts_ls", "rust_analyzer", "lua_ls" }

local default_handler = function(server_name)
    lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

local lua_handler = function()
    lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = { globals = { "vim" } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file(),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                }
            },
        },
    })
end

mlsp.setup({
    ensure_installed = servers, -- safe to include again
    handlers = {
        default_handler,
        ["lua_ls"] = lua_handler,
    },
})

-- ============================
-- nvim-cmp Autocompletion
-- ============================
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})
