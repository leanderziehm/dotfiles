. "$HOME/.local/bin/env"

# History file
HISTFILE=~/.zsh_history
HISTSIZE=100000       # number of commands to keep in memory
SAVEHIST=100000       # number of commands to save to file

# Append to the history file, don't overwrite
setopt APPEND_HISTORY

# Share history across all sessions in real time
setopt SHARE_HISTORY

# Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS
