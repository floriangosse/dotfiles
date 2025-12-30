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
    echo -e "${roll_back}[${color_fg_green} ${symbol_ok} ${color_clean}] $@"
}

log_process_fail () {
    echo -e "${roll_back}[${color_fg_green} ${symbol_ok} ${color_clean}] $@"
}

ask () {
    # If not interactive, return false
    if ! tty -s; then
        return 1
    fi

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

force_or_ask () {
    if [[ "$1" == "true" ]]; then
        return 0
    fi

    ask "$2" "${3:-}"
    return $?
}
