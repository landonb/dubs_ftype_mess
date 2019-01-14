" File: ftplugin/python_dubsacks.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2016.07.12
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubsacks *.py filetype behavior
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
if exists("g:ftplugin_python_dubsacks") || &cp
  finish
endif
let g:ftplugin_python_dubsacks = 1

" Snippets-Insertion Shortcuts
" ------------------------------------------------------

" [lb] loves me some breakpoint action.
" And this is a silly/great macro to insert in-code bps quickly.
" Simply type the magic sequence and then hit space or return, et voilà!
"autocmd BufEnter,BufRead *.py iabbrev <buffer> ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR>
autocmd BufEnter,BufRead *.py iabbrev <buffer> ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
"setlocal iabbrev <buffer> ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
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

autocmd BufEnter,BufRead *.py iabbrev <buffer> ';;' import rpdb2; rpdb2.start_embedded_debugger('password', fAllowRemote=True)<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>
iabbrev <buffer> ';;' import rpdb2; rpdb2.start_embedded_debugger('password', fAllowRemote=True)<Home><Up><End><CR><C-O>0<C-O>D#<Down><End><CR><C-R>=Eatchar('\s')<CR>

" What'sAKeyword See The F1 Command / Ctrl-R Ctrl-W
" ------------------------------------------------------

" Strange...
" This is the default and makes, e.g., else: not be highlighted:
"   iskeyword=@,48-57,_,192-255,:
autocmd Filetype py setlocal iskeyword=@,48-57,_,192-255
setlocal iskeyword=@,48-57,_,192-255

" ------------------------------------------------------
" Python Highlighting
" ------------------------------------------------------

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
" 2015.03.12: I cannot tab a line starting with a pound...
autocmd BufEnter,BufRead *.py setlocal nosmartindent
setlocal nosmartindent
" 2016.02.25: Is this safe with my overridden syntax/python.vim?
autocmd BufEnter,BufRead *.py setlocal spell
setlocal spell

" ======================================================
" =============================================== EOF ==

