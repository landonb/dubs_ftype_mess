" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/landonb/dubs_ftype_mess#🧹
" License: GPLv3 | Copyright © 2015-2017 Landon Bouma.
" Summary: Dubs Vim reST filetype behavior

" -------------------------------------------------------------------

" GUARD: Press <F9> to reload this plugin (or :source it).
" - Via: https://github.com/embrace-vim/vim-source-reloader#↩️

if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_dubs_ftype_mess_ftplugin_rst_dubsvim
endif

if exists('g:loaded_dubs_ftype_mess_ftplugin_rst_dubsvim') || &cp

  finish
endif

let g:loaded_dubs_ftype_mess_ftplugin_rst_dubsvim = 1

" -------------------------------------------------------------------

function! s:DubsFtypeMessRstClearAutocommands()
  if exists('#DubsFtypeMessRst')
    augroup DubsFtypeMessRst
      autocmd!
    augroup END
    augroup! DubsFtypeMessRst
  endif
endfunction

call s:DubsFtypeMessRstClearAutocommands()

" -------------------------------------------------------------------

augroup DubsFtypeMessRst
  autocmd!

" Snippets-Insertion Shortcuts
" ------------------------------------------------------

" Insert contents of a file at cursor.
"
" https://stackoverflow.com/questions/690386/writing-a-vim-function-to-insert-a-block-of-static-text
"
" function! Text_Insert_File_Example()
"   " ~/vim/cpp/new-class.txt is the path to the template file
"   r~/vim/cpp/new-class.txt
" endfunction
" autocmd BufEnter,BufRead *.rst nmap ^N :call Text_Insert_File_Example()<CR>

" Insert string contents at cursor.
"
" https://stackoverflow.com/questions/12030965/change-the-mapping-of-f5-on-the-basis-of-specific-file-type
"
" snippetsEmu : An attempt to emulate TextMate's snippet expansion 
" http://vim.sourceforge.net/scripts/script.php?script_id=1318
"
" tmpl.vim : Syntax for HTML-Template
" http://www.vim.org/scripts/script.php?script_id=254

" Doesn't work: autocmd Filetype rst iabbrev <buffer> ``` `<CR><>`__
autocmd BufEnter,BufRead *.rst iabbrev <buffer> ``` `<CR><>`__

" -------------------------------------------------------------------

" What'sAKeyword See The F1 Command / Ctrl-R Ctrl-W
" ------------------------------------------------------

" [lb] just took the default for Python files.
" The default for rst is: iskeyword=38,42,43,45,47-58,60-62,64-90,97-122,_
" but then, e.g., colons are included in word-under-cursor selections,
" which makes searching some_word: not find some_word.
"
" Either BufEnter/BufRead and Filetype should work... the latter
" should run just once which should be all we need.
"
"  autocmd BufEnter,BufRead *.rst setlocal iskeyword=@,48-57,_,192-255
autocmd Filetype rst setlocal iskeyword=@,48-57,_,192-255

augroup END

" -------------------------------------------------------------------

" ======================================================
" =============================================== EOF ==

