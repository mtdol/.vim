" Vim syntax file
" Language: My Notes Format

if exists("b:current_syntax")
    finish
endif

" section headers
syn match headerText '\v(^\s*)@<=\S.*(::[0-9]?\s*$)@='
" section enders
syn match enderText '\v(^\s*)@<=/:[0-9](.*$)@='

" matches a term defined as 'term :-'
" matches only the 'term' part not the ' :-' part
syn match definitionKey '\v(^\s*)@<=\S.*(\s:\-\s*$)@='

" match keywords for important information
syn match importantWords '\v\CNote:|NOTE:|Important:|IMPORTANT:|Remember:|REMEMBER:|Todo:|TODO:'

" the markers of a list element such as '. ' or '23. ' or '.. ' for an indented
" list
" ie.
" . Main idea
"   .. Sub idea
"       1... Sub Sub idea1
"       2... Sub Sub idea2
"   .. Another Sub idea
syn match listSegmentHeader '\v(^\s*)@<=\d*\.+\s(\S.*$)@='

" highlight the earlier definitions
hi def link headerText Underlined
hi def link enderText Underlined
hi def link definitionKey Statement
hi def link importantWords Comment
hi def link listSegmentHeader Statement

let b:current_syntax = "MyNotes"
