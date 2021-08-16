" (lb) Copied from Vim sources.
"
" - This restores the older Vim rst.vim literal block behavior, which
"   recognizes a literal block starting on the line immediately after
"   the `::`, e.g.,
"
"      This used to be valid literal block syntax::
"        foo bar
"
"    This was changed recently (I assume to match that actual reST
"    spec) to require an intermediate blank line, e.g.,
"
"      This is what valid literal block syntax looks like::
"
"        foo bar
"
" - Use case: I use reST highlighting almost exclusively in Vim,
"   for notes. And while the *correct* (with blank line) syntax
"   looks nicer (yay for empty space!), sometimes I (ab)use the
"   feature when I'm trying to keep notes tighter (fewer lines)
"   or when trying to group related notes more... note-iceably.
"
" LATER/2021-03-25: Split this override out to its own plugin,
"                   or otherwise make this behavior opt-in'able.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

" Vim syntax file
" Language: reStructuredText documentation format
" Maintainer: Marshall Ward <marshall.ward@gmail.com>
" Previous Maintainer: Nikolai Weibull <now@bitwi.se>
" Website: https://github.com/marshallward/vim-restructuredtext
" Latest Revision: 2018-12-29
"  (lb): *and*:
" Latest Revision: 2020-03-31

if exists("b:current_syntax__relaxed_inclusive_literal_block")
  finish
endif

" (lb): Not sure this matters, but 'ensure nocompatible mode for the script'
"       (like the source script does).
let s:cpo_save = &cpo
" (lb): Reset cpo to its Vim default value. Ref: :help :set-&vim
set cpo&vim

" (lb): This is the former definition, from 2018-12-29, which I prefer for notes:
"
"  syn region  rstLiteralBlock         matchgroup=rstDelimiter
"       \ start='::\_s*\n\ze\z(\s\+\)' skip='^$' end='^\z1\@!'
"       \ contains=@NoSpell
"
" This is the latest definition, from 2020-03-31:
"
"  syn region  rstLiteralBlock         matchgroup=rstDelimiter
"        \ start='\(^\z(\s*\).*\)\@<=::\n\s*\n' skip='^\s*$' end='^\(\z1\s\+\)\@!'
"        \ contains=@NoSpell
"
" And then here's a little combination of both (update skip so that a line
" of only whitespace, but with fewer characters than the literal block
" indent, does not break the block).

syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\ze\z(\s\+\)' skip='^\s*$' end='^\z1\@!'
      \ contains=@NoSpell

let b:current_syntax = "rst"

let &cpo = s:cpo_save
unlet s:cpo_save

