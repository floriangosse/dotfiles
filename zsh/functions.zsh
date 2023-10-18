# General
take () {
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

#
# NPM
#

npm-upgrade-globals () {
    npm outdated --global --json | jq -r 'to_entries | .[] | .key + "@" + .value.latest' | xargs --no-run-if-empty npm install --global
}

#
# NVM
#

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

#
# man
#

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

#
# Git
#

git-branch-delete-with-rebase-fallback() {
    local exit_code;

    local branch=${1:-}

    local delete_error_output;
    # TODO: Show standard out
    delete_error_output=$(git branch -d $branch 2>&1 >/dev/null)
    exit_code=$?

    if [[ "$exit_code" == "0" ]]; then
        return 0
    elif ! echo "$delete_error_output" | grep -q "is not fully merged."; then
        echo "$delete_error_output" >&2
        return $exit_code
    fi

    local current_branch;
    local rebase_branch=${2:-}
    if [[ -z "$rebase_branch" ]]; then
        local fallback_rebase_branch;
        fallback_rebase_branch=$(git branch --show-current);
        exit_code=$?

        if [[ "$exit_code" != "0" ]]; then
            return $exit_code
        elif [[ "$fallback_rebase_branch" == "" ]] || ! git symbolic-ref -q HEAD >/dev/null; then
            echo "error: You are in 'detached HEAD' state."
            return 1
        fi

        rebase_branch=$fallback_rebase_branch
        current_branch=$fallback_rebase_branch
    fi

    if [[ -z "$current_branch" ]]; then
        current_branch=$(git branch --show-current);
        exit_code=$?
        if [[ "$exit_code" != "0" ]]; then
            echo "error: Deleting from a non branch isn't possible yet." >&2
            return $exit_code
        fi
    fi

    git checkout $branch
    git -c advice.skippedCherryPicks=false rebase $rebase_branch
    exit_code=$?
    if [[ "$exit_code" != "0" ]]; then
        git rebase --abort
        return $exit_code
    fi
    git checkout $current_branch
    git branch -d $branch
}

#
# AWS
#

s3-cat() {
    aws s3 cp $1 - | cat
}

s3-gunzip() {
    aws s3 cp $1 - | gunzip
}

#
# Export AWS credentials from assume-role as environment variables for use with other commands.
#
# Usage:
#   aws sts assume-role --role-arn arn:aws:iam::123456789012:role/role-name --role-session-name "role-session-name" | aws-assume-role-env-export
#
aws-assume-role-env-export() {
    export $(cat | jq -r '.Credentials | ["AWS_ACCESS_KEY_ID=" + .AccessKeyId, "AWS_SECRET_ACCESS_KEY=" + .SecretAccessKey, "AWS_SESSION_TOKEN=" + .SessionToken] | .[]' | xargs)
}
