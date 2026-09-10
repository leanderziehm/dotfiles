#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(dirname "$(realpath "$0")")"
SYNC_DIR="$DOTFILES_DIR/sync"

HOSTNAME="$(hostname)"
USER_NAME="$(whoami)"

DEFAULT_LIST="$SYNC_DIR/default.list"
HOST_LIST="$SYNC_DIR/${HOSTNAME}.list"

IGNORE=(
    "*state.vscdb*"
    "*.backup*"
)

matches_ignore() {
    local file="$1"
    for pattern in "${IGNORE[@]}"; do
        [[ "$file" == $pattern ]] && return 0
    done
    return 1
}

load_dotfiles() {
    local file="$1"
    [[ -f "$file" ]] || return 1
    mapfile -t DOTFILES < "$file"
}

get_dotfiles() {
    if [[ -f "$HOST_LIST" ]]; then
        load_dotfiles "$HOST_LIST"
    else
        load_dotfiles "$DEFAULT_LIST"
    fi
}

sync_files() {
    local sync_dir="$DOTFILES_DIR/sync/${HOSTNAME}-${USER_NAME}"
    mkdir -p "$sync_dir"

    get_dotfiles

    for path in "${DOTFILES[@]}"; do
        [[ -e "$path" ]] || continue

        if [[ -f "$path" ]]; then
            rel="${path/#$HOME\//}"

            if matches_ignore "$rel"; then
                continue
            fi

            dest="$sync_dir/$rel"
            mkdir -p "$(dirname "$dest")"
            cp -p "$path" "$dest"
        else
            find "$path" -type f | while read -r file; do
                rel="${file/#$HOME\//}"

                if matches_ignore "$rel"; then
                    continue
                fi

                dest="$sync_dir/$rel"
                mkdir -p "$(dirname "$dest")"
                cp -p "$file" "$dest"
            done
        fi
    done
}

git_status() {
    cd "$DOTFILES_DIR"
    git diff --name-only || true
}

git_sync() {
    cd "$DOTFILES_DIR"

    git add .

    if git commit -m "sync" 2>/dev/null; then
        git push
        echo "[OK] pushed"
    else
        echo "[OK] no changes"
    fi
}

list_dotfiles() {
    get_dotfiles
    printf "%s\n" "${DOTFILES[@]}"
}

add_dotfile() {
    local file="$1"
    local target="$DEFAULT_LIST"

    mkdir -p "$SYNC_DIR"

    if [[ ! -f "$target" ]]; then
        touch "$target"
    fi

    echo "$file" >> "$target"
    sort -u "$target" -o "$target"

    echo "[OK] added: $file"
}

remove_dotfile() {
    local file="$1"
    local target="$DEFAULT_LIST"

    [[ -f "$target" ]] || return 0

    grep -vF "$file" "$target" > "${target}.tmp" || true
    mv "${target}.tmp" "$target"

    echo "[OK] removed: $file"
}

case "${1:-sync}" in
    sync)
        sync_files
        ;;
    git)
        sync_files
        git_sync
        ;;
    status)
        git_status
        ;;
    list)
        list_dotfiles
        ;;
    add)
        add_dotfile "${2:-}"
        ;;
    remove)
        remove_dotfile "${2:-}"
        ;;
    *)
        echo "Usage: $0 {sync|git|status|list|add <file>|remove <file>}"
        exit 1
        ;;
esac