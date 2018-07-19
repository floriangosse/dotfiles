# General
function take () {
    mkdir -p $1
    cd $1
}

# Creates files and corresponding folders
create () {
    for file in "$@"; do
        mkdir -p "$(dirname $file)";
        touch $file;
    done;
}

# NPM
npm-upgrade-globals () {
    npm outdated --global --json | jq -r 'to_entries | .[] | .key + "@" + .value.latest' | xargs --no-run-if-empty npm install --global
}

# NVM
nvm-upgrade () {
    nvm install $1 --reinstall-packages-from=$(nvm version)
    nvm use $1
    npm install -g npm
    npm upgrade -g
}

nvm-versions-upgrade-globals () {
    ls -1 ~/.nvm/versions/node/ | while read version; do
        nvm use $version
        npm-upgrade-globals
    done
    nvm use default
}

# Man
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}
