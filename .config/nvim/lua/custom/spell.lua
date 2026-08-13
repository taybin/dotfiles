-- ============================================================
-- SPELL CHECKING
-- Built-in spell checker with two word lists: one per project,
-- one per user. No plugins.
--
-- `zg`/`zw` add to the project list (<root>/.nvim-spell/), and
-- `<leader>zg`/`<leader>zw` add to the user list. See `:help spell`.
-- ============================================================

-- The user-wide word list. Its directory does not exist on a fresh install,
-- so it is created on first use.
local user_add = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "spell", "en.utf-8.add")

-- Check `getUserName` as `get`, `User`, `Name` rather than one bogus word.
vim.o.spelloptions = "camel"

-- `.nvim-spell` comes first so an explicitly marked subdirectory wins over an
-- enclosing repo. Note that yadm-managed files match neither marker: yadm keeps
-- its git dir outside the work tree, which is what stops all of $HOME from
-- being treated as a single project.
local markers = { ".nvim-spell", ".git" }

-- Walking the filesystem on every BufEnter is wasteful, so remember what each
-- directory resolved to. `false` records "no marker found".
local root_cache = {}

---@param buf integer
---@return string|nil
local function project_root(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return nil
	end

	local dir = vim.fs.dirname(name)
	if root_cache[dir] == nil then
		root_cache[dir] = vim.fs.root(buf, markers) or false
	end

	return root_cache[dir] or nil
end

---@param buf integer
---@return string|nil project The project word list, if this buffer is in one
---@return string user The user-wide word list
local function word_lists(buf)
	local root = project_root(buf)
	local project = root and vim.fs.joinpath(root, ".nvim-spell", "en.utf-8.add") or nil
	return project, user_add
end

-- 'spellfile' is a comma-separated list, so commas and spaces in a path have to
-- be escaped or they would read as separators.
---@param path string
---@return string
local function escape(path)
	return (path:gsub("([ ,])", "\\%1"))
end

---@param buf integer
---@param win integer
local function apply(buf, win)
	local project, user = word_lists(buf)

	local entries = { escape(user) }
	if project then
		entries = { escape(project), escape(user) }
	end
	vim.bo[buf].spellfile = table.concat(entries, ",")

	-- Terminal, help, quickfix and scratch buffers are noise.
	vim.wo[win].spell = vim.bo[buf].buftype == ""
end

local group = vim.api.nvim_create_augroup("custom-spell", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	group = group,
	desc = "Point 'spellfile' at the project and user word lists",
	callback = function(args)
		apply(args.buf, vim.api.nvim_get_current_win())
	end,
})

-- [[ Adding words ]]
--
-- A count picks the entry in 'spellfile', so `1zg` is the project list and
-- `2zg` the user list. The wrappers below work out that index, since it shifts
-- to 1 for both when a buffer is not inside a project.

---@param scope "project"|"user"
---@param cmd string The normal-mode command to run, e.g. "zg"
local function add_word(scope, cmd)
	local buf = vim.api.nvim_get_current_buf()
	local project, user = word_lists(buf)

	-- Without a project, the user list is the only entry, so both scopes land
	-- on it. This is also what makes `zg` keep working outside any repo.
	local path = (scope == "project" and project) or user
	local index = (path == project) and 1 or (project and 2 or 1)

	vim.fn.mkdir(vim.fs.dirname(path), "p")

	-- The directory hides itself from git rather than editing the repo's own
	-- .gitignore. yadm honours this too, being git underneath.
	if path == project then
		local ignore = vim.fs.joinpath(vim.fs.dirname(path), ".gitignore")
		if not vim.uv.fs_stat(ignore) then
			vim.fn.writefile({ "*" }, ignore)
		end
	end

	vim.cmd("normal! " .. index .. cmd)
end

vim.keymap.set("n", "zg", function()
	add_word("project", "zg")
end, { desc = "Add word to project dictionary" })

vim.keymap.set("n", "zw", function()
	add_word("project", "zw")
end, { desc = "Mark word bad in project dictionary" })

vim.keymap.set("n", "<leader>zg", function()
	add_word("user", "zg")
end, { desc = "Add word to user dictionary" })

vim.keymap.set("n", "<leader>zw", function()
	add_word("user", "zw")
end, { desc = "Mark word bad in user dictionary" })

-- `zug`/`zuw` are left alone: they undo against entry 1, which is the project
-- list when there is one. Use `2zug` to undo a word in the user list.

require("which-key").add({
	{ "<leader>z", group = "Spelling" },
})
