return {
	--"savq/melange-nvim",
	--"rose-pine/neovim",
	"Mofiqul/adwaita.nvim",
	priority = 1000, -- load before plugins
	config = function()
		--vim.cmd.colorscheme("melange")
		--vim.cmd.colorscheme("rose-pine-dawn")
		vim.cmd.colorscheme("adwaita")
	end,
}
