function! ExecuteFile()
  let l:filename=expand('%:p')
  let l:op = l:filename . '.exec'
  let l:compile = 'g++ -std=c++17 ' . l:filename . ' -o ' . l:op
  let l:exec = ' && echo "Executing..." && ' . l:op
  let l:cmd = l:compile . l:exec
  :call setqflist([], ' ', {
        \'lines' : systemlist(l:cmd),
        \'title' : l:cmd }) | copen
endfunction

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal fileformat=unix
setlocal makeprg=g++\ -std=c++17\ %\ -o\ %<.exec
nnoremap <F7> : make \| cw<CR>
nnoremap <F9> : !./%<.exec<CR>
nnoremap <F8> : call ExecuteFile()<CR>

"nasty way of getting my needed colors, use the exact same order
colorscheme evening
colorscheme slate
colorscheme evening
