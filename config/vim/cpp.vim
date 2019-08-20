setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=79
setlocal expandtab
setlocal autoindent
setlocal smarttab
setlocal fileformat=unix
setlocal makeprg=g++\ -std=c++17\ %\ -o\ %<.exec
colorscheme evening
nnoremap <F7> : make \| cw<CR>
nnoremap <F8> : !./%<.exec<CR>
