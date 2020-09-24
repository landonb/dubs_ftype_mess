" Opinionated Vim filetype (buffer setlocal) tweaks (syntax highlighting, etc.).
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Online: https://github.com/landonb/dubs_ftype_mess
" License: https://creativecommons.org/publicdomain/zero/1.0/

" ====================================================================
" In lieu of a bunch of small ~/.vim/ftplugin/*.vim files, this file!
" ====================================================================
" (Also to keep a bunch of not-so-DRY CxPx code together).

" FIXME/2020-02-27: Keep slitting this file to smaller ftplugin/ scripts.
" - See ftplugin/sh_dubsvim.vim, the first one, keep up the momentum!

" ====================================================================
" NOTE: This file is... Not Very Vim
"       See http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean, and
"         :help vimfiles, :help ftplugin-overrule, :help after-directory
"       I should use the ~/.vim/ftplugin directory and replace all the
"       autocmd's below with one file for each filetype... but a lot of
"       the changes for each filetype are similar, so having everything
"       here is probably easier to maintain.
" ====================================================================

" ========================================================================
" ------------------------------------------------------------------------
" ========================================================================

" Load this script just once
if exists("g:plugin_dubs_ftype_mess") || &cp
  finish
endif
let g:plugin_dubs_ftype_mess = 1

" ========================================================================
" ------------------------------------------------------------------------
" ========================================================================

" ------------------------------------------------------
" Abbreviation Helper: Consume trailing whitespace
" ------------------------------------------------------

" To trigger an abbreviation (replace some text with other text),
" one has to type a space or hit return after the abbreviation is
" typed, but this adds trailing whitespace to your abbreviation.
" Call Eatchar to consume this trailing whitespace.

" See :helpgrep Eatchar
func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
" E.g.,
"  iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

" ------------------------------------------------------
" Fix Syntax Highlighting (Always Parse from the Top)
" ------------------------------------------------------

" Sometimes -- especially w/ the Actionscript syntax
" highlighter -- files look like all-comments (the text is
" all pink) because the syntaxer started from the top of the
" window or thereabouts and not from the start of the buffer.

autocmd BufNewFile,BufRead * syntax sync fromstart

" ------------------------------------------------------
" Enable ~/.vim/ftplugin/<filetype>_<whatever>.vim
" ------------------------------------------------------

" By default, Vim doesn't load ftplugin/*.vim files.

filetype plugin on

" ------------------------------------------------------
" Search-under-cursor tweak.
" ------------------------------------------------------

" LATER/2020-02-27: This code came after the `autocmd BufRead *.sh`
" code that was moved to ftplugin/sh_dubsvim.vim, so I think it was
" related to an issue with Bash/shell filetypes. However the code was
" not part of the autocmd, so applied globally.
" - In any case, I looked at the latest syntax/sh.vim, and there's now
"   code therein that touches g:sh_noisk if the user has not set it.
"   So I'm trying without this enabled anymore, with the hopes of
"   LATER/2020-02-27: ... removing this code eventually.
"   - But for now, just disabled, should I have a problem in the near
"     future, so I can easily re-enable it.
if 0
  " 2016-11-29: When did this start happening? I think we I copied bash.vim
  " in dubs_ftype_mess/after/syntax/, periods starting getting sucked into
  " search-under-cursor.
  "   Wrong:
  "     iskeyword=@,48-57,_,192-255,.
  "   If we just set g:sh_noisk, bash.vim won't add . to the isk.
  if !exists("g:sh_noisk")
    let g:sh_noisk = 1
  endif
endif

" ========================================================================
" ------------------------------------------------------------------------
" ========================================================================

" ------------------------------------------------------
" Vim Highlighting
" ------------------------------------------------------

" Add special FIXME and NOTE comments w/ smart indenting to Python and Vim
" FIXME If you reformat w/ par, you lose your special formatting...
" ------------------------------------------------------
" Following are the original comments for the specified filetypes
"   for filetype=vim
"     comments=sO:" -,mO:"  ,eO:"",:"
"   You have to escape this string to set it, i.e.,
"     set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",:\"
autocmd BufRead *.vim set
  \ comments=sb:\"\ FIXME:,m:\"\ \ \ \ \ \ \ ,ex:\".,sb:\"\ NOTE:,m:\"\ \ \ \ \ \ ,ex:\".,sb:\"\ FIXME,m:\"\ \ \ \ \ \ ,ex:\".,sb:\"\ NOTE,m:\"\ \ \ \ \ ,ex:\".,sO:\"\ -,mO:\"\ \ ,eO:\"\",:\"
  \ formatoptions+=croql

" 2017-12-06: Suprised I hadn't been bothered by the octothorpe
" being included in '*' and <F1> searches...
"autocmd Filetype vim setlocal iskeyword=@,48-57,_,192-255,#
autocmd Filetype vim setlocal iskeyword=@,48-57,_,192-255

" ------------------------------------------------------
" DOSINI Behavior
" ------------------------------------------------------

" 2020-02-03: I find myself editing conf files more recently, and less json and yaml.
autocmd FileType dosini set
  \ comments=sb:#\ FIXME:,m:#\ \ \ \ \ \ \ ,ex:#.,sb:#\ NOTE:,m:#\ \ \ \ \ \ ,ex:#.,sb:#\ FIXME,m:#\ \ \ \ \ \ ,ex:#.,sb:#\ NOTE,m:#\ \ \ \ \ ,ex:#.,b:#
  \ formatoptions+=croql
  \ smartindent

" ------------------------------------------------------
" SQL Highlighting
" ------------------------------------------------------

"autocmd BufRead *.sql set
"  \ comments=sb:--\ FIXME:,m:--\ \ \ \ \ \ \ \ ,ex:--.,sb:--\ NOTE:,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--\ FIXME,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--\ NOTE,m:--\ \ \ \ \ \ ,ex:--.,s:/*\ FIXME:,m:*\ \ \ \ \ ,ex:*/,s:/*\ NOTE:,m:*\ \ \ \ ,ex:*/,:--,s:/*\ FIXME,m:*\ \ \ \ ,ex:*/,s:/*\ NOTE,m:*\ \ \ ,ex:*/,:--,s1:/*,mb:*,ex:*/
"  \ formatoptions+=croql
"  \ smartindent
" This one prefixes * to secondary lines in a /* */ comment:
" 2015.01.14: This line is redunant, isn't it? Commenting-out:
"autocmd BufRead *.sql set
"  \ comments=sb:--\ FIXME:,m:--\ \ \ \ \ \ \ \ ,ex:--.,sb:--\ NOTE:,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--\ FIXME,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--"\ NOTE,m:--\ \ \ \ \ \ ,ex:--.,s:/*\ FIXME:,m:*\ \ \ \ \ ,ex:*/,s:/*\ NOTE:,m:*\ \ \ \ ,ex:*/,s:/*\ FIXME,m:*\ \ \ \ ,ex:*/,s:/*\ NOTE,m:*"\ \ \ ,ex:*/,s1:/*,mb:*,ex:*/
"  \ formatoptions+=croql
"  \ smartindent
" The 'x' in 'ex' means you can type the trailing end-comment character on a
" new comment line to close the comment (and vim will fix the indent, too).
" But [lb] likes the cleaner look of seconday comment lines without asterisks.
" So 'ex' doesn't matter/work.
" 2013.03.26: [lb] finally fixed all the quirks with comments (not all of them
" worked right, and middle lines are ugly with asterisks) and also with
" indentkeys (pressing colon ':' would indent line, which was making writing
" FIXME:s annoying).
autocmd BufRead *.sql set
  \ comments=sb:--\ FIXME:,m:--\ \ \ \ \ \ \ \ ,ex:--.,sb:--\ NOTE:,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--\ FIXME,m:--\ \ \ \ \ \ \ ,ex:--.,sb:--\ NOTE,m:--\ \ \ \ \ \ ,ex:--.,sb:/*\ FIXME:,m:\ \ \ \ \ \ ,e:*/,sb:/*\ NOTE:,m:\ \ \ \ \ ,e:*/,sb:/*\ FIXME,m:\ \ \ \ \ ,e:*/,sb:/*\ NOTE,m:\ \ \ \ ,e:*/,s:/*,m:\ ,e:*/,s:--,m:--\ ,e:--
  \ formatoptions+=croql
  \ smartindent
  \ indentexpr=GetSQLIndent()
  \ indentkeys=!^F,o,O,=elif,=except,=~end,=~else,=~elseif,=~elsif,0=~when,0=)
"  \ indentkeys=!^F,o,O,<:>,=elif,=except,=~end,=~else,=~elseif,=~elsif,0=~when,0=)
"
" 2012.09.30: Trying to fix SQL autocommentindent so it doesn't use leader...
" fo-table
" c: Auto-wrap comments w/ textwidth; insert comment leader automatically.
" n: When formatting text, recognize numbered lists.
" 2: When formatting text, use the indent of the second line of a paragraph.
" NO: formatoptions-=c
" NO: formatoptions+=n2
" See: indentexpr=GetSQLIndent()
" :fu GetSQLIndent
" :echo exists("*GetSQLIndent")
" $ repoquery --list vim-common
" /usr/share/vim/vim73/indent/sqlanywhere.vim

" ------------------------------------------------------
" ActionScript/MXML/Flex Highlighting
" ------------------------------------------------------
" (No comment.)
" (Okay, one comment:)
" Specify comments and additional formatoptions
" so that writing comments is easier (Vim indents
" and adds the comment prefix).
" FIXME Mayhaps this belongs in the actionscript and
"       mxml syntax files?
" formatoptions:
"   c = Auto-wrap comments using textwidth, inserting comment leader
"   r = Automatically insert comment leader after <Enter> in Insert mode
"   o = Automatically insert comment leader after 'o' or 'O' in normal mode
"   q = Allow formatting of comments with "gq"
"       FIXME I have <F1> mapped to !par, so I probably don't care about q
"   l = Long lines are not broken in Insert mode (if already long when edited)
" NOTE The first two sb/m/ex force smart formatting of FIXME and NOTE
"      comments. I'm not quite sure this is the place for it, but it
"      works quite nicely.
" NOTE The funny ex://- is to get around a problem in Vim: if the string isn't
"      unique, Vim misinterprets our intention and then auto-commenting doesn't
"      work well. We could use a bunch of spaces (i.e., ex://\ \ \ \ \ \ \ ) to
"      make ex: unique, but then we can't kill our comment with a single
"      keystroke. So instead we make a bogus ex: so we can kill it with a dot.

" NOTE I tried to get //. to work w/ just :// but it's not having it. That is,
"          sb://,mb://,ex://.

autocmd BufRead *.as set
  \ filetype=actionscript
  \ comments=sb://\ FIXME:,m://\ \ \ \ \ \ \ \ ,ex://.,sb://\ NOTE:,m://\ \ \ \ \ \ \ ,ex://.,sb://\ FIXME,m://\ \ \ \ \ \ \ ,ex://.,sb://\ NOTE,m://\ \ \ \ \ \ ,ex://.,s:/*\ FIXME:,m:*\ \ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE:,m:*\ \ \ \ \ \ \ \ ,ex:*/,://,s:/*\ FIXME,m:*\ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE,m:*\ \ \ \ \ \ \ ,ex:*/,://,s1:/*,mb:**,ex:*/
  \ formatoptions+=croql
  \ smartindent
  \ indentexpr=
  \ indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except
" This is messing me up: XML indenting causes both lines to re-indent
"    indentexpr=XmlIndentGet(v:lnum,1)
autocmd BufRead *.mxml set
  \ filetype=mxml
  \ comments=sb://\ FIXME:,m://\ \ \ \ \ \ \ \ ,ex://.,sb://\ NOTE:,m://\ \ \ \ \ \ \ ,ex://.,sb://\ FIXME,m://\ \ \ \ \ \ \ ,ex://.,sb://\ NOTE,m://\ \ \ \ \ \ ,ex://.,s:/*\ FIXME:,m:*\ \ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE:,m:*\ \ \ \ \ \ \ \ ,ex:*/,://,s:/*\ FIXME,m:*\ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE,m:*\ \ \ \ \ \ \ ,ex:*/,sb:<!--\ FIXME:,m:\ \ \ \ \ \ \ \ \ \ \ \ ,ex:-->,sb:<!--\ NOTE:,m:\ \ \ \ \ \ \ \ \ \ \ ,ex:-->,sb:<!--\ FIXME,m:\ \ \ \ \ \ \ \ \ \ \ ,ex:-->,sb:<!--\ NOTE,m:\ \ \ \ \ \ \ \ \ \ ,ex:-->,://,s1:/*,mb:**,ex:*/,sb:<!--,m:\ \ \ \ \ ,ex:-->
  \ formatoptions+=croql
  \ smartindent
  \ indentexpr=MxmlIndentGet(v:lnum)
  \ indentkeys=o,O,<>>,{,}
" 2013.04.16: Added mxml indent fcn., which is the only way to fix mxml
" indenting... (is using a custom indent file). See:
"   /usr/share/vim/vim73/indent/python.vim
"   :h C-indenting
" [lb] notes, here's Vim's MXML default:
"  \ indentexpr=XmlIndentGet(v:lnum,1)
"  \ indentkeys=o,O,*<Return>,<>>,<<>,/,{,}
"
" MAYBE: Should we move mxml-indent.vim to to ~/.vim/indent?

" ------------------------------------------------------
" JavaScript
" ------------------------------------------------------
" See: JavaScript syntax : Better JavaScrirpt syntax support
"      http://www.vim.org/scripts/script.php?script_id=1491
"  installed at dubs_ftype_mess/syntax/javascript.vim

" The default JavaScript isk has an issue with colons, such that
" pressing F1 (or *) while the cursor is in a word followed by a
" colon, the search-on-word includes the colon, which really
" messes up the functionality of F1/*.
"   iskeyword=@,48-57,_,192-255,:
autocmd Filetype js setlocal iskeyword=@,48-57,_,192-255

" Spell check comments.
"autocmd BufEnter,BufRead *.js setlocal spell
" 2017-11-12: Argh. Too distracting. Or maybe I should change the highlight...
" FIXME/MAYBE/2017-11-12: <leader>s to toggle spell check??
"   I'd have to change all the autocmd's to not undo it. Or not.
autocmd BufEnter,BufRead *.js setlocal nospell
autocmd BufEnter,BufRead *.jsx setlocal nospell
" 2019-12-30: TypeScript (React).
autocmd BufEnter,BufRead *.tsx setlocal nospell

" 2016.01.25: What the heck? When did this start happening to bash, too?
" Ctrl-left/right-arrow is skipping periods
" I wonder if something... oh, wait, now it's not happening anymore....
"autocmd Filetype sh setlocal iskeyword=@,48-57,_,192-255,#

" 2016-05-30: For about the past week, JavaScript has been single-tab
"             undented closing braces. What gives! What happened?
"               :set indentexpr
"               indentexpr=GetVimIndent()
autocmd BufEnter,BufRead *.js setlocal indentexpr=

""autocmd BufEnter,BufRead *.js iabbrev <buffer> ";; if (true) { debugger; }<Home><Up><End><CR><C-O>0<C-O>D//<Down><End><CR><C-R>=Eatchar('\s')<CR>
"autocmd BufEnter,BufRead *.js iabbrev <buffer> ';'; if (true) { debugger; }<Home><Up><End><CR><C-O>0<C-O>D//<Down><End><CR><C-R>=Eatchar('\s')<CR>
" 2016-08-07: I was hoping to be able to delete to beginning of line,
" but whatever (with the <C-O>d<C-O>0, effectively nothing happens).
"autocmd BufEnter,BufRead *.js iabbrev <buffer> ';'; <C-O>d<C-O>0if (true) { debugger; }<Home><Right><Right><Right><Right><C-R>=Eatchar('\s')<CR>
" autocmd BufEnter,BufRead *.js,*.jsx,*.tsx iabbrev <buffer> ';'; if (true) { debugger; }<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><C-R>=Eatchar('\s')<CR>
autocmd BufEnter,BufRead *.js,*.jsx,*.tsx iabbrev <buffer> ';'; if (true) { debugger; /* eslint-disable-line no-debugger */ }<C-o>52<Left><C-R>=Eatchar('\s')<CR>

" autocmd BufEnter,BufRead *.js,*.jsx,*.tsx iabbrev <buffer> ';; console.log('');<Left><Left><Left><C-R>
autocmd BufEnter,BufRead *.js,*.jsx,*.tsx iabbrev <buffer> ';; console.log(''); // eslint-disable-line no-console<C-o>36<Left><C-R>

" 2020-09-24: See also ESLint `alert` warning disablement (I don't really use alert, so not wired).
"
"  autocmd BufEnter,BufRead *.js,*.jsx,*.tsx iabbrev <buffer> ';; alert(''); // eslint-disable-line no-alert<C-o>34<Left><C-R>

" Vim-surround JSX auto-commenter. In normal mode, to comment-out line: yss-
autocmd FileType javascript.jsx let b:surround_45 = "{/* \r */}"
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx

" In lieu of editing:
"   vim-jsx/ftdetect/javascript.vim
"     [2020-02-08 21:46: Note that vim-jsx deprecated and removed,
"      and replaced by vim-js and vim-jsx-pretty. See also new TS
"      syntax highlighter, yats.vim.
"      - Not sure how that affects this code!]
autocmd BufNewFile,BufRead *.tsx let b:jsx_ext_found = 1
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

" 2020-09-16: It's just a JSON file.
autocmd BufNewFile,BufRead *.eslintrc set ft=json

" 2020-09-16: Thanks!
"   https://gist.github.com/richardsonlima/fd42bf8f34ca4444cc828a34c8093f4c
" <Jenkinsfile VIM syntax highlighting>
autocmd BufNewFile,BufRead Jenkinsfile setf groovy

" ------------------------------------------------------
" CSS
" ------------------------------------------------------

" Default:
"  comments=s1:/*,mb:*,ex:*/

" This works better, I think:
"  comments=sl:/*\ ,mb:**,ex:*/

" But I think I still opt for none at all.

autocmd BufEnter,BufRead *.css set comments=

" Well, no to a comment-autocomplete, but yes to a comment alias.
" In spirit of the python 'set_trace' macro.

"autocmd BufEnter,BufRead *.css iabbrev <buffer> /// /*<CR>*/<CR>
"
" HAHA: Note: There are four *deliberate* trailing spaces hereafter:
"autocmd BufEnter,BufRead *.css iabbrev <buffer> // /*<CR><CR>*/<Up>
"
" Ug, nevermind, exo css is tab-delimited, so it almost makes more sense
" for user to type slash-slash-tab to start a comment.
"autocmd BufEnter,BufRead *.css iabbrev <buffer> // /*<CR><CR>*/<Up>
" UG: //<TAB> for some reason is ending up with two spaces in stead of tab...
"
" Darn, doesn't delete user's last char, just one from abbrev, duh!:
"autocmd BufEnter,BufRead *.css iabbrev <buffer> // /*<CR><CR>*/<Up><Tab><Backspace>
"
" Oh, whatever, typing slash-slash-space-backspace is still easier than
" make the stupid slash-star-return-return-star-slash-up-tab motion.
autocmd BufEnter,BufRead *.css iabbrev <buffer> // /*<CR><CR>*/<Up><Tab>

" ------------------------------------------------------
" Wikitext
" ------------------------------------------------------
" Because who doesn't love Jimmy Wales?
" Even his name is Super Sexy!
"autocmd BufRead *.wp set filetype=wp
autocmd BufRead,BufNewFile *.wiki setfiletype wikipedia
autocmd BufRead,BufNewFile *.wikipedia.org* setfiletype wikipedia
autocmd BufRead,BufNewFile *.wp setfiletype wikipedia

" ------------------------------------------------------
" Silver Searcher .agignore
" ------------------------------------------------------
autocmd BufRead,BufNewFile .agignore setfiletype conf
" All the tools coalesced around .ignore.
autocmd BufRead,BufNewFile .ignore setfiletype conf

" ------------------------------------------------------
" I have a little Gradle, I made it out of clay.
" ------------------------------------------------------
" Eh, good enough. Or maybe not. python looks okay except for comments.
"autocmd BufRead,BufNewFile *.gradle setfiletype python
" So `//` comments work:
autocmd BufRead,BufNewFile *.gradle setfiletype java

" ------------------------------------------------------
" Markdown Syntax
" ------------------------------------------------------
" http://daringfireball.net/projects/markdown/

augroup markdown
  au! BufRead,BufNewFile *.mkd setfiletype mkd
  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
  " Also map *.txt files, since you
  " love Markdown so much
  " au! BufRead,BufNewFile *.txt
  "   \ set nowrap sw=2 sts=2 ts=8
  "au BufRead,BufNewFile *.txt setfiletype mkd
  "autocmd BufRead *.txt set ai formatoptions=tcroqn2 comments=n:>
augroup END
"augroup mkd
"  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
"augroup END

" I keep waffling on this, but I can get used to
" naming my text files *.mkd, I suppose...
"au BufRead,BufNewFile *.txt setfiletype mkd

" Convert HTML link to Markdown link
" --------------------------------
" E.g.,
"   http://www.google.com/a/cpanel/domain/new
" becomes
"   [http://www.google.com/a/cpanel/domain/new](http://www.google.com/a/cpanel/domain/new)
noremap <Leader>l :let tmp=@/<CR>:s/\(http[s]\?:\/\/[^ \t()\[\]]\+\)/[\1](\1)/ge<CR>:let @/=tmp<CR>
" MAYBE: In Markdown, surround the link in angle
"        brackets does the same thing, e.g.,
"          <http://www.google.com/a/cpanel/domain/new>
"        So maybe \L adds brackets
"        and \l converts to
"          [](http://www.google.com/a/cpanel/domain/new)
"        and puts the cursor in the brackets
" MAYBE: There's also the [reference][ref-id] format

" ------------------------------------------------------
" NSIS Installer Script Syntax
" ------------------------------------------------------
" The Nullsoft Scriptable Installer System
" makes Windows .exe executables ('cause
" Windows isn't cool enough for gems).
" The defauft NSIS file extension is .nsi,
" but convention says to use .nsh for
" include (header?) files.
augroup nsis
  au BufRead,BufNewFile *.nsh setfiletype nsis
augroup END

" ------------------------------------------------------
" Mardown Markup
" ------------------------------------------------------
" 2015.06.09: Strange. You'd think this would be set already.
"autocmd BufRead,BufNewFile .md setfiletype markdown
" 2018-02-08: You'd think I'd've noticed the missing glob!
"   (Which goes to show: I almost never touch Markdown!
"   Long Live reST!)
autocmd BufRead,BufNewFile *.md setfiletype markdown
" 2018-02-08: Markdown Makefile!
autocmd BufRead,BufNewFile *.ronn setfiletype markdown

" ------------------------------------------------------
" Textile Markup
" ------------------------------------------------------

" Map the script function to a global :command
command! -bang -nargs=0 RenderTextileToHtml
  \ call <SID>RenderTextileToHtml('<bang>')

" Map the :command to <Leader>tt
noremap <silent> <Leader>tt
  \ :RenderTextileToHtml<CR>

" ------------------------------------------
" Private Interface for Textile
" ------------------------------------------

" LoadRedClothWrapper loads the textile.rb code,
" which is a wrapper around the RedCloth gem.
" NOTE RedClothWrapperLoaded is -1 until run the
"      first time, then it's either 0 or 1
"      depending on the outcome
let s:RedClothWrapperFile = "textile.rb"
let s:RedClothWrapperPath = ""
let s:RedClothWrapperLoaded = -1
function s:LoadRedClothWrapper()

  if -1 == s:RedClothWrapperLoaded
    " Load associated Ruby code for Textile.
    let s:rubyf = findfile(s:RedClothWrapperFile,
                           \ pathogen#split(&rtp)[0] . "/**")
    if s:rubyf != ''
      " Turn into a full path. See :h filename-modifiers
      let s:RedClothWrapperPath = fnamemodify(s:rubyf, ":p")
    elseif filereadable($HOME
                        \ . "/.vim/plugin/"
                        \ . s:RedClothWrapperFile)
      " $HOME/.vim is *nix
      let s:RedClothWrapperPath = $HOME
                                  \ . "/.vim/plugin/"
                                  \ . s:RedClothWrapperFile
    elseif filereadable($USERPROFILE
                        \ . "/vimfiles/plugin/"
                        \ . s:RedClothWrapperFile)
      " $HOME/vimfiles is Windows
      let s:RedClothWrapperPath = $USERPROFILE
                                  \ . "/vimfiles/plugin/"
                                  \ . s:RedClothWrapperFile
    elseif filereadable($VIMRUNTIME
                        \ . "/plugin/"
                        \ . s:RedClothWrapperFile)
      " $VIMRUNTIME for both *nix and Windows
      let s:RedClothWrapperPath = $VIMRUNTIME
                                  \ . "/plugin/"
                                  \ . s:RedClothWrapperFile
    endif
  endif

  if (-1 == s:RedClothWrapperLoaded)
      \ && !empty(s:RedClothWrapperPath)
    " TODO Since this is native Windows gVim
    "      and our Ruby environment is Cygwin,
    "      we can start to load the Ruby file,
    "      but it bombs on any 'requires',
    "      probably just 'cause the PATHs aren't
    "      set...
    "
    "      ... so this does not work:
    "
    "        rubyfile $RUBYREDCLOTHWRAPPER
    "
    "      Instead, we'll just know the file
    "      exists, and then, when the user runs
    "      the command, we'll just execute !ruby,
    "      rather than ruby
    let s:RedClothWrapperLoaded = 1
  else
    let s:RedClothWrapperLoaded = 0
    call confirm(
      \ "Unable to load Vim plugin file: \""
      \ . expand("%") . "\".\n\n"
      \ . "Cannot find Ruby RedCloth wrapper: \""
      \ . s:RedClothWrapperFile . "\".\n\n"
      \ . "Please place "
      \ . "\"" . s:RedClothWrapperFile . "\""
      \ . " in one of the plugin \n"
      \ . "directories -- you can use either the "
      \ .   "one in your \n"
      \ . "Vim home directory or the one in "
      \ .   "Vim's application \n"
      \ . "directory.")
  endif

endfunction

" RenderTextileToHtml renders the active buffer
" to a new HTML file. The name and path of the
" HTML are derived from the name and path of
" the active buffer, and the user is asked to
" confirm replacement of the HTML file if it
" already exists (though one can use a bang to
" force replacement without prompting).
function! s:RenderTextileToHtml(bang)

  " First things first, make sure the
  " RedCloth wrapper exists
  call <SID>LoadRedClothWrapper()

  if 1 == s:RedClothWrapperLoaded

    " Start by constructing the path of the HTML
    " output file.
    " NOTE Vim maps % to the current buffer's full
    "      path and filename when used in bang cmds
    "      or when expanded.
    let HtmlFile = substitute(
      \ expand("%"), "\.txt$", "\.htm", "")
    if HtmlFile == expand("%")
      let HtmlFile = substitute(
        \ expand("%"), "\.textile$", "\.htm", "")
    endif
    if HtmlFile == expand("%")
      let HtmlFile = expand("%") . ".htm"
    endif

    " Next, see if the HTML output file already
    " exists
    let ftype = getftype(HtmlFile)
    " ftype is non-empty if the item exists
    let confirmed = 1
    if ftype != ""
      if ftype != "file"
        echoerr "Cannot create Textile HTML file: "
          \ ."already exists and not a file: "
          \ . HtmlFile
        let confirmed = 0
      elseif a:bang == "!"
        echomsg "Overwriting existing HTML file"
          \ . ": " . HtmlFile
      else
        let choice = confirm(
          \ "Overwrite \"" . HtmlFile . "\"?",
          \ "&Yes\n&No\n&Cancel")
        if 1 != choice
          let confirmed = 0
        endif
      endif
    endif

    " Finally, make the ruby command and do it
    if 1 == confirmed
      " NOTE In a bang command, % gets expanded
      " NOTE Yes, that's a stdout > redirect
      execute "!ruby "
        \ . '"' . s:RedClothWrapperPath . '"'
        \ . " % > "
        \ . '"' . HtmlFile . '"'
    endif

  endif

endfunction

" ------------------------------------------------------
" What's a .map file?
" ------------------------------------------------------

autocmd BufRead *.map set
  \ filetype=python
  \ formatoptions+=croql

" ------------------------------------------------------
" Dockerfile 'tis of thee
" ------------------------------------------------------
autocmd BufRead,BufNewFile Dockerfile setfiletype conf

" ------------------------------------------------------
" Go can spell
" ------------------------------------------------------
autocmd BufRead,BufNewFile *.go setfiletype go
" Argh, I have it when it does that, all the quoted
" map keys get red squiggly underlined. Nuts to that.
" 2016-10-11: I add contains=@NoSpell to goString in syntax/go.vim.
autocmd BufEnter,BufRead *.go setlocal spell

autocmd BufEnter,BufRead *.go iabbrev <buffer> ';'; contract.Contract(false)<Left><C-R>=Eatchar('\s')<CR>

" ------------------------------------------------------
" Yaml don't spell
" ------------------------------------------------------
" 2016-10-18 Since when?
autocmd BufEnter,BufRead *.yaml setlocal nospell

" ------------------------------------------------------
" Go can comments
" ------------------------------------------------------
autocmd BufRead *.go set
  \ filetype=go
  \ comments=sb://\ FIXME:,m://\ \ \ \ \ \ \ \ ,ex://.,sb://\ NOTE:,m://\ \ \ \ \ \ \ ,ex://.,sb://\ FIXME,m://\ \ \ \ \ \ \ ,ex://.,sb://\ NOTE,m://\ \ \ \ \ \ ,ex://.,s:/*\ FIXME:,m:*\ \ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE:,m:*\ \ \ \ \ \ \ \ ,ex:*/,://,s:/*\ FIXME,m:*\ \ \ \ \ \ \ \ ,ex:*/,s:/*\ NOTE,m:*\ \ \ \ \ \ \ ,ex:*/,://,s1:/*,mb:**,ex:*/
  \ formatoptions+=croql
  \ smartindent
  \ indentexpr=
  \ indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except

" ------------------------------------------------------
" Ino has an itis
" ------------------------------------------------------
autocmd BufRead,BufNewFile *.ino setfiletype cpp
autocmd BufEnter,BufRead *.h setlocal spell
autocmd BufEnter,BufRead *.cpp setlocal spell

" ------------------------------------------------------
" To HJSON is Human.
" ------------------------------------------------------
" 2016-11-17: So, like, what the heck? Now setfiletype isn't sticking?
"autocmd BufRead,BufNewFile *.json setfiletype hjson
"autocmd BufRead,BufNewFile *.json setfiletype=hjson
autocmd BufRead,BufNewFile *.json set ft=hjson

autocmd BufEnter,BufRead *.hjson setlocal spell

" ------------------------------------------------------
" Stop: Re-indenting: Lines: When: I, <:>Colon<:>
" ------------------------------------------------------
" See:
"  :help cinkeys-format
"
" Sh Defaults:
"  indentexpr=GetShIndent()
"  indentkeys=0{,0},!^F,o,O,e,<:>,=elif,=except,0=then,0=do,0=else,0=elif,0=fi,0=esac,0=done,),0=;;,0=;&,0=fin,0=fil,0=fip,0=fir,0=fix
autocmd BufRead *.sh set indentkeys-=<:>
"
" Yaml Defaults:
"  indentexpr=GetYAMLIndent(v:lnum)
"  indentkeys=!^F,o,O,0#,0},0],<:>,-
autocmd BufRead *.yaml set indentkeys-=<:>

" ------------------------------------------------------
" Ruby on my mind.
" ------------------------------------------------------
autocmd BufEnter,BufRead *.rb,Rakefile iabbrev <buffer> ';'; require 'byebug' ; byebug if true<C-R>=Eatchar('\s')<CR>
" Alternative debugger; but no step capabilities.
"autocmd BufEnter,BufRead *.rb iabbrev <buffer> ';'; require 'pry' ; binding.pry if true<C-R>=Eatchar('\s')<CR>

" 2017-05-01: I find that most co-workers don't care about spelling. But I do!
autocmd BufEnter,BufRead *.rb setlocal spell

" ------------------------------------------------------
" Golang Templates
" ------------------------------------------------------
" 2017-03-28: [lb] swiped Go template syntax file from:
"  https://github.com/fatih/vim-go
" I don't think I need all the other fancy stuff that
" project offers.
autocmd BufRead,BufNewFile *.gotmpl setfiletype gotexttmpl
autocmd BufRead,BufNewFile *.gotpl setfiletype gotexttmpl
autocmd BufRead,BufNewFile *.tmpl setfiletype gotexttmpl

" ------------------------------------------------------
" VIM GPG/GPG2 DECRYPT/ENCRYPT PLUGIN [hits no metal]
" ------------------------------------------------------
" See:
"   /home/landonb/.vim/pack/jamessan/start/vim-gnupg/plugin/gnupg.vim
" 2018-01-24: Default to gpg2. For old 14.04 machine whose gpg is whack.
if (!exists("g:GPGExecutable"))
  if executable("gpg2")
    let g:GPGExecutable = "gpg2 --trust-model always"
  elseif executable("gpg")
    let g:GPGExecutable = "gpg --trust-model always"
  "else
  "  echom "GnuPG: No `gpg` or `gpg2"
  endif
endif
" Uncomment to see ``:messages``. Levels 1, 2, and 3.
"let g:GPGDebugLevel = 3

" ------------------------------------------------------
" Git ignore can ignore spelling mistakes!
" ------------------------------------------------------

" 2018-05-02: Do I really want to disable spell checking,
" or just enable for comments only?
"autocmd BufRead .gitignore setlocal nospell
"autocmd BufRead .gitignore.local setlocal nospell

" Not needed:
"   autocmd BufRead .gitignore setlocal nospell
autocmd BufRead .gitignore.local setfiletype conf
" 2019-01-12: Since when? A random .gitignore (nark's, no less!) not being filetype'd!
autocmd BufRead .gitignore setfiletype conf

" ------------------------------------------------------
" Fugitive Blame Buffers, too!
" ------------------------------------------------------

" 2020-08-07: Otherwise the hashes each have a red squiggly underline.

autocmd BufEnter,BufRead *.fugitiveblame setlocal nospell

" ------------------------------------------------------
" Git commit --verbose editing template should show spelling errors
" ------------------------------------------------------

autocmd FileType gitcommit set spell

" ------------------------------------------------------
" Tweak Spell Checking Capitalization Warning
" ------------------------------------------------------

" Tell SpellCap not to flag words following inline bangs
" or question marks. Ruby has methods like this! and let
" that? for which we don't want to trigger capitalization
" warnings.
"
" Default:
"   spellcapcheck=[.?!]\_[\])'"^I ]\+

set spellcapcheck=[.]\_[\])'"^I ]\+

" ------------------------------------------------------
" dirshenvy
" ------------------------------------------------------

autocmd BufRead,BufNewFile .envrc setfiletype sh

