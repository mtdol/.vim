"================================
"THESE ARE MY CUSTOM VIM EDITS
"================================

"Clear Existing Autogroups -----{{{

" this is to avoid importing the same autocommands over and over
" again when this vimrc is reloaded
augroup indentation
    autocmd!
augroup END

augroup folding
    autocmd!
augroup END

augroup braces
    autocmd!
augroup END

augroup debugStatements
    autocmd!
augroup END

augroup Netrw
    autocmd!
augroup END


"}}}
"Plugins -----{{{
" allows unix man pages to be read within vim (on unix system)
" additionally <s-k> can be used to search up a term by going outside
" of vim
runtime ftplugin/man.vim

"}}}
"Sanity Settings -----{{{

" make vim not poopy, ie. disable vi compatibility mode
set nocompatible
set showmode
set showcmd
set ruler
" autocompletion on the command line
set wildmenu
" show all possible matches in command line when tab is hit
set wildmode=list:full
" distance of cursor to edge of screen before screen moves
set scrolloff=3
" sane backspace
set backspace=indent,eol,start
" disable modelines, modelines can misinterpret text in a file as a command
set nomodeline
" don't delete buffers from buffer list when their windows are closed
set hidden

" cause Netrw buffers to be closable
augroup Netrw
    autocmd FileType netrw setl bufhidden=wipe
augroup END

"}}}
"Search Functionality -----{{{

" makes searching work as in other regex engines
" ie, there is no need to escape the + or | characters
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" all searches case agnostic by default
" equivalent to starting a search with \c
" use \C at the beginning of a search string for case sensitive
set ignorecase
" if any uppercase characters are used then case sensitive
set smartcase
" shows matches as they are found
set incsearch
" highlight search matches
set hlsearch

" do not highlight searches upon entering the file
noh
"}}}
"Encodings and Language -----{{{

set encoding=utf-8
set fileencoding=utf-8

set spelllang=en_us

"}}}
"Display and Audio Settings -----{{{

if has("gui_running")
    let g:color = "desert"
else
    let g:color = "blue"
endif

let g:barColor = 8
let g:guiBarColor = "#222222"
let g:backGroundStyle = "dark"

syntax on
exec "colorscheme ".g:color
set number
set relativenumber
" faster screen
set ttyfast

" wrap lines
set wrap

" highlight the current line
:set cul


" draws the screen in my prefered format
function! DrawScreenMyWay(...)
    let g:color = a:0 >= 1 ? a:1 : g:color
    " the second argument will either be the console color or the gui color
    " depending on whether console or gui vim is running
    if has ("gui_running")
        let g:guiBarColor = a:0 >= 2 ? a:2 : g:guiBarColor
    else
        let g:barColor = a:0 >= 2 ? a:2 : g:barColor
    endif

    exec "colorscheme ".g:color

    if has ("gui_running")
        " highlights the columns to the right of 80"
        let &colorcolumn=join(range(81,999),",")"
    else
        " highlights the 81st column
        set colorcolumn=81
    endif
    " set background
    let background = g:backGroundStyle
    " using this color; change ctermbg to change the color of the highlight"
    exec "highlight ColorColumn ctermbg=".g:barColor." guibg=".g:guiBarColor
endf

call DrawScreenMyWay()


" display statusline
" make statusline mandatory
set laststatus=2
" statusline settings
set statusline=b%n\ \ %-4l\ %-3c\ %t\ %y%m\ %3p%%

" turn off the annoying beeping and flashing
set vb t_vb=



"}}}
"Tab Functionality -----{{{

"Tabstop is the width of an actual tab character. Press <C-v><Tab> to
"enter an actual tab character (especially useful if tab softtabstop != 0 and/or
"expandtab is true)
"
"softtabstop is the the width of a 'simulated' tab character.
"If this option is set (if it is not zero) then tab will use
"a mixture of spaces and tabs to indent the line. If expandtab is set
"then only spaces will be used
"
"shiftwidth is the size of a tab character for operations such as > in visual
"mode 
"
"expandtab causes vim to add spaces instead of tab characters when
"the tab key is pressed
"
"smarttab inserts a shiftwidth amount of space before a line, and
"uses tabstop or softtabstop elsewhere in the line
"
set tabstop=8 softtabstop=4 expandtab shiftwidth=4

"File type sensitive indentation
augroup indentation
    autocmd FileType Ruby :setlocal softtabstop=2 shiftwidth=2
augroup END

"indent to the same level of the previous line"
set autoindent


"allows tab functionality to be changed locally (buffer) on the fly
function! SetTabFunctionality(...)
    let tabVal = a:0 >= 1 ? a:1 : 4
    let expandTab = a:0 >= 2 ? a:1 : 1
    let hardTabVal = a:0 >= 3 ? a:1 : 8

    if expandTab ==# 1
        let &l:tabstop=hardTabVal
        let &l:softtabstop=tabVal
        setlocal expandtab
        let &l:shiftwidth=tabVal
    else
        let &l:tabstop=tabVal
        setlocal softtabstop=0
        setlocal noexpandtab
        let &l:shiftwidth=tabVal
    endif
endf

"Displays the values of the most important indentation variables for the
"current buffer
function! DisplayTabSettings()
    exec 'echo "expandtab:"'.&l:expandtab
    exec 'echo "tabstop:"'.&l:tabstop
    exec 'echo "softtabstop:"'.&l:softtabstop
    exec 'echo "shiftwidth:"'.&l:shiftwidth
    exec 'echo "smarttab:"'.&l:smarttab
endf

"}}}
"Folding -----{{{
"Special folding functions ---{{{2


function! MarkdownLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "=" 
    else
        return ">" . len(h)
    endif
endf

"}}}2
"General Folding ---{{{2

" limit syntax folding to just one level
set foldnestmax=1

" start unfolded by default, press zm (zM) or zc to refold;
" zc will restore the existing fold settings, and zm will refold all
set nofoldenable

augroup folding 
    " enable folding in vim files (such as this one) using 3 {
    autocmd FileType vim setlocal foldmethod=marker

    " various file types that should support syntax folding
    autocmd FileType C setlocal foldmethod=syntax
    autocmd FileType Python setlocal foldmethod=syntax
    autocmd FileType Java setlocal foldmethod=syntax

    autocmd FileType Markdown setlocal foldexpr=MarkdownLevel() foldmethod=expr

    " this is intended to prevent screwy syntax highlighting 
    " particularly when scrolling up and down a buffer, long strings will fail
    " to highlight properly.
    "
    " The minlines argument speeds up the syntax analysis at the potential cost
    " of multiline constructs not rendering properly
    autocmd BufEnter * :syntax sync minlines=7

    " keeps the syntax analysis from failing when it takes a while to load
    set redrawtime=10000

    " limits the number of columns that will be used in syntax highlighting
    " computations
    set synmaxcol=130
augroup END

"}}}2
"}}}
"File Save Behavior -----{{{

" backs up files, undos, and stores swp files in this directory
" IMPORTANT: change these directories if being used on a new computer
set backupdir=~/.vim/vimbackups/backups//,.
set directory=~/.vim/vimbackups/swaps//,.
set undodir=~/.vim/vimbackups/undos//,.
set undofile
set backup

" Prevent backups from overwriting each other. The naming is weird,
" since I'm using the 'backupext' variable to append the path.
" So the file '/home/docwhat/_vimrc' becomes '_vimrc%home%docwhat~'

" if you want to add a time stamp to each backup add strftime("%Y-%m-%d-%H.%M.%S")
" to the file scheme above.
" if you do this however, remember to clean out the directory every once
"and a while

" NO TIMESTAMP:
autocmd BufWritePre * let &backupext ='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'),  ':', '', 'g').'~'

" TIMESTAMP:
" autocmd BufWritePre * let &backupext ='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'),  ':', '', 'g').'%%'.strftime("%Y-%m-%d-%H.%M.%S").'~'

"}}}
"Gui Functionality -----{{{

" These settings are for use in a vim gui window not terminal vim
" Also note that "set vb t_vb=" has to be set in _gvimrc as well

if has("gui_running")
    " set the display font
    set guifont=consolas:h11
    " set the size of the vim window
    set lines=32 columns=100

    " turn off unnecessary gui options
    " also allows normal use of tab key in gui vim
    " turn off menubar
    set guioptions -=m
    " turn off icon menubar
    set guioptions -=T
endif

"}}}
"Macros -----{{{
"Key readjustments -----{{{2

" remap leader key
nnoremap <space> <Nop>
let mapleader = " "

" in insert mode <c-b> acts like a leader key
inoremap <c-b> <nop>

" make alt work right on different terminals
set <M-h>=h
set <M-j>=j
set <M-k>=k
set <M-l>=l

"}}}2
"Function Keys and Critical Mappings ---{{{2
"<F1> ---{{{3
" enable easy toggling of relative numbers
nnoremap <F1> :set relativenumber!<cr>

" also allow toggling of cursor highlighting
nnoremap <leader><F1> :set cul!<cr>
"}}}3
"<F2> ---{{{3
" allow easy toggling of spell mode
nnoremap <F2> <esc>:set spell!<cr>
"}}}3
"<F3> ---{{{3
" allows the toggling of the highlighting of tabs
let g:tabsAreHighlighted = 0
syntax match Tab /\t/
function! ToggleTabHighlighting()
    if g:tabsAreHighlighted ==# 0
        hi Tab gui=underline guifg=blue ctermbg=blue
        echom "Enabling Tab Highlighting"
        let g:tabsAreHighlighted = 1
    else
        hi clear
        echom "Disabling Tab Highlighting"
        let g:tabsAreHighlighted = 0
        " redraw screen in case of unwanted highlight changes
        call DrawScreenMyWay()
    endif
endf
nnoremap <F3> :call ToggleTabHighlighting()<cr>
"}}}
"<F4> ---{{{3
" displays all custom functions in this vimrc and followed by a call option
" NOTE: that this list must be updated as new custom functions are added to
" this vimrc
function! DisplayCustomFunctions()
    echom "1: DisplayTabSettings"
    echom "2: DrawScreenMyWay"
    echom "3: MyNotesFold"
    echom "4: SetTabFunctionality"
    echom "5: ToggleTabHighlighting"
    echom ""
endf
" allow easy number selection
function! SelectCustomFunctions(choice)
    if a:choice ==# 1
        let res = 'DisplayTabSettings'
    elseif a:choice ==# 2
        let res = 'DrawScreenMyWay'
    elseif a:choice ==# 3
        let res = 'MyNotesFold'
    elseif a:choice ==# 4
        let res = 'SetTabFunctionality'
    elseif a:choice ==# 5
        let res = 'ToggleTabHighlighting'
    endif
    let res = res.'()'
    call feedkeys(':call '.res."\<left>")
endf

nnoremap <F4> :call DisplayCustomFunctions()<cr>:call SelectCustomFunctions()<left>
"}}}3
"<F5> ---{{{3
" grab the data from the quick_locations file in the .vim directory
let g:freqLocations = readfile(expand('~/.vim/quick_locations.txt'))
" ensure that we only grab lines that match the syntax "label":path
" and are not comments
call filter(g:freqLocations, 'v:val !~ "^#.*$" && v:val =~ "\\v^\".+\":.+$"')

" display frequent locations
function! DisplayFrequentLocations()
    for i in range(0, len(g:freqLocations)-1)
        echom i+1 . ': ' . split(g:freqLocations[i], '"')[0]
    endfor
    echom ""
endf

" places the frequent location directory as a command for the user
function! SelectFrequentLocations(choice)
    if a:choice <=# len(g:freqLocations) && a:choice >#0 
        let res = split(g:freqLocations[a:choice - 1], '":')[1]
        let feed = ':edit '.res
        call feedkeys(feed)
    endif
endf

nnoremap <F5> :call DisplayFrequentLocations()<cr>:call SelectFrequentLocations()<left>
"}}}3
"<F12> ---{{{3
" allows easy editing of this vimrc
nnoremap <F12> :edit $MYVIMRC<cr>
" allows easy resourcing of the vimrc
nnoremap <leader><F12> :source $MYVIMRC<cr>
" opens the vimrc in a new tab
nnoremap -<F12> :tabe $MYVIMRC<cr>
"}}}3
"}}}2
"General Mappings ---{{{2

" allows screen movement regardless of cursor in insert mode
" makes j and k act like <c-e> and <c-y>
" also allows h and l to scroll faster
" press gl to activate, press gl or <esc> in normal mode to deactivate
let g:ScrollEnabled = 0
function! ToggleScrollMode()
  if g:ScrollEnabled == 0
      nnoremap j <c-e>
      nnoremap k <c-y>
      nnoremap h 3<c-e>
      nnoremap l 3<c-y>
      nnoremap <esc> :call ToggleScrollMode()<cr>
      nnoremap i :call ToggleScrollMode()<cr>
      nnoremap a :call ToggleScrollMode()<cr>
      nnoremap I :call ToggleScrollMode()<cr>
      nnoremap A :call ToggleScrollMode()<cr>
      nnoremap o :call ToggleScrollMode()<cr>
      nnoremap O :call ToggleScrollMode()<cr>
      let g:ScrollEnabled = 1
      echom "-- ScrollMode Enabled --"
  else
      nunmap j
      nunmap k
      nunmap h
      nunmap l
      nunmap <esc>
      nunmap i
      nunmap a
      nunmap I
      nunmap A
      nunmap o
      nunmap O
      let g:ScrollEnabled = 0
      echom "-- ScrollMode Disabled --"
  endif
endf
nnoremap gl :call ToggleScrollMode()<cr>

" speedier movement
nnoremap <c-l> w
nnoremap <c-h> b
nnoremap <c-j> 3j
nnoremap <c-k> 3k
vnoremap <c-l> w
vnoremap <c-h> b
vnoremap <c-j> 3j
vnoremap <c-k> 3k
" speedier line wrap movement
nnoremap g<c-j> 3gj
nnoremap g<c-k> 3gk
vnoremap g<c-j> 3gj
vnoremap g<c-k> 3gk

inoremap <c-backspace> <c-w>

" allow easy movement with hjkl in insert mode
inoremap <M-h> <left>
inoremap <M-j> <down>
inoremap <M-k> <up>
inoremap <M-l> <right>

" allows easy movement one space over using <c-g>
inoremap <c-g><c-l> <right>
inoremap <c-g>l <right>
inoremap <c-g><c-h> <left>
inoremap <c-g>h <left>

" places cursor between these constructs
inoremap () ()<esc>i
inoremap [] []<esc>i
inoremap {} {}<esc>i
inoremap "" ""<esc>i
inoremap '' ''<esc>i

" add an additional mapping for the escape key
inoremap kj <esc>

" exit insert mode without heading left (except for end of line)
inoremap <c-f> <esc><right>

" allows easier buffer searching
nnoremap <leader>l :ls<cr>:b

" allows easier writing
nnoremap <leader>w :write<cr>

" allows easy access to the plus buffer
nnoremap <leader><leader> "+
vnoremap <leader><leader> "+

" cycle through buffers
nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprev<cr>
" alternative version
nnoremap g<tab> :bprev<cr>

" allow the clearing of a previous search's highlighting
"nnoremap <leader>h :noh<cr> 

" toggles the display of search highlighting, but causes a new search
" to re-enable highlighting
nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" easier text replacement
nnoremap <leader>s :%s///gc<left><left><left><left>

" allows newlines to be added in normal mode, while staying in normal mode
nnoremap <leader>o mqo<esc>`q
nnoremap <leader>O mqO<esc>`q

" funtions like o, but leaves you in normal mode
nnoremap <c-f>o o<esc>
nnoremap <c-f>O O<esc>

" adds a semicolon to end of line then returns to same spot
nnoremap <leader>; mqA;<esc>`q
" also works in insert mode
inoremap <c-b>; <esc>mqA;<esc>`q<right>i

" wraps the selected visual area in quotes or parens
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`><right><right>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>`><right><right>
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>`><right><right>
vnoremap <leader>) <esc>`>a)<esc>`<i(<esc>`><right><right>

" uses s(for i) and S(for a) to insert a single character at the cursor
function! RepeatChar(char, count)
  return repeat(a:char, a:count)
endf
nnoremap s :<c-u>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<cr>
nnoremap S :<c-u>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<cr>

" inserts braces while in insert mode
inoremap <c-b>b <esc>$a<space>{<cr>}<esc>O<tab>
" language specific
augroup braces
    " python: inserts the parens and the colon at the end
    autocmd FileType python :inoremap <buffer> <c-b>b ():<esc>hi
    " Csharp
    autocmd BufNewFile,BufRead *.cs :inoremap <buffer> <c-b>b <esc>$a<enter>{<cr>}<esc>O<tab>
augroup END

" places //DEBUG
inoremap <c-b>d //DEBUG<cr>//DEBUG<esc>O
augroup debugStatements
   autocmd FileType python :inoremap <c-b>d #DEBUG<cr>#DEBUG<esc>O
augroup END

" allows the use of <c-f>w and <c-f>b to move forwards and backwards
" in a camelCase word, also <c-f>e to go to the end of the current word
"
" explanation: /> is match new word, /<Bar> is pipe for regex, /u is next
" capital letter
"
" Bugs: using in visual mode with a backwards expanding selection
" will not work properly.
" Also cannot use numbers right now.
" Also <c-f>e will not go to the end if at the end of the line
nnoremap <silent><c-f>w :call search('\>\<Bar>\u', '')<cr>
nnoremap <silent><c-f>b :call search('\>\<Bar>\u', 'b')<cr>
nnoremap <silent><c-f>e <right>:call search('\>\<Bar>\u\<Bar>\$', '')<cr><left>
onoremap <silent><c-f>w :call search('\>\<Bar>\u', '')<cr>
onoremap <silent><c-f>b :call search('\>\<Bar>\u', 'b')<cr>
onoremap <silent><c-f>e <right>:call search('\>\<Bar>\u', '')<cr><left>
vnoremap <silent><c-f>w <esc>:call search('\>\<Bar>\u', '')<cr>mqv`<o
vnoremap <silent><c-f>b <esc>:call search('\>\<Bar>\u', 'b')<cr>v`<o
vnoremap <silent><c-f>e <esc><right>:call search('\>\<Bar>\u', '')<cr>mqv`<o<left>

"}}}2
"}}}
"Unix Settings -----{{{
" these are settings that are intended to be used primarily on unix enviroments

" find files and populate the quickfix list
" use :FindFile <file name> <location> to call this
fun! FindFiles(filename, loc)
  let error_file = tempname()
  silent exe '!find '.a:loc.' -name "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file
  set errorformat=%f:%l:%m
  exe "cfile ". error_file
  copen
  call delete(error_file)
endfun
command! -nargs=+ FindFile call FindFiles(<f-args>)

"}}}

"{{{------Source Custom Modules
source ~/.vim/custom_modules/MyNotesFold/MyNotesFold.vim
"}}}
"{{{ ------Source Vim Code Unique to this System
source ~/.vim/vimrc_exceptions.vim
"}}}
