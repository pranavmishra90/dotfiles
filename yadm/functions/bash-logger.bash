#!/bin/bash

# Example pre-amble needed in a script using this logger


# ```
# # Report errors and exit if detected
# trap 'logger ERROR "line $LINENO: $BASH_COMMAND"; exit 1' ERR
# set -e

# SCRIPT_DIR="$(dirname "$(realpath "$0")")"
# cd "$SCRIPT_DIR"

# echo "Current directory is: " $(pwd)

# LOG_FILE="$(realpath log/docker-build.log)"
#```


############################################################################################################
# Functions
############################################################################################################

create_log_file() {
    local file="${1:-$LOG_FILE}"
    if [ -z "$file" ]; then
        echo "create_log_file: no log file specified" >&2
        return 1
    fi

    if [ ! -f "$file" ]; then
        mkdir -p "$(dirname "$file")" || { echo "Failed to create directory for $file" >&2; return 1; }
        echo "Docker build log file" > "$file"
        echo "Created log file: $file"
        cat "$file"
    else
        echo "Log file exists: $file"
    fi
}


# Function to get the current date and time in ISO 8601 format
current_datetime() {
    date +"%Y-%m-%dT%H:%M:%S%:z"
}

# Function to send notifications
send_notification() {
    local verbose=0
    if [ "$1" = "-v" ]; then
        verbose=1
        shift
    fi

    local message="$1"
    local topic="${NTFY_DRPM_TOPIC:-mishralab}"
    local token="$NTFY_DRPM_TOKEN"

    local response http_code body

    # Capture both body and HTTP code
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer $token" \
        -H "Markdown: yes" \
        -H "Title: MishraLab - Build" \
        -d "$message" \
        "https://ntfy.drpranavmishra.com/$topic")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" != "200" ]; then
        echo "Error sending ntfy message. Code: $http_code" >&2
    fi

    if [ "$verbose" -eq 1 ]; then
        echo "$body"
    fi
}


# Function to log messages with levels and optional notification
logger() {
    local LEVEL=$1
    shift
    local TIMESTAMP=$(current_datetime)
    local MESSAGE="$@"
    local LOG_FILE="${LOG_FILE:-/tmp/bash-logger-$(date +"%Y-%m-%d").log}"
    
    # Define color codes
    local COLOR_RESET="\033[0m"
    local COLOR_YELLOW="\033[33m"    # Yellow
    local COLOR_RED="\033[31m"       # Red
    local COLOR_BLUE="\033[34m"      # Blue
    local COLOR_GREY="\033[90m"      # Grey

    # Determine color based on log level
    local COLOR
    case "$LEVEL" in
        DEBUG|TRACE)
            COLOR=$COLOR_GREY
            ;;
        INFO)
            COLOR=$COLOR_BLUE
            ;;
        WARN)
            COLOR=$COLOR_YELLOW
            ;;
        ERROR|CRITICAL|FATAL)
            COLOR=$COLOR_RED
            ;;
        *)
            COLOR=$COLOR_GREY
            ;;
    esac


    # Log message to terminal with color and to file without color
    echo -e "$COLOR$TIMESTAMP [$LEVEL] $MESSAGE$COLOR_RESET" | tee >(sed "s/\x1b\[[0-9;]*m//g" >> "$LOG_FILE")

    # # Send notification for WARN, ERROR, and CRITICAL levels
    # if [[ "$LEVEL" == "WARN" || "$LEVEL" == "ERROR" || "$LEVEL" == "CRITICAL" ]]; then
    #     send_notification "$TIMESTAMP [$LEVEL] $MESSAGE"
    # fi
}
