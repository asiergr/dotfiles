-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
    use 'nvim-tree/nvim-web-devicons'

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
	use({ "ms-jpq/coq_nvim", branch = "coq" })
	use({ "mhartington/formatter.nvim" })
	use({ "mfussenegger/nvim-lint" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })
	use({ "romgrk/barbar.nvim" })
end)
