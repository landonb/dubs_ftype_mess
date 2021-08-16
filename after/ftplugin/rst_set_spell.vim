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

" [lb] tested spell checking for obviously-texty files,
" like txt and log, but there's too much of a mix
" of English and non-dictionary tokens. Only reST seems
" to work, especially since spell check ignores ``literals``.

autocmd BufEnter,BufRead *.rst setlocal spell

" Note that I tried a variation on the command,
"
"   autocmd Filetype rst setlocal spell
"
" but for some reason when I switched buffers to a code file, spell checking
" was still enabled. You could get over that with the above command,
"
"   autocmd BufEnter,BufRead *.rst setlocal spell

" -----------------------------------------------------------------------------
" Spell Checking cAPITALIZATION
" -----------------------------------------------------------------------------

" 2014.11.20: on 'blah... blah', the latter blah is underlined blue, indicating
" it's not capitalized. How would you fix the spellcapcheck to be okay with
" that?
"
" There are two ways to disable caps checking: changing the spellcapcheck
" variable,
"
"   set spellcapcheck=
"
" or disabling the highlight:
"
"   highlight clear SpellCap
"
" You can copy the default spellcapcheck using TabMessage:
"
"   :TabMessage set spellcapcheck spellcapcheck=[.?!]\_[\])'"^I ]\+
"
" And you can easily peruse the list of over 1,000 highlights similary:
"
"   :TabMessage hi
"
" There are five highlights with the word 'spell' in their name:
"
"   SpellBad xxx term=reverse ctermbg=12 gui=undercurl guisp=Red SpellCap xxx
"   term=reverse ctermbg=9 gui=undercurl guisp=Blue SpellRare xxx term=reverse
"   ctermbg=13 gui=undercurl guisp=Magenta SpellLocal xxx term=underline
"   ctermbg=11 gui=undercurl guisp=DarkCyan hl-SpellCap xxx cleared

autocmd BufEnter,BufRead *.rst setlocal spellcapcheck=

