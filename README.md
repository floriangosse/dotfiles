# dotfiles

## Install

Clone repository:
```sh
cd ~ && git clone https://github.com/floriangosse/dotfiles.git .dotfiles
```

Import files into `.zshrc`:
```sh
echo 'source ~/.dotfiles/functions' >> ~/.zshrc
echo 'source ~/.dotfiles/aliases' >> ~/.zshrc
```

Link files:
```sh
cd $HOME
ln -s ~/.dotfiles/.vimrc
ln -s ~/.dotfiles/.tmux.conf
```
