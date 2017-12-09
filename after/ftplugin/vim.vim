" File: after/ftplugin/vim.vim
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Last Modified: 2017.12.08
" Project Page: https://github.com/landonb/dubs_ftype_mess
" Summary: Dubsacks vim filetype additional behavior
" License: GPLv3
" -------------------------------------------------------------------
" Copyright © 2015-2017 Landon Bouma.
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

" Press F9 to source the Vim file being edited.
"   http://vim.wikia.com/wiki/Source_current_file_when_editing_a_script
noremap <silent><buffer> <F9> :exec 'source '.bufname('%')<CR>

