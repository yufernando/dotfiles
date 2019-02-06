" .vimrc

" Setup {{{

set nocompatible              " Loads .vimrc as your own .vimrc

" colorscheme apprentice

" }}}
" Options {{{ 

syntax enable
set number
set ruler
set background=dark
set number relativenumber

" Indentation:
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

set smarttab

set foldmethod=marker

set clipboard=unnamed "MacOS Clipboard

set textwidth=80

set term=screen-256color  "Make Vim colors work in Tmux

" }}}
" Vundle {{{

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins and call vundle#begin('~/some/path/here')

" Plugins on Github repo
Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown' " Plasticboy Plugin for Markdown
let g:vim_markdown_frontmatter = 1
Plugin 'Valloric/YouCompleteMe' " YouCompleteMe: Autocomplete code
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
" Plugin 'nelstrom/vim-markdown-folding' "Markdown Header Folding. Messes up with plasticboy
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" }}}
" Vim Plugged {{{

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'vim-airline/vim-airline' " Bottom Status Bar
" Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-surround'
Plug 'takac/vim-hardtime'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'epeli/slimux'
" Plug 'jupytext.vim'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Install with :Plug Install
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" }}}
" Other Plugins {{{

" Jupytext.vim
let g:jupytext_fmt = 'python' "convert to .py files
let g:jupytext_filetype_map = {'md': 'python'} "python syntax highlighting

" }}}
" Vimtex and Skim {{{

let g:vimtex_view_method = 'skim'

"}}}
" Keybindings {{{

" Leader key
let mapleader = ","

" NERDTreeToggle
nnoremap <leader>n :NERDTreeToggle<CR> 

" Slimux Send Selection
nnoremap <silent> <space><CR>  :SlimuxREPLSendLine<CR>j0
vnoremap <silent> <space><CR>  :SlimuxREPLSendSelection<CR>
nnoremap <silent> <leader><CR> :SlimuxREPLSendBuffer<CR>
"vnoremap <silent> <space><CR> :<C-w>SlimuxShellRun %cpaste<CR>:'<,'>SlimuxREPLSendSelection<CR>:SlimuxShellRun --<CR>

" Escape key to jk
inoremap jk <Esc>
inoremap kj <Esc>

" Maps for Spanish Keyboard
inoremap ç \

" Shift+d: Compile tex file using latexmk
autocmd FileType tex nmap <buffer> <C-T> :!latexmk -pdf %<CR>

" Open tex file in Skim
autocmd FileType tex nmap <buffer> <S-T> :!open -a skim %:r.pdf<CR><CR><D-S-->

" Syntax highlighting for Markdown
" autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

" }}}
" Added by VimTutor {{{

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" }}} 
