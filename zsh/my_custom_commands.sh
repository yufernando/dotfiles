#!/bin/bash

# Sets iTerm transparency

function transparency { 

echo "Setting transparency to $1."

osascript -e "
tell application \"iTerm\"
    repeat with aWindow in windows
        tell aWindow
            tell current session
                set transparency to $1
            end tell
        end tell
    end repeat
end tell"

}

function tt { 

echo "Increasing transparency."

osascript -e "
tell application \"iTerm\"
    repeat with aWindow in windows
        tell aWindow
            tell current session
                set old_transparency to transparency
                set transparency to old_transparency + 0.05
            end tell
        end tell
    end repeat
end tell"

}

function TT { 

echo "Reducing transparency."

osascript -e "
tell application \"iTerm\"
    repeat with aWindow in windows
        tell aWindow
            tell current session
                set old_transparency to transparency
                set transparency to old_transparency - 0.05
            end tell
        end tell
    end repeat
end tell"

}
# Vim Man Pager: opens man pages in vim
# https://stackoverflow.com/a/40849153
function vman {
    export MANPAGER="col -b" # for FreeBSD/MacOS
    export MANWIDTH=109

    # Make it read-only
    eval "man $@ | nvim -MR - -c 'set textwidth=99'"

    unset MANPAGER
    unset MANDWIDTH
}

function chromeapp {
    usage="Google Chrome in app mode.

Usage: 
    chromeapp -h                    Display help.
    chromeapp [url]                 Open url.
    chromeapp
    chromeapp localhost             Open localhost:8888.
    chromeapp           -p [port]
    chromeapp localhost -p [port]   Open localhost on given port.
    chromeapp        -c [container]
    chromeapp docker -c [container] Open JupyterLab running in container.
    chromeapp docker                Open JupyterLab running in jupyterlab container."

    # chromeapp with no arguments
    if [[ $# -eq 0 ]] ; then
        URL=${subcommand:-http://localhost:8888}
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
        return 0
    fi

    while getopts ':hc:p:' option; do
        CONTAINER='jupyterlab'
        case "$option" in
            h) # Display help 
                echo "$usage"
                return 0
                ;;
            c)  # Open running JupyterLab in Docker container in Chrome
                CONTAINER=$OPTARG
                # Check if container is running
                if ! docker ps --format "{{.Names}}" | grep -wq $CONTAINER
                then
                    echo "Container '$CONTAINER' not found!";
                    return 1
                fi

                # Get token and launch
                TOKEN=`docker logs $CONTAINER 2>&1| grep -o "token=[a-z0-9]*" | tail -1`
                URL="http://localhost:8888/?$TOKEN"
                echo "Opening JupyterLab running in Docker container '$CONTAINER'..."
                /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL > /dev/null
                return 0
                ;;
            p)
                PORT=${OPTARG:-8888}
                URL="http://localhost:$PORT"
                /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
                return 0
                ;;
            \?) # incorrect option
                echo "Error: Invalid option. Usage: chromeapp -h."
                return 1
                ;;
            :)
                echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    subcommand=$1; shift  # Remove 'chromeapp' from the argument list
    case "$subcommand" in
        localhost)
            PORT=8888

            # Process options
            while getopts ":p:" opt; do
              case ${opt} in
                p )
                  PORT=$OPTARG
                  ;;
                \? )
                  echo "Invalid Option: -$OPTARG" 1>&2
                  return 1
                  ;;
                : )
                  echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                  return 1
                  ;;
              esac
            done
            shift $((OPTIND -1))

            URL="http://localhost:$PORT"
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
            ;;

        docker)  # Open running JupyterLab in Docker container in Chrome
            CONTAINER=jupyterlab

            # Process options
            while getopts ":c:" opt; do
              case ${opt} in
                c )
                  CONTAINER=$OPTARG
                  ;;
                \? )
                  echo "Invalid Option: -$OPTARG" 1>&2
                  return 1
                  # exit 1
                  ;;
                : )
                  echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                  return 1
                  # exit 1
                  ;;
              esac
            done
            shift $((OPTIND -1))

            # Check if container is running
            if ! docker ps --format "{{.Names}}" | grep -wq $CONTAINER
            then
                echo "Container '$CONTAINER' not found!";
                return 1
            fi

            # Get token and launch
            TOKEN=`docker logs $CONTAINER 2>&1| grep -o "token=[a-z0-9]*" | tail -1`
            URL="http://localhost:8888/?$TOKEN"
            echo "Opening JupyterLab running in Docker container '$CONTAINER'..."
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL > /dev/null
            ;;
        *)
            URL=${subcommand:-http://localhost:8888}
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
            ;;
    esac
}

# Run JupyterLab from Docker Container
# This command pulls the yufernando/jupyterlabok image from Docker Hub if it is
# not already present on the local host. It then starts an ephemeral container
# running a Jupyter Notebook server and exposes the server on host port 8888.
# The command mounts the current working directory on the host as
# /home/jovyan/work in the container. The server logs appear in the terminal.
# Visiting http://<hostname>:10000/?token=<token> in a browser loads
# JupyterLab, where hostname is the name of the computer running docker and
# token is the secret token printed in the console. Docker destroys the
# container after notebook server exit, but any files written to ~/work in the
# container remain intact on the host.:
function dockerlab {

    usage="Run Jupyter Lab in a Docker Container.

Usage: 
    dockerlab -h                    Display help.
    dockerlab                       Use image: yufernando/jupyterlab.
    dockerlab bioaretian            Use image: yufernando/bioaretian.
    dockerlab [container]           Use image: yufernando/[container]."

    while getopts ':h' option; do
        case "$option" in
            h) # Display help 
                echo "$usage"
                return 0
                ;;
            \?) # incorrect option
                echo "Error: Invalid option. Usage: dockerlab -h."
                return 1
                ;;
            :)
                echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [[ $# -eq 0 ]] 
    then
        CONTAINER='jupyterlab'
    else 
        CONTAINER=$1
    fi

    # Check if preexisting container is running
    NOCOLOR='\033[0m'
    GREEN='\033[0;32m'
    # CONTAINER='jupyterlab'
    if docker ps --format "{{.Names}}" | grep -wq $CONTAINER
    then
        echo "Found Docker container '$CONTAINER' already running."
    else
        echo "Container '$CONTAINER' not found. Attempting to run Docker image yufernando/$CONTAINER...";
        docker run -d --rm -p 8888:8888 -v "$PWD":/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes --user root --name $CONTAINER yufernando/$CONTAINER
        echo ""
        echo "  Mounted: ${GREEN}$PWD${NOCOLOR} --> /home/jovyan/work"
        echo ""
        # Wait until Jupyterlab is initialized by checking logs
        echo 'Jupyterlab initializing...'
        RUNNING=""
        while [[ -z $RUNNING ]]; do
            RUNNING=`docker logs $CONTAINER 2>&1| grep -o "Or copy and paste one of these URLs"`
            sleep .5
        done
    fi

    # Open JupyterLab running in container with Chrome
    chromeapp docker -c $CONTAINER
}

# Create Evernote notes from terminal
function note {
    case "$1" in 
        cabinet)
            shift
            echo "Creating note in Cabinet with title \"$*\"."
            geeknote create --title "$*" --notebook "Cabinet" 
            ;;
        tag)
            shift
            tagname=$1
            echo "Creating note with tag \"$tagname\" in Cabinet."
            shift
            geeknote create --title "$*" --notebook "Cabinet" --tag "$tagname" 
            ;;
        edit)
            shift
            echo "Editing note with content \"$*\"."
            geeknote edit --note "$*" --content "WRITE" 
            ;;
        "")
            echo "Creating a new note in Inbox with title \"Note from terminal\"."
            geeknote create --title "Note from terminal"
            ;;
        *)
            echo "Creating a new note in Inbox with title \"$*\"."
            geeknote create --title "$*"
            ;;
    esac
}

# Script to convert RISE presentation to pdf

function risetopdf {

echo "Converting RISE presentation $1.ipynb to PDF"

token=$(jupyter notebook list | grep 'token=' | sed 's/^.*=//' | sed 's/:.*$//')
DIR=$PWD

`npm bin`/decktape rise http://localhost:8888/notebooks/$1.ipynb\?token\=$token $DIR/$1.pdf

echo "Exported $DIR/$1.pdf" 
}

# Set default tmux session name
function tmux {
    if [ "$#" -eq 0 ]
        then command tmux new -s "tmux"
        else command tmux "$@"
    fi
}

# Tmux hostname in pane title after ssh
# ssh() {
#     if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
#         # echo "This is a Tmux session."
#         tmux set -g pane-border-status top
#         # tmux set -g pane-border-format "$(echo $* | cut -d . -f 1)"
#         # tmux set -g pane-border-format "#{pane_index} #{pane_current_command}"
#         tmux set -g pane-border-format "#T"
#         tmux select-pane -T "$(echo $* | cut -d . -f 1)"
#         command ssh "$@"
#         # tmux set-window-option automatic-rename "on" 1>/dev/null
#     else
#         # echo "This is not a Tmux session."
#         command ssh "$@"
#     fi
# }

# Stores current working directory to access after exiting Vifm
function vicd {
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}
