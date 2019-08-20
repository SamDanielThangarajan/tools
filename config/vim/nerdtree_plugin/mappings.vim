call NERDTreeAddKeyMap({
       \ 'key': 'x',
       \ 'callback': 'SamNerdExecFile',
       \ 'quickhelpText': 'Execute a file',
       \ 'scope': 'FileNode' })

function! SamNerdExecFile(filenode)
  call NERDTreeExecFile()
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'd',
       \ 'callback': 'SamNerdDelFile',
       \ 'quickhelpText': 'Delete a file',
       \ 'scope': 'FileNode' })

function! SamNerdDelFile(filenode)
  call NERDTreeDeleteNode()
endfunction
