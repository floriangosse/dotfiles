#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

DOTFILES_DIR=$HOME/.dotfiles

# Update dotfiles to master branch
log_process_start "Update ${DOTFILES_DIR} to master"
pushd ${DOTFILES_DIR} > /dev/null
git pull --quiet origin master
popd > /dev/null
log_process_success

# Setup bin
log_process_start "Link ~/.bin folder"
ln -sf ${DOTFILES_DIR}/bin ${HOME}/.bin
log_process_success

# Setup ZSH
if ask "Setup ZSH?" Y; then
    log_process_start "Link ZSH files"
    ln -sfn ${DOTFILES_DIR}/zsh ${HOME}/.zsh
    ln -sf ${DOTFILES_DIR}/zsh/zshrc ${HOME}/.zshrc
    log_process_success

    pushd ${DOTFILES_DIR}/zsh/plugins > /dev/null

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
    ln -sf ${DOTFILES_DIR}/vim/vimrc ${HOME}/.vimrc
    log_process_success
fi


# Setup tmux
if ask "Setup tmux?" Y; then
    log_process_start "Linking tmux files"
    ln -sf ${DOTFILES_DIR}/tmux/tmux.conf ${HOME}/.tmux.conf
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

# Install Homebrew
if ask "Install Homebrew?" Y; then
    if [[ -d /opt/homebrew ]]; then
        log_info "Already installed"
    else
        log_process_start "Install Homebrew"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        log_process_success "Install Homebrew"
    fi
fi
