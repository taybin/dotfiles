vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("nvim-tree").setup()

-- Documented by which-key under the existing `<leader>t` [T]oggle group.
vim.keymap.set("n", "<leader>tv", "<cmd>NvimTreeToggle<cr>", { desc = "[T]oggle File Tree [V]iew" })
