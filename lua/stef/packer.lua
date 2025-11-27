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
    })

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
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

    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
    })

    -- Random
    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('voldikss/vim-floaterm')
    use ('tpope/vim-commentary')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('chrisbra/csv.vim')
    use {
      'nmac427/guess-indent.nvim',
      config = function() require('guess-indent').setup {} end,
    }
    use {
        'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
            }
        end
    }
end)
