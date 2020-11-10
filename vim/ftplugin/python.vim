setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal fileformat=unix
let python_highlight_all=1
colorscheme 256-grayvim
colorscheme evening
nnoremap <F8> : !./%<CR>

function! SamPytest()
  echon "Enter pytest args:"
  let l:args = input('pytest> ')
  let l:cmd = "PYTHONPATH=" . getcwd() . " pytest " . l:args
  :call setqflist([], ' ', {
        \'lines' : systemlist(l:cmd),
  	\'title': l:args }) | copen
endfunction

nnoremap <F9> :call SamPytest()<CR>
