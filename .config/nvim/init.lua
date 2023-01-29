require("plugins")

-- for nvim-tree disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1

vim.g.loaded_netrwPlugin = 1

-- Tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Set relative numbering
vim.opt.relativenumber = true
vim.opt.number = true

-- Remap to stop highlight after pattern search
vim.keymap.set("n", "<Leader>/", ":noh<cr>")

-- Remap keys for start/end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- Remap keys for split screen
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Terminal mode remaps exit with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- VimTex Configs

-- This is necessary for VimTeX to load properly. The "indent" is optional.
-- Note that most plugin managers will do this automatically.
vim.cmd([[filetype plugin indent on]])

-- This enables Vim's and neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more
-- info).
vim.cmd([[syntax on]])

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_enabled = 1

-- VimTeX uses latexmk as the default compiler backend. If you use it, which is
-- strongly recommended, you probably don't need to configure anything. If you
-- want another compiler backend, you can change it as follows. The list of
-- supported backends and further explanation is provided in the documentation,
-- see ":help vimtex-compiler".
-- vim.g.vimtex_compiler_method = 'latexrun'

-- Config options inspired by castel.dev
vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_syntax_enabled = 1
vim.g.setconceallevel = 2
vim.g.vimtex_imaps_enabled = 0 -- disable vimtex snippets

vim.g.vimtex_format_enabled = 1

vim.keymap.set("n", "<localleader>c", "<Plug>(vimtex-compile)")
vim.keymap.set("n", "<localleader>v", "<Plug>(vimtex-view)")

local function tex_focus_vim()
	vim.cmd([[silent execute "!open -a kitty"]])
	vim.cmd([[redraw!]])
end

vim.cmd([[function! s:TexFocusVim() abort
  silent execute "!open -a kitty"
  redraw!
endfunction

augroup vimtex_event_focus
  au!
  au User VimtexEventViewReverse call s:TexFocusVim()
augroup END]])
-- End of Vimtex Config

-- Theme
require("tokyonight").setup({
	style = "night",
})
vim.cmd([[colorscheme tokyonight]])
-- End Theme

-- Lualine
require("lualine").setup({
	theme = "tokyonight",
})
-- end Lualine

-- nvim-tree

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Mappings for home row navigation of tree and toggling tree
-- empty setup using defaults
local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")

local function collapse_all()
	require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
	-- open as vsplit on current node
	local action = "edit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
		view.close() -- Close the tree if file was opened
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
		view.close() -- Close the tree if file was opened
	end
end

local function vsplit_preview()
	-- open as vsplit on current node
	local action = "vsplit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
	end

	-- Finally refocus on tree if it was lost
	view.focus()
end

local config = {
	view = {
		side = "right",
		mappings = {
			custom_only = false,
			list = {
				{ key = "l", action = "edit", action_cb = edit_or_open },
				{ key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
				{ key = "h", action = "close_node" },
				{ key = "H", action = "collapse_all", action_cb = collapse_all },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = false,
		},
	},
}

vim.api.nvim_set_keymap("n", "<leader>t", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
require("nvim-tree").setup(config)

-- end nvim-tree

-- TreeSitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "rust", "latex" },
})
-- end TreeSitter

-- Start LuaSnip
vim.cmd([[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

" Cycle forward through choice nodes with Control-f (for example)
imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>'
]])
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
require("luasnip").config.set_config({ -- Setting LuaSnip config

	-- Enable autotriggered snippets
	enable_autosnippets = true,

	-- Use Tab (or some other key if you prefer) to trigger visual selection
	store_selection_keys = "<Tab>",

	-- Repeated node updates as you type
	update_events = "TextChanged, TextChangedI",
})
-- End LuaSnip

-- Start indent_blankline
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup({
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
	char = "▎",
})
-- End indent-blankline

-- Start LSP Configs and coq
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
end

vim.cmd([[
let g:coq_settings = { "keymap.recommended": v:false }
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Up>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <Down> pumvisible() ? "\<C-p>" : "\<BS>"]])
local lsp = require("lspconfig")
local coq = require("coq")

lsp.pylsp.setup({ coq.lsp_ensure_capabilities({ on_attach = on_attach }) })
lsp.sumneko_lua.setup({ coq.lsp_ensure_capabilities({ on_attach = on_attach }) })
lsp.texlab.setup({ coq.lsp_ensure_capabilities({ on_attach = on_attach }) })

-- Autostart COQ
vim.cmd("COQnow -s")

-- End LSP Configs and COQ

-- Start formatter
-- Mappings

vim.keymap.set("n", "<leader>f", ":Format<CR>")
vim.keymap.set("n", "<leader>F", ":FormatWrite<CR>")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- Use the special "*" filetype for defining formatter configurations on
			-- any filetype
			["*"] = {
				-- "formatter.filetypes.any" defines default configurations for any
				-- filetype
				require("formatter.filetypes.any").remove_trailing_whitespace,
			},
		},
	},
})

-- End formatter

-- Start nvim-lint
require("lint").linters_by_ft = {
	py = { "flake8", "mypy" },
	lua = { "luacheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- End nvim-lint
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
-- Begin telescope

-- begin barbar
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
vim.keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
vim.keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
-- Re-order to previous/next
vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
-- Goto buffer in position...
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
-- Pin/unpin buffer
vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
-- Close buffer
vim.keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
-- Sort automatically by...
vim.keymap.set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
vim.keymap.set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
vim.keymap.set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
vim.keymap.set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

-- So that nvim tree doesnt look weird
local nvim_tree_events = require("nvim-tree.events")
local bufferline_api = require("bufferline.api")

local function get_tree_size()
	return require("nvim-tree.view").View.width
end

nvim_tree_events.subscribe("TreeOpen", function()
	bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("Resize", function()
	bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("TreeClose", function()
	bufferline_api.set_offset(0)
end)

-- End barbr
