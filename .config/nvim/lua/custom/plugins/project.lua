-- Project / session management via neovim-project.
--
-- Projects are discovered by scanning for git repositories under a set of
-- roots. Those roots are machine-specific and therefore live in a gitignored
-- file, `lua/custom/private/projects.lua` -- see projects.example.lua there for
-- the shape. Everything in *this* file is generic and shared across machines.
--
-- Note the scan lives here rather than in neovim-project's `projects` globs
-- because the plugin does no project-marker filtering: a glob like `~/src/*/*`
-- matches every directory at that depth, repo or not.

local uv = vim.uv or vim.loop

local defaults = {
	roots = { "~/src" },
	max_depth = 4,
	ignore = {},
}

local function machine_config()
	-- Drop the cached module so edits to the roots file take effect on the next
	-- picker open rather than the next restart. (`ignore` is only read at setup,
	-- so changing that one still needs a restart.)
	package.loaded["custom.private.projects"] = nil
	local ok, cfg = pcall(require, "custom.private.projects")
	if not ok or type(cfg) ~= "table" then
		return defaults
	end
	return vim.tbl_deep_extend("force", defaults, cfg)
end

-- Directories never worth descending into. Dot-directories are skipped
-- wholesale by the scanner, so this only needs the noisy non-dotted ones.
local skip = {
	["node_modules"] = true,
	["venv"] = true,
	["__pycache__"] = true,
	["target"] = true,
	["build"] = true,
	["dist"] = true,
	["site"] = true,
	["coverage"] = true,
}

-- `.git` is a directory in a normal clone but a file in worktrees and
-- submodule checkouts, so any stat hit counts.
local function is_repo(dir)
	return uv.fs_stat(dir .. "/.git") ~= nil
end

local function scan(dir, depth, max_depth, out)
	if depth > max_depth then
		return
	end
	local iter = uv.fs_scandir(dir)
	if not iter then
		return
	end
	while true do
		local name, entry_type = uv.fs_scandir_next(iter)
		if not name then
			break
		end
		if not skip[name] and name:sub(1, 1) ~= "." then
			local path = dir .. "/" .. name
			if entry_type ~= "directory" then
				-- Resolve symlinks, and cover filesystems that don't report a
				-- type from scandir.
				local stat = uv.fs_stat(path)
				entry_type = stat and stat.type or nil
			end
			if entry_type == "directory" then
				if is_repo(path) then
					-- Don't descend: nested submodules aren't separate projects.
					out[#out + 1] = path
				else
					scan(path, depth + 1, max_depth, out)
				end
			end
		end
	end
end

local function discover()
	local cfg = machine_config()
	local found = {}
	for _, root in ipairs(cfg.roots) do
		local dir = (vim.fn.expand(root):gsub("/+$", ""))
		if uv.fs_stat(dir) then
			scan(dir, 1, cfg.max_depth, found)
		end
	end
	table.sort(found)
	return found
end

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/Shatur/neovim-session-manager" },
	{ src = "https://github.com/coffebar/neovim-project" },
})

-- Required by neovim-project so session files capture global variables.
vim.opt.sessionoptions:append("globals")

-- Buffers to keep out of saved sessions. Extend the plugin's own defaults
-- rather than restating them, so upstream additions aren't silently dropped;
-- fall back to just our own entries if that internal table moves.
local autosave_ignore_filetypes = { "NvimTree" } -- a restored tree buffer comes back inert
do
	local ok, plugin_config = pcall(require, "neovim-project.config")
	local upstream = ok
		and plugin_config.defaults
		and plugin_config.defaults.session_manager_opts
		and plugin_config.defaults.session_manager_opts.autosave_ignore_filetypes
	if type(upstream) == "table" then
		autosave_ignore_filetypes = vim.list_extend(vim.deepcopy(upstream), autosave_ignore_filetypes)
	end
end

require("neovim-project").setup({
	-- Populated on demand -- see refresh() below.
	projects = {},
	ignore_projects = machine_config().ignore,
	-- Bare `nvim` gets a normal empty buffer; projects are opened explicitly.
	last_session_on_startup = false,
	picker = { type = "telescope" },
	session_manager_opts = {
		autosave_ignore_filetypes = autosave_ignore_filetypes,
	},
})

-- neovim-project expands `projects` lazily, when a picker opens, so refreshing
-- it just beforehand costs nothing at startup and never goes stale after a new
-- clone. `config.options` is internal, so degrade loudly rather than silently
-- handing the picker an empty list if a plugin update moves it.
local warned = false
local function refresh()
	local ok, plugin_config = pcall(require, "neovim-project.config")
	if ok and type(plugin_config.options) == "table" then
		plugin_config.options.projects = discover()
	elseif not warned then
		warned = true
		vim.notify(
			"neovim-project: could not refresh the project list; "
				.. "`neovim-project.config.options` is not the expected shape. "
				.. "See lua/custom/plugins/project.lua.",
			vim.log.levels.WARN
		)
	end
end

local function project_cmd(cmd)
	return function()
		refresh()
		vim.cmd(cmd)
	end
end

pcall(function()
	require("which-key").add({ { "<leader>p", group = "[P]roject" } })
end)

vim.keymap.set("n", "<leader>pp", project_cmd("NeovimProjectDiscover"), { desc = "[P]roject: find [P]roject" })
vim.keymap.set("n", "<leader>ph", project_cmd("NeovimProjectHistory"), { desc = "[P]roject: recent [H]istory" })
vim.keymap.set("n", "<leader>pl", project_cmd("NeovimProjectLoadRecent"), { desc = "[P]roject: [L]oad last session" })

-- Exposed for inspection and debugging:
--   :lua vim.print(require("custom.plugins.project").discover())
return { discover = discover }
