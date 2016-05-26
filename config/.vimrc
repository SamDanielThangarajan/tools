" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Sep 09
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
version 4.3
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set binary
set showmode
set showmatch
set nowrapscan
"set shiftwidth=2
set binary 
set filetype=on
set incsearch
set ic
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Inc_Winwidth = 0

map z :w

map f :f

map F :x

map W :!asrch <cword> <CR>
map [1~ 0
map [2~ R
map [3~ x
map [4~ $
map [5~ 
map [6~ 
map OB j
map OA k
map OC l
map OD h
map [B j
map [A k
map [C l
map [D h
abbr U2 U_INT16
abbr U4 U_INT32
abbr FO for ( ; ; )
{
} 
abbr WH while ()
{
} 
abbr DO do
{
} while ();
abbr CO /*  */
abbr CB /*
abbr CE */
abbr teh the
abbr esle else
abbr NO_POR_NUM NO_PORT_NUM

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

 "for cscope connections 
	if has("cscope")
		set csprg=/usr/bin/cscope
		set csto=1
		set cst
		set nocsverb
		cs add cscope.out
		set csverb
	endif

"C Intending Options
"TODO: Sam changed this options
"set cinoptions=2s,>2s,e0,n0,f0,{1s,}0,^0,:s,=s,ps,ts,c3,+s,(2s,us,)20,*30,gs,hs
"set cinkeys=0{,0},:,0#,!<Tab>,<CR>,<o>,<O>,<e>,<0>,<*>,<!>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 autocmd BufRead *.txt set tw=78

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    let ch_save = &ch
    set ch=2
    execute "'[,']!" . a:cmd
    set nobin
    let &ch = ch_save
    execute ":doautocmd BufReadPost " . expand("%:r")
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")

:let g:ttcn_fold = 1

com! -ra I call VisBlockIncr()
au VimLeave * echo "                  Thanks for using VIM   - Sam Daniel Thangarajan !!!"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" Sam Daniel Custom profile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set numbering
:se rnu
function! NumberToggle()
   if(&relativenumber == 1)
      set norelativenumber
      set number
   else
      set nonumber
      set relativenumber
   endif
endfunc

function SetNumber()
   set nornu
   set nu
endfunc

function SetRNumber()
   set nonu
   set rnu
endfunc

function MyInsertLeave()
   :call SetRNumber()
endfunc

function MyInsertEnter()
   :call SetNumber()
endfunc


nnoremap <leader>n :call NumberToggle()<cr>
:au FocusLost * :call SetNumber()
:au FocusGained * :call SetRNumber()
autocmd InsertEnter * :call MyInsertEnter()
autocmd InsertLeave * :call MyInsertLeave()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"To copy text to system clipboard
:set clipboard=unnamed
:set clipboard=unnamedplus
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CURSOR LINE DEFINITION
"Set The cursore line for easy line spotting
"set cursorline
":hi CursorLine term=bold cterm=bold guibg=Grey40 "fallback to this version
":hi CursorLine   ctermbg=darkred ctermfg=white guibg=darkred guifg=white
":hi CursorColumn ctermbg=darkred ctermfg=white guibg=darkred guifg=white
"color desert
"set cursorline
"hi CursorLine term=bold cterm=bold guibg=Grey40
" " Default Colors for CursorLine
"highlight  CursorLine ctermbg=red ctermfg=green
" " Change Color when entering Insert Mode
"autocmd InsertEnter * highlight  CursorLine ctermbg=Green ctermfg=Red
" " Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * highlight  CursorLine term=bold cterm=bold guibg=Grey40
"
"CURSORLINE DEFINITION
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
"autocmd InsertEnter * highlight  CursorLine ctermbg=Yellow ctermfg=Red term=bold cterm=bold
"autocmd InsertEnter * highlight  CursorLine ctermbg=Yellow ctermfg=Black term=bold cterm=bold
autocmd InsertEnter * highlight  CursorLine ctermbg=DarkBlue ctermfg=LightGrey term=bold cterm=bold
autocmd InsertLeave * highlight  CursorLine ctermbg=NONE ctermfg=NONE term=bold cterm=bold guibg=Grey40
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ENABLE PYTHON HIGHLIGHTING                                                                                                                                          
syntax on
"filetype indent plugin on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SET THE INDENT FOLDING IN THE PROGRAMS
"set foldmethod=indent
"set foldmethod=syntax
"set foldlevel=3
"za - toggle
"zc - close
"zo - open
"and all commands with caps A C O.. to do all folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SET TAG FILES
"tags created using ~/tools/generatetags/generatetags.py
set tags=~/project_tags/${PROJECT_NAME}/${CLONE_NAME}/tags
set tags+=~/project_tags/c++_header_tags/tags
"set tags+=~/project_tags/poco/tags 
set tags+=~/project_tags/maf/tags 
set tags+=~/project_tags/sys_tags
set tags+=~/project_tags/gmock/tags
set tags+=~/project_tags/boost/tags

if has("cscope")
    set nocsverb
    cs add ~/project_tags/${PROJECT_NAME}/${CLONE_NAME}/cscope.out
endif    

"CTRL + ] => normal jump in same buffer
"CTRL + \ => jump in new tab
"ALT + ] => jump in new vertical tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ENABLE SYNTAX HIGHLIGHTING
syntax enable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GIT COMMIT
autocmd Filetype gitcommit setlocal spell textwidth=72
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"OMNICCCOMPLETE
"Use the below commands to make autocomplete in vi for cpp files.
set nocp
filetype plugin on
let OmniCpp_NamespaceSearch = 1
let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD", "ComAccessManagement"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
map <C-F12> :!ctags -R --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CUSTOM KEY BINDINGS
"
"TAGlIST COMMANDs
"
"Important commands
"1. CTRL + t : open the taglist window
"2. ENTER the tag to opent the particular tag
"3. press 'o' to open the tag in a new window
"4. press 'x' to zoom in and zoom out
"5. press 's' to sort the tag list
"6. press 'space' to get function signature
nnoremap <silent> <C-l> :TlistToggle<CR>


"WINDOW NAVIGATION
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

"CTAGS
"map <F3> <C-]> "F3 used down
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"TAGLIST OPTIONS
"http://vim-taglist.sourceforge.net/manual.html
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"TABS TO SPACE
set smartindent
set tabstop=3
set shiftwidth=3
set expandtab
set softtabstop=3

"Project specific indendation
if !empty($PROJECT_NAME)
   let project_name = $PROJECT_NAME
   let project_specific_config = '~/project_vim_config/' . project_name . '/vimrc'
   if filereadable(project_specific_config)
      exe 'source' project_specific_config
   endif
endif

filetype plugin indent on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"TABS TO SPACE
"Open NERD TREE by default if no files are present
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"Open NERDTREE by default (disabled for now)
"`autocmd vimenter * NERDTree`

"Close vi only if NERDTREE is the only buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Key mappings
map <C-n> :NERDTreeToggle<CR>

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"MISC.
"Spell check
:nnoremap <F3> : set spell spelllang=en_us<CR>
:nnoremap <F4> :set nospell<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SYNTASTIC
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler = 'gcc'
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_error_symbol = "x"
let g:syntastic_warning_symbol = "W"
let g:syntastic_style_error_symbol = "sE"
let g:syntastic_enable_balloons = 1

"Make it available only on demand
"let b:syntastic_mode = "passive"
let g:syntastic_mode_map = { "mode": "passive"}
:nnoremap <F9> :SyntasticCheck<CR>
:nnoremap <F10> :SyntasticReset<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Defined macros
":nnoremap <leader>C :'<,'>s/^/\/\/<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"VIM FUGITIVE
"1. Edit files.
"2. :GStatus
"3. '-' to add files to staging area
"4. 'r' in nerdtree to get it reflected
"5. :GCommit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVIM
colorscheme slate
"colorscheme ron
"colorscheme evening
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
