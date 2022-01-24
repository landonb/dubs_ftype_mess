" Vim filetype plugin: Opinionated Bash/Shell behavior.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/vim-synsible-sh#🐚
" License: https://creativecommons.org/publicdomain/zero/1.0/
" Revision: 2021-08-18

" Ref: For details on boilerplate constructs used herein, consult:
"
"      https://github.com/landonb/vim-synsible-ftplugin-lesson#𝘼➕

" Usage: This plugin is enabled by default.
"
"        To disable, set "g:vim_synsible_sh_off" to a truthy value.

" ========================================================================
" BOILERPLATE

" Be modern.
if has("vimscript-4") | scriptversion 4 | endif

" ------------------------------------------------------------------------

" Load guard.
if exists('b:did_ftplugin_too') | finish | endif

let b:did_ftplugin_too = 1

" ------------------------------------------------------------------------

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

" ------------------------------------------------------------------------

" Compatibility two-step.
let s:save_cpo = &cpo
set cpo-=C

" ========================================================================
" FUNCTIONALITY

" - Fix problem with starting a comment and then typing a colon: it
"   indents the line thinking we're typing Python code, or something.
" - The default for sh files:
"   indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix
function! s:ft_sh_set_indentkeys()
  setlocal indentkeys=0{,0},!^F,o,O,e,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix

  call <SID>update_undo_ftplugin("setlocal indentkeys<")
endfunction

" ------------------------------------------------------------------------

" ------------------------------------------------------
" Bash Highlighting
" ------------------------------------------------------

" [2020-02-27: Comment from when code was in plugin/dubs_ftype_mess.vim,
"  so refers to earlier comments= in that file:]
" Do the same for Bash shell script files
" 2020-01-23: The `XCOMM` comment is some holdover from somewhere.
"   - I see it atop Imakefile files when I grggle it, and at least
"     the `imake` tool converts 'XCOMM' to '#'.
"       https://linux.die.net/man/1/imake
"   - Removed from tail of comments:
"       ,:XCOMM
" 2020-01-23: But really I came here to remove another holdover that
"   erroneously prefixes echoes to stderr, e.g., if I type a line of
"   code that redirects an echo to stderr, and then hit return:
"       >&2 echo "ERROR: blarg"<CR>
"       >
"   you'll see than Vim starts with what it thinks is a comment char.
"   - Removed from tail of comments:
"       ,n:>
" 2020-01-23: While I'm at it, a few notes.
"   - The rule ``://`` really is two forward slashes;
"     I'm not sure if what context this is useful.
"       /* Maybe some people
"       // like to format their
"       // long comments weird-like.
"       */
"     - Whatever, let's remove it! Nixxed:
"       ,://
"   - The ``fb:-`` is for supposedly for a bullet list, i.e.,
"     Vim will not repeat the dash character on subsequent lines,
"     but it will preserve indentation.
"     - But Vim currently preserves indentation when I type in Bash,
"       whether as code or in comments, so I think ``fb:-`` is a no-op.
"     - As such, also nixxed!:
"       ,fb:-
function! s:ft_sh_set_comments()
  setlocal comments=sb:#\ FIXME:,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE:,m:#\ \ \ \ \ \ ,ex:#.,sb:#\ FIXME,m:#\ \ \ \ \ \ ,ex:#.,sb:#\ NOTE,m:#\ \ \ \ \ ,ex:#.,s1:/*,mb:**,ex:*/,b:#

  call <SID>update_undo_ftplugin("setlocal comments<")
endfunction

" ------------------------------------------------------------------------

function! s:ft_sh_set_formatoptions()
  setlocal formatoptions+=croql

  call <SID>update_undo_ftplugin("setlocal formatoptions<")
endfunction

" ------------------------------------------------------------------------

" Specify nosmartindent, else Vim won't tab your octothorpes
function! s:ft_sh_set_smartindent()
  setlocal nosmartindent

  call <SID>update_undo_ftplugin("setlocal smartindent<")
endfunction

" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

" Plugin main.
function! s:load_plugin()
  call <SID>ft_sh_set_indentkeys()
  call <SID>ft_sh_set_comments()
  call <SID>ft_sh_set_formatoptions()
  call <SID>ft_sh_set_smartindent()
endfunction

" ========================================================================
" BOILERPLATE

" Plugin enablement.
if !exists("g:vim_synsible_sh_off") || !g:vim_synsible_sh_off
  call <SID>load_plugin()
endif

" ------------------------------------------------------------------------

" Restore compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo

