let g:ColorColumnBlacklist = ['diff', 'undotree', 'nerdtree', 'qf']
let g:CursorlineBlacklist = ['command-t']

function! autocmds#should_colorcolumn() abort
	return index(g:ColorColumnBlacklist, &filetype) == -1
endfunction

function! autocmds#should_cursorline() abort
	return index(g:CursorlineBlacklist, &filetype) == -1
endfunction
