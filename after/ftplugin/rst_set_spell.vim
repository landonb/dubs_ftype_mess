" Vim filetype plugin: Enable spell checking on reST docs.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/vim-synsible-rst#🚻
" License: https://creativecommons.org/publicdomain/zero/1.0/
" Revision: 2021-08-18

" Ref: For details on boilerplace constructs used herein, consult:
"
"      https://github.com/landonb/vim-synsible-ftplugin-lesson#𝘼➕

" Usage: This plugin is enabled by default.
"
"        To disable, set "g:vim_synsible_rst_off" to a truthy value.

" ========================================================================
" BOILERPLATE

" Be modern.
if has("vimscript-4") | scriptversion 4 | endif

" Load guard.
if exists('b:did_ftplugin_too') | finish | endif

let b:did_ftplugin_too = 1

" Undo builder.
function! s:update_undo_ftplugin(snippet)
  if !exists("b:undo_ftplugin")
    let b:undo_ftplugin = ""
  elseif b:undo_ftplugin != ""
    let b:undo_ftplugin = b:undo_ftplugin .. " | "
  endif

  let b:undo_ftplugin = b:undo_ftplugin .. a:snippet
endfunction

call <SID>update_undo_ftplugin("unlet! b:did_ftplugin_too")

" Compatibility two-step.
let s:save_cpo = &cpo
set cpo-=C

" ========================================================================
" FUNCTIONALITY

function! s:setup_spell_enable()
  setlocal spell

  call <SID>update_undo_ftplugin("setlocal spell<")
endfunction

" Plugin main.
function! s:load_plugin()
  call <SID>setup_spell_enable()
endfunction

" ========================================================================
" BOILERPLATE

" Plugin enablement.
if !exists("g:vim_synsible_rst_off") || !g:vim_synsible_rst_off
  call <SID>load_plugin()
endif

" Restore compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo

