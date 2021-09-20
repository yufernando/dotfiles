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
# This command pulls the yufernando/jupyterlab image from Docker Hub if it is
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

    usage="Run JupyterLab in a Docker Container, mount current directory and open with Chrome in app mode.

Usage: 
    dockerlab -h                    Display help.

    dockerlab                       Use image: yufernando/jupyterlab.
    dockerlab yufernando/bioaretian Use image: yufernando/bioaretian.
    dockerlab [IMG]                 Use image: IMG.
    dockerlab -n [NAME]             Set container name NAME. (Default: jupyterlab)
    dockerlab -p [PORT]             Use port PORT. (Default: 8888)

    dockerlab -v [DIR]              Mount directory DIR only. (Default: PWD)
    dockerlab -V [DIR]              Mount directory DIR and current directory.
    dockerlab -v \"\"               Do not mount directory.

    dockerlab -d                    Detached mode: do not open Chrome.
    dockerlab -i                    Interactive mode: open zsh shell."

    # Defaults
    OPENCHROME=true
    OPENZSH=false
    MOUNT_PWD=true
    MOUNT_SOURCE_TARGET=""
    PORT=8888
    CONTAINER_NAME='jupyterlab'

    while getopts 'dhin:p:v:V:' option; do
        case "$option" in
            d) # Detached. do not open Chrome.
                OPENCHROME=false
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
            p) # Port
                PORT=$OPTARG
                ;;
            v) # Mount folder
                MOUNT_SOURCE_TARGET=$OPTARG
                MOUNT_PWD=false
                ;;
            V) # Mount both specified folder and CWD
                MOUNT_SOURCE_TARGET=$OPTARG
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

    # Check if Docker is running
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

    if [[ $# -eq 0 ]]; then
        IMAGE='yufernando/jupyterlab'
    else 
        IMAGE=$1
    fi
    # Container name: yufernando/jupyterlab:lab-3.1.6 --> jupyterlab
    CONTAINER=$(echo $IMAGE | cut -d/ -f2 | cut -d: -f1)
    NOCOLOR='\033[0m'
    GREEN='\033[0;32m'

    # Set container name if not specified in option -n
    if [[ -z $CONTAINER_NAME ]]; then
        CONTAINER_NAME=$CONTAINER
    fi

    # Check if preexisting container is running
    if docker ps --format "{{.Names}}" | grep -wq $CONTAINER_NAME
    then
        echo "Found Docker container '$CONTAINER_NAME' already running. If you want to create a new container run 'dockerlab -n [CONTAINER_NAME]'"
    else
        echo "Running image '$IMAGE' in container '$CONTAINER_NAME' with ID:";

        # Mount directory depending on flag option
        MOUNT_SCRIPT_PWD=""
        MOUNT_MSG_PWD=""
        if [[ $MOUNT_PWD = true ]]; then
            MOUNT_SCRIPT_PWD="-v$PWD:/home/jovyan/work"
            MOUNT_MSG_PWD="  Mounted: ${GREEN}$PWD${NOCOLOR} --> /home/jovyan/work"
        fi

        MOUNT_SCRIPT=""
        MOUNT_MSG=""
        if [[ -n $MOUNT_SOURCE_TARGET ]]; then
            MOUNT_SOURCE=$(echo $MOUNT_SOURCE_TARGET | cut -d: -f1)
            MOUNT_TARGET=$(echo $MOUNT_SOURCE_TARGET | cut -d: -f2)
            MOUNT_SCRIPT="-v$MOUNT_SOURCE:$MOUNT_TARGET"
            MOUNT_MSG="  Mounted: ${GREEN}$MOUNT_SOURCE${NOCOLOR} --> $MOUNT_TARGET"
        fi

        if [[ -z $MOUNT_SOURCE_TARGET  && $MOUNT_PWD = false ]]; then
            MOUNT_MSG="  No Mounted Folder."
        fi

        # Check Port
        PORT_LIST=$(docker ps --format "{{.Ports}}" | cut -d: -f2 | cut -d- -f1 | tr '\n' ' ')
        PORT_MATCH=$(echo $PORT_LIST | grep -w -q $PORT; echo $?)
        CHANGE_PORT=false
        while [[ $PORT_MATCH -eq 0 ]]; do
            PORT=$(($PORT+1))
            PORT_MATCH=$(echo $PORT_LIST | grep -w -q $PORT; echo $?)
            CHANGE_PORT=true
        done

        # Run container
        docker run -d --rm -p $PORT:8888 $MOUNT_SCRIPT_PWD $MOUNT_SCRIPT -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes --user root --name $CONTAINER_NAME $IMAGE

        # Report PORT
        if [[ $CHANGE_PORT = true ]]; then 
            echo "Port in use. Using Port $PORT."; 
        fi
        # Report mounted folder
        echo ""
        if [[ -n $MOUNT_MSG_PWD ]]; then echo $MOUNT_MSG_PWD; fi
        if [[ -n $MOUNT_MSG ]]    ; then echo $MOUNT_MSG    ; fi
        echo ""

        # Wait until Jupyterlab is initialized by checking logs
        # echo 'Jupyterlab initializing...'
        RUNNING=""
        while [[ -z $RUNNING ]]; do
            RUNNING=`docker logs $CONTAINER_NAME 2>&1| grep -o "Or copy and paste one of these URLs"`
            sleep .2
        done
    fi

    # Open JupyterLab running in container with Chrome
    if [[ $OPENCHROME = true ]]; then
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
