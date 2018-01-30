" Vim syntax file
" Language: reStructuredText documentation format
" Maintainer: Marshall Ward <marshall.ward@gmail.com>
" Previous Maintainer: Nikolai Weibull <now@bitwi.se>
" Website: https://github.com/marshallward/vim-restructuredtext
" Latest Revision: 2017-02-18

" 2017-12-08: See the reST syntax file included with Vim:
"   /srv/opt/bin/share/vim/vim80/syntax/rst.vim
" And the more current upstream source of the same:
"   https://github.com/marshallward/vim-restructuredtext

if exists("b:current_syntaxXXX")
  finish
endif

" reST header syntax can use any of the 32 punctation keys found on a US keyboard:
"
"   ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
"
" The documentation recommends using a subset of those, because "some characters
" are more suitable than others":
"
"   = - ` : . ' " ~ ^ _ * + #
"
" Omitted from included rst syntax runtime:
"
"   ! $ % & ( ) , / ; < > ? @ [ \ ] { | }
"
" Although I'd respond that that's really user preference, and that the syntax
" plugin should honor what reST itself honors. (I'd concede this might not be
" the case if certain punctuation is used in a way that's not for headerizing,
" but that might be interpreted as such, e.g., a merge conflict uses angle
" brackets in such a way:
"
"   <<<<<<<<<<<<<<
"   some code
"   ==============
"   other code
"   >>>>>>>>>>>>>>
"
" and we wouldn't want any of this to be interpreted as headerization.
" (But such code would most likely be in a block quote, anyway.)
"
" I'm adding in the missing punctuation and we'll see how it goes.
"
" (What I really want is a few more 'Big' symbols that'll look good
" as the main, top-level section. I currently use '#', which is the
" character that uses the most ink of all available characters. But
" I think '$', '@', and '&' could also work to convey main-sectionness.)

syn clear rstSections

" NOTE: `-` must come last so it is not interpreted as range.
"
" NOTE: `+` does not highlight when used both below and above,
"             because it's interpreted as rstTableLines.
"
" This adds the missing punctuation: !@$%&()[]{}<>/\|,;?
"
syn match rstSections "\v^%(([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\1+\n)?.{1,2}\n([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\2+$" contains=@Spell
syn match rstSections "\v^%(([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\1{2,}\n)?.{3,}\n([=`:.'"~^_*+#!@$%&()[\]{}<>/\\|,;?-])\2{2,}$" contains=@Spell

" +----------------------------------------------------------------------+

" 2018-01-30: NUTS!
"
"   This is pretty cool. And it only serves one purpose:
"     Making me color-happy when reSTing.
"   That is, if I repeat the same character 8 or more times
"     on its own line, it'll be highlighted!
"   You can fiddle with the highlights for specific characters
"     below.
"   In this way, you can create more visually appealing reST
"     documents, and you can more easily highlight section
"     headers, as well as section delimiters!

" - Our match interferes with rstSections, whether it's defined before or
"   after, and I'm not sure what's up, so only highlight when HR is followed
"   by newlines, to avoid conflict.
"   - (And note that `\n\n` sorta works, but the highlight only works if
"      there are two trailing blank lines; whereas using just `\n` works,
"      but then the top line of a real section header gets hijack-highlighted
"      (the top line of the header should be rstSections like the header
"      title and the bottom line of the header, but instead the top line
"      gets a rstFakeHRAll match).
"
" - Note that the captured (.) character \1 matches case-insensitively.
"   - E.g., `e` will match `E`, so
"       EEeeeeEEEEEEeee
"     will match.
"   - There's probably a way to match case-sensitively but meh.
"
" Match lines with the same character repeating 8 or more times,
" with optional preceding and trailing whitespace.
syn match   rstFakeHRAll            '\n\s*\(.\)\1\{8,}\s*\n$'
" Match lines of repeating `|`s.
syn match   rstFakeHRPipes          '\n\s*|\{8,}\s*\n$'
" Match lines of repeating `$`s.
syn match   rstFakeHRBills          '\n\s*\$\{8,}\s*\n$'
" Match lines of repeating `*`s.
syn match   rstFakeHRStars          '\n\s*\*\{8,}\s*\n$'
" Match lines of repeating `(`s or `)`s.
syn match   rstFakeHRParns          '\n\s*[()]\{8,}\s*\n$'
" Match lines of repeating `%`s.
syn match   rstFakeHRPercs          '\n\s*%\{8,}\s*\n$'

" Orange-yellow: Statement, or Keyword
hi! def link rstFakeHRAll           Statement
" More orangy (darker than orange-yellow)
hi! def link rstFakeHRStars         Delimiter
" Light pinkish-orangish-reddish
hi! def link rstFakeHRPercs         String
" Green: Type, or Question
hi! def link rstFakeHRPipes         Question
" White on baby blue
hi! def link rstFakeHRParns         MatchParen
" Black on baby blue
hi def rstHorizRuleUser01 term=reverse guibg=DarkCyan guifg=Black ctermfg=1 ctermbg=6
hi! def link rstFakeHRBills         rstHorizRuleUser01

