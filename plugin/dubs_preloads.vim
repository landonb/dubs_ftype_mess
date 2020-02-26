" Vim startup script meant to be sourced before system scripts are loaded.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/dubs_ftype_mess
" License: https://creativecommons.org/publicdomain/zero/1.0/

" ------------------------------------------
" About:

" If you want to set any g:global variables to override stock
" Vim script behavior, you have to set the globals *before*
" sourcing the shared Vim files. So the `.vimrc` for Dubs Vim
" (https://github.com/landonb/dubs-vim) sources this script
" before loading any system scripts.

" ------------------------------------------------------------
" Extend the reST syntax highlighter's code vocabulary
" by overriding the ``.. code-block:: <language>`` mapping.
" ------------------------------------------------------------
" SYNC_ME: Similar *.rst changes in dubs_preloads.vim and rst_dubsvim.vim.

" See the Vim package file that takes care of reST syntax highlighting:
"  /usr/share/vim/vim74/syntax/rst.vim
" The list of recognized syntax highlighting languages is merely:
"   if !exists('g:rst_syntax_code_list')
"     let g:rst_syntax_code_list = ['vim', 'java', 'cpp', 'lisp',
"                                   'php', 'python', 'perl']
"   endif
" but we can do better than that, eh?
" Each language type is just bouced to another syntax file; see:
"   ls /usr/share/vim/vim74/syntax
" We could add them in ftplugin/rst_dubsvim.vim, but it's
"  a wee bit easier to setup the array that rst.vim uses.
" See also :help initialization for Vim script load ordering;
"  we could maybe set g: whenever and call runtime! to reload
"  the appropriate vim script, but which script is it? It's
"  easier just to swoop in early.

" Note that you cannot add 'rst' to this list without
" causing errors probably due to recursivenosity.
" NOTE: Add to this list to add languages to the .. code-block:: recognizer.
let g:rst_syntax_code_list = [
  \ 'bash',
  \ 'javascript',
  \ 'python',
  \ ]
  " E484: Can't open file syntax/json.vim
  " \ 'json',
  " 2016-11-17: One of these causes the line numbers to be inverse color.
  "  \ 'actionscript',
  "  \ 'mkd',
  "  \ 'mxml',
  "  \ 'textile',
  "  \ 'wikipedia',
  "  \ 'wp',
  " 2018-12-07: On 7K file, each code-block lang. costs 0.05 secs. of 3.75 total.
  " Meh.
  "  \ 'dtd',
  "  \ 'java',
  "  \ 'lisp',
  "  \ 'lua',
  "  \ 'make',
  "  \ 'perl',
  "  \ 'php',
  "  \ 'svg',
  " Suppose Meh.
  "  \ 'c',
  "  \ 'cpp',
  "  \ 'css',
  "  \ 'diff',
  "  \ 'go',
  "  \ 'hjson',
  "  \ 'html',
  "  \ 'ruby',
  "  \ 'sh',
  "  \ 'sql',
  "  \ 'vim',
  "  \ 'yaml',

" Re: bash syntax defined by sh.vim, so to make it work
" so you don't have to do, e.g., .. code-block:: sh
" we made a symlink, i.e.,
"   cd $HOME/.vim/pack/landonb/start/dubs_ftype_mess/syntax/
"   /bin/ln -s sh.vim bash.vim

