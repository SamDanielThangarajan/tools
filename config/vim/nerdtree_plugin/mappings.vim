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

call NERDTreeAddKeyMap({
       \ 'key': '+',
       \ 'callback': 'SamNerdAddToGitSA',
       \ 'quickhelpText': 'add a file to git staging area',
       \ 'scope': 'FileNode' })
function! SamNerdAddToGitSA(filenode)
  let treenode = g:NERDTreeFileNode.GetSelected()
  let cmd = 'git add ' . treenode.path.str({'escape': 1})
  exec ':silent !' . cmd
  exec ':redraw!'
  exec ':NERDTreeRefreshRoot'
endfunction

call NERDTreeAddKeyMap({
       \ 'key': '-',
       \ 'callback': 'SamNerdRemoveFromGitSA',
       \ 'quickhelpText': 'remove a file from git staging area',
       \ 'scope': 'FileNode' })
function! SamNerdRemoveFromGitSA(filenode)
  let treenode = g:NERDTreeFileNode.GetSelected()
  let cmd = 'git reset HEAD ' . treenode.path.str({'escape': 1})
  exec ':silent !' . cmd
  exec ':redraw!'
  exec ':NERDTreeRefreshRoot'
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'g',
       \ 'callback': 'SamGrepInANode',
       \ 'quickhelpText': 'grep for text in a node',
       \ 'scope': 'Node'})
function! SamGrepInANode(node)
  echon "Enter the pattern to search:"
  let l:ptrn = input(' ')
  let l:cmd = "grep -rHIn \"" . l:ptrn . "\" " . a:node.path._strForCd()
  :call setqflist([], ' ', {
	\'lines' : systemlist(l:cmd),
	\'title': l:ptrn }) | copen
endfunction


"""
"To debug a varibale
":redir > ~/tmp/op111
":echo a:node
":redir END
"
"The op is a dict and a huge one.. So,
"> cat ~/tmp/op111 | tr "," "\n" > sample
"open sample in vi
"> %s/function("\d\+")/"function"/g
"> %s/'/"/g
"> %s/$/,/g
"> %s/\.\.\./ /g
