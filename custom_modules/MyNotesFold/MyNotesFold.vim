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
    set filetype=MyNotes
    source ~/.vim/syntax/MyNotes.vim
    :setlocal foldexpr=Aux()
    :setlocal foldmethod=expr
endf

" runs MyNotesFold function if the file has !MyNotes at the top
function! CheckIfRunMyNotesFold()
    if getline(1)=~'\v\s*!MyNotes\s*'
        call MyNotesFold()
        call feedkeys("zm")
    endif
endf

augroup MyNotesFold
    autocmd FileType text :call CheckIfRunMyNotesFold()
augroup END
