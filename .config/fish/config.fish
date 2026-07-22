set fish_greeting
fish_vi_key_bindings

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

fish_add_path $_asdf_shims

set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

fish_add_path $HOME/.local/bin
fish_add_path ~/bin

zoxide init fish | source
starship init fish | source

fish_ssh_agent

