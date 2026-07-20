#!/bin/sh
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
short_dir=$(echo "$dir" | sed "s|^$HOME|~|")

# Get current git branch (skip optional locks to avoid stalling)
branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)

# Gruvbox dark 24-bit colors (R;G;B)
FG0="251;241;199"     # #fbf1c7 - light cream
BG1="60;56;54"        # #3c3836 - dark (used as dir text color)
BG3="102;92;84"       # #665c54 - medium dark (context segment bg)
C_BLUE="69;133;136"   # #458588 - model segment bg
C_AQUA="102;157;105"  # #689d6a - git branch segment bg
C_YELLOW="215;153;23" # #d79921 - directory segment bg

# Powerline right-pointing filled arrow (U+E0B0)
SEP=""

# ANSI helpers — produce actual escape bytes
ESC=$(printf '\033')
fg() { printf "${ESC}[38;2;%sm" "$1"; }
bg() { printf "${ESC}[48;2;%sm" "$1"; }
RS="${ESC}[0m"

# Segment 1: Directory — yellow background, dark foreground
out="$(bg "$C_YELLOW")$(fg "$BG1") ${short_dir} "

# Arrow into Segment 2: git branch (if present) or model
if [ -n "$branch" ]; then
    out="${out}$(fg "$C_YELLOW")$(bg "$C_AQUA")${SEP}"
    # Segment 2: Git branch — aqua background
    out="${out}$(fg "$FG0") ${branch} "
    out="${out}$(fg "$C_AQUA")$(bg "$C_BLUE")${SEP}"
else
    out="${out}$(fg "$C_YELLOW")$(bg "$C_BLUE")${SEP}"
fi

# Segment 3: Model name — blue background
out="${out}$(fg "$FG0") ${model} "

# Arrow into Segment 4 (context %) or closing arrow
if [ -n "$used" ]; then
    out="${out}$(fg "$C_BLUE")$(bg "$BG3")${SEP}"
    # Segment 4: Context used — bg3 background
    out="${out}$(fg "$FG0") ${used}% ctx "
    out="${out}${RS}$(fg "$BG3")${SEP}${RS}"
else
    out="${out}${RS}$(fg "$C_BLUE")${SEP}${RS}"
fi

printf "%s\n" "$out"
