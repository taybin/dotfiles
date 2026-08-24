-- Machine-local project roots for lua/custom/plugins/project.lua.
--
-- Copy this file to `projects.lua` in this directory and edit it. The copy is
-- gitignored, so each machine keeps its own roots without touching the shared
-- config:
--
--   cp lua/custom/private/projects.example.lua lua/custom/private/projects.lua
--
-- If `projects.lua` is absent, project.lua falls back to the defaults shown
-- below, so a fresh checkout works with no setup.

return {
	-- Directories to scan for git repositories. A repo is any directory
	-- containing a `.git` entry (directory or file, so worktrees and
	-- submodule checkouts both count). "~" is expanded.
	--
	-- The scan does not descend into a repo once it finds one, so nested
	-- submodules and vendored checkouts do not show up as separate projects.
	roots = { "~/src" },

	-- How many levels below each root to search. Repos deeper than this are
	-- not found. 4 covers a ~/src/<group>/<subgroup>/<repo> layout.
	max_depth = 4,

	-- Passed straight through to neovim-project's `ignore_projects`. Glob
	-- patterns matched against discovered project paths.
	--
	-- NOTE: dot-directories (.venv, .vscode, node_modules, and friends) are
	-- already skipped by the scanner, so this is only for repos you want
	-- hidden from the picker. The flip side of that rule: a repo whose own
	-- directory name starts with "." will not be discovered.
	ignore = {},
}
