# ╔═╗╔═╗╦ ╦╦═╗╔═╗
# ╔═╝╚═╗╠═╣╠╦╝║  
# ╚═╝╚═╝╩ ╩╩╚═╚═╝

# Options {{{
# Avoid exit after Ctrl+d
set -o ignoreeof

# }}}
# Oh My Zsh {{{

# Path to your oh-my-zsh installation.
export ZSH="/Users/Fer/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnostergit"
ZSH_THEME="robbyrussell"

# Display username
#DEFAULT_USER=`whoami`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

#}}}
# Plugins {{{
#
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git 
  osx 
  kubectl 
  zsh-autosuggestions
  # zsh-syntax-highlighting
)

#}}}
# User configuration {{{
# Neovim as Git default editor
export VISUAL='nvim'
export EDITOR="$VISUAL"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

#}}}
# Aliases {{{
#
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh
alias skim='open -a skim'
alias vim='nvim'
alias vi='nvim'
alias jhubrun='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --app=http://104.197.213.71'
# Call Python 3 by default. This does not and should not change the symlink to
# /usr/local/lib/python
alias python='python3'
# alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window --incognito --app='

#}}}
# Path {{{

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/Fer/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/Fer/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/Fer/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/Fer/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda deactivate

# TeX and X11 directories are added to path from /etc/paths.d

# added by Anaconda3 5.1.0 installer
PATH="/Users/Fer/anaconda3/bin:$PATH"

# Use latest version of Vim (symlinked to MacVim) instead of /usr/bin/vim
PATH="/usr/local/bin:$PATH"

# Add Latexmk to path
PATH="$PATH:/Library/TeX/texbin"

# Setting PATH for Python 2.7
# The original version is saved in .bash_profile.pysave
PATH="$PATH:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# Add Visual Studio Code (code)
PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Vimgolf
PATH="$PATH:/Users/Fer/.gem/ruby/2.3.0/bin"

# Dotfiles
PATH="$PATH:/Users/Fer/.dotfiles/"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Fer/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/Fer/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Fer/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/Fer/google-cloud-sdk/completion.zsh.inc'; fi

typeset -gxU path # equivalent to 'export PATH' but also keep unique entries
export PATH

# CS50 tutorial: add to path so it finds cs50.h
export LIBRARY_PATH=/usr/local/lib
# Configure clang
# export CC="clang"
# export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable Wshadow"
# export LDLIBS="lcrypt -lcs50 -lm"

export C_INCLUDE_PATH=/usr/local/include

# Extended globbing options: allows ^(file.txt) to select everything but file.txt
# set -o gives full list of options
setopt extendedglob

# }}}
# Source files {{{

source $ZSH/oh-my-zsh.sh
source ~/.dotfiles/zsh/my_custom_commands.sh

#}}}
# Key Bindings {{{
bindkey '^[[A' fzf-history-widget
# }}}
# Other {{{
# Solves problem with Tmux and Conda environments
[[ -z $TMUX ]] || conda deactivate; #conda activate base

# Run rbenv to manage Ruby versions
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Source FZF Autocompletion and Command Search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#}}}
