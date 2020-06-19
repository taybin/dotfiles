set fish_greeting
fish_vi_key_bindings

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

starship init fish | source
