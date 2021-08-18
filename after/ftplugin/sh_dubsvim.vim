" Opinionated Bash/Shell filetype buffer (setlocal) behavior.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/dubs_ftype_mess
" License: https://creativecommons.org/publicdomain/zero/1.0/

" ========================================================================

" (lb): Just a few debugging hints...
" LATER/2020-02-27: Remove from this file. Here for now because this the
" only ftplugin, and I don't want this info to get lost quite yet (i.e.,
" so I can remind myself in a month or two when I migrate more code from
" plugin/dubs_ftype_mess.vim to ftplugin/*).
function! s:Trace(msg)
  " 2020-02-27: (lb) I moved this code from (abused) `autocmd BufRead *.sh set`
  " calls in plugin/dubs_ftype_mess.vim, and I added `echom` calls to help trace:
  "     echom "Loading ftplugin/sh..."
  " but I did not see these messages. But I could see that the buffer locals
  " were being set (e.g., `:set comments?` replied correctly). Also, I could
  " trigger a shell command to see this file being executed when opening a
  " shell filetype.
  " - So if you want to see for your self, call this function!
  let s:bfn = bufnr('%')
  execute "!notify-send -i face-wink 'ftplugin/sh' '".a:msg." (".s:bfn.")'"
endfunction

let s:trace_ftplug = 0
" YOU/DEV: Uncomment the following to see trace messages.
"  let s:trace_ftplug = 1

if s:trace_ftplug | call <SID>Trace('Go\!') | endif

" ========================================================================

" Only do this when not done yet for this buffer.
" (lb): I added a notify-send to the `if` and never saw it trigger,
" even though I see this file being sourced one, two, or sometimes
" three times when I load a file of the associated filetype.
" - So not quite sure why `:h ftplugin` says to add this code, but
"   here 'tis!
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

if s:trace_ftplug | call <SID>Trace('IN\!') | endif

" ========================================================================

function! s:update_undo_ftplugin(snippet)
  " (lb): I tested and it's somewhat okay if the undo snippet starts with a
  " pipe, " e.g., "| setlocal ... | setlocal ...", except that Vim echoes a
  " line (such as the line under the cursor) for every commandless pipe section.
  " Similarly with an starting echo, e.g., g:undo_ftplugin="echo | setlocal ...".
  " - Which is why this wrapper function, to decide when to add the pipe.
  " (lb): I also tested and it seems the only time the undo code is run is
  " if you deliberately change the filetype, e.g., closing the file or opening
  " another file will not trigger it. But if you, say, open a shell file, and
  " then `:set ft=conf`, you'll see the undo code run (which you can verify
  " by adding a `| !notify-send` to the end of the undo sequence; see below).
  if b:undo_ftplugin != ""
    let b:undo_ftplugin = b:undo_ftplugin . " | "
  endif
  let b:undo_ftplugin = b:undo_ftplugin . a:snippet
endfunction

" ========================================================================


" - Fix problem with starting a comment and then typing a colon: it
"   indents the line thinking we're typing Python code, or something.
" - The default for sh files:
"   indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix
function! s:ft_sh_set_indentkeys()
  setlocal indentkeys=0{,0},!^F,o,O,e,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix
  call <SID>update_undo_ftplugin("setlocal indentkeys<")
endfunction

" ========================================================================

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

" ========================================================================

function! s:ft_sh_set_formatoptions()
  setlocal formatoptions+=croql
  call <SID>update_undo_ftplugin("setlocal formatoptions<")
endfunction

" ========================================================================

function! s:ft_sh_set_smartindent()
  " Specify nosmartindent, else Vim won't tab your octothorpes
  setlocal nosmartindent
  call <SID>update_undo_ftplugin("setlocal smartindent<")
endfunction

" ========================================================================

function! s:ft_sh_set_locals()
  let b:undo_ftplugin = ""
  call <SID>ft_sh_set_indentkeys()
  call <SID>ft_sh_set_comments()
  call <SID>ft_sh_set_formatoptions()
  call <SID>ft_sh_set_smartindent()
  " (lb): If you want to see when the undo code is run, uncomment this call
  "       (and then trigger the undo with `set ft=...`).
  " - Note the `silent `, otherwise Vim echoes the `notify-send ...`.
  " - Note also the escaped !, one escape on the former, so it's !{cmd};
  "   and two escapes on the latter, so that "Cleanup!" is punctuated.
  if s:trace_ftplug
    call <SID>update_undo_ftplugin("silent \!notify-send -i face-wink 'ftplugin/sh' 'Cleanup\\!'")
  endif
endfunction

" ========================================================================
" ------------------------------------------------------------------------
" ========================================================================

if !exists("g:dubs_ftype_mess_ftplugin_sh_no_locals")
    \ || !g:dubs_ftype_mess_ftplugin_sh_no_locals
  call <SID>ft_sh_set_locals()
endif

