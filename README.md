
clone this repository with ssh into home dir ~/:

```
git clone git@github.com:leanderziehm/dotfiles.git
```
or http:
```
git clone https://github.com/leanderziehm/dotfiles.git
```

```
cd ~/dotfiles
make
make s
make g
```



# Nvim
```
# Backup old config (if config existed before)
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup.$(date +%Y%m%d%H%M%S)

# Setup (if never had config)
mkdir -p ~/.config/nvim

# Install
curl -fsSL https://raw.githubusercontent.com/leanderziehm/dotfiles/refs/heads/main/sync/default/.config/nvim/init.lua -o ~/.config/nvim/init.lua
```

# Tmux Install

```
curl -fsSL https://raw.githubusercontent.com/LeanderZiehm/dotfiles/refs/heads/main/sync/default/.tmux.conf -o ~/.tmux.conf

```

# Vim
```
# Backup old config (if config existed before)
mv ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d%H%M%S)
# Install
curl -fsSL https://raw.githubusercontent.com/leanderziehm/dotfiles/refs/heads/main/sync/default/.vimrc -o ~/.vimrc

```


# TODO
create a script which lets the user select which configs to use/download/get/install from the sync