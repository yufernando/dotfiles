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
        URL=http://localhost:8888
        # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
        # --new-window --incognito --app=$URL #Incognito was opening two
        # windows
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL
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
                URL="http://localhost:$PORT/?$TOKEN"
                echo "Opening JupyterLab running in Docker container '$CONTAINER'..."
                # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL > /dev/null
                /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL > /dev/null
                return 0
                ;;
            p)
                PORT=${OPTARG:-8888}
                URL="http://localhost:$PORT"
                # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
                /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL
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
            # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL
            ;;

        docker)  # Open running JupyterLab in Docker container in Chrome
            CONTAINER=jupyterlab
            PORT=8888

            # Process options
            while getopts ":c:p:" opt; do
              case ${opt} in
                c )
                  CONTAINER=$OPTARG
                  ;;
                p )
                  PORT=$OPTARG
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
            URL="http://localhost:$PORT/?$TOKEN"
            echo "Opening browser window."
            # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL > /dev/null
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL > /dev/null
            ;;
        *)
            URL=${subcommand:-http://localhost:8888}
            # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$URL
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=$URL
            ;;
    esac
}

# Run JupyterLab from Docker Container
# This command is a wrapper on docker run that uses a specified image (default:
# yufernando/jupyterlab). It then starts a container and can mount folders into
# it.

# JupyterLab Image
# For the JupyterLab image it runs a Jupyter Notebook server and exposes the
# server on host port 8888. It can mount the current working directory into
# /home/jovyan/work or any other directory specified. It queries unused ports
# and the JupyterLab token to build the URL
# http://<hostname>:<port>/?token=<token> and optionally open it in Chrome.

function dock {

    usage="Run a Docker Container, optionally mount directories and open in a browser or in a terminal.

${COLOR_LIGHT_GREEN}Usage:${COLOR_NC} dock ${COLOR_LIGHT_BLUE}[options]${COLOR_NC} ${COLOR_LIGHT_RED}<target>${COLOR_NC}

  ${COLOR_LIGHT_RED}target:${COLOR_NC}
    lab, cs50, bio, <image-name>. Default: yufernando/jupyterlab.

  ${COLOR_LIGHT_BLUE}options:${COLOR_NC}
    -h                    Display help.
    -n [NAME]             Set container name NAME (Default: jupyterlab).
    -p [PORT]             Use port PORT (Default: 8888).

    -c                    Mount CWD into WORKDIR.
    -v [HOSTDIR:CONTDIR]  Mount HOSTDIR into CONTDIR.
    -V [HOSTDIR:CONTDIR]  Mount HOSTDIR into CONTDIR and CWD into WORKDIR (same as -vc).

    -o                    Open Jupyterlab in Chrome.
    -i                    Interactive mode: open zsh shell.

    -s                    Copy Github SSH keys into container.

${COLOR_LIGHT_GREEN}Examples:${COLOR_NC}
    dock -co lab          Run JupyterLab. Mount CWD. Open in a browser.
    dock -cis cs50        Run CS50 image. Mount CWD. Copy SSH Keys. Open in a terminal.
"

    # Defaults
    IMAGE='yufernando/jupyterlab'
    CONTAINER_NAME=""
    OPENCHROME=false
    OPENZSH=false
    COPYSSH=false
    MOUNT_CWD=false
    MOUNT_SOURCE_TARGET=""
    PORT=8888

    # Color aliases
    COLOR_NC='\033[0m'
    COLOR_GREEN='\033[0;32m'
    COLOR_LIGHT_GREEN='\e[1;32m'
    COLOR_LIGHT_BLUE='\e[1;34m'
    COLOR_RED='\e[0;31m'
    COLOR_WHITE='\e[1;37m'
    COLOR_YELLOW='\e[1;33m'
    COLOR_LIGHT_PURPLE='\e[1;35m'
    COLOR_LIGHT_RED='\e[1;31m'
    COLOR_GRAY='\e[1;30m'
    COLOR_LIGHT_GRAY='\e[0;37m'

    # GET OPTIONS
    while getopts 'chiosn:p:v:V:' option; do
        case "$option" in
            c) # Mount current working directory
                MOUNT_CWD=true
                ;;
            h) # Display help 
                echo "$usage"
                return 0
                ;;
            i) # Open zsh in interactive mode
                OPENZSH=true
                ;;
            n) # Container name
                CONTAINER_NAME=$OPTARG
                ;;
            o) # Open Chrome in Jupyterlab
                OPENCHROME=true
                ;;
            p) # Port
                PORT=$OPTARG
                ;;
            s) # Copy ssh keys into container
                COPYSSH=true
                ;;
            v) # Mount folder
                MOUNT_SOURCE_TARGET=$OPTARG
                ;;
            V) # Mount both specified folder and CWD
                MOUNT_SOURCE_TARGET=$OPTARG
                MOUNT_CWD=true
                ;;
            \?) # Incorrect option
                echo "Error: Invalid option. Usage: dock -h."
                return 1
                ;;
            :) # Argument ommited
                echo "Invalid Option: -$OPTARG requires an argument" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    # GET TARGET (image name)
    if [[ $# -ge 1 ]]; then
        subcommand=$1; shift
        case "$subcommand" in 
            lab)
                IMAGE="yufernando/jupyterlab"
                ;;
            cs50)
                IMAGE="yufernando/cs50"
                ;;
            *)
                IMAGE="$subcommand"
                ;;
        esac
    fi 

    # Check if Docker is running. Launch Docker if not.
    if (! docker ps > /dev/null 2>&1 ); then
        # Launch Docker
        echo "Docker daemon not running. Launching Docker Desktop..."
        open /Applications/Docker.app
        # Wait until Docker daemon is running and has completed initialisation
        while (! docker ps > /dev/null 2>&1 ); do
            # Docker takes a few seconds to initialize
            sleep 1.5
        done
    fi

    # Get container name from image name: yufernando/jupyterlab:lab-3.1.6 --> jupyterlab
    CONTAINER=$(echo $IMAGE | cut -d/ -f2 | cut -d: -f1)
    # Set container name if not specified in option -n
    if [[ -z $CONTAINER_NAME ]]; then
        CONTAINER_NAME=$CONTAINER
    fi

    # Check if preexisting container is running. Else run image.
    if docker ps --format "{{.Names}}" | grep -wq $CONTAINER_NAME
    then
        echo "Using Docker container '$CONTAINER_NAME' found running. If you want to create a new container run 'dock -n [CONTAINER_NAME]'"
    else
        echo "Running image '$IMAGE' in container '$CONTAINER_NAME' with ID:";

        # Mount directory depending on flag option
        MOUNT_SCRIPT_CWD=""
        MOUNT_MSG_CWD=""
        if [[ $MOUNT_CWD = true ]]; then
            MOUNT_SCRIPT_CWD="-v$PWD:/home/jovyan/work"
            MOUNT_MSG_CWD="  Mounted: ${COLOR_LIGHT_GREEN}$PWD${COLOR_NC} --> /home/jovyan/work"
        fi

        MOUNT_SCRIPT=""
        MOUNT_MSG=""
        if [[ -n $MOUNT_SOURCE_TARGET ]]; then
            MOUNT_SOURCE=$(echo $MOUNT_SOURCE_TARGET | cut -d: -f1)
            MOUNT_TARGET=$(echo $MOUNT_SOURCE_TARGET | cut -d: -f2)
            MOUNT_SCRIPT="-v$MOUNT_SOURCE:$MOUNT_TARGET"
            MOUNT_MSG="  Mounted: ${COLOR_LIGHT_GREEN}$MOUNT_SOURCE${COLOR_NC} --> $MOUNT_TARGET"
        fi

        # Run container
        if [[ $IMAGE = 'yufernando/jupyterlab' ]] then
            # Check if port $PORT is in use. If it is, look for port not in use.
            PORT_LIST=$(docker ps --format "{{.Ports}}" | cut -d: -f2 | cut -d- -f1 | tr '\n' ' ')
            PORT_MATCH=$(echo $PORT_LIST | grep -w -q $PORT; echo $?)
            CHANGE_PORT=false
            while [[ $PORT_MATCH -eq 0 ]]; do
                PORT=$(($PORT+1))
                PORT_MATCH=$(echo $PORT_LIST | grep -w -q $PORT; echo $?)
                CHANGE_PORT=true
            done

            docker run -d --rm -p $PORT:8888 $MOUNT_SCRIPT_CWD $MOUNT_SCRIPT -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes --user root --name $CONTAINER_NAME $IMAGE
        else
            docker run -dit --rm $MOUNT_SCRIPT_CWD $MOUNT_SCRIPT --name $CONTAINER_NAME $IMAGE
        fi

        # Report PORT
        if [[ $CHANGE_PORT = true ]]; then 
            echo "Port in use. Using Port $PORT."; 
        fi
        # Report mounted folder
        # echo ""
        if [[ -n $MOUNT_MSG_CWD ]]; then echo "\n$MOUNT_MSG_CWD\n"; fi
        if [[ -n $MOUNT_MSG ]]    ; then echo "\n$MOUNT_MSG\n"    ; fi
        # echo ""
    fi

    # Add Github ssh keys
    if [[ $COPYSSH = true ]]; then
        cat ~/.ssh/id_rsa_github     | docker exec -i $CONTAINER_NAME sh -c \
            'mkdir -p /root/.ssh && cat > /root/.ssh/id_rsa_github && chmod -R 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa_github'
        cat ~/.ssh/id_rsa_github.pub | docker exec -i $CONTAINER_NAME sh -c \
            'mkdir -p /root/.ssh && cat > /root/.ssh/id_rsa_github.pub && chmod 644 /root/.ssh/id_rsa_github.pub'
        echo "Added Github SSH keys."
    fi

    # Open JupyterLab running in container with Chrome
    if [[ $OPENCHROME = true ]]; then
        # Wait until Jupyterlab is initialized by checking logs
        # echo 'Jupyterlab initializing...'
        RUNNING=""
        while [[ -z $RUNNING ]]; do
            RUNNING=`docker logs $CONTAINER_NAME 2>&1| grep -o "Or copy and paste one of these URLs"`
            sleep .2
        done
        # Open Chrome
        chromeapp docker -c $CONTAINER_NAME -p $PORT
    fi

    if [[ $OPENZSH = true ]]; then
        docker exec -it $CONTAINER_NAME /bin/zsh
    fi
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
