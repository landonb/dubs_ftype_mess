" Opinionated Vim filetype (buffer setlocal) tweaks (syntax highlighting, etc.).
" Author: Landon Bouma <https://tallybark.com/>
" Online: https://github.com/landonb/dubs_ftype_mess#🧹
" License: https://creativecommons.org/publicdomain/zero/1.0/

" CXREF:
" /Applications/MacVim.app/Contents/Resources/vim/runtime/syntax/vim.vim

" USAGE: I don't appreciate that vim highlights "comment strings" specially.
" - It's distracting to me, especially when you have commented key sequences,
"   for example, this snippet:
"     " How it works:
"     " "zyw yanks into the z register to start of next word
"     :map <F1> b"zyw:echo 'h ' .. @z .. ''
"   Where the first line's comment leader is not highlighted,
"   but both double quotes on the second line are highlighed.
"   As another example:
"     " This comment leader is not highlighted.
"     " " But here you see both comment leaders are highlighted.
"     " Also this half of the sentence " if it contains a double quote.
"     " " Or this " word " and this " word ", both words are highlighted,
"     " and all double quotes on the previous line are highlighted.

" Default: hi def link vimCommentString	vimString
hi! link vimCommentString vimLineComment
" vimCommentTitle is also applied sometimes, but that's the same
" highlight group as `" TITLE: ...` comments... (maybe this is a
" losing battle).
"  hi! link vimCommentTitle vimLineComment

