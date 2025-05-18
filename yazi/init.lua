local home = os.getenv("HOME")
require("bunny"):setup({
	hops = {
		{ tag = "home", path = home, key = "h" },
		{ tag = "config", path = home .. "/.config", key = "c" },
		{ tag = "local", path = home .. "/.local", key = "l" },
		{ tag = "downloads", path = home .. "/Downloads", key = "d" },
		{ tag = "music", path = home .. "/Music", key = "m" },
		{ tag = "pictures", path = home .. "/Pictures", key = "p" },
		{ tag = "videos", path = home .. "/Videos", key = "v" },
		{ tag = "repo", path = home .. "/repo", key = "r" },
		{ tag = "root", path = "/", key = "R" },
	},
	notify = true, -- notify after hopping, default is false
	fuzzy_cmd = "sk", -- fuzzy searching command, default is fzf
})
