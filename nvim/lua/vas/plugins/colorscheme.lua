return {
	--"savq/melange-nvim",
	"rose-pine/neovim",
	priority = 1000, -- load before plugins
	config = function()
		--vim.cmd.colorscheme("melange")
		vim.cmd.colorscheme("rose-pine-dawn")
	end,
}
