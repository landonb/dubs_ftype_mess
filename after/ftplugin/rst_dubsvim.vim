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

" What'sAKeyword See The F1 Command / Ctrl-R Ctrl-W
" ------------------------------------------------------

" [lb] just took the default for Python files.
" The default for rst is: iskeyword=38,42,43,45,47-58,60-62,64-90,97-122,_
" but then, e.g., colons are included in word-under-cursor selections,
" which makes searching some_word: not find some_word.
"
" Either BufEnter/BufRead and Filetype should work... the latter
" should run just once which should be all we need.
"  autocmd BufEnter,BufRead *.rst setlocal iskeyword=@,48-57,_,192-255
autocmd Filetype rst setlocal iskeyword=@,48-57,_,192-255

" Override .rst syntax ``.. code-block:: <language>`` mapping.
" ------------------------------------------------------------
" SYNC_ME: Similar *.rst changes in dubs_preloads.vim and rst_dubsvim.vim.

" In the preload file we added a few of the built-in syntaxes for
" Sphinx's `.. code-block:: <language>` mapping. Here we add syntaxes
" we've added to ~/.vim/syntax that are not standard.

" Add a few of our own syntaxes, er, syntaxii.
" Included Alternative File Extension Syntax File Type Mappings.
"
" To add syntax language highlighting to the ..code-block:: list,
" search: rst_syntax_code_list
if !exists('g:rst_syntax_code_list_dubs')
  let g:rst_syntax_code_list_dubs = [
    \ { 'fext': 'actionscript', 'synf': 'actionscript' },
    \ { 'fext': 'bash',         'synf': 'sh' },
    \ { 'fext': 'htm',          'synf': 'html' },
    \ { 'fext': 'js',           'synf': 'javascript' },
    \ { 'fext': 'mxml',         'synf': 'mxml' },
    \ ]
endif
" The following code is adapted from
"   /usr/share/vim/vim81/syntax/rst.vim
" I added ~/.vim/, the nested list, a lookup in ~, and refactored.
function! s:load_nonstandard_rst_code_block_syntaxes() abort
  let l:search_paths = pathogen#split(&rtp)

  for l:codemap in g:rst_syntax_code_list_dubs
    let fext = codemap.fext
    let synf = codemap.synf

    call s:load_nonstandard_rst_code_block_syntax(fext, synf)
  endfor
endfunction

" ***

function! s:load_nonstandard_rst_code_block_syntax(fext, synf) abort
  unlet! b:current_syntax

  " The first entry in the runtime path is the user's base Vim directory,
  " usually ~/.vim. We could search all files therein, e.g.,
  "
  "     let syntax_file = findfile(a:synf.'.vim', pathogen#split(&rtp)[0] . '/**')
  "
  " but if you have, e.g., a symlink to a large directory tree somewhere,
  " a depthy search can noticeably delay Vim boot time. So only look in a
  " few specific places for the syntax file.
  let l:syntax_file = ''

  if has('nvim')
    let l:syntax_file = s:find_syntax_file_nvim(a:synf)
  else
    let l:syntax_file = s:find_syntax_file_vim(a:synf)
  endif

  if l:syntax_file != ''
    " Turn into a full path. See :h filename-modifiers
    let l:syntax_file = fnamemodify(l:syntax_file, ':p')
  else
    let l:syntax_file = $VIMRUNTIME .. '/syntax/' .. a:synf .. '.vim'
  endif
  " echomsg 'codemap.fext: ' . a:fext '/ syntax_file: ' l:syntax_file

  if l:syntax_file != ''
    if !filereadable(l:syntax_file)
      echom 'ALERT: rst_dubsvim.vim: could not find syntax file: ' .. a:synf
      echom '- It was not found on any runtimepath, nor at: ' .. l:syntax_file
      echom '- REFER: Current &rtp: ' .. &rtp
    else
      exe 'syn include @rst' .. a:fext .. ' ' .. l:syntax_file
    endif
  endif

  exe 'syn region rstDirective' .. a:fext .. ' matchgroup=rstDirective fold '
        \ .. 'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+' .. a:fext .. '\s*$# '
        \ .. 'skip=#^$# '
        \ .. 'end=#^\s\@!# contains=@NoSpell,@rst' .. a:fext
  exe 'syn cluster rstDirectives add=rstDirective' .. a:fext
endfunction
" There's also a non-syntax, filetype plugin:
"  /usr/share/vim/vim81/ftplugin/rst.vim

" ***

" Note that Vim adds auto-loaded ~/.vim/pack/*/start/* dirs to runtimepath,
" e.g.,
"   :echo &rtp
" in Vim prints
"   /Users/user/.vim,/Users/user/.vim/pack/foo/start/bar,/Users/user/.vim/pack/baz/start/bat,...
"
" But in Neovim, instead of individual plugin paths, &rtp includes a glob path:
"   /Users/user/.vim/pack/*/start/*
" e.g.,
"   :echo &rtp
" in Neovim prints 
"  /Users/user/.vim,/Users/user/.vim/pack/*/start/*,/Users/user/.config/nvim,...
"
" - You'll also see a few other 'after/' paths in nvim you won't see in vim, e.g.,:
"     /Users/user/.local/share/nvim/site/after
"     /Users/user/.config/nvim/after
"     etc.
"
" REFER: See nvim's :help packages
"   
" REFER: nvim `:help rtp` says not to use wildcards:
"          Note that, unlike 'path', no wildcards like "**" are allowed.  Normal
"          wildcards are allowed, but can significantly slow down searching for
"          runtime files.  For speed, use as few items as possible and avoid
"          wildcards.
"        Except apparently for nvim itself, then wildcards are okay...
"
" SAVVY: nvim suggests nvim_get_runtime_file, not &rtp, to find files.
"
" - USAGE: You cannot just pass the basename, e.g.,
"
"     nvim_get_runtime_file('somefile.vim', 1)
"
"   returns: []
"
" - So include the directory name or glob, e.g.,
"
"     nvim_get_runtime_file('syntax/somefile.vim', 1)
"     nvim_get_runtime_file('*/somefile.vim', 1)

function! s:find_syntax_file_nvim(synf) abort
  let l:syntax_file = ''

  let l:all = 1
  let l:matches = nvim_get_runtime_file('syntax/' .. a:synf .. '.vim', l:all)

  if len(l:matches) > 1
    echom 'ALERT: rst_dubsvim.vim: More than one match for: syntax/' .. a:synf .. '.vim'
    echom l:matches
  endif

  if len(l:matches) > 0
    " Eh.
    let l:syntax_file = l:matches[0]
  endif

  return l:syntax_file
endfunction

function! s:find_syntax_file_vim(synf) abort
  let l:syntax_file = ''

  for l:vim_dir in pathogen#split(&rtp)
    let l:try_file = l:vim_dir .. '/after/syntax/' .. a:synf .. '.vim'
    if filereadable(l:try_file)
      let l:syntax_file = try_file

      break
    endif

    let l:try_file = l:vim_dir .. '/syntax/' .. a:synf .. '.vim'
    if filereadable(l:try_file)
      let l:syntax_file = l:try_file

      break
    endif
  endfor

  return l:syntax_file
endfunction

call s:load_nonstandard_rst_code_block_syntaxes()

" ======================================================
" =============================================== EOF ==

