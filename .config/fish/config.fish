set PATH ~/bin $PATH
set fish_greeting
fish_vi_key_bindings

set EDITOR nvim
set VISUAL nvim

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

starship init fish | source
