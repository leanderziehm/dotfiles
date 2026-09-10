#  ============================================================
#  Autocomplete
#  ============================================================
if [[ -n $BASH_VERSION && $- == *i* ]]; then
  set -o emacs 2>/dev/null || return  # WARNING: I HAVE NO IDEA WHAT THIS DOES? [CHATGPT GENERATED CODE]
  bind 'set show-all-if-ambiguous on'
  bind 'set menu-complete-display-prefix on'
  bind '"\t":menu-complete'
  bind '"\e[Z":menu-complete-backward'
  bind '"\C-r": reverse-search-history'
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
fi





_git_branches() {
  COMPREPLY=($(compgen -W "$(git branch --all | sed 's#^\s*##' | sed 's#remotes/##')" -- "${COMP_WORDS[1]}"))
}
complete -F _git_branches checkout


#  ============================================================
#  TMUX
#  ============================================================
# Autostart tmux
# if [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s dev
# fi


tmux_fzf_dev_picker() {
local files selected

files=$(ls "$HOME"$HOME/dev/{sd*,tty*} 2>/dev/null)
[ -z "$files" ] && {
echo "No matching directories found"
read -r
return
}

selected=$(printf "%s\n" $files | fzf 
--height 40% 
--border 
--prompt "Select file: ")

clear
echo "$selected"
read -rp "Press Enter to close..."
}


tmux_project() {
    local DEV_DIR="$HOME/dev"
    local dirs
    local selected
    local SESSION_NAME
    local SESSION_DIR

    # List directories up to depth 3, exclude hidden ones
    dirs=$(find "$DEV_DIR" -maxdepth 3 -mindepth 1 -type d ! -name ".*" | sed "s|^$HOME|~|")

    # Use FZF for exact matching
    selected=$(printf '%s\n' "$dirs" | fzf --exact --prompt="Select project dir: ")

    # Exit if no selection
    [[ -z "$selected" ]] && return 0

    # Remove ~/dev/ prefix for tmux session name
    SESSION_NAME="${selected#"$HOME/dev/"}"
    SESSION_DIR="${selected/#\~/$HOME}"  # expand ~ to $HOME

    # Check if tmux session exists
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo "Session '$SESSION_NAME' already exists. Attaching..."
        tmux attach -t "$SESSION_NAME"
    else
        echo "Creating new tmux session '$SESSION_NAME' in $SESSION_DIR..."
        tmux new-session -s "$SESSION_NAME" -c "$SESSION_DIR"
    fi
}

# Disable X11 beep
#xset b off

# Store command history forever
HISTFILE=~/.bash_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE   # In Bash, just HISTSIZE is enough
shopt -s histappend   # Append to history rather than overwrite




#### Programming Languages

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# JBang
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

# Python / Miniconda
#conda-activate() { source ~/miniconda3/bin/activate; }

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# Go
export PATH="$HOME/go/bin:$PATH"

# Bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH="$BUN_INSTALL/bin:$PATH"
#[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"


#####
# User scripts
export PATH="$PATH:/home/user/.local/bin:/home/user/bin:$HOME/bin"
export PATH="$HOME/bin/commands:$PATH"

##### Aliases


alias dotfiles='/home/user/dotfiles/dotfiles.sh'
alias pacman-ophins-list="pacman -Qtdq"
alias pacman-ophins-remove="sudo pacman -Rns $(pacman -Qtdq)"
alias pacman-installed="pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{size=$4} END{print name,size}' | sort -nrk2"

# Vim / editor

# alias vim="nvim"
alias bashrc="vim ~/.bashrc"
alias nvimrc="vim ~/.config/nvim/init.lua"
alias i3config="vim ~/.config/i3/config"
#alias lvim="NVIM_APPNAME=LazyVim nvim"
#alias svim="NVIM_APPNAME=SlimNvim nvim"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias slides="vim ~/dev/repos/00_active-repos/presentation-artificial-intelligence/slides.md"
alias fzfman="apropos . | fzf --exact"
alias manfzf="apropos . | fzf --exact"
alias zoxide-debug="zoxide query -l -s"

export EDITOR=vim


#####
# ff_find_files() {
#   find ~/dev ~/.config \
#     \( -name "node_modules" -o -name ".git" -o -name ".venv" -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.webp" -o -name "*.gif" -o -name "*.ico" -o -name "*.ttf" -o -name "*.woff" -o -name "*.woff2" -o -name "*.pfb" -o -name "*.hyb" -o -name "*.bcmap" -o -name "*.class" -o -name "*.so" -o -name "*.jar" -o -name "*.pyc" -o -name "*.tflite" -o -name "*.tgz" -o -path "*/leveldb/*" -o -name "*.dat" -o -name "*.lock" -o -name "*.db" -o -name "*.syms" -o -path "*/dist-info/*" -o -name "*.old" -o -name "*.map" \) -prune -o -type f -print 2>/dev/null | sed "s|^$HOME|~|"
# }
# ff() {
#   local file=$(ff_find_files | fzf --exact --ignore-case --query="$1") || return
#   vim "$file"
# }

# WIKI setup
export WIKI_ROOT=~/dev/wiki
alias wiki="cd $WIKI_ROOT && vim $WIKI_ROOT/index.md"
alias wiki-git="cd $WIKI_ROOT && git add . && git commit -m 'sync' && git push"
# --------------------
# Journal function with embedded template
# journal() {
#   local NOTES_DIR="$WIKI_ROOT/journal"
#   local TS="$(date '+%Y-%m-%d_%H%M')"
#   local DATE="$(date '+%Y-%m-%d')"
#   local FILE="$NOTES_DIR/$TS.md"
#
#   mkdir -p "$NOTES_DIR"
#
#   cat > "$FILE" <<EOF
# # Journal — $DATE
#
# ## Context
# - Location:
# - Mood:
# - Focus:
#
# ## Notes
#
# ## Reflection
# EOF
#
#   vim "$FILE"
# }

# --------------------
# Idea function with embedded template
# idea() {
#   local NOTES_DIR="$WIKI_ROOT/ideas"
#   local TS="$(date '+%Y-%m-%d %H:%M:%S')"
#   local ID="$(date +%s)-$(openssl rand -hex 2)"
#   local FILE="$NOTES_DIR/$ID.md"
#
#   mkdir -p "$NOTES_DIR"
#
#   cat > "$FILE" <<EOF
# ---
# id: $ID
# created: $TS
# tags: []
# ---
#
# # $ID
#
# ## Idea
#
# ## Links
# - 
# EOF
#
#   vim "$FILE"
# }
#


ff_find_files() {
    local dirs=(~/dev ~/.config)
    find "${dirs[@]}" \
        \( -name "node_modules" -o -name ".git" -o -name ".venv" \
           -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.webp" -o -name "*.gif" -o -name "*.ico" \
           -o -name "*.ttf" -o -name "*.woff" -o -name "*.woff2" -o -name "*.pfb" -o -name "*.hyb" -o -name "*.bcmap" \
           -o -name "*.class" -o -name "*.so" -o -name "*.jar" -o -name "*.pyc" -o -name "*.tflite" -o -name "*.tgz" \
           -o -path "*/leveldb/*" -o -name "*.dat" -o -name "*.lock" -o -name "*.db" -o -name "*.syms" -o -path "*/dist-info/*" -o -name "*.old" -o -name "*.map" \
        \) -prune -o -type f -print 2>/dev/null | sed "s|^$HOME|~|"
}

fd_find_dirs_deep() {
    local dirs=(~/dev ~/.config)
    find "${dirs[@]}" \
        \( -name "node_modules" -o -name ".git" -o -name ".venv" -o -name "lib"  \
           -o -path "*/leveldb/*" -o -path "*/dist-info/*" \
        \) -prune -o -type d -print 2>/dev/null | sed "s|^$HOME|~|"


}

ff_find_dirs_one_level() {
    local dirs=(~/dev ~/.config)
    find "${dirs[@]}" -maxdepth 1 \
        \( -name "node_modules" -o -name ".git" -o -name ".venv" \
           -o -path "*/leveldb/*" -o -path "*/dist-info/*" \
        \) -prune -o -type d -print 2>/dev/null | sed "s|^$HOME|~|"
}


ff() {
    local file
    file=$(ff_find_files | fzf --exact --ignore-case --query="$1") || return
    vim "$file"
}

fd() {
    local dir
    dir=$(ff_find_dirs_one_level | fzf --exact --ignore-case --query="$1") || return
    vim "$dir"
}


ff_stats() {
    ff_find_files | awk -F. 'NF>1 {ext[tolower($NF)]++} END {for (e in ext) if (ext[e]>10) print ext[e], e}' | sort -n
}

replaceHomeWithWaves(){
     sed "s|^$HOME|~|"
}


#fp() {
    #local selection
    # Flatten the directories into a list of files
    #selection=$(find "${projects[@]}" -maxdepth 0 -type d | sed "s|^$HOME|~|"  | fzf --exact --ignore-case --query="$1") || return
    #code "$selection"
#}
fp() {
    local selection
		local projects=(~/dotfiles ~/dev/wiki)
    selection=$(printf "%s\n" "${projects[@]}" | sed "s|^$HOME|~|" |  fzf --exact --ignore-case --query="$1") || return
    code "$selection"

}




du_top10() {
    local TARGET="/home/user"
    local EXCLUDES="--exclude=.git --exclude=.venv"

    echo "Top 10 largest files in $TARGET"
    du -ah $TARGET $EXCLUDES 2>/dev/null \
        | grep -v '/$' \
        | sort -hr \
        | head -n 10

    echo
    echo "Top 10 largest directories in $TARGET"
    du -h --max-depth=1 $TARGET $EXCLUDES 2>/dev/null \
        | sort -hr \
        | head -n 10
}

live_clipboard_server() {
    host_dir="$HOME/host-clipboard"
    mkdir -p "$host_dir"
    tmpfile="$host_dir/clipboard.html"
    clip_txt="$host_dir/clipboard.txt"
    port=3214

    # Detect clipboard tool
    if command -v wl-paste &>/dev/null; then
        clipboard_cmd="wl-paste"
        echo "Using wl-clipboard (wl-paste)."
    elif command -v xclip &>/dev/null; then
        clipboard_cmd="xclip -selection clipboard -o"
        echo "Using xclip."
    elif command -v xsel &>/dev/null; then
        clipboard_cmd="xsel --clipboard --output"
        echo "Using xsel."
    else
        echo "No supported clipboard tool found (wl-paste, xclip, or xsel)."
        return 1
    fi

    # Function to write HTML for live updates
    write_clipboard_html() {
        local content="$1"
        if grep -qi "<html" <<< "$content"; then
            echo "$content" > "$tmpfile"
        else
            cat > "$tmpfile" <<EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Live Clipboard</title>
</head>
<body>
<pre id="clip"></pre>
<script>
let prevContent = '';
async function update() {
    try {
        const resp = await fetch('clipboard.txt?_=' + Date.now());
        const text = await resp.text();
        if (text !== prevContent) {
            prevContent = text;
            document.getElementById('clip').textContent = text;
        }
    } catch(e) {
        console.error(e);
    }
}
setInterval(update, 500);
update();
</script>
</body>
</html>
EOF
        fi
    }

    # Initial clipboard write
    echo "$($clipboard_cmd 2>/dev/null || echo "")" > "$clip_txt"
    write_clipboard_html "$(cat "$clip_txt")"

    # Start server
    python3 -m http.server $port -d "$host_dir" &
    server_pid=$!

    url="http://localhost:$port/clipboard.html"
    echo "Serving clipboard live at $url"
    sleep 1
    xdg-open "$url" &>/dev/null

    prev=""
    stop_loop=false
    cleanup() {
        stop_loop=true
        kill $server_pid 2>/dev/null
        rm -rf "$host_dir"
        echo "Server stopped and temporary folder deleted."
    }
    trap cleanup INT TERM

    # Live update loop
    while ! $stop_loop; do
        current=$($clipboard_cmd 2>/dev/null || echo "")
        if [[ "$current" != "$prev" ]]; then
            echo "$current" > "$clip_txt"
            write_clipboard_html "$current"
            prev="$current"
        fi
        sleep 0.5
    done
}





# Todo

todo() {
    if [ -z "$1" ]; then
        echo "Usage: todo <text>"
        return 1
    fi

    curl -X POST 'https://todo-api.leanderziehm.com/texts' \
         -H 'accept: application/json' \
         -H 'Content-Type: application/json' \
         -d "{\"text\": \"$1\"}"
}

# llm() {
# curl -X 'POST' \
#   'https://llm.leanderziehm.com/chat/auto' \
#   -H 'accept: application/json' \
#   -H 'Content-Type: application/json' \
#   -d "{\"message\": \"$1\"}"
# }


kali(){
qemu-system-x86_64 \
    -enable-kvm \
    -m 6G \
    -cpu host \
    -smp 4,sockets=1,cores=4,threads=1 \
    -drive file=/home/user/VMs/kali.qcow2,if=virtio,cache=writeback \
    -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -display gtk,gl=on \
    -usb -device usb-tablet
}


#PS1="[\h/\u: \w > "


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias sandbox="podman start -ai cli-playground 2>/dev/null || podman run -it --name cli-playground debian:stable bash"



alias mark='. "/home/user/.local/share/mark/mark.sh"'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/user/dev/repos/00_active-repos/devops/terraform/gcp/google-cloud-sdk/path.bash.inc' ]; then . '/home/user/dev/repos/00_active-repos/devops/terraform/gcp/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/user/dev/repos/00_active-repos/devops/terraform/gcp/google-cloud-sdk/completion.bash.inc' ]; then . '/home/user/dev/repos/00_active-repos/devops/terraform/gcp/google-cloud-sdk/completion.bash.inc'; fi



alias export-bw="sh /home/user/dev/repos/00_active-repos/devops/secrets/export-bw.sh"

# docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
alias generate_readme='bash /home/user/dev/repos/00_active-repos/my-linux-setup/llm-cli/generate_readme.sh'
alias llm='bash /home/user/dev/repos/00_active-repos/my-linux-setup/llm-cli/llm.sh'
alias clipoff="systemctl --user stop clipboard-feedback.service"
alias clipon="systemctl --user start clipboard-feedback.service"
alias datagrip="nohup bash /home/user/installed/datagrip/bin/datagrip.sh >/dev/null 2>&1 &"


pacls() {
  pacman -Qi |
  awk -F': *' '
    /^Name/ { name=$2 }
    /^Installed Size/ {
      size=$2
      split(size, a, " ")
      value=a[1]
      unit=a[2]

      if (unit=="KiB") value/=1024
      if (unit=="GiB") value*=1024

      printf "%.2f\t%s\n", value, name
    }
  ' |
  sort -n |
  awk '{ printf "%-40s %.2f MB\n", $2, $1 }'
}

alias findnodemodules="find ~/dev -type d -name node_modules -prune -print"
alias deletenodemodules="find ~/dev -type d -name node_modules -prune -exec rm -rf {} +"
