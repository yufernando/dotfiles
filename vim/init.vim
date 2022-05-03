" ╦  ╦╦╔╦╗
" ╚╗╔╝║║║║
"  ╚╝ ╩╩ ╩
" Vim Configuration File

" 'zo': Open folded sections 
" 'zc': Open folded sections 
" <leader>d: Open init.vim
" <leader>D: Reload init.vim

" Setup {{{

" Transition to Neovim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

filetype plugin on " So it loads files in after/ftplugin

set nocompatible     " Loads .vimrc as your own .vimrc. Was used for compatibility with vi

" }}}
" General Settings {{{ 

set textwidth=79

syntax enable " Use this vs 'syntax on' if you use 'highlight' commands
    " Source: https://www.reddit.com/r/vim/comments/choowl/vimpolyglot_syntax_on_or_syntax_enable/
set number
set number relativenumber
set ruler

" Case insensitive search
set ignorecase

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

" Statusline helper functions
" Get Git Branch
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
" Add Git Branch to Statusline
function! StatuslineGit()
  " let l:branchname = GitBranch()
  let l:branchname = FugitiveHead()
  return strlen(l:branchname) > 0?'   '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#CursorColumn#
set statusline+=%{StatuslineGit()}
" set statusline+=%{FugitiveHead()}         " Get Branch From Vim Fugitive
" set statusline+=\ %{FugitiveStatusline()} " Get Branch From Vim Fugitive
set statusline+=%m\ " File was modified
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

set foldmethod=marker " Fold with three brackets

set mouse=a " enable mouse (selection, resizing windows)

" set list                    " Show whitespace
" set listchars=nbsp:⦸        " Circle Reverse Solidus U+29B8)
" set listchars+=trail:•      " BULLET (U+2022)

set scrolloff=1             "Keep lines visible at end

set virtualedit=block "Allow cursor to move when there is no text in visual block mode

" }}}
" Plugins {{{

call plug#begin(stdpath('data') . '/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree browser
Plug 'junegunn/goyo.vim'            " Focused editing
Plug 'junegunn/limelight.vim'       " Highlight current paragraph
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'           " Edit surrounding text
Plug 'tpope/vim-commentary'         " Comments
Plug 'tpope/vim-fugitive'           " Github
Plug 'mhinz/vim-startify'           " Startup buffer
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Autocomplete
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim' " Has Go To Definition
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'Shougo/deoplete-clangx', { 'for': ['c'] }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " Snippets
Plug 'dense-analysis/ale' " Linter
Plug 'jiangmiao/auto-pairs'
Plug 'epeli/slimux'                 " Send comands to tmux window
Plug 'kassio/neoterm'               " Terminal in Vim
" Plug 'posva/vim-vue'                 " Vue syntax highlighting
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'vim-airline/vim-airline' " Bottom Status Bar
" Plug 'vim-airline/vim-airline-themes'
" Plug 'rakr/vim-one'
" Plug 'goerz/jupytext.vim'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'lervag/vimtex'                " Latex
" Plug 'neomake/neomake'              " Code syntax checking: activate with :Neomake
" Plug 'bkad/camelcasemotion'
" Plug 'plasticboy/vim-markdown'      " Plasticboy Plugin for Markdown
" Plug 'takac/vim-hardtime'           " Block repeat keys
" Plug 'ctrlpvim/ctrlp.vim'           " Fuzzy finder
" Plug 'tpope/vim-vinegar'            " File browser
" Plug 'godlygeek/tabular'

call plug#end()
" }}}
" Plugin Modifications {{{

" Vimtex and Skim
let g:vimtex_view_method = 'skim'

" Neoterm: https://github.com/kassio/neoterm/pull/274
let g:neoterm_repl_python = ['conda activate ds', 'clear', 'ipython --no-banner --nosep']
let g:neoterm_bracketed_paste = 1
let g:neoterm_autoscroll = 1
let g:neoterm_default_mod='belowright'
let g:neoterm_size = 14
let g:neoterm_keep_term_open = 1
" https://github.com/kassio/neoterm/issues/148 Usage: TT ls
command! -nargs=+ TT Topen | T <args>
let g:neoterm_automap_keys = ",t"
" let g:neoterm_repl_python = ['conda activate ds', 'clear', 'ipython --no-banner --no-autoindent --nosep']
" let g:neoterm_repl_enable_ipython_paste_magic = 1
let g:neoterm_shell = "/bin/zsh"

" For Limelight to work with colorscheme (:help cterm-colors)
let g:limelight_conceal_ctermfg = 'gray'
" autocmd! User GoyoEnter Limelight | set colorcolumn="" | set nocursorline
" autocmd! User GoyoLeave Limelight!

" Neomake: When writing a buffer (no delay), and on normal mode changes (after 1s).
"call neomake#configure#automake('nw', 1000)


" SQL Completion: disable <C-c> binding
let g:omni_sql_no_default_maps = 1

" Linter
let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'javascript': ['eslint'],
    \ 'c': ['clang']} " pydocstyle, bandit, mypy
let g:ale_fixers = {'*': [], 'python':['black']}
let g:ale_fix_on_save = 1
" Disable ALE by default. Enable with :ALEToggle (leader+z)
let g:ale_enabled = 0

" UltiSnips: since we are using Deoplete, <tab> doesn't work
let g:UltiSnipsExpandTrigger="<C-t>"

" Deoplete
let g:deoplete#enable_at_startup = 0
" Also include snippets with short names
call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
set completeopt+=noinsert " Do not insert text while scrolling the menu
set completeopt-=noselect " Select first result
set completeopt-=preview  " Disable preview window in the bottom


" command! Autocomplete  call deoplete#custom#option('auto_complete', v:true) \| echo "hello world"
" command! AutocompleteOff call deoplete#custom#option('auto_complete', v:false)
" command! Popup           call deoplete#custom#option({'auto_complete_popup':'auto'})
" command! PopupOff        call deoplete#custom#option({'auto_complete_popup':'manual'})
" AutocompleteOff
"
function AutocompleteOn()
    call deoplete#custom#option('auto_complete', v:true)
    call jedi#configure_call_signatures()
    let g:jedi#show_call_signatures = "1" "Show function helper
endfunction

function AutocompleteOff()
    call deoplete#custom#option('auto_complete', v:false)
    let g:jedi#show_call_signatures = "0" "Hide function helper
endfunction

function AutocompleteToggle()
    if deoplete#is_enabled() == 0
        call deoplete#enable()
        call AutocompleteOn()
        ALEEnable
        echo 'Autocomplete On. Linter On.'
        " call AutocompleteOff()
        " echo 'Deoplete On. Repeat keys: Autocomplete On. <C-n>: Activate manually.'
    else
        if deoplete#custom#_get().option.auto_complete
            call AutocompleteOff()
            echo 'Autocomplete Off.'
        else
            call AutocompleteOn()
            echo 'Autocomplete On.'
        endif
    endif
endfunction

" Tabs for autocompletion
" inoremap <silent><expr> <TAB>
" 	    \ pumvisible() ? "\<C-n>" :
" 	    \ <SID>check_back_space() ? "\<Tab>" :
" 	    \ deoplete#complete()
" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Deoplete Jedi
let g:python_host_prog  = '/usr/bin/python' 
if system('uname') =~ "Darwin"
    let g:python3_host_prog = '/Users/fer/miniconda3/envs/dsfull/bin/python'
else
    let g:python3_host_prog  = '/usr/bin/python3' 
endif

" Deoplete-clangx
call deoplete#custom#var('clangx', 'clang_binary', '/usr/bin/clang')

" Deoplete-clang
" let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
" let g:deoplete#sources#clang#clang_header = '/Library/Developer/CommandLineTools/usr/lib/clang'

" Jedi-Vim
let g:jedi#auto_initialization = 1 " Disable init at startup
" Manually set function helper
" let g:jedi#show_call_signatures = "1" "0: do not show function helper
" Disable completions when using together with deoplete-jedi
let g:jedi#completions_enabled = 0 " Disable completions: https://github.com/davidhalter/jedi-vim
let g:jedi#goto_command = 'gd'
nnoremap gd :call jedi#goto()<CR>
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#documentation_command = '<Leader>_K'
" let g:jedi#auto_close_doc = 0

" Plasticboy markdown
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_level = 2    " Do not fold title
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1             " Avoid math syntax conceal
let g:tex_conceal = ""
set conceallevel=2                      " Highlight Bold and Italic 

" Startify Bookmarks
let g:startify_bookmarks = [ {'d': '~/.dotfiles/vim/init.vim'},  {'z': '~/.dotfiles/zsh/zshrc'}, {'t': '~/.dotfiles/tmux/tmux.conf'}, {'c': '~/.dotfiles/zsh/my_custom_commands.sh'} ]

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

" NERD Tree hide help message
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
let g:NERDTreeQuitOnOpen=1 " Close NERDTree after opening file ('o')

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
" let g:jupytext_fmt = 'py'
" let g:jupytext_fmt = 'python' "convert to .py files
" let g:jupytext_filetype_map = {'md': 'python'} "python syntax highlighting

" CamelCaseMotion: treat _ as word separator
" omap <silent> iw <Plug>CamelCaseMotion_iw
" xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie

" Vim-go: Go automatic imports
let g:go_fmt_command = "goimports"
" Vim-go: Syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1

" TERNJS (Javascript)
" Set bin if you have many instalations
" let g:deoplete#sources#ternjs#tern_bin = '/path/to/tern_bin'
let g:deoplete#sources#ternjs#timeout = 1
" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1
" Whether to include the distance (in scopes for variables, in prototypes for 
" properties) between the completions and the origin position in the result 
" data. Default: 0
let g:deoplete#sources#ternjs#depths = 1
" Whether to include documentation strings (if found) in the result data.
" Default: 0
let g:deoplete#sources#ternjs#docs = 1
" When on, only completions that match the current word at the given point will
" be returned. Turn this off to get all results, so that you can filter on the 
" client side. Default: 1
let g:deoplete#sources#ternjs#filter = 0
" Whether to use a case-insensitive compare between the current word and 
" potential completions. Default 0
let g:deoplete#sources#ternjs#case_insensitive = 1
" When completing a property and no completions are found, Tern will use some 
" heuristics to try and return some properties anyway. Set this to 0 to 
" turn that off. Default: 1
let g:deoplete#sources#ternjs#guess = 0
" Determines whether the result set will be sorted. Default: 1
let g:deoplete#sources#ternjs#sort = 0
" When disabled, only the text before the given position is considered part of 
" the word. When enabled (the default), the whole variable name that the cursor
" is on will be included. Default: 1
let g:deoplete#sources#ternjs#expand_word_forward = 0
" Whether to ignore the properties of Object.prototype unless they have been 
" spelled out by at least two characters. Default: 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0
" Whether to include JavaScript keywords when completing something that is not 
" a property. Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1
" If completions should be returned when inside a literal. Default: 1
let g:deoplete#sources#ternjs#in_literal = 0
"Add extra filetypes
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'vue',
                \ ]
"}}}
" UI Customization {{{

" Blinking Cursor (from :help guicursor)
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175
" Set cursor underline in normal mode
" set guicursor=n:hor50,v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" Gruvbox
" colorscheme apprentice
" colorscheme one
set background=dark
" let g:gruvbox_color_column='bg0'
let g:gruvbox_italic=1 "This should go before colorscheme gruvbox
" let g:gruvbox_bold=1 "Enabled by default

" TermGui colors for Gruvbox: https://github.com/morhetz/gruvbox/wiki/Terminal-specific
" The first two lines are recommended for standard Vim
" let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Comments in italics
highlight Comment cterm=italic

"Vertical Split bar. autocmd: change survives switch of color scheme
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=NONE

" Linebreaks
set wrap
set linebreak " Do not split words in linebreak
set breakindent " Indent line breaks
set breakindentopt=shift:1 " Add space to linebreaks to make them more evident
let &showbreak='⤷ '        "Arrow pointing downwards U+2935
set formatoptions-=t " Disable break lines but keep textwidth and colorcolumn

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
nnoremap <silent> <leader><CR> :SlimuxREPLSendBuffer<CR>
nnoremap <silent> mm    :w<CR>:!python3 %<CR>
nnoremap <silent> m<CR> :w<CR>:!tmux send-keys -t .1 "python3 %:p"; tmux send-keys -t .1 C-m<CR><CR>
nnoremap <silent> <F5>  :w<CR>:!tmux send-keys -t .1 "python3 %:p"; tmux send-keys -t .1 C-m<CR><CR>

"vnoremap <silent> <space><CR> :<C-w>SlimuxShellRun %cpaste<CR>:'<,'>SlimuxREPLSendSelection<CR>:SlimuxShellRun --<CR>

" Neoterm Send Selection
nnoremap <silent> <leader>tt :Ttoggle<CR>
nnoremap <silent> <leader>th :Tclose<CR>
nmap gx <Plug>(neoterm-repl-send)
xmap gx <Plug>(neoterm-repl-send)
nmap gxx <Plug>(neoterm-repl-send-line)
nnoremap <silent> gz :TREPLSendFile<CR>
nnoremap <silent> gm :T python %<CR>
nnoremap <silent> mp :silent w<CR>:Tclear<CR>:TT python %<CR>
" nnoremap <leader><CR> <Plug>(neoterm-repl-send-line)
"xnoremap <leader><CR> <Plug>(neoterm-repl-send)
" nnoremap <silent> <leader><CR> :TREPLSendLine<CR>j0
" vnoremap <silent> <leader><CR> :TREPLSendSelection<CR>

" C Language compile
" Compile only and create executable
nnoremap <silent> mC :silent w<CR>:echo system('clang -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow '.expand('%').' -lcs50 -lm -o '.expand('%:r').' && echo Compiled to file: '.expand('%:r'))<CR>
" Compile and Run in new terminal window
nnoremap <silent> mc :silent w<CR>:Tclear<CR>:exec "TT clang -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow ".expand('%')." -lcs50 -lm -o ".expand('%:r')." && ./".expand('%:r')<CR>

" :exec "T cd ".expand('%:h:p').
" Escape key to jk
inoremap jj <Esc>`^
inoremap jk <Esc>`^
inoremap kj <Esc>`^
inoremap <C-c> <Esc>`^

" Insert blank lines below and above: https://superuser.com/a/607168 (Tim Pope)
nnoremap <silent> ]<Space> :<C-u>put =repeat(nr2char(10),v:count)<Bar>execute "'[-1"<CR>
nnoremap <silent> [<Space> :<C-u>put!=repeat(nr2char(10),v:count)<Bar>execute "']+1"<CR>

" Maps for Spanish Keyboard
inoremap ç \

" Forward search in Skim
map ,p :w<CR>:silent !~/.dotfiles/zsh/displayline -b -g <C-r>=line('.')<CR> %<.pdf<CR>

" Syntax highlighting for Markdown
" autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

" FZF
" nnoremap <silent> <leader>f :FZF<cr>
nnoremap <leader>e :Files<CR>
nnoremap <leader>o :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :BLines<CR>
nnoremap <leader>F :Lines<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>H :History<CR>
nnoremap <leader>h :Helptags!<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>R :Rgcmd 
" Home folder
nnoremap <leader>rh :Rghome<CR> 
" Up one folder
nnoremap <leader>ru :Rgup<CR>
" Dropbox folder
nnoremap <leader>rd :Rgdrop<CR>

" Jump between buffers
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" ALE Linting
" Toggle Linter
noremap <leader>z :ALEToggle \| :echo ale_enabled ? "Linter On." : "Linter Off." <CR>
" nmap <leader>Z <Plug>(ale_detail)
" nmap <silent> <leader>k <Plug>(ale_previous)
" nmap <silent> <leader>j <Plug>(ale_next)

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
nnoremap <leader>d :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>D :source ~/.config/nvim/init.vim<CR>

" Goyo
nnoremap <leader>g :Goyo<CR>

" Vimwiki
" Todo Toggle conflicts with Choosing keyboard language
" From: https://github.com/vimwiki/vimwiki/blob/master/doc/vimwiki.txt
" nmap <Leader>tt <Plug>VimwikiToggleListItem
nmap <Leader>w<Leader>g <Plug>VimwikiMakeDiaryNote<Esc>:Goyo<CR>i

" Deoplete Enable Autocomplete
nnoremap <leader>a :call AutocompleteToggle()<CR>
" Activate manual complete (Open popup)
inoremap <expr> <C-n> deoplete#manual_complete()
" C-j to down and C-k to up in popup
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <silent><expr><CR> pumvisible() ? "<C-E>\<CR>" : "\<CR>"

" Hide all status lines
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noruler " Show row and column numbers
        set laststatus=0
        set noshowmode " Hide Insert, Visual text in statusline
        set noshowcmd " Hide number of lines output in visual mode
    else
        let s:hidden_all = 0
        set ruler
        set laststatus=2
        set showmode
        set showcmd
    endif
endfunction

nnoremap <S-h> :call ToggleHiddenAll()<CR>

" }}}
" Autocommands {{{

" Filetype detect
augroup set_filetypes
    autocmd!
    autocmd BufReadPost,BufNewFile *.txt set filetype=text
    autocmd BufReadPost,BufNewFile *.md  set filetype=markdown
    autocmd BufReadPost,BufNewFile *.py  set filetype=python
    autocmd BufReadPost,BufNewFile *.R   set filetype=R
    autocmd BufReadPost,BufNewFile *.tex set filetype=tex
augroup end

" Filetype settings
" Note: at some point this should/could be moved to .vim/after/ftplugin/tex.vim
augroup filetype_settings
    autocmd!
    autocmd FileType text,tex,markdown setlocal textwidth=99 
    autocmd FileType text,tex,markdown let g:goyo_width=99
    autocmd FileType python,R   setlocal textwidth=79

    " Latex no indent environments (Abstract, theorem, etc)
    autocmd FileType tex set indentkeys-=o
    " Ctrl+t: Compile tex file using latexmk
    autocmd FileType tex nmap <buffer> <C-T> :w<CR> :<C-u>silent call system('pdflatex '.expand('%'))<CR>
    " Shift+t:Open tex file in Skim
    autocmd FileType tex nmap <buffer> <S-T> :!open -a skim %:r.pdf<CR><CR><D-S-->

    " Preview Markdown and Vimwiki in HTML
    autocmd FileType markdown,vimwiki nnoremap <silent> <leader>md :<C-u>w<CR>:silent call system('mkdir -p ${TMPDIR}md-preview-${PPID}; pandoc -s -f markdown -t html --css ~/.dotfiles/css/github.css '.expand('%:p:S').' -o ${TMPDIR}md-preview-${PPID}/'.expand('%:t:r').'.html')<CR>:silent call system('open -a "Google Chrome" ${TMPDIR}md-preview-${PPID}/'.expand('%:t:r').'.html')<CR> :echom 'Previewing Markdown File.'<CR> 
    " Convert to HTML in the background
    autocmd FileType markdown,vimwiki nnoremap <silent> <leader>mD :<C-u>w<CR>:silent call system('mkdir -p ${TMPDIR}md-preview-${PPID}; pandoc -s -f markdown -t html --css ~/.dotfiles/css/github.css '.expand('%:p:S').' -o ${TMPDIR}md-preview-${PPID}/'.expand('%:t:r').'.html')<CR><CR> :echom 'Markdown Preview Updated.'<CR>
    " To autorefresh include this header in Markdown or Wiki file
    " ---
    "header-includes: <meta http-equiv="refresh" content="3"/>
    " ---

    autocmd FileType vimwiki set syntax=markdown

    " Javascript: tab = 2 spaces
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

    " Makefiles: use real tabs instead of spaces
    autocmd FileType make set noexpandtab
augroup END

" https://vi.stackexchange.com/a/17550
augroup my_autocmds
    autocmd!

    " Start new file in Insert Mode
    autocmd BufNewFile * startinsert
    autocmd BufNewFile ALEPreviewWindow stopinsert

    " Start Insert Mode for Geeknote
    autocmd BufEnter *.markdown startinsert 

    " Load NERD Tree on startup
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

" Focus function
function! s:focus()
augroup focus
autocmd!

set cursorline
highlight CursorLine ctermbg=236
" Set color of greyed-out columns to the right
" highlight Colorcolumn ctermbg=236
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

" Toggle Background (colocolumn)
command! Background :let &cc = &cc == '' ? '+'.join(range(1,255), ',+') : ''
command! CC :let &cc = &cc == '' ? '+'.join(range(1,255), ',+') : ''

" Call focus function to set greyed columns on and off
call s:focus()

augroup aug_nerd_tree
  au!

  " Auto launch tree when vim is run with directory as argument
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

  " Exit vim when the only buffer remaining is NerdTree
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " Use arrow keys to navigate
  autocmd FileType nerdtree nmap <buffer> l o
  autocmd FileType nerdtree nmap <buffer> L O
  autocmd FileType nerdtree nmap <buffer> h p
  autocmd FileType nerdtree nmap <buffer> H P

  " Disable cursorline in NERDtree to avoid lags
  " built-in g:NERDTreeHighlightCursorline does not work
  autocmd FileType nerdtree setlocal nocursorline
augroup END

fun s:PatchGruvboxScheme()
  " hi! ColorColumn ctermfg=255 ctermbg=203 guifg=#F8F8F2 guibg=#FF5555

  " Show NERDTree directory nodes in yellow/green
  " hi! __DirectoryNode cterm=bold ctermfg=214 gui=bold guifg=#E7A427
  hi! __DirectoryNode cterm=bold ctermfg=106 gui=bold guifg=#689d69
  " hi! link NerdTreeDir Directory
  hi! link NerdTreeDir __DirectoryNode
  " hi! link NERDTreeFlags Normal

  " Show NERDTree toggle icons as white
  " hi! link NERDTreeOpenable Normal
  " hi! link NERDTreeOpenable Directory
  " hi! link NERDTreeClosable Directory
  hi! link NERDTreeOpenable __DirectoryNode
  hi! link NERDTreeClosable __DirectoryNode
endf

" Customime color scheme after it was loaded
augroup aug_color_scheme
  au!

  autocmd ColorScheme gruvbox call s:PatchGruvboxScheme()
augroup END
colorscheme gruvbox

" Edit crontab: https://superuser.com/a/907889
autocmd filetype crontab setlocal nobackup nowritebackup

" }}}
" Commands and Functions {{{

function! s:goyo_enter()
    " Uncomment these lines to turn on gray colorcolumns
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
    
    " set statusline=\ 
    set colorcolumn=""
    set showbreak=
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
    " Uncomment this line to turn on gray colorcolumns
    call s:focus()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" FZF Commands
" command! -bang -nargs=? -complete=dir Files
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

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
