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


