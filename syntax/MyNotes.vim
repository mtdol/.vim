" Vim syntax file
" Language: My Notes Format

if exists("b:current_syntax")
    finish
endif

" when set to 1, runs intensive matching, when 0 does not
" 0 is better for performance
let intensive = 1

" section headers
syn match headerText '\v(^\s*)@<=\S.*(::[0-9]?\s*$)@='
" section enders
syn match enderText '\v(^\s*)@<=/:[0-9](.*$)@='

" matches a term defined as 'term :-'
" matches only the 'term' part not the ' :-' part
syn match definitionKey '\v(^\s*)@<=\S.*(\s:\-.*$)@='

" match keywords for important information
syn match importantWords '\v\CNote:|Important:|Remember:|Todo:'
syn match urgentWords '\v\CNOTE:?|IMPORTANT:?|REMEMBER:?|TODO:?'

" the markers of a list element such as '. ' or '23. ' or '.. ' for an indented
" list
" ie.
" . Main idea
"   .. Sub idea
"       1... Sub Sub idea1
"       2... Sub Sub idea2
"   .. Another Sub idea
syn match listSegmentHeader '\v(^\s*)@<=\d*\.+\s(\S.*$)@='
" similar to above but accepts a colon instead of a dot and requires a number
syn match listSegmentHeader '\v(^\s*)@<=\d+:+\s(\S.*$)@='

" import performance heavy regexes
if (intensive)

" These two regexes are the same except for being one char different.
" The first matches lines that have arbitrary whitespace and then '-', the other '*'
" Both of these essentially keep going until they hit another keyword or a blank line
" Additionally the label can be ended with a space followed by '-' or '*' 
" at the end of the line: 
" '-' for - lists and '*' for * lists.
"syn match dashLine '\v(^\s*\-+\s)@<=\_.{-}%(%(\n\s*\n)@=|%(%$)@=|%(^\s*\d*[\*\.\-\:]+\s+)@=|%(^.+:-.*$)@=|%(^.+::[0-9]?\s*$)@=|%(^\s*/:\d+.*$)@=|%(\s-+$)@=|%(^\s*\S.*[^\:]:$)@=)'
" same as above, but with *
"syn match starLine '\v(^\s*\*+\s)@<=\_.{-}%(%(\n\s*\n)@=|%(%$)@=|%(^\s*\d*[\*\.\-\:]+\s+)@=|%(^.+:-.*$)@=|%(^.+::[0-9]?\s*$)@=|%(^\s*/:\d+.*$)@=|%(\s\*+$)@=|%(^\s*\S.*[^\:]:$)@=)'

" matches the left side of expressions like 'leftside:' where
" there is no space after the colon
"syn match colonLeft '\v%(^\s*)@<=\S{-}.*[^\:]:$'

" matches a line that starts with one or more of '-', '*', '~', '!'
syn match dashLine '\v%(^\s*\-+\s)@<=.*$'
syn match starLine '\v%(^\s*\*+\s)@<=.*$'
syn match tildeLine '\v%(^\s*\~+\s)@<=.*$'
syn match bangLine '\v%(^\s*\!+\s)@<=.*$'

" allows highlighting of quoted lines (start with >>)
syn match quoteLine '\v%(^\s*\>{2,}\s)@<=.*$'

endif

" highlight the earlier definitions
hi def link headerText Underlined
hi def link enderText Underlined
hi def link definitionKey Statement
hi def link importantWords Comment
hi def link urgentWords Todo
hi def link listSegmentHeader Statement
hi def link dashLine Identifier
hi def link starLine Constant
hi def link tildeLine PreProc
hi def link bangLine Todo
hi def link quoteLine Special

let b:current_syntax = "MyNotes"
