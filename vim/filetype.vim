" my filetype file
if exists("did_load_filetypes")
		finish
endif
augroup filetypedetect
		au! BufRead,BufNewFile pom.xml         setfiletype pom
		au! BufRead,BufNewFile *.log          setfiletype text
augroup END
