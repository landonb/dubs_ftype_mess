" File: ftplugin/python_dubsvim.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2016.07.12
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubs Vim *.py filetype behavior
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2015-2016 Landon Bouma.
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

" Only do this when not done yet for this buffer
if exists("g:ftplugin_python_dubsvim") || &cp
  finish
endif
let g:ftplugin_python_dubsvim = 1

" Snippets-Insertion Shortcuts
" ------------------------------------------------------

" :h line-continuation

function! s:Python_Abbrev_PDB_Right_Hand_Middles_and_Pointies__SO_COMPLICATED()
  " [lb] loves me some breakpoint action.
  " And this is a silly/great macro to insert in-code bps quickly.
  " Simply type the magic sequence and then hit space or return, et voilà!

  " Final part of abbreviation, used to position cursor and cleanup the trigger.
  " This was originally:
  "   l:rhs_clean = '<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR>'
  " but wnclude the Eatchar so that whatever triggers the replacement gets removed,
  " e.g., the user can type the abbrev, then hit space to trigger it, and Eatchar
  " will gobble the space.
  let l:rhs_clean = "<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\\\s')<CR>"

  let l:lhs_pdbbp = "';';"
  let l:rhs_pdbbp = 'import pdb; pdb.set_trace()'
  " Just for ref, without the intermediate variables, it'd be:
  "   autocmd BufEnter,BufRead *.py
  "     \ iabbrev <buffer> ';';
  "     \ import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
  "   iabbrev <buffer> ';';
  "     \ import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
  exec 'autocmd BufEnter,BufRead *.py iabbrev <buffer> ' . l:lhs_pdbbp . ' ' . l:rhs_pdbbp . l:rhs_clean
  " 2019-01-14: I had `setlocal iabbrev...` commented out. But this is a filetype plugin, so... should be fine?
  " FIXME/2019-01-14: Why both an autocmd, and this iabbrev. 1 or the other is all we gotta really need!
  exec 'iabbrev <buffer> ' . l:lhs_pdbbp . ' ' . l:rhs_pdbbp . l:rhs_clean

  " https://vi.stackexchange.com/questions/18146/iabbrev-starting-with-semicolon
  "let l:lhs_saner = ";l;l"
  let l:lhs_saner = "';;'"
  let l:rhs_saner = 'import os, pdb; os.system("stty sane"); pdb.set_trace()'
  " For working with PPT, and other front end frameworks that rewire the terminal pipes.
  exec 'autocmd BufEnter,BufRead *.py iabbrev <buffer> ' . l:lhs_saner . ' ' . l:rhs_saner . l:rhs_clean
  exec 'iabbrev <buffer> ' . l:lhs_saner . ' ' . l:rhs_saner . l:rhs_clean

  " TEST:
  "  iabbrev ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#
  " PAST: I first tried to abbrev -p-p, something easy and unique, but it
  " evokes "E474: Invalid argument". The similar sequence, p-p-, does work,
  " but it doesn't feel natural to type. ;l;l seemed like another good idea,
  " but it also evokes invalid argument. However, starting with a single quote
  " work, which gives us such combinations as ';';, ';;', and ';';.
  " NOTE: In command mode, typing 0 is same as <HOME>.
  "       In block mode, the cursor has to sit on a character, so
  "       d<HOME> will delete to the beginning of the line but will
  "       leave the last character. So instead bounce to the start
  "       of the line and type D to delete to the end of the line.
  " CAVEAT: The abbreviation is triggered by you typing a whitespace
  "         character which remains. Since you'll delete the breakpoint
  "         eventually, anyway, this isn't that big of a deal, unless
  "         you're like me and a little OCD and despise all trailing \s$
  " MAYBE: Is there a better way to do this? Just always type it out?
  "        Use a <Leader>macro? \trace? A command/meta-key mapping?
endfunction

" 2020-12-05: Why is the previous function _SO_COMPLICATED? This one-liner much better!
" I think it works better, too, something with l:rhs_clean was not working
" and I kept getting left with an extra character after the alias...? prob
" user error, but, anyway, at least for now, this!
"
"  autocmd BufEnter,BufRead *.py iabbrev <buffer> ';'; import pdb; pdb.set_trace()<C-o>26<Left><C-R>
"
"  function! s:Python_Abbrev_PDB_Set_Trace_Right_Hand_Middle_Pointy_Middle_Pointy__THIS_WORKS()
"    iabbrev <buffer> ';'; import pdb; pdb.set_trace()<C-o>26<Left><C-R>
"  endfunction
"
function! s:Python_Abbrev_PDB_Set_Trace_Right_Hand_Middle_Pointy_Middle_Pointy__THIS_WORKS()
  autocmd BufEnter,BufRead *.py
    \ redir => message
    \ | iabbrev <buffer> ';';
    \ | redir END
    \ | if message == ''
    \ |   iabbrev <buffer> ';'; import pdb; pdb.set_trace()<C-o>26<Left><C-R>
    \ | endif
endfunction

" ****

" 2023-01-30: I've added iabbrev check (using redir to capture output) to not
" clobber ';'; alias if previously set. This lets user override alias from a
" private Vim plug, perhaps, e.g., to use `pdbr` and `pdbr.set_trace()`.

function! s:Python_Abbrev_PDB_Set_Trace_Right_Hand_Middle_Pointy_Middle_Pointy__ACTUAL()
  autocmd BufEnter,BufRead *.py silent call <SID>MaybeSetPDBAlias()
endfunction

function! s:MaybeSetPDBAlias()
  redir => message
  iabbrev <buffer> ';';
  redir END

  if message == ''
    iabbrev <buffer> ';'; import pdb; pdb.set_trace()<C-o>26<Left><C-R>
  endif
endfunction

" ***

function! s:Python_Abbrev_PDB_Stty_Prep_Right_Hand_Middle_Pointy_Pointy_Middle()
  " Leave cursor on same line, at start of 'import os...':
  "
  "   autocmd BufEnter,BufRead *.py iabbrev <buffer> ';;' import os, pdb; os.system("stty sane"); pdb.set_trace()<C-o>54<Left><C-R>
  "
  " Or what I've liked better recently, throw a pass line after
  " and don't worry about repositioning the cursor (also I added
  " hands-off-`black` pragma):
  autocmd BufEnter,BufRead *.py iabbrev <buffer> ';;' import os, pdb; os.system("stty sane"); pdb.set_trace()  # fmt: skip<CR>pass<C-R>
endfunction

" FIXME/2023-01-31 15:36: Or don't care (don't use this), but ;ll; not working for me. Anywhere.
function! s:Python_Abbrev_RPDB2_Right_Hand_Middle_Pointy_Pointy_Middle()
  autocmd BufEnter,BufRead *.py iabbrev <buffer> ;ll; import rpdb2; rpdb2.start_embedded_debugger('password', fAllowRemote=True)<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
  iabbrev <buffer> ;ll; import rpdb2; rpdb2.start_embedded_debugger('password', fAllowRemote=True)<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
endfunction

" What'sAKeyword See The F1 Command / Ctrl-R Ctrl-W
" ------------------------------------------------------

function! s:Python_Configure_iskeyword()
  " Strange...
  " This is the default and makes, e.g., else: not be highlighted:
  "   iskeyword=@,48-57,_,192-255,:
  autocmd Filetype py setlocal iskeyword=@,48-57,_,192-255
  setlocal iskeyword=@,48-57,_,192-255
endfunction

" ------------------------------------------------------
" Python Highlighting
" ------------------------------------------------------

function! s:Python_Comments_FIXME_NOTE_highlighting()
  "   for filetype=python
  "     comments=s1:/*,mb:*,ex:*/,://,b:#,:XCOMM,n:>,fb:-
  " NOTE I'm not sure why python considers /* */ a comment...
  autocmd BufRead *.py setlocal
    \ comments=sb:#\ FIXME:,m:#\ \ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE:,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ FIXME,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE,m:#\ \ \ \ \ \ ,ex:#.,b:#
    \ formatoptions+=croql
  " 2016-05-02: EXPLAIN: Why is setlocal all alone here and not autocmd'd?
  setlocal
    \ comments=sb:#\ FIXME:,m:#\ \ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE:,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ FIXME,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE,m:#\ \ \ \ \ \ ,ex:#.,b:#
    \ formatoptions+=croql
endfunction

function! s:Python_Prevent_smartindent_Undent_Cstyle_Macro()
  " smartindent is too smart for octothorpes: it removes any indentation,
  " assuming you're about a write a C-style macro. Nuts to this, I say!
  " (Per the documentation (:h 'smartindent'), the ^H you see below is generated
  " by typing Ctrl-q Ctrl-h (Ctrl-V if dosmode isn't enabled, which makes Ctrl-V
  " paste).) (And you can't copy/paste this command to execute it, if you type it
  " you'll have to Ctrl-q Ctrl-h the special character.)
  autocmd BufRead *.py inoremap # X#
  "setlocal inoremap # X#
  inoremap # X#
  "inoremap # X#
endfunction

function! s:Python_Configure_nosmartindent()
  " 2015.03.12: I cannot tab a line starting with a pound...
  autocmd BufEnter,BufRead *.py setlocal nosmartindent
  setlocal nosmartindent
endfunction

function! s:Python_Configure_spell()
  " 2016.02.25: Is this safe with my overridden syntax/python.vim?
  autocmd BufEnter,BufRead *.py setlocal spell
  setlocal spell
endfunction

" Snippets-Insertion Shortcuts
" ------------------------------------------------------

function! s:Python_Main()
  " call <SID>Python_Abbrev_PDB_Right_Hand_Middles_and_Pointies__SO_COMPLICATED()
  " call <SID>Python_Abbrev_PDB_Set_Trace_Right_Hand_Middle_Pointy_Middle_Pointy__THIS_WORKS()
  call <SID>Python_Abbrev_PDB_Set_Trace_Right_Hand_Middle_Pointy_Middle_Pointy__ACTUAL()
  call <SID>Python_Abbrev_PDB_Stty_Prep_Right_Hand_Middle_Pointy_Pointy_Middle()
  call <SID>Python_Abbrev_RPDB2_Right_Hand_Middle_Pointy_Pointy_Middle()
  call <SID>Python_Configure_iskeyword()
  call <SID>Python_Comments_FIXME_NOTE_highlighting()
  call <SID>Python_Prevent_smartindent_Undent_Cstyle_Macro()
  call <SID>Python_Configure_nosmartindent()
  " call <SID>Python_Configure_spell()
endfunction

call <SID>Python_Main()

" ======================================================
" =============================================== EOF ==

