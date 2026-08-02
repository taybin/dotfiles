vim.pack.add({ "https://github.com/nvim-orgmode/orgmode" })
require("orgmode").setup({
	org_agenda_files = "~/orgs/**/*",
	org_default_notes_file = "~/orgs/refile.org",
	org_capture_templates = {
		r = {
			description = "Repo",
			template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
			target = "~/orgs/repos.org",
		},
		o = {
			description = "One on One",
			template = "* %t\n** Their Thoughts\n** My Thoughts\n** Action Items",
			target = "~/orgs/meetings/%^{PROMPT}.org",
		},
	},
})
vim.lsp.enable("org")

vim.pack.add({ "https://github.com/nvim-orgmode/org-bullets.nvim" })
require("org-bullets").setup()

vim.pack.add({ "https://github.com/hamidi-dev/org-list.nvim" })
require("org-list").setup({
	mapping = {
		key = "<leader>olt", -- nvim-orgmode users: you might want to change this to <leader>olt
		desc = "Toggle: Cycle through list types",
	},
	checkbox_toggle = {
		enabled = true,
		-- NOTE: for nvim-orgmode users, you should change the following mapping OR change the one from orgmode.
		-- If both mapping stay the same, the one from nvim-orgmode will "win"
		key = "<C-Space>",
		desc = "Toggle checkbox state",
		filetypes = { "org", "markdown" }, -- Add more filetypes as needed
	},
})

vim.pack.add({ "https://github.com/nvim-orgmode/telescope-orgmode.nvim" })
require("telescope-orgmode").setup()
require("telescope").load_extension("orgmode")

local ext = require("telescope").extensions.orgmode
vim.keymap.set("n", "<leader>soh", ext.search_headings, { desc = "[S]earch [O]rg [H]eadings" })
vim.keymap.set("n", "<leader>sot", ext.search_tags, { desc = "[S]earch [O]rg [T]ags" })
vim.keymap.set("n", "<leader>sor", ext.refile_heading, { desc = "[S]earch [O]rg [R]efile" })
vim.keymap.set("n", "<leader>soi", ext.insert_link, { desc = "[S]earch [O]rg Insert Link" })

vim.pack.add({ "https://github.com/chipsenkbeil/org-roam.nvim" })
require("org-roam").setup({
	directory = "~/orgs/roam",
	org_files = {
		"~/orgs",
	},
})
