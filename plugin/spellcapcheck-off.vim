" Disables spellcapcheck. With an overexplanation why.
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/dubs_ftype_mess#🧹
" License: https://creativecommons.org/publicdomain/zero/1.0/

" -----------------------------------------------------------------------------
" Spell-checking Capitalization... is 'So Very Broken!' so turn it *Off*.
"                                  〰                   ⁉⁉
" -----------------------------------------------------------------------------

" 2014-11-20: Words after an ellipsis are flagged as not capitalized.
"             E.g., after the dot-dot-dot in 'blah... blah', the second
"             'blah' is undercurled, to show that it is not capitalized.
"
" 2021-08-16: I dug into this more, thinking I could solve it with regex,
"             but Vim does not support me. This is backed up by the few
"             search results I found online, none of which had a working
"             solution.
"
"             Furthermore, the following investigation shows that getting
"             spellcapcheck to match after an ellipses is not supported.
"             (tl;dr, Vim does not run enough of the word ending against
"             the spellcapcheck pattern to make the match we desire).
"
" - First, let's examine the default spellcapcheck value.
"
"   Disable the code at the bottom of this file and restart Vim with the default
"   value, and print it to a new buffer using TabMessage (from `dubs_edit_juice`):
"
"     :TabMessage set spellcapcheck
"
"   I captured the following value:
"
"     spellcapcheck=[.?!]\_[\])'"^I ]\+
"
"   Which is similar to the default value documented by `:h spellcapcheck`:
"
"     spellcapcheck="[.?!]\_[\])'" \t]\+"
"
"   And matches what I see in source:
"
"     (char_u *)"[.?!]\\_[\\])'\"	 ]\\+"
"
" - To set the default value from command mode, escape it profoundly:
"
"     :set spellcapcheck=[.?!]\\_[\\])\'\"^\t\ ]\\+
"
" - I edited the default value and added a negative look-behind to try to
"   not match after an ellipsis. But try as I might, I couldn't get it to
"   work. In fact, the following value makes the setting not work at all,
"   such that no spell-cap errors are indicated:
"
"     set spellcapcheck=\(\.\.\)\@<![.?!]\\_[\\])\'\"^\t\ ]\\+
"
" - I also tried a much simpler match to see if I could get something sorta
"   working. I replaced the [.?!] with a simple ASCII 'o' to try to get the
"   'bar' in 'foo bar' to match. But that doesn't work either:
"
"     set spellcapcheck=o\\_[\\])\'\"^\t\ ]\\+
"
" - But this works, to match the 'bar' in 'Foo) bar':
"
"     set spellcapcheck=)\\_[\\])\'\"^\t\ ]\\+
"
" - Also this works, which I think holds the key:
"
"     set spellcapcheck=.\\_[\\])\'\"^\t\ ]\\+
"
"   The last pattern matches any lowercase word following a punctuation
"   character and one or more spaces, but it doesn't match any lowercase
"   word that follows another word.
"
" - And if you change the bare dot, which matches any character, to an
"   escaped dot, so it only matches a period, e.g.,:
"
"     set spellcapcheck=\\.\\_[\\])\'\"^\t\ ]\\+
"
"   then only lowercase words following a period are matched.
"
" - But the moment you add two dots — \\.\\. — the whole pattern fails
"   to match anything.
"
" - This suggests to me (without actually reading the C source code to
"   confirm) that Vim is only comparing the last punctuation character
"   it sees up until the next lowercase word.
"
"   So what I've been trying to do *is impossible*.
"
" In any case, I've had this option disabled since 2014, and I don't miss
" it, so stick with the easy (best) solution — just disable it altogether.

set spellcapcheck=

" A few after-thoughts:
"
" - You could write your own syntax rule to highlight spell-cap errors.
"
"   And if you wanted to mimic the spellcapcheck highlight, use SpellCap:
"
"     SpellCap xxx term=reverse cterm=undercurl ctermbg=12 gui=undercurl guibg=#2E3440 guisp=#EBCB8B
"
" - If you wanted to try something someone else already cooked up, consider:
"
"     https://github.com/iamcco/coc-spell-checker
"
"   (Note that I have not tried and so nor do I endorse this plugin, but I am
"    a fan of Conqueror of Completion (https://github.com/neoclide/coc.nvim)
"    and I'd assume, given the 'coc' prefix, that it's somehow related, so it
"    is probably worth a sniff. That is, if you really wanted spell-cap checks.
"    But I don't care. Which is saying something, given that I've gone to all
"    this trouble trying to get it to work, and then wasted my valuable time
"    documenting it. But I do love a challenge. And I don't like mysteries.)

