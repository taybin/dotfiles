set fish_greeting
fish_vi_key_bindings

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin

zoxide init fish | source
starship init fish | source

fish_ssh_agent

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims
# end ASDF configuration code

# Created by `pipx` on 2022-10-05 17:51:05
set PATH $PATH /Users/taybin.rutkin/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/taybin.rutkin/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set PATH ~/bin $PATH
