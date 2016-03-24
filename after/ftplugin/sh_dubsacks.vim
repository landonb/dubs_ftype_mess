" File: ftplugin/sh_dubsacks.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2015.04.04
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubsacks *.sh filetype behavior
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
if exists("g:ftplugin_sh_dubsacks") || &cp
  finish
endif
let g:ftplugin_sh_dubsacks = 1

" Fix problem with starting a comment and then typing a colon:
" it indents the line thinking we're typing Pythons.
" The default for sh files:
"   indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix

autocmd BufRead *.sh set indentkeys=0{,0},!^F,o,O,e,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix

