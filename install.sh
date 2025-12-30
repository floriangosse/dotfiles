#!/usr/bin/env bash
set -e
shopt -s extglob

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# This sets SETUP_<OPTION> variables based on command line arguments
for arg in "$@"; do
    case $arg in
        --@(zsh|vim|tmux|nvm|homebrew))
            var_name="SETUP_$(echo "${arg#--}" | tr '[:lower:]' '[:upper:]')"
            declare "$var_name=true"
            shift
            ;;
    esac
done

DOTFILES_DIR=$HOME/.dotfiles

# Update dotfiles to main branch
log_process_start "Update ${DOTFILES_DIR} to main"
pushd ${DOTFILES_DIR} > /dev/null
git pull --quiet origin main
popd > /dev/null
log_process_success

# Setup bin
log_process_start "Link ~/.bin folder"
ln -sf ${DOTFILES_DIR}/bin ${HOME}/.bin
log_process_success

# Setup ZSH
if force_or_ask "$SETUP_ZSH" "Setup ZSH?" Y; then
    log_process_start "Link ZSH files"
    ln -sfn ${DOTFILES_DIR}/zsh ${HOME}/.zsh
    ln -sf ${DOTFILES_DIR}/zsh/zshrc ${HOME}/.zshrc
    log_process_success

    pushd ${DOTFILES_DIR}/zsh/plugins > /dev/null

    if force_or_ask "$SETUP_ZSH" "Install zsh-syntax-hightlighting?" Y; then
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

    if force_or_ask "$SETUP_ZSH" "Install z?" Y; then
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
if force_or_ask "$SETUP_VIM" "Setup Vim?" Y; then
    log_process_start "Linking Vim files"
    ln -sf ${DOTFILES_DIR}/vim/vimrc ${HOME}/.vimrc
    log_process_success
fi


# Setup tmux
if force_or_ask "$SETUP_TMUX" "Setup tmux?" Y; then
    log_process_start "Linking tmux files"
    ln -sf ${DOTFILES_DIR}/tmux/tmux.conf ${HOME}/.tmux.conf
    log_process_success
fi


# Install nvm
if force_or_ask "$SETUP_NVM" "Install nvm?" N; then
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
if force_or_ask "$SETUP_HOMEBREW" "Install Homebrew?" Y; then
    if [[ -d /opt/homebrew ]]; then
        log_info "Already installed"
    else
        log_process_start "Install Homebrew"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        log_process_success "Install Homebrew"
    fi
fi
