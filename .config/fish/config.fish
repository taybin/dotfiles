set fish_greeting
fish_vi_key_bindings

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish ; or true

zoxide init fish | source
starship init fish | source

fish_ssh_agent

source /usr/local/opt/asdf/libexec/asdf.fish

# Created by `pipx` on 2022-10-05 17:51:05
set PATH $PATH /Users/taybin.rutkin/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/taybin.rutkin/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set PATH ~/bin $PATH
