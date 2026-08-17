-- Root of the org files, so this config can be shared between machines that
-- store them in different places. Set NVIM_ORG_DIR per machine, e.g.
--   set -Ux NVIM_ORG_DIR "$HOME/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org"
-- Defaults to ~/orgs when unset.
local org_dir = (function()
	local dir = vim.env.NVIM_ORG_DIR
	if dir == nil or dir == "" then
		dir = "~/orgs"
	end
	-- Expand a leading "~" by hand; vim.fn.expand() would also chew on the
	-- "~" characters inside the iCloud container name.
	local home = vim.env.HOME or vim.loop.os_homedir()
	if dir == "~" then
		dir = home
	elseif dir:sub(1, 2) == "~/" then
		dir = home .. dir:sub(2)
	end
	return (dir:gsub("/+$", ""))
end)()

-- Join a path relative to the org root.
local function org_path(relative)
	return org_dir .. "/" .. relative
end

vim.pack.add({ "https://github.com/nvim-orgmode/orgmode" })
require("orgmode").setup({
	org_agenda_files = org_path("**/*"),
	org_default_notes_file = org_path("refile.org"),
	org_capture_templates = {
		r = {
			description = "Repo",
			template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
			target = org_path("repos.org"),
		},
		o = {
			description = "One on One",
			template = "* %t\n** Their Thoughts\n** My Thoughts\n** Action Items",
			target = org_path("meetings/%^{PROMPT}.org"),
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
	directory = org_path("roam"),
	org_files = {
		org_dir,
	},
})
