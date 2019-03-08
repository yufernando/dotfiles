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

chrome() {
    open -a "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome" "$1"
# '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=http://104.197.213.71'
}

function note() {
    case $1 in 
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
