" ╦  ╦╦╔╦╗
" ╚╗╔╝║║║║
"  ╚╝ ╩╩ ╩

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

set splitbelow      " Split below
set splitright      " Split to the right, feels more natural 

set statusline=
set statusline+=%#LineNr#
set statusline+=%f
set statusline+=\ %{FugitiveStatusline()}
set laststatus=0    " Hide status bar

set foldmethod=marker " Fold with three brackets

set mouse=a " enable mouse (selection, resizing windows)

" set list                    " Show whitespace
" set listchars=nbsp:⦸        " Circle Reverse Solidus U+29B8)
" set listchars+=trail:•      " BULLET (U+2022)

set scrolloff=1             "Keep lines visible at end

set virtualedit=block "Allow cursor to move when there is no text in visual block mode

" }}}
" Plugins {{{

call plug#begin('~/.vim/plugged')

"Plug 'vim-airline/vim-airline' " Bottom Status Bar
"Plug 'vim-airline/vim-airline-themes'
"Plug 'rakr/vim-one'
"Plug 'goerz/jupytext.vim'
"Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree browser
Plug 'lervag/vimtex'                " Latex
Plug 'junegunn/goyo.vim'            " Focused editing
Plug 'junegunn/limelight.vim'       " Highlight current paragraph
Plug '/usr/local/opt/fzf'           " Fuzzy finder
Plug 'junegunn/fzf.vim'             " Fuzzy finder for Vim
Plug 'tpope/vim-surround'           " Edit surrounding text
Plug 'tpope/vim-commentary'         " Comments
Plug 'tpope/vim-fugitive'           " Github
Plug 'tpope/vim-vinegar'            " File browser
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
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
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
" autocmd! User GoyoEnter Limelight | set colorcolumn="" | set nocursorline
" autocmd! User GoyoLeave Limelight!

" Neomake: When writing a buffer (no delay), and on normal mode changes (after 1s).
"call neomake#configure#automake('nw', 1000)

" Deoplete
let g:deoplete#enable_at_startup = 1

" Plasticboy markdown
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_level = 2            " Do not fold title
let g:vim_markdown_folding_disabled = 1

" Deoplete Jedi
let g:python_host_prog  = '/Users/Fer/anaconda3/envs/ds/bin/python' 
let g:python3_host_prog = '/Users/Fer/anaconda3/envs/ds/bin/python' 
command! DeopleteDisable call deoplete#custom#option('auto_complete', v:false)

" FZF preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'

" Startify Bookmarks
let g:startify_bookmarks = [ {'d': '~/.dotfiles/init.vim'}, {'z': '~/.dotfiles/zshrc'}, {'t':'~/.dotfiles/tmux.conf'} ]

let s:startify_ascii_header=[
                \ '                  ________ ;;     ________',
                \ '                 /********\;;;;  /********\',
                \ '                 \********/;;;;;;\********/',
                \ '                  |******|;;;;;;;;/*****/',
                \ '                  |******|;;;;;;/*****/''',
                \ '                 ;|******|;;;;/*****/'';',
                \ '               ;;;|******|;;/*****/'';;;;;',
                \ '             ;;;;;|******|/*****/'';;;;;;;;;',
                \ '               ;;;|***********/'';;;;;;;;;',
                \ '                 ;|*********/'';;;;;;;;;',
                \ '                  |*******/'';;;;;;;;;',
                \ '                  |*****/'';;;;;;;;;',
                \ '                  |***/'';;;;;;;;;',
                \ '                  |*/''   ;;;;;;',
                \ '                           ;;',
                \ '',
                \]
let g:startify_custom_header = map(s:startify_ascii_header +
        \ startify#fortune#boxed(), '"           ".v:val')

" Disable ALE by default. Enable with :ALEToggle
let g:ale_enabled = 0

" NERD Tree hide help message
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1

" Vim wiki
" Not needed, I already use plasticboy markdown
" let g:vimwiki_ext2syntax= {'.md': 'markdown', '.markdown': 'markdown', 'mdown':'markdown'}

let ferwiki = {}
    let ferwiki.path             = '~/Dropbox/vimwiki/'
    let ferwiki.path_html        = '~/Dropbox/vimwiki/html'
    " let wiki_1.custom_wiki2html = '~/Dropbox/vimwiki/vimwiki_md2html/misaka_md2html.py'
    let ferwiki.syntax           = 'markdown'
    let ferwiki.ext              = '.wiki'

" let wiki_2 = {}
    " let wiki_2.path             = '~/Dropbox/vimwiki/home'
    " let wiki_2.path_html        = '~/Dropbox/vimwiki/home/html'
    " let wiki_2.custom_wiki2html = '~/Dropbox/vimwiki/vimwiki_md2html/misaka_md2html.py'
    " let wiki_2.syntax           = 'markdown'
    " let wiki_2.ext              = '.wiki'

let g:vimwiki_list = [ferwiki]

" Jupytext
let g:jupytext_fmt = 'py'

"}}}
" UI Customization {{{

" True colors

" Gruvbox
colorscheme gruvbox
set background=dark

"colorscheme apprentice
"colorscheme one

"Vertical Split bar. autocmd: change survives switch of color scheme
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=NONE

" Textwidth 
set textwidth=79
autocmd FileType                text            setlocal textwidth=99
autocmd BufReadPost,BufNewFile *.py,*.R         setlocal textwidth=79
autocmd BufReadPost,BufNewFile *.md,*.txt,*.tex setlocal textwidth=99

" Markdown
autocmd BufReadPost,BufNewFile *.md set filetype=markdown

" Linebreaks
set wrap
set linebreak " Do not split words in linebreak
set breakindent " Indent line breaks
set breakindentopt=shift:1 " Add space to linebreaks to make them more evident
let &showbreak='⤷ '        "Arrow pointing downwards U+2935

" Colorcolumn and cursorline
" set cursorline
" set colorcolumn=
" let &l:colorcolumn='+' . join(range(1, 255), ',+')

" }}}
" Keybindings {{{

" Leader key
let mapleader = ","

" Nerd Tree
nnoremap <silent> <leader>l :NERDTreeToggle<CR> 
nnoremap <silent> <leader>L :NERDTreeFind<CR> 

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
inoremap jk <Esc>`^
inoremap kj <Esc>`^
inoremap <C-c> <Esc>`^

" Maps for Spanish Keyboard
inoremap ç \

" Shift+d: Compile tex file using latexmk
autocmd FileType tex nmap <buffer> <C-T> :!latexmk -pdf %<CR>

" Open tex file in Skim
autocmd FileType tex nmap <buffer> <S-T> :!open -a skim %:r.pdf<CR><CR><D-S-->

" Forward search in Skim
map ,p :w<CR>:silent !~/.dotfiles/zsh/displayline -b -g <C-r>=line('.')<CR> %<.pdf<CR>

" Syntax highlighting for Markdown
" autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

" FZF
" nnoremap <silent> <leader>f :FZF<cr>
nnoremap <leader>e :Files<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Lines<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>H :History<CR>
nnoremap <leader>h :Helptags!<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>R :Rgcmd 
nnoremap <leader>rh :Rghome<CR>
nnoremap <leader>ru :Rgup<CR>
nnoremap <leader>rd :Rgdrop<CR>

" ALE Linting
nmap <leader>A <Plug>(ale_toggle)
nmap <leader>a <Plug>(ale_detail)
nmap <silent> <leader>k <Plug>(ale_previous)
nmap <silent> <leader>j <Plug>(ale_next)

" Navigate splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w><C-w>

" Toggle files
nnoremap <leader><leader> <C-^>

" Resemble C and D
nnoremap Y y$

" Edit new file in same folder
nnoremap <leader>n :edit <C-R>=expand('%:p:h') . '/'<CR>

" Spanish keyboard workarounds
nnoremap Ñw :w
nnoremap Ñq :q

" Spell check
nnoremap <leader>s :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>S :setlocal spell! spelllang=es<CR>

" Terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" VIMRC
nnoremap <leader>d :e ~/.dotfiles/init.vim<CR>
nnoremap <leader>D :source ~/.dotfiles/init.vim<CR>

" Goyo
nnoremap <leader>g :Goyo<CR>

" Vimwiki
" Todo Toggle conflicts with Choosing keyboard language
" From: https://github.com/vimwiki/vimwiki/blob/master/doc/vimwiki.txt
nmap <Leader>tt <Plug>VimwikiToggleListItem

" }}}
" Autocommands {{{

" https://vi.stackexchange.com/a/17550
augroup my_autocmds
    autocmd!
    autocmd FileType markdown,vimwiki nnoremap <leader>md :<C-u>silent call system('pandoc -s -f markdown -t html --css ~/.dotfiles/style.css '.expand('%:p:S').' -o '.expand('%:p:r:S').'.html')<CR>:silent call system('open -a "Google Chrome" '.expand('%:p:r:S').'.html')<CR> 
    " \:<C-u>silent call system('open -a "Google Chrome" %')

    " Start new file in Insert Mode
    autocmd BufNewFile * startinsert
    autocmd BufNewFile ALEPreviewWindow stopinsert

    " Start Insert Mode for Geeknote
    autocmd BufEnter *.markdown startinsert 

augroup END

" Focus
function! s:focus()
augroup focus
autocmd!
set cursorline
" let &l:colorcolumn='+' . join(range(1, 255), ',+')

" Make current window more obvious by turning off/adjusting some features in non-current windows.
" if exists('+colorcolumn')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * 
        \if autocmds#should_colorcolumn() | 
            \let &l:colorcolumn='+' . join(range(1,255), ',+') |
        \endif
    " autocmd FocusLost,WinLeave *
        " \if autocmds#should_colorcolumn() |
            " \let &l:colorcolumn=join(range(1, 255), ',') |
        " \endif
" endif

" autocmd InsertLeave,VimEnter,WinEnter * 
    " \if autocmds#should_cursorline() | setlocal cursorline | endif
" autocmd InsertEnter,WinLeave *
    " \if autocmds#should_cursorline() | setlocal nocursorline | endif

augroup END
endfunction

call s:focus()

" Load NERD Tree on startup
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

" }}}
" Commands and Functions {{{

function! s:goyo_enter()
    augroup focus
      autocmd!
    augroup END
    augroup! focus

    let s:settings = {
          \   'showbreak': &showbreak,
          \   'statusline': &statusline,
          \   'cursorline': &cursorline,
          \   'showmode': &showmode
          \ }
    
    set colorcolumn=""
    set showbreak=
    " set statusline=\ 
    set nocursorline
    set noshowmode
    call deoplete#custom#option('auto_complete', v:false)
    Limelight
    silent !tmux set-option status off
endfunction

function! s:goyo_leave()
    silent !tmux set-option status on
    for [k, v] in items(s:settings)
      execute 'let &' . k . '=' . string(v)
    endfor
    Limelight!
    call deoplete#custom#option('auto_complete', v:true)
    call s:focus()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '
  \   .shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rgcmd
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '
  \ . <q-args>, 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rghome
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow --max-depth 2 '
  \   .shellescape(<q-args>). ' ~' , 1, 
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rgup
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow --max-depth 3 '
  \   .shellescape(<q-args>). ' ' .expand('%:p:h:h') , 1, 
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* Rgdrop
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '
  \   .shellescape(<q-args>). ' ~/Dropbox/' , 1, 
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

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
" if v:progname =~? "evim"
    " finish
" endif

" Get the defaults that most users want.
"source $VIMRUNTIME/defaults.vim

" if has("vms")
    " set nobackup		" do not keep a backup file, use versions instead
" else
    " set backup		" keep a backup file (restore to previous version)
    " if has('persistent_undo')
        " set undofile	" keep an undo file (undo changes after closing)
    " endif
" endif

" if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    " set hlsearch
" endif

" Only do this part when compiled with support for autocommands.
" if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    " augroup vimrcEx
        " au!

        " For all text files set 'textwidth' to 78 characters.
        " autocmd FileType text setlocal textwidth=78

    " augroup END

" else

    " set autoindent		" always set autoindenting on

" endif " has("autocmd")

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
