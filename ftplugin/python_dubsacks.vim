" File: ftplugin/python_dubsacks.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2015.04.04
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubsacks *.py filetype behavior
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2015 Landon Bouma.
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
autocmd BufEnter,BufRead *.py iabbrev <buffer> ';'; import pdb;pdb.set_trace()<Home><Up><End><CR><C-O>0<C-O>D#
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

" What'sAKeyword See The F1 Command / Ctrl-R Ctrl-W
" ------------------------------------------------------

" Strange...
" This is the default and makes, e.g., else: not be highlighted:
"   iskeyword=@,48-57,_,192-255,:
autocmd Filetype py setlocal iskeyword=@,48-57,_,192-255

" ======================================================
" =============================================== EOF ==

