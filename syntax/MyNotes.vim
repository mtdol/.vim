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

" highlight the earlier definitions
hi def link headerText Todo
hi def link enderText Todo
hi def link definitionKey Statement
hi def link importantWords Comment

let b:current_syntax = "MyNotes"
