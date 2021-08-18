" Vim help filetype plugin: Enable spell checking on text docs.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/dubs_ftype_mess#🧹
" Revision: 2021-08-16
" License: GPLv3

" Optional: Set g: variable to disable plugin from ever loading. But leave
"           b: variable alone, to prevent plugin from re-running on :edit.
if exists("g:no_vim_syntax_text_set_spell") || exists("b:did_vim_syntax_text_set_spell")
  finish
endif

let b:did_vim_syntax_text_set_spell = 1

setlocal spell

