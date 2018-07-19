#!/usr/bin/env bash
set -e

symbol_info="i"
symbol_ok="\xE2\x9C\x94"
symbol_error="\xE2\x9C\x97"
symbol_warn="\xE2\x9D\x97"
symbol_question="\xE2\x9D\x93"

color_clean="\033[0m"
color_fg_red="\033[0;31m"
color_fg_green="\033[0;32m"
color_fg_light_blue="\033[0;94m"

roll_back="\033[0K\r"

log_info () {
    echo -e "[${color_fg_light_blue} ${symbol_info} ${color_clean}] $@"
}

log_process_start () {
    echo -en "[${color_fg_light_blue}...${color_clean}] $@"
}

log_process_success () {
    echo -e "${roll_back}[${color_fg_green} ${symbol_ok} ${color_clean}]"
}

log_process_fail () {
    echo -e "${roll_back}[${color_fg_green} ${symbol_ok} ${color_clean}]"
}

ask () {
    # https://djm.me/ask
    local prompt default reply

    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -en "[${color_fg_light_blue} ${symbol_question}${color_clean}] $1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

DOTFILES_DIR=$HOME/.dotfiles

# Update dotfiles to master branch
log_process_start "Update $DOTFILES_DIR to master"
pushd $DOTFILES_DIR > /dev/null
git pull --quiet origin master
popd > /dev/null
log_process_success


# Setup ZSH
if ask "Setup ZSH?" Y; then
    log_process_start "Link ZSH files"
    ln -sfn $DOTFILES_DIR/zsh ${HOME}/.zsh
    ln -sf $DOTFILES_DIR/zsh/zshrc ${HOME}/.zshrc
    log_process_success

    pushd $DOTFILES_DIR/zsh/plugins > /dev/null

    if ask "Install zsh-syntax-hightlighting?" Y; then
        if [[ -d ./zsh-syntax-highlighting/.git ]]; then
            log_info "Already installed"

            log_process_start "Update zsh-syntax-hightlighting"
            pushd zsh-syntax-highlighting > /dev/null
            git pull --quiet origin master
            popd > /dev/null
            log_process_success
        else
            log_process_start "Download zsh-syntax-hightlighting"
            git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git
            log_process_success
        fi
    fi

    if ask "Install z?" Y; then
        if [[ -d ./z/.git ]]; then
            log_info "Already installed"

            log_process_start "Update z"
            pushd z > /dev/null
            git pull --quiet origin master
            popd > /dev/null
            log_process_success
        else
            log_process_start "Download z"
            git clone --quiet https://github.com/rupa/z.git
            log_process_success
        fi
    fi

    popd > /dev/null
fi


# Setup Vim
if ask "Setup Vim?" Y; then
    log_process_start "Linking Vim files"
    ln -sf $DOTFILES_DIR/vim/vimrc ${HOME}/.vimrc
    log_process_success
fi


# Setup tmux
if ask "Setup tmux?" Y; then
    log_process_start "Linking tmux files"
    ln -sf $DOTFILES_DIR/tmux/tmux.conf ${HOME}/.tmux.conf
    log_process_success
fi


# Install nvm
if ask "Install nvm?" N; then
    if [[ -d ~/.nvm/.git ]]; then
        log_info "Already installed"

        log_process_start "Update nvm"
        pushd ~/.nvm > /dev/null
        git pull --quiet origin master
        popd > /dev/null
        log_process_success
    else
        log_process_start "Download nvm"
        git clone --quiet https://github.com/creationix/nvm.git ~/.nvm
        log_process_success
    fi
fi
