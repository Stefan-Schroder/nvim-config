-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use ({
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    })

    -- Theme
    use ({
        'rose-pine/neovim',
        as = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    -- Copilot
    use ('zbirenbaum/copilot.lua')
    use ('zbirenbaum/copilot-cmp')
    use ({
        'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary',
        requires = {
            { 'zbirenbaum/copilot.lua' },
            { 'nvim-lua/plenary.nvim' }
        },
        build = 'make tiktoken'
    })

    -- For the LSP
    use({'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'})
    use({'neovim/nvim-lspconfig'})
    use({'williamboman/mason.nvim'})
    use({'williamboman/mason-lspconfig'})
    use({'hrsh7th/nvim-cmp'})
    use({'hrsh7th/cmp-nvim-lsp'})
    use({'hrsh7th/cmp-buffer'})
    use({'saadparwaiz1/cmp_luasnip'})
    use({'L3MON4D3/LuaSnip'})

    -- Random
    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('tpope/vim-commentary')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('chrisbra/csv.vim')
    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
            }
        end
    }
end)
