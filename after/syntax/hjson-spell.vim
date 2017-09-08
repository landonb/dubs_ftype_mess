" Vim syntax file
" [lb] hjsonified from https://github.com/elzr/vim-json/blob/master/syntax/json.vim
" Language: HJSON
" Maintainer: Landon Bouma <landonb@retrosoft.com>
" Original Author: Eli Parra <eli@elzr.com>
" Last Change: 2017 Sep 08
" Version: 0.13
" License: MIT License. See end.

if !exists("main_syntax")
    if version < 600
        syntax clear
    elseif exists("b:current_syntax")
        finish
    endif
    let main_syntax = 'hjson'
endif

syntax match hjsonNoise /\%(:\|,\)/

" NOTE that for the concealing to work your conceallevel should be set to 2

" Syntax: Strings
" Separated into a match and region because a region by itself is always greedy
syn match hjsonStringMatch /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=hjsonString
if has('conceal')
    syn region hjsonString oneline matchgroup=hjsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ concealends contains=hjsonEscape,@Spell contained
else
    syn region hjsonString oneline matchgroup=hjsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=hjsonEscape,@Spell contained
endif

" Syntax: JSON does not allow strings with single quotes, unlike JavaScript.
" [lb]: Except that HJSON don't care. We disable hjsonStringSQError below.
syn region hjsonStringSQError oneline start=+'+ skip=+\\\\\|\\"+ end=+'+

" Syntax: JSON Keywords
" Separated into a match and region because a region by itself is always greedy
syn match hjsonKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=hjsonKeyword
if has('conceal')
    syn region hjsonKeyword matchgroup=hjsonQuote start=/"/ end=/"\ze[[:blank:]\r\n]*\:/ concealends contained
else
    syn region hjsonKeyword matchgroup=hjsonQuote start=/"/ end=/"\ze[[:blank:]\r\n]*\:/ contained
endif

" Syntax: Strings, Single-Quoted / Copy-pasted from above
" Separated into a match and region because a region by itself is always greedy
syn match hjsonStringMatch /'\([^']\|\\\'\)\+'\ze[[:blank:]\r\n]*[,}\]]/ contains=hjsonString
if has('conceal')
    syn region hjsonString oneline matchgroup=hjsonQuote start=/'/ skip=/\\\\\|\\'/ end=/'/ concealends contains=hjsonEscape contained
else
    syn region hjsonString oneline matchgroup=hjsonQuote start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=hjsonEscape contained
endif

" Syntax: JSON Keywords, Single-Quoted / Copy-pasted from above
" Separated into a match and region because a region by itself is always greedy
syn match hjsonKeywordMatch /'\([^']\|\\\'\)\+'[[:blank:]\r\n]*\:/ contains=hjsonKeyword
if has('conceal')
    syn region hjsonKeyword matchgroup=hjsonQuote start=/'/ end=/'\ze[[:blank:]\r\n]*\:/ concealends contained
else
    syn region hjsonKeyword matchgroup=hjsonQuote start=/'/ end=/'\ze[[:blank:]\r\n]*\:/ contained
endif

" Syntax: Escape sequences
syn match hjsonEscape "\\["\\/bfnrt]" contained
syn match hjsonEscape "\\u\x\{4}" contained

" Syntax: Numbers
syn match hjsonNumber "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>\ze[[:blank:]\r\n]*[,}\]]"

" ERROR WARNINGS **********************************************
if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
    " Syntax: Strings should always be enclosed with quotes.
    " [lb]: Except in HJSON. Disabled below.
    syn match hjsonNoQuotesError "\<[[:alpha:]][[:alnum:]]*\>"
    syn match hjsonTripleQuotesError /"""/

    " Syntax: An integer part of 0 followed by other digits is not allowed.
    syn match hjsonNumError "-\=\<0\d\.\d*\>"

    " Syntax: Decimals smaller than one should begin with 0 (so .1 should be 0.1).
    syn match hjsonNumError "\:\@<=[[:blank:]\r\n]*\zs\.\d\+"

    " Syntax: No comments in JSON, see http://stackoverflow.com/questions/244777/can-i-comment-a-json-file
    "syn match hjsonCommentError "//.*"
    "syn match hjsonCommentError "\(/\*\)\|\(\*/\)"
    " 2016-11-17: [lb] copied this from go.vim
    " Comments; their contents
    syn keyword hjsonTodo contained TODO FIXME XXX BUG
    syn cluster hjsonCommentGroup contains=goTodo
    syn region hjsonComment start="/\*" end="\*/" contains=@goCommentGroup,@Spell
    syn region hjsonComment start="//" end="$" contains=goGenerate,@goCommentGroup,@Spell

    hi def link hjsonComment Comment
    hi def link hjsonTodo Todo

    " Syntax: No semicolons in JSON
    syn match hjsonSemicolonError ";"

    " Syntax: No trailing comma after the last element of arrays or objects
    " [lb]: Disabled
    "syn match hjsonTrailingCommaError ",\_s*[}\]]"

    " Syntax: Watch out for missing commas between elements
    syn match hjsonMissingCommaError /\("\|\]\|\d\)\zs\_s\+\ze"/
    syn match hjsonMissingCommaError /\(\]\|\}\)\_s\+\ze"/ "arrays/objects as values
    syn match hjsonMissingCommaError /}\_s\+\ze{/ "objects as elements in an array
    syn match hjsonMissingCommaError /\(true\|false\)\_s\+\ze"/ "true/false as value
endif

" 2016-11-17: [lb] copied this from go.vim
" included from: https://github.com/athom/more-colorful.vim/blob/master/after/syntax/go.vim
"
" Comments; their contents
syn keyword hjsonTodo contained NOTE
hi def link hjsonTodo Todo

" ********************************************** END OF ERROR WARNINGS
" Allowances for JSONP: function call at the beginning of the file,
" parenthesis and semicolon at the end.
" Function name validation based on
" http://stackoverflow.com/questions/2008279/validate-a-javascript-function-name/2008444#2008444
syn match hjsonPadding "\%^[[:blank:]\r\n]*[_$[:alpha:]][_$[:alnum:]]*[[:blank:]\r\n]*("
syn match hjsonPadding ");[[:blank:]\r\n]*\%$"

" Syntax: Boolean
syn match hjsonBoolean /\(true\|false\)\(\_s\+\ze"\)\@!/

" Syntax: Null
syn keyword hjsonNull null

" Syntax: Braces
syn region hjsonFold matchgroup=hjsonBraces start="{" end=/}\(\_s\+\ze\("\|{\)\)\@!/ transparent fold
syn region hjsonFold matchgroup=hjsonBraces start="\[" end=/]\(\_s\+\ze"\)\@!/ transparent fold

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_json_syn_inits")
    if version < 508
        let did_json_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
      HiLink hjsonPadding Operator
      HiLink hjsonString String
      HiLink hjsonTest Label
      HiLink hjsonEscape Special
      HiLink hjsonNumber Number
      HiLink hjsonBraces Delimiter
      HiLink hjsonNull Function
      HiLink hjsonBoolean Boolean
      HiLink hjsonKeyword Label

    if (!exists("g:vim_json_warnings") || g:vim_json_warnings==1)
        HiLink hjsonNumError Error
        "HiLink hjsonCommentError Error
        HiLink hjsonSemicolonError Error
        " [lb]: Disabled
        "HiLink hjsonTrailingCommaError Error
        HiLink hjsonMissingCommaError Error
        " [lb]: Disabled
        "HiLink hjsonStringSQError Error
        " [lb]: Disabled
        "HiLink hjsonNoQuotesError Error
        HiLink hjsonTripleQuotesError Error
    endif
    HiLink hjsonQuote Quote
    HiLink hjsonNoise Noise
    delcommand HiLink
endif

let b:current_syntax = "hjson"
if main_syntax == 'hjson'
    unlet main_syntax
endif

" MIT License
" Copyright (c) 2013, Jeroen Ruigrok van der Werven, Eli Parra
"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
"THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

