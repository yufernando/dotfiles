#!/bin/bash

# Sets iTerm transparency

function transparency() { 

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

# Vim Man Pager: opens man pages in vim
# https://stackoverflow.com/a/40849153
vman() {
    export MANPAGER="col -b" # for FreeBSD/MacOS
    export MANWIDTH=109

    # Make it read-only
    eval "man $@ | nvim -MR - -c 'set textwidth=99'"

    unset MANPAGER
    unset MANDWIDTH
}

function chromeapp() {
    if [[ $# -eq 0 ]] ; then
		/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=http://localhost:8888
    else
    case $1 in 
        app)
            PORT=${2:-http://localhost:8888}
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$PORT
            ;;
        --headless)
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --headless
            ;;
        *)
            /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app=$1
            ;;
    esac
	fi
}

# Create Evernote notes from terminal
function note() {
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

function risetopdf() {

echo "Converting RISE presentation $1.ipynb to PDF"

token=$(jupyter notebook list | grep 'token=' | sed 's/^.*=//' | sed 's/:.*$//')
DIR=$PWD

`npm bin`/decktape rise http://localhost:8888/notebooks/$1.ipynb\?token\=$token $DIR/$1.pdf

echo "Exported $DIR/$1.pdf" 
}

# Create docker container
# This command pulls the jupyter/scipy-notebook image from Docker Hub if it is
# not already present on the local host. It then starts an ephemeral container
# running a Jupyter Notebook server and exposes the server on host port 8888.
# The command mounts the current working directory on the host as
# /home/jovyan/work in the container. The server logs appear in the terminal.
# Visiting http://<hostname>:10000/?token=<token> in a browser loads
# JupyterLab, where hostname is the name of the computer running docker and
# token is the secret token printed in the console. Docker destroys the
# container after notebook server exit, but any files written to ~/work in the
# container remain intact on the host.:
function dockerlab() {
docker run --rm -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/scipy-notebook
}

# Set default tmux session name
tmux () {
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
