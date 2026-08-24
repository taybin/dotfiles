vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_cursor = true,
	-- Follow `:cd`. neovim-project switches projects with `nvim_set_current_dir`,
	-- which fires DirChanged; without this the tree keeps the root it was first
	-- opened with and shows the previous project's files.
	sync_root_with_cwd = true,
})

-- Documented by which-key under the existing `<leader>t` [T]oggle group.
vim.keymap.set("n", "<leader>tv", "<cmd>NvimTreeToggle<cr>", { desc = "[T]oggle File Tree [V]iew" })

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#ppwwyyxx
vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		local invalid_win = {}
		local wins = vim.api.nvim_list_wins()
		for _, w in ipairs(wins) do
			local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
			if bufname:match("NvimTree_") ~= nil then
				table.insert(invalid_win, w)
			end
		end
		if #invalid_win == #wins - 1 then
			-- Should quit, so we close all invalid windows.
			for _, w in ipairs(invalid_win) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end,
})
