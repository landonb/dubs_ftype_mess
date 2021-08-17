" File: ftplugin/rst_dubsvim.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2017.03.28
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubs Vim reST filetype behavior
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2015-2017 Landon Bouma.
" 
" This file is part of Dubs Vim.
" 
" Dubs Vim is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
" 
" Dubs Vim is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with Dubs Vim. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" Only do this when not done yet for this buffer.
if exists("g:ftplugin_rst_dubsvim") || &cp
  finish
endif
let g:ftplugin_rst_dubsvim = 1

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
" I added ~/.vim/, the nested list, a lookup in ~, and some spaces.
" Note that you cannot run the for-in loop without unletting first, else,
"   E706: Variable type mismatch for: code.
" That is, unless you use a unique name rather than `code`.
" I'm not sure where it's set (the syntax/rst.vim system file?),
" and it's not a global, or at least `:echo g:code` shows naught.
" So either use a unique name or just unlet, to be safe, or both.
" See also:
"   :help E706.
let search_paths = pathogen#split(&rtp)
unlet! codemap
for codemap in g:rst_syntax_code_list_dubs
  let fext = codemap.fext
  let synf = codemap.synf
  unlet! b:current_syntax
  " The first entry in the runtime path is the user's base Vim directory,
  " usually ~/.vim. We could search all files therein, e.g.,
  "
  "     let syntax_file = findfile(synf.'.vim', pathogen#split(&rtp)[0] . '/**')
  "
  " but if you have, e.g., a symlink to a large directory tree somewhere,
  " a depthy search can noticeably delay Vim boot time. So only look in a
  " few specific places for the syntax file.
  let syntax_file = ''
  for vim_dir in pathogen#split(&rtp)
    let try_file = vim_dir . '/after/syntax/' . synf.'.vim'
    if filereadable(try_file)
      let syntax_file = try_file
      break
    endif
    let try_file = vim_dir . '/syntax/' . synf.'.vim'
    if filereadable(try_file)
      let syntax_file = try_file
      break
    endif
  endfor
  if syntax_file != ''
    " Turn into a full path. See :h filename-modifiers
    let syntax_file = fnamemodify(syntax_file, ':p')
  else
    let syntax_file = $VIMRUNTIME . '/syntax/' . synf.'.vim'
  endif
  " echomsg 'codemap: ' . codemap.fext '/ syntax_file: ' . syntax_file
  if syntax_file != ''
    if !filereadable(syntax_file)
      echomsg 'Warning: Dubs could find: ' . synf.'.vim'
    else
      exe 'syn include @rst' . fext . ' ' . syntax_file
    endif
  endif
  exe 'syn region rstDirective'.fext.' matchgroup=rstDirective fold '
        \.'start=#\%(sourcecode\|code\%(-block\)\=\)::\s\+' . fext . '\s*$# '
        \.'skip=#^$# '
        \.'end=#^\s\@!# contains=@NoSpell,@rst' . fext
  exe 'syn cluster rstDirectives add=rstDirective' . fext
  unlet codemap
endfor
" There's also a non-syntax, filetype plugin:
"  /usr/share/vim/vim81/ftplugin/rst.vim

" ======================================================
" =============================================== EOF ==

