"  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
" ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███▌ ███   ███   ███
" ███    ███ ███  ███   ███   ███
" ███    ███ ███  ███   ███   ███
"  ▀██████▀  █▀    ▀█   ███   █▀
"
" .vimrc

" Setup {{{

" Transition to Neovim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

set nocompatible     " Loads .vimrc as your own .vimrc. Was used for compatibility with vi

" }}}
" General Settings {{{ 

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
set clipboard=unnamed "MacOS Clipboard
"set textwidth=80
"set nowrap

set splitbelow      " Split below
set splitright      " Split to the right, feels more natural 

set statusline=
set statusline+=%#LineNr#
set statusline+=%f
set statusline+=\ %{FugitiveStatusline()}
set laststatus=0    " Hide status bar

set foldmethod=marker " Fold with three brackets

set mouse=a " enable mouse (selection, resizing windows)

" }}}
" Plugins {{{

call plug#begin('~/.vim/plugged')

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
"Plug 'vim-airline/vim-airline' " Bottom Status Bar
"Plug 'vim-airline/vim-airline-themes'
"Plug 'rakr/vim-one'
"Plug 'jupytext.vim'
"Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree browser
Plug 'lervag/vimtex'                " Latex
Plug 'junegunn/goyo.vim'            " Focused editing
Plug 'junegunn/limelight.vim'       " Highlight current paragraph
Plug '/usr/local/opt/fzf'           " Fuzzy finder
Plug 'junegunn/fzf.vim'             " Fuzzy finder for Vim
Plug 'tpope/vim-surround'           " Edit surrounding text
Plug 'tpope/vim-vinegar'            " File browser
Plug 'tpope/vim-commentary'         " Comments
Plug 'tpope/vim-fugitive'           " Github
Plug 'takac/vim-hardtime'           " Block repeat keys
Plug 'ctrlpvim/ctrlp.vim'           " Fuzzy finder
Plug 'epeli/slimux'                 " Send comands to tmux window
Plug 'kassio/neoterm'               " Terminal in Vim
Plug 'mhinz/vim-startify'           " Startup buffer
Plug 'w0rp/ale'                     " Code syntax
" Plug 'neomake/neomake'              " Code syntax checking: activate with :Neomake

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown' " Plasticboy Plugin for Markdown

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'davidhalter/jedi'
Plug 'zchee/deoplete-jedi'
Plug 'morhetz/gruvbox'

call plug#end()

" Jupytext.vim
let g:jupytext_fmt = 'python' "convert to .py files
let g:jupytext_filetype_map = {'md': 'python'} "python syntax highlighting

" }}}
" Plugin Modifications {{{

" Vimtex and Skim
let g:vimtex_view_method = 'skim'

" Neoterm
let g:neoterm_autoscroll = '1'

" For Limelight to work with colorscheme (:help cterm-colors)
let g:limelight_conceal_ctermfg = 'gray'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Neomake: When writing a buffer (no delay), and on normal mode changes (after 1s).
"call neomake#configure#automake('nw', 1000)

" Deoplete
let g:deoplete#enable_at_startup = 1

" Plasticboy markdown
let g:vim_markdown_frontmatter = 1

" Deoplete Jedi
let g:python_host_prog  = '/Users/Fer/anaconda3/envs/ds/bin/python' 
let g:python3_host_prog = '/Users/Fer/anaconda3/envs/ds/bin/python' 

" FZF preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Startify Bookmarks
let g:startify_bookmarks = [ {'d': '~/.dotfiles/init.vim'}, '~/.zshrc' ]

" Disable ALE by default. Enable with :ALEToggle
let g:ale_enabled = 0

" NERD Tree hide help message
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1

"}}}
" UI Customization {{{

" True colors
set termguicolors  " enable true colors
" set term=screen-256color  "Make Vim colors work in Tmux

" Gruvbox
colorscheme gruvbox
set background=dark

"colorscheme apprentice
"colorscheme one

"Vertical Split bar. autocmd: change survives switch of color scheme
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=NONE

" }}}
" Keybindings {{{

" Leader key
let mapleader = ","

" NERDTreeToggle
nnoremap <leader>l :NERDTreeToggle<CR> 

" Slimux Send Selection
nnoremap <silent> <space><CR>  :SlimuxREPLSendLine<CR>j0
vnoremap <silent> <space><CR>  :SlimuxREPLSendSelection<CR>
"nnoremap <silent> <leader><CR> :SlimuxREPLSendBuffer<CR>
"vnoremap <silent> <space><CR> :<C-w>SlimuxShellRun %cpaste<CR>:'<,'>SlimuxREPLSendSelection<CR>:SlimuxShellRun --<CR>

" Neoterm Send Selection
"nnoremap <leader><CR> <Plug>(neoterm-repl-send-line)
"xnoremap <leader><CR> <Plug>(neoterm-repl-send)
nnoremap <silent> <leader><CR> :TREPLSendLine<CR>j0
vnoremap <silent> <leader><CR> :TREPLSendSelection<CR>

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

" FZF
" nnoremap <silent> <leader>f :FZF<cr>
nnoremap <leader>e :Files<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Lines<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>H :History<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>h :Helptags!<CR>

" ALE Linting
noremap <leader>a :ALEToggle<CR>

" Navigate splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w><C-w>

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
"source $VIMRUNTIME/defaults.vim

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
"if has('syntax') && has('eval')
"  packadd! matchit
"endif

" }}}' 
