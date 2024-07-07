setopt promptsubst
autoload -U colors && colors

# Set colors for ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"

if [[ "$OSTYPE" == darwin* ]]; then
    # this is a good alias, it works by default just using $LSCOLORS
    ls -G . &>/dev/null && alias ls='ls -G'

    # only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
    # otherwise, gls will use the default color scheme which is ugly af
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ls='gls --color=tty'
else
    # For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
    if [[ -z "$LS_COLORS" ]]; then
    (( $+commands[dircolors] )) && eval "$(dircolors -b)"
    fi

    ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

    # Take advantage of $LS_COLORS for completion as well.
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi


function fg_hostname {
    hostname
}

function fg_machine_name {
    if [[ -n $SSH_CONNECTION ]]; then
        echo "%{$fg[white]%}on %{$fg[green]%}$(fg_hostname)%{$reset_color%} ";
    fi
}

function fg_context {
    local machine=$(fg_machine_name)

    if [[ "${USER}" != "${DEFAULT_USER}" ]] || ! [[ -z "${machine}" ]]; then
         echo "%{$fg[cyan]%}${USER} ${machine}%{$fg[white]%}in%{$reset_color%} "
    fi
}

# Checks if working tree is dirty
function fg_parse_git_dirty() {
    local STATUS=''
    local -a FLAGS
    FLAGS=('--porcelain')
    if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
        if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        FLAGS+='--ignore-submodules=dirty'
        fi
        if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        FLAGS+='--untracked-files=no'
        fi
        STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    fi
    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}

# Outputs the name of the current branch
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function fg_git_current_branch() {
    local ref
    ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
    local ret=$?
    if [[ $ret != 0 ]]; then
        [[ $ret == 128 ]] && return  # no git repo.
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    fi
    echo ${ref#refs/heads/}
}

# Outputs if current branch is ahead of remote
function fg_git_prompt_ahead() {
    if [[ -n "$(command git rev-list origin/$(fg_git_current_branch)..HEAD 2> /dev/null)" ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
    fi
}

# Outputs if current branch is behind remote
function fg_git_prompt_behind() {
    if [[ -n "$(command git rev-list HEAD..origin/$(fg_git_current_branch) 2> /dev/null)" ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
    fi
}

function fg_git_prompt_diverged {
    local diverged_status=""
    local diverged_status_ahead="$(fg_git_prompt_ahead)"
    local diverged_status_behind="$(fg_git_prompt_behind)"

    if [[ "x${diverged_status_ahead}" != "x" ]]; then
        diverged_status="${diverged_status}${diverged_status_ahead}"
    fi

    if [[ "x${diverged_status_behind}" != "x" ]]; then
        diverged_status="${diverged_status}${diverged_status_behind}"
    fi

    if [[ "x${diverged_status}" != "x" ]]; then
        echo " ${diverged_status}"
    fi
}

function fg_git_prompt_wip {
    if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
        echo " %{$fg[red]%}WIP"
    fi
}

function fg_git_prompt_info {
    local current_branch=$(fg_git_current_branch)
    if [[ "x${current_branch}" != "x" ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX${current_branch}$(fg_git_prompt_wip)$(fg_git_prompt_diverged)%{$reset_color%} $(fg_parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}

function fg_nvm_prompt_info() {
    [[ -f "$NVM_DIR/nvm.sh" ]] || return
    local nvm_prompt
    nvm_prompt=$(node -v 2>/dev/null)
    [[ "${nvm_prompt}x" == "x" ]] && return
    nvm_prompt=${nvm_prompt:1}
    echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} %{$fg[cyan]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[cyan]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}x" # Possible value: ✗ - Previous used: x
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}o" # Possible value: ✔ - Previous used: o
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_bold[magenta]%}↓"

# Node info
ZSH_THEME_NVM_PROMPT_PREFIX=" %{$fg[white]%}[⬢ " # Correct color is 243
ZSH_THEME_NVM_PROMPT_SUFFIX="]%{$reset_color%}"

# Prompt
PROMPT='
$(fg_context)\
%{$terminfo[bold]$fg[yellow]%}${PWD/#$HOME/~}%{$reset_color%}\
$(fg_git_prompt_info)$(fg_nvm_prompt_info)
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}'

if [[ "$(whoami)" == "root" ]]; then
PROMPT="
%{$fg[cyan]%}%n \
$(fg_machine_name)\
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
$(fg_git_prompt_info)
%{$terminfo[bold]$fg[red]%}# %{$reset_color%}"
fi
