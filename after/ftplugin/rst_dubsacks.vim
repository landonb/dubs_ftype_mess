" File: ftplugin/rst_dubsacks.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2016.05.10
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubsacks reST filetype behavior
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2015-2016 Landon Bouma.
" 
" This file is part of Dubsacks.
" 
" Dubsacks is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License
" as published by the Free Software Foundation, either version
" 3 of the License, or (at your option) any later version.
" 
" Dubsacks is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty
" of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
" the GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with Dubsacks. If not, see <http://www.gnu.org/licenses/>
" or write Free Software Foundation, Inc., 51 Franklin Street,
"                     Fifth Floor, Boston, MA 02110-1301, USA.
" ===================================================================

" Only do this when not done yet for this buffer
if exists("g:ftplugin_rst_dubsacks") || &cp
  finish
endif
let g:ftplugin_rst_dubsacks = 1

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

" ------------------------------------------------------
" Spell Checking! [sic]
" ------------------------------------------------------

" [lb] tested spell checking for obviously-texty files,
" like txt and log, but there's too much of a mix
" of English and non-dictionary tokens. Only reST seems
" to work, especially since spell check ignores ``literals``.

autocmd BufEnter,BufRead *.rst setlocal spell

" Note that I tried a variation on the command,
"
"   autocmd Filetype rst setlocal spell
"
" but for some reason when I switched buffers to a code file, spell checking
" was still enabled. You could get over that with the above command,
"
"   autocmd BufEnter,BufRead *.rst setlocal spell

" -----------------------------------------------------------------------------
" Spell Checking cAPITALIZATION
" -----------------------------------------------------------------------------

" 2014.11.20: on 'blah... blah', the latter blah is underlined blue, indicating
" it's not capitalized. How would you fix the spellcapcheck to be okay with
" that?
"
" There are two ways to disable caps checking: changing the spellcapcheck
" variable,
"
"   set spellcapcheck=
"
" or disabling the highlight:
"
"   highlight clear SpellCap
"
" You can copy the default spellcapcheck using TabMessage:
"
"   :TabMessage set spellcapcheck spellcapcheck=[.?!]\_[\])'"^I ]\+
"
" And you can easily peruse the list of over 1,000 highlights similary:
"
"   :TabMessage hi
"
" There are five highlights with the word 'spell' in their name:
"
"   SpellBad xxx term=reverse ctermbg=12 gui=undercurl guisp=Red SpellCap xxx
"   term=reverse ctermbg=9 gui=undercurl guisp=Blue SpellRare xxx term=reverse
"   ctermbg=13 gui=undercurl guisp=Magenta SpellLocal xxx term=underline
"   ctermbg=11 gui=undercurl guisp=DarkCyan hl-SpellCap xxx cleared

autocmd BufEnter,BufRead *.rst setlocal spellcapcheck=

" FIXME: MAGIC_VALUE: Hrm, we cannot use a modeline to set highlight.
"        See: DG_CycleThruStyleGuides_. We parse the head and tail of
"        each file looking for a modeline and call 'set', so we could
"        do the same: look for a highlight-type modeline. But for now,
"        just bake this in. I can only think of one person with a file
"        of this name, so for most people, this'll be a no-op.
autocmd BufEnter,BufRead peckerwords.rst highlight clear rstEmphasis

" Other filetypes to spell check.
" -------------------------------

" E.g., todo.txt.
autocmd BufEnter,BufRead *.txt setlocal spell
autocmd BufEnter,BufRead *.txt setlocal spellcapcheck=

" Override .rst syntax ``.. code-block:: <language>`` mapping.
" ------------------------------------------------------------
" SYNC_ME: Similar *.rst changes in dubs_preloads.vim and rst_dubsacks.vim.

" In the preload file we added a few of the built-in syntaxes for
" Sphinx's `.. code-block:: <language>` mapping. Here we add syntaxes
" we've added to ~/.vim/syntax that are not standard.

" Add a few of our own syntaxes, er, syntaxii.
" Included Alternative File Extension Syntax File Type Mappings.
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
"   /usr/share/vim/vim74/syntax/rst.vim
" I added ~/.vim/, the nested list, a lookup in ~, and some spaces.
" Note that you cannot run the for-in loop without unletting first, else,
"   E706: Variable type mismatch for: code.
" That is, unless you use a unique name rather than `code`.
" I'm not sure where it's set (the syntax/rst.vim system file?),
" and it's not a global, or at least `:echo g:code` shows naught.
" So either use a unique name or just unlet, to be safe, or both.
" See: :help E706.
"
" findfileing... / &rtp: /home/landonb/.vim,/home/landonb/.vim/bundle_/AutoAdapt,/home/landonb/.vim/bundle_/TeTrIs.vim,/home/landonb/.vim/bundle_/command-t,/home/landonb/.vim/bundle_/ctrlp.vim,/home/landonb/.vim/bundle_/dubs_all,/home/landonb/.vim/bundle_/dubs_appearance,/home/landonb/.vim/bundle_/dubs_buffer_fun,/home/landonb/.vim/bundle_/dubs_core,/home/landonb/.vim/bundle_/dubs_edit_juice,/home/landonb/.vim/bundle_/dubs_excensus,/home/landonb/.vim/bundle_/dubs_file_finder,/home/landonb/.vim/bundle_/dubs_ftype_mess,/home/landonb/.vim/bundle_/dubs_grep_steady,/home/landonb/.vim/bundle_/dubs_html_entities,/home/landonb/.vim/bundle_/dubs_project_tray,/home/landonb/.vim/bundle_/dubs_quickfix_wrap,/home/landonb/.vim/bundle_/dubs_style_guard,/home/landonb/.vim/bundle_/dubs_syntastic_wrap,/home/landonb/.vim/bundle_/dubs_toggle_textwrap,/home/landonb/.vim/bundle_/editorconfig-vim,/home/landonb/.vim/bundle_/generate_links.sh,/home/landonb/.vim/bundle_/ingo-library,/home/landonb/.vim/bundle_/minibufexpl.vim,/home/landonb/.vim/bundle_/nerdtree,/home/landonb/.vim/bundle_/syntastic,/home/landonb/.vim/bundle_/taglist,/home/landonb/.vim/bundle_/tlib_vim,/home/landonb/.vim/bundle_/viki_vim,/home/landonb/.vim/bundle_/vim-bufsurf,/home/landonb/.vim/bundle_/vim-gnupg,/home/landonb/.vim/bundle_/vim-misc,/home/landonb/.vim/bundle_/vim-rails,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,/home/landonb/.vim/bundle_/dubs_edit_juice/after,/home/landonb/.vim/after,/home/landonb/.vim/bundle/ctrlp.vim
"
"syntax_file: .vim/bundle_/dubs_ftype_mess/syntax/actionscript.vim
" WRONG:
"syntax_file: .vim/bundle_/syntastic/syntax_checkers/sh/sh.vim
"codemap: htm
"syntax_file:
"syntax_file: .vim/bundle_/dubs_ftype_mess/syntax/javascript.vim
"codemap: mxml
" WRONG:
"syntax_file: .vim/bundle_/dubs_ftype_mess/indent/mxml.vim
"
let search_paths = pathogen#split(&rtp)
unlet! codemap
for codemap in g:rst_syntax_code_list_dubs
  let fext = codemap.fext
  let synf = codemap.synf
  unlet! b:current_syntax
  " The first entry in the runtime path is the user's base Vim directory,
  "   usually ~/.vim. We could search that, e.g.,
  "
  "     let syntax_file = findfile(synf.'.vim', pathogen#split(&rtp)[0] . '/**')
  "
  "   but if you have any symlinks therein to large directory trees (such as
  "   those links under dubs_all/cmdt_paths), a depthy search can noticeably
  "   delay Vim boot time.
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
  "echomsg 'codemap: ' . codemap.fext '/ syntax_file: ' . syntax_file
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
"  /usr/share/vim/vim74/ftplugin/rst.vim

" ======================================================
" =============================================== EOF ==

