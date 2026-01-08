# General
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias ll='ls -l'
alias la='ls -lAh'
alias rgrep='grep -Rn'
alias take-temp='take $(mktemp -u)'

# Git
alias gst='git status --short --branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias ga='git add'
alias gap='git add -p'
alias gc='git commit -v'
alias gcmsg='git commit -m'
alias gp='git push'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gbdr='git-branch-delete-with-rebase-fallback'
alias gwl='git worktree list'
alias gwa='git worktree add'
alias gwac='git-worktree-add-and-cd'
alias gwr='git worktree remove'

# DNF
alias dnfs='dnf search'
alias dnfu='sudo dnf upgrade'
alias dnfi='sudo dnf install'
alias dnfr='sudo dnf remove'

# APT
alias agi='sudo apt-get install'
alias agr='sudo apt-get remove'
alias agp='sudo apt-get purge'
alias aguu='sudo apt-get update && sudo apt-get upgrade'

# cURL
alias curl-headers='curl -svo /dev/null'

# Date/Timestamp
alias timestamp='date +%s'
