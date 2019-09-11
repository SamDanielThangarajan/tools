call NERDTreeAddKeyMap({
       \ 'key': 'r',
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

call NERDTreeAddKeyMap({
       \ 'key': 'x',
       \ 'callback': 'SamNerdChmodAsExecFile',
       \ 'quickhelpText': 'chmod a file to be executable',
       \ 'scope': 'FileNode' })
function! SamNerdChmodAsExecFile(filenode)
  let treenode = g:NERDTreeFileNode.GetSelected()
  let cmd = 'chmod +x ' . treenode.path.str({'escape': 1})
  exec ':silent !' . cmd
  exec ':redraw!'
  exec ':NERDTreeRefreshRoot'
endfunction
