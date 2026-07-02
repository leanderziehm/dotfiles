#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(dirname "$(realpath "$0")")"

DOTFILES=(
	~/.bashrc
    ~/.tmux.conf
    ~/.vimrc
    ~/.config/nvim/init.lua
)

    # ~/.zshrc
    # ~/.config/i3
    # ~/.wezterm.lua
    # ~/.config/hypr
    # ~/.vimrc
	# ~/.bashrc
    # ~/.config/nvim/init.lua
    # ~/.wezterm.lua
    # ~/.tmux.conf
    # ~/.vimrc
    # ~/.zshrc
    # ~/.config/kglobalshortcutsrc
    # ~/.config/Code/User/keybindings.json
    # ~/.config/Code/User/settings.json
    # ~/.config/Code/User/profiles/
    # ~/.config/i3
    # ~/.config/hypr
    # ~/.config/yazi/
    # ~/.config/dunst
    # ~/.config/kitty
    # ~/.config/flameshot


IGNORE=(
    "*state.vscdb*"
    "*.backup*"
)

HOSTNAME=$(hostname)
echo $HOSTNAME
sync_dir="$DOTFILES_DIR/sync/$HOSTNAME-$USER/"
mkdir -p "$sync_dir"



matches_ignore() {
    local file="$1"
    for pattern in "${IGNORE[@]}"; do
        if [[ "$file" == $pattern ]]; then
            return 0  # matched ignore
        fi
    done
    return 1  # did not match
}



for dir_to_sync in "${DOTFILES[@]}"; do

    if [[ ! -e "$dir_to_sync" ]]; then
        echo "- Directory does not exist: $dir_to_sync"
        continue
    fi

    if [[ -f "$dir_to_sync" ]]; then
        # Strip home directory prefix
        file_rel="${dir_to_sync/#$HOME\//}"
       
        if matches_ignore "$file_rel"; then
            #echo "- Ignored file: $file_rel"
            continue
        fi

        dest="$sync_dir/$file_rel"

        mkdir -p "$(dirname "$dest")"
        cp -p "$dir_to_sync" "$dest"
    else
        find "$dir_to_sync" -type f | while IFS= read -r file; do
            file_real="$(realpath "$file")"
            file_rel="${file_real/#$HOME\//}"

            if matches_ignore "$file_rel"; then
                #echo "- Ignored file: $file_rel"
                continue
            fi

            dest="$sync_dir/$file_rel"
            mkdir -p "$(dirname "$dest")"
            cp -p "$file_real" "$dest"
            #echo "+ Copied file: $file_real to $dest"
        done
    fi
done



GIT_MODE=false
if [[ "${1:-}" == "git" ]]; then
    GIT_MODE=true
fi



if command -v git &>/dev/null; then
    cd "$DOTFILES_DIR" || exit 1

    # Get the list of changed files
    changed_files=$(git diff --name-only)

    if [[ -n "$changed_files" ]]; then
        echo "[INFO] Files changed:"
        echo "$changed_files"
        echo ""
    else
        echo "[INFO] No changes detected."
    fi
fi

if [[ "$GIT_MODE" == true ]]; then
    cd "$DOTFILES_DIR"
    # Stage changes
    git add .
    # Commit changes if any, capture the result
    if git commit -m "sync" 2>/dev/null; then
        # Only push if commit was successful (there were changes)
        git push
        echo "[INFO] Changes committed and pushed to git"
    else
        echo "[INFO] No changes to commit, nothing pushed"
    fi
fi
