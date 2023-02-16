-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("nvim-tree/nvim-web-devicons")

	use("lervag/vimtex")
	use("folke/tokyonight.nvim")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
	})
	use("lukas-reineke/indent-blankline.nvim")
	use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
	use({
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"petertriho/cmp-git",
		"saadparwaiz1/cmp_luasnip",
	})
	use({ "mhartington/formatter.nvim" })
	use({ "mfussenegger/nvim-lint" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })
	use({ "romgrk/barbar.nvim" })
	use({ "kylechui/nvim-surround" })
	use({ "ray-x/lsp_signature.nvim" })
	use({ "windwp/nvim-autopairs" })
	use({ "abecodes/tabout.nvim" })
end)
