vim.pack.add({ "https://github.com/vuki656/package-info.nvim" })
vim.pack.add({ "https://github.com/MunifTanjim/nui.nvim" })

require("package-info").setup({})

-- Documented by which-key under the existing `<leader>t` [T]oggle group.
vim.keymap.set("n", "<leader>tp", "<cmd>PackageInfoToggle<cr>", { desc = "[T]oggle [P]ackage Info" })
