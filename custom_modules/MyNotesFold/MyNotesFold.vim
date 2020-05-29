" A special note folding scheme for .txt files that feature
" !MyNotes on the first line

augroup MyNotesFold
    autocmd!
augroup END

" this is for notes files of the form HEADER::
" ::2 marks the start of section 2 and /:2 marks the end
" :: with no number simply will go downwards until it sees another :: line
function! MyNotesFold() 
    function! Aux()
        if getline(v:lnum)=~'\v^.+::\s*$'
            return '>1'
        elseif getline(v:lnum+1)=~'\v^.+::\s*$'
            return '<1'
        elseif getline(v:lnum)=~'\v^.+::1\s*$'
            return '>1'
        elseif getline(v:lnum)=~'\v^\s*/:1.*$'
            return '<1'
        elseif getline(v:lnum)=~'\v^.+::2\s*$'
            return '>2'
        elseif getline(v:lnum)=~'\v^\s*/:2.*$'
            return '<2'
        elseif getline(v:lnum)=~'\v^.+::3\s*$'
            return '>3'
        elseif getline(v:lnum)=~'\v^\s*/:3.*$'
            return '<3'
        elseif getline(v:lnum)=~'\v^.+::4\s*$'
            return '>4'
        elseif getline(v:lnum)=~'\v^\s*/:4.*$'
            return '<4'
        elseif getline(v:lnum)=~'\v^.+::5\s*$'
            return '>5'
        elseif getline(v:lnum)=~'\v^\s*/:5.*$'
            return '<5'
        else
            return '='
        endif
    endf
    :setlocal foldexpr=Aux()
    :setlocal foldmethod=expr
endf

" runs MyNotesFold function if the file has !MyNotes at the top, or the user
" specifies to force the run
function! RunMyNotesFold(intensive = 1)

    set filetype=MyNotes
    source ~/.vim/syntax/MyNotes.vim
    call MyNotesFold()
    call feedkeys("zm")

    " don't load intensive matches if specified
    if a:intensive == 0
        syn clear dashLine 
        syn clear starLine 
        syn clear tildeLine
        syn clear bangLine 
    endif
endf

function! CheckIfMyNotes()
    return getline(1)=~'\v\C^\s*!MyNotes\s*$'
endf


" changes settings that usually slow down this filetype, and make buffer specific
" mappings
function! ApplyMyNotesOptimizations()
    setl nocul 
    setl norelativenumber

    " 1:: will now autocomplete to ::1 /:1
    inoreabbrev <buffer> 1:: <left>::1<cr><cr>/:1<up>
    inoreabbrev <buffer> 2:: <left>::2<cr><cr>/:2<up>
    inoreabbrev <buffer> 3:: <left>::3<cr><cr>/:3<up>
    inoreabbrev <buffer> 4:: <left>::4<cr><cr>/:4<up>
    inoreabbrev <buffer> 5:: <left>::5<cr><cr>/:5<up>
endf

augroup MyNotesFold
    autocmd FileType text :if CheckIfMyNotes() | call RunMyNotesFold() | call ApplyMyNotesOptimizations() | endif
augroup END
