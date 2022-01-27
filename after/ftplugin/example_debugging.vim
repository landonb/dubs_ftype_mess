" ftplugin development and debugging tips and tricks, aka hints.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/vim-synsible-ftplugin-lesson#𝘼➕
" License: https://creativecommons.org/publicdomain/zero/1.0/

" ========================================================================
" BOILERPLATE

" Use dot-dot string concatenation (vimscript-2).
" Use v:<vim-variables> name space (vimscript-3).
" Leading zero does not mean octal (vimscript-4).
if has("vimscript-4") | scriptversion 4 | endif

" ------------------------------------------------------------------------

" HINT: Use desktop notifications to trace your code, not `:echom`.
"
" - You cannot `:echo` or `:echom` from ftplugin code.
"
"   I have no idea why. I couldn't find documentation on this.
"
" - Oddly, you can send other messages to the command line, e.g.,
"
"     set comments?
"
"   will generate output.
"
" So instead, send yourself notifications!
"
" - You can call the Trace function, or copy this one-off:
"
"     silent !notify-send -i face-wink 'You there' 'Yes, you\!'

function! s:Trace(msg)
  if !s:trace_ftplug | return | endif

  let l:cmd = "notify-send -i face-wink 'ftplugin/example'"
  let l:bfn = "buf. no. " .. bufnr('%')

  execute "silent !" .. l:cmd .. " '" .. a:msg .. " (" .. l:bfn .. ")'"
endfunction

" ------------------------------------------------------------------------

" HINT: Use this DEV switch to enable/disable the Trace mechanism.

let s:trace_ftplug = 0
" YOU/DEV: Uncomment/comment the following to control trace messages.
let s:trace_ftplug = 1

call <SID>Trace('Pre-load\!')

" ------------------------------------------------------------------------

" HINT: Use a load guard.
"
" CAVEAT: The load guard variable name matters.
"
" The variable name depends on if you want to override the runtime plugin.
"
" - If you don't want the global plugin to run (from $VIMRUNTIME/ftplugin),
"   use the same variable name as the runtime, "b:did_ftplugin".
"
"   All the runtime plugins check this variable and `finish` early if
"   it's set. So set it here to stop the global plugin from running.
"
" - If you'd rather complement/extend the existing plugin functionality,
"   use a unique variable name, e.g., "b:did_ftplugin_too".
"
"   (Or, you could skip the load guard in this case, but note that the
"   ftplugin is sourced on BufEnter, and not just when the buffer is
"   first loaded (BufRead); and also on `:edit` and `set ft=<filetype>`.
"   So if your ftplugin does any heavy lifting, you might just want to
"   run it once per buffer.)
"
"   - If you use b:undo_ftplugin to unwind changes when the buffer
"     filetype is changed, you'll definitely need the guard clause,
"     and you'll need to do two things:
"
"     (1) use a load guard, but use a variable name other than Vim's;
"
"     and (2) unset the load guard variable via b:undo_ftplugin.

" HINT: The ftplugin script is sourced on BufRead, BufEnter, and `:setf`.
"
" - Note that the ftplugin might frequently run on each buffer.
"
"   - The ftplugin script runs when the buffer is first loaded, which is
"     either because (a) the user just opened the file; or (b) the user
"     destroyed and recreated the buffer by calling `:edit`.
"
"     Anecdotally, I see that ftplugin is sourced 2 times in this case
"     (which I assume is essentially BufRead).
"
"   - The ftplugin is sourced when entering a buffer, e.g., if you
"     change buffers in the window, or if you jump the cursor to a
"     different window and then jump back.
"
"     Anecdotally, I see that ftplugin is sourced 1 time in this case
"     (which I assume is essentially BufEnter).
"
"   - Finally, the ftplugin is sourced on calls to `setf` (`set ft=<>`).
"
"     Anecdotally, I see that ftplugin is sourced 1 time in this case.
"
" - One nice bonus of running frequently is that it makes developing
"   easier. If you edit the ftplugin side-by-side with an example file
"   of that file type open in another windor, then as you jump between
"   the windows, you can edit the ftplugin file and jump back to the
"   example file and see your new code take effect.

" CAVEAT: If you use a custom load guard variable, unlet it on unload.
"
" - Note that Vim unlets b:did_ftplugin when a plugin is unloaded
"   (via LoadFTPlugin(), discussed more below), so that its load
"   guard is not blocked when the ftplugin script is subsequently
"   sourced again (e.g., on BufEnter, or because `:setf`).
"
"   So if you use a custom load guard and a buffer is reloaded, if
"   the b:undo_ftplugin command runs but your custom load guard is
"   *not* unlet (e.g., "unlet! b:did_ftplugin_too"), then when the
"   ftplugin script is sourced again, the load guard will see that
"   the guard variable is already set, and it'll `finish` early.
"
"   I.e., the ftplugin will have unloaded, but it will not reload.
"
"   SO REMEMBER: Unlet the custom guard variable on unload.
"
"                (See later is this example script for more.)

" CAVEAT: Store plugin in `after/ftplugin` if using b:did_ftplugin_too.
"
" - If you want your ftplugin and the global runtime plugin to work
"   side-by-side, ensure your plugin loads last. If the runtime plugin
"   runs last, it'll clobber b:undo_ftplugin, and then b:did_ftplugin_too
"   won't be unlet on unload, and your plugin won't reinitialize when
"   reloaded.

" So, where were we? Oh yeah, use a guard clause (aka load guard):

if exists('b:did_ftplugin_too')
  call <SID>Trace('Guard clause\!')

  finish
endif

let b:did_ftplugin_too = 1

call <SID>Trace('Loading\!')

" ------------------------------------------------------------------------

" HINT: Use b:undo_ftplugin to run cleanup code... (but how useful is it?).
"
" Assemble one or more undo commands that run when changing the filetype.
"
" - Note that it's (somewhat) okay to start the command with a pipe, e.g.,
"     "b:undo_ftplugin='| setlocal ... | setlocal ...'"
"   except that Vim echoes a line (such as the line under the cursor) for
"   every commandless pipe section. Kinda like starting with an echo, e.g.,
"     "b:undo_ftplugin='echo | setlocal ... | setlocal ...'"
"   So be complete and only pipe if b:undo_ftplugin is set before appending.
"
" - Note that the undo code (b:undo_ftplugin) runs whenever the user:
"   - Sets the file type (e.g., `:set ft=example`);
"   - Reloads the file (e.g., `:edit`); or
"   - Re-enters the buffer.
"   It does not run when leaving the buffer, or when closing the file.
"
" - Note that each global Vim ftplugin undoes any settings that it changes.
"
"   But I'm sorta unclear on the use case. Why would a user change the file-
"   type on a buffer? I can only think of one use case: working on help.
"   E.g., you might switch between `ft=text` to edit the document and then
"   `ft=help` to preview it.
"
"   It might just be for completeness. But I'm a little worried that I don't
"   totally understand the utility of b:undo_ftplugin, or switching filetype.
"   Then again, maybe I'm mostly correct, and there's only one legitimate
"   use case (working on help docs), in which case, perhaps you needn't
"   worry too much about crafting the undo command (except to prepare for
"   ftplugin to be sourced again, e.g., resetting cumulative effects).
"
"   I'm also unclear why ftplugin is sourced twice on BufRead or BufEnter,
"   but that's not a big deal. I'm more curious why it's unloaded and re-
"   sourced at all on BufEnter. Considering that ftplugin is mostly just
"   using `setlocal`, why reload it on BufEnter? Wouldn't the state before
"   and after be the same? (As a take-home exercise, I could study all the
"   $VIMRUNTIME/ftplugin/*.vim scripts to see if I can find the answer.)

function! s:update_undo_ftplugin(snippet)
  if !exists("b:undo_ftplugin")
    let b:undo_ftplugin = ""
  elseif b:undo_ftplugin != ""
    let b:undo_ftplugin = b:undo_ftplugin .. " | "
  endif

  let b:undo_ftplugin = b:undo_ftplugin .. a:snippet
endfunction

" ------------------------------------------------------------------------

" CAVEAT: If load guard named b:did_ftplugin, you must define b:undo_ftplugin.
"
" Otherwise, if you leave the undo variable unset, the plugin will not be
" sourced again after it's unloaded (either because BufEnter, `:setf`, or
" `:edit`, as discussed above).
"
" - According to Vim's implementation ($VIMRUNTIME/ftplugin.vim):
"
"     func! s:LoadFTPlugin()
"       if exists("b:undo_ftplugin")
"         exe b:undo_ftplugin
"         unlet! b:undo_ftplugin b:did_ftplugin
"       endif
"       ...
"
"   Meaning, if b:undo_ftplugin is not set, b:did_ftplugin won't be unlet,
"   and a subsequent `set ft=`, `:edit`, or BufEnter won't work, because
"   the guard clause atop the global ftplugin script will `finish` early.

" NOTE: This is redundant if your plugin call update_undo_ftplugin().
"       But it's here so you remember in case you use b:did_ftplugin.
if !exists("b:undo_ftplugin") | let b:undo_ftplugin = "" | endif

" Because of the custom guard clause, ensure that the custom guard variable
" is unlet on undo.

call <SID>update_undo_ftplugin("unlet! b:did_ftplugin_too")

" ------------------------------------------------------------------------

" HINT: Temporarily adjust compatible-options if using continuation lines.
"
" If you want the plugin to work in compatibility mode, and if your
" ftplugin uses continuation lines, e.g.,
"
"   let b:something =
"     \ 'something'
"
" then you'll need to remove the 'C' cpoption, which behaves thusly:
"
"   C   Do not concatenate sourced lines that start with a
"       backslash.  See |line-continuation|.
"
" As an example, here's what $VIMRUNTIME/ftplugin/sh.vim says and does:

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

" And then refer to the bottom of this file for restoring cpoptions.

" ========================================================================
" FUNCTIONALITY

" HINT: Use `setlocal {option}<` to reset local values.
"
" Adding the `<` postfix to `setlocal` sets "the local value of {option}
" to its global value by copying the value" (per `:h setlocal`).
"
" You could also `set {option}<` to remove the local value of {option}.
"
" Say you change the commentstring, e.g.,
"
"   setlocal commentstring=#%s
"
" then you'd also want to revert that change on undo, e.g.,
"
"   "Undo the stuff we changed.
"   let b:undo_ftplugin = "setlocal cms< | unlet! b:something | ..."
"
" Or, taking a more modular approach, encapsulate both in a function:

function! s:setup_pound_comments()
  setlocal commentstring=#%s

  call <SID>update_undo_ftplugin("setlocal cms<")
endfunction

" ------------------------------------------------------------------------

" HINT: Use a modular approach.
"
" Well, if you want to do so. I like that functions help isolate separate
" concerns. And each function can have a descriptive name, which provides
" some inherent documentation (and might be easier for you to absorb when
" scanning a file, and glossing over all the (lengthy) comments (I) left).
"
" E.g., here's another modular setup function:

function! s:setup_something_var()
  let b:something = "something"

  call <SID>update_undo_ftplugin("unlet! b:something")
endfunction

" ------------------------------------------------------------------------

" HINT: Add an undo trace to better understand the ftplugin lifecycle.
"
" Ensure s:trace_ftplug is enabled above, and then use `set ft=example`
" or `:edit` to see the undo in action, or cause a BufEnter event.
"
" - Note the `silent `, otherwise Vim echoes the `notify-send ...`.
"
" - Note also the escaped ! bangs: one escape on the !{cmd},
"   and two escapes so the literal 'Cleanup!' is punctuated.

function! s:trace_undo()
  if s:trace_ftplug
    call <SID>update_undo_ftplugin("silent \!notify-send -i face-wink 'ftplugin/sh' 'Cleanup\\!'")
  endif
endfunction

" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

" HINT: Use a global load guard to let users globally
"       enable or disable your cool new filetype plugin.
"
" Start by wrapping the modular functions in a 'main' function
" that sets everything up:

function! s:load_plugin()
  call <SID>setup_pound_comments()
  call <SID>setup_something_var()

  call <SID>trace_undo()
endfunction

" ========================================================================
" BOILERPLATE

" HINT: Call the main setup function conditionally.
"
" - This gives the user a way to disable the plugin programmatically.

if !exists("g:vim_synsible_ftplugin_lesson_off")
    \ || !g:vim_synsible_ftplugin_lesson_off
  call <SID>load_plugin()
endif

" (You could actually combine this guard up top with the other load guard,
"  but I didn't want to add even more complexity to the discussion above.)

" ========================================================================

" HINT: Restore cpoptions that you changed above.

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo

" ========================================================================

" And that's your honors course on Vim ftplugin scripting! A Plus Good Job!

