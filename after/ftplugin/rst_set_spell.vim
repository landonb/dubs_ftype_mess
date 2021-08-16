" Vim help filetype plugin: Enable spell checking on reST docs.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/dubs_ftype_mess#🧹
" Revision: 2021-08-16
" License: GPLv3

" Optional: Set g: variable to disable plugin from ever loading. But leave
"           b: variable alone, to prevent plugin from re-running on :edit.
if exists("g:no_vim_syntax_rst_set_spell") || exists("b:did_vim_syntax_rst_set_spell")
  finish
endif

let b:did_vim_syntax_rst_set_spell = 1

" ------------------------------------------------------
" Spell Checking! [sic]
" ------------------------------------------------------

setlocal spell

" -----------------------------------------------------------------------------
" Spell Checking cAPITALIZATION
" -----------------------------------------------------------------------------

" 2014-11-20: Writing the text, 'blah... blah', the latter 'blah' is
"             undercurled, to indicate that it is not capitalized.
"
" 2021-08-16: Updated investigation follows:
"
" - The highlight is controlled by the SpellCap highlight, e.g.,
"
"     SpellCap xxx term=reverse cterm=undercurl ctermbg=12 gui=undercurl guibg=#2E3440 guisp=#EBCB8B
"
"   (Open a reST document and run `:TabMessage hi` to see the (long) list of highlights.)
"
"   A naive approach might be to remove the highlight, e.g.,
"
"     highlight clear SpellCap
"
" - A more appropriate solution is to tweak or clear the spellcapcheck rule, e.g.,
"
"     set spellcapcheck=
"
" - You can use TabMessage to grab a copy of the current spellcapcheck value, e.g.,
"
"     :TabMessage set spellcapcheck
"
"   For a reST file I had open, I saw the value:
"
"     spellcapcheck=[.?!]\_[\])'"^I ]\+
"
"   Which is similar to the default value documented by `:h spellcapcheck`:
"
"     spellcapcheck="[.?!]\_[\])'" \t]\+"
"
"   To set again, escape it profoundly:
"
"     set spellcapcheck=[.?!]\\_[\\])\'\"^\t\ ]\\+
"
"   But try as I might, I couldn't get a negative look-behind to work, e.g.,
"
"     set spellcapcheck=\(\.\.\.\)\@<![.?!]\\_[\\])\'\"^\t\ ]\\+
"
"   I even tried a regular 'o' to try to get the 'bar' in 'foo bar'
"   highlighted, but this didn't work:
"
"     set spellcapcheck=o\\_[\\])\'\"^\t\ ]\\+
"
"   But I've had this option disabled since 2014, and I don't miss it,
"   so stick with the easy solution — just disable it altogether.

setlocal spellcapcheck=

