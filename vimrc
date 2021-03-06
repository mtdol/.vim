"================================
"THESE ARE MY CUSTOM VIM SETTINGS
"================================

" Run Local Presets {{{
" Source code local to this machine
source ~/.vim/pre_vimrc_exceptions.vim
" }}}
"Clear Existing Autogroups and Reset Defaults -----{{{
" resets every global mapping to its default
"mapclear

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

augroup saveFunctionality
    autocmd!
augroup END

augroup GuiSettings
    autocmd!
augroup END

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

" keep vim from "helpfully" inserting newlines into your text
set formatoptions-=tc

" the time until a ambigous mapping resolves
set timeoutlen=1000
" the time until a escape key on the terminal is resolved
" If this is set to high then a press of the escape key might not work when
" followed by other keypresses.
set ttimeoutlen=25

" This loads the file "ftplugin.vim" in 'runtimepath'.
filetype plugin indent on

" disable annoying autoindenting with # in powershell
augroup indentation
    autocmd FileType ps1 setl nocindent smartindent | inoremap <buffer> # X<c-h>#
augroup END

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

"}}}
"Plugin Settings {{{
" Startup {{{2
" does basic bookkeeping for plugins
"
" figure out which plugins are active
let s:enabledPluginsRaw = readfile(expand('$HOME/.vim/enabled_plugins.txt'))
call filter(s:enabledPluginsRaw, 'v:val !~ ''\v^\s*#'' && v:val =~ ''\v^\s*%(\S+)\s+%(\d)\s*$''')

let g:enabledPlugins = {}
for item in s:enabledPluginsRaw
    " gets the plugin name
    let k = matchstr(item, '\v^%(\s*)@<=\S+%(\s+\d+\s*$)@=') 
    " gets the plugin state
    let v = matchstr(item, '\v^{-}%(\s*\S+\s+)@<=\d+%(\s*$)@=') 
    " add to dictionary
    let g:enabledPlugins[k] = v
endfor

" checks for command line overide of enabled plugins
if exists('g:Cli_Plugs')
    for item in split(g:Cli_Plugs, ' ') 
        if len(item) !=# 0 && item =~ '\v\S+:[01]'
            let kv = split(item, ':')
            let g:enabledPlugins[kv[0]] = kv[1]
        endif
    endfor
endif

" }}}2
"Man.vim {{{2
" allows unix man pages to be read within vim (on unix system)
" additionally <s-k> can be used to search up a term by going outside
" of vim
runtime ftplugin/man.vim
"}}}2
"Netrw {{{2
" starts netrw without the banner by default
let g:netrw_banner=0

" cause Netrw buffers to be closable
augroup Netrw
    autocmd!
    autocmd FileType netrw setl bufhidden=wipe
augroup END
"}}}2
"Syntastic {{{2
if g:enabledPlugins['syntastic'] ==# 1
"Plugin 'vim-syntastic/syntastic'
set rtp+=~/.vim/bundle/syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" when enabled causes syntastic to check files when first loaded and when saving
let g:syntastic_check_on_open = 1

let g:syntastic_check_on_wq = 0

" causes syntastic to not start up until asked
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

" pops open syntastic
nnoremap <c-w>e :SyntasticCheck<CR>
nnoremap <c-w><c-e> :SyntasticCheck<CR>
" resets (hides)
nnoremap <leader><c-w>e :SyntasticReset<CR>
nnoremap <leader><c-w><c-e> :SyntasticReset<CR>

endif
"}}}2
"NERDTree {{{2
if g:enabledPlugins['nerdtree'] ==# 1
"Plugin 'scrooloose/nerdtree'
set rtp+=~/.vim/bundle/nerdtree
" open and close nerdtree on demand

nnoremap <silent> <c-w><c-\> :NERDTreeToggle<cr>
nnoremap <silent> <c-w>\ :NERDTreeToggle<cr>

endif
"}}}2
"buffergator {{{2
if g:enabledPlugins['vim_buffergator'] ==# 1
"Plugin 'jeetsukumaran/vim-buffergator'
set rtp+=~/.vim/bundle/vim-buffergator

" causes the window not to expand when the plugin is opened
let g:buffergator_autoexpand_on_split=0

" sort by most recently used
let g:buffergator_sort_regime="mru"

" display files with their parent directory
let g:buffergator_display_regime="parentdir"

" keeps the plugin from remapping keys on its own
let g:buffergator_suppress_keymaps=1

" now provide our own mappings
nnoremap <silent> <leader>b :BuffergatorToggle<cr>
nnoremap <silent> <leader>B :BuffergatorTabsToggle<cr>

endif
"}}}2
" EasyMotion {{{2
if g:enabledPlugins['vim_easymotion'] ==# 1
"Plugin 'easymotion/vim-easymotion'
set rtp+=~/.vim/bundle/vim-easymotion

" keep the cursor on the same line when using easymode jk
let g:EasyMotion_startofline = 0

" Use capital letters when displaying locations
" NOTE: Doesn't seem to work as of 2020/5/13
"let g:EasyMotion_use_upper = 1

" Use smart case for searches
let g:EasyMotion_smartcase = 1

" change the prefix key used in the bindings
map , <Plug>(easymotion-prefix)

" search only on one line
nmap <leader>f <Plug>(easymotion-sl)
xmap <leader>f <Plug>(easymotion-sl)
omap <leader>f <Plug>(easymotion-sl)

" search over the whole file without looking into other windows
nmap <leader>,s <Plug>(easymotion-s)
xmap <leader>,s <Plug>(easymotion-s)
omap <leader>,s <Plug>(easymotion-s)

" allow overwin motions
nmap ,s <Plug>(easymotion-overwin-f)
xmap ,s <Plug>(easymotion-bd-f)
omap ,s <Plug>(easymotion-bd-f)

" allow double char search
nmap <Leader>s <Plug>(easymotion-overwin-f2)
xmap <Leader>s <Plug>(easymotion-bd-f2)
omap <Leader>s <Plug>(easymotion-bd-f2)

" allow j and k to be used to go to the beginning and ends of lines
map ,J <Plug>(easymotion-sol-j)
map ,K <Plug>(easymotion-sol-k)
map ,<c-j> <Plug>(easymotion-eol-j)
map ,<c-k> <Plug>(easymotion-eol-k)

" allow sn mapping as well
nmap <leader><leader>s <Plug>(easymotion-sn)
xmap <leader><leader>s <Plug>(easymotion-sn)
omap <leader><leader>s <Plug>(easymotion-sn)

endif
"}}}2
" NerdCommenter {{{2
if g:enabledPlugins['nerdcommenter'] ==# 1
"Plugin 'ddollar/nerdcommenter'
set rtp+=~/.vim/bundle/nerdcommenter

endif
" }}}2
" CtrlSpace {{{2
if g:enabledPlugins['vim_ctrlspace'] ==# 1
"Plugin 'vim-ctrlspace/vim-ctrlspace'
set rtp+=~/.vim/bundle/vim-ctrlspace

" allow alternate access to the plugin if <c-space> doesn't work
nnoremap <silent> <leader><leader>b :CtrlSpace<cr>

endif
" }}}2
" YouCompleteMe {{{2
if g:enabledPlugins['YouCompleteMe'] ==# 1
"Plugin 'valloric/youcompleteme'
set rtp+=~/.vim/bundle/youcompleteme

" syntastic has to be disabled for java when using ycm
if g:enabledPlugins['syntastic'] ==# 1
    let g:syntastic_java_checkers = []
endif

" disable documentation display on cursor hover
" Note: read up on this, 0 isn't a good value
"let g:ycm_auto_hover = 0

" instead allow this to be activated with a mapping
nnoremap <leader>di <plug>(YCMHover)


" allow language identifiers to be seeded from the language's syntax file
let g:ycm_seed_identifiers_with_syntax = 1

" if 1: closes the preview window after a preview is completed
let g:ycm_autoclose_preview_window_after_completion = 0

" the keys that are used to go backwards in the completion menu
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

" these keys will close the completion menu
let g:ycm_key_list_stop_completion = ['<C-y>']

" the key used to invoke the completion menu
" By default it is <C-Space>
"let g:ycm_key_invoke_completion = '<C-Space>'


" the black list for ycm: filetypes in this list will be ignored by ycm
  let g:ycm_filetype_blacklist = {
        \ 'tagbar': 1,
        \ 'notes': 1,
        \ 'markdown': 1,
        \ 'netrw': 1,
        \ 'unite': 1,
        \ 'text': 1,
        \ 'vimwiki': 1,
        \ 'pandoc': 1,
        \ 'infolog': 1,
        \ 'leaderf': 1,
        \ 'mail': 1
        \}


" allow refactoring easily
cnoreabbrev ymrf YcmCompleter RefactorRename 

" most mappings involve <leader like key>d, so we will clear it
nmap <leader>d <nop>

nnoremap <silent> <leader>dd :YcmShowDetailedDiagnostic<cr>
let g:ycm_key_detailed_diagnostics = '<leader>dd'
nnoremap <silent> <leader>dr :YcmCompleter GoToReferences<cr>
nnoremap <silent> <leader>df :YcmCompleter FixIt<cr>
nnoremap <silent> <leader>dF :YcmCompleter Format<cr>
nnoremap <leader><leader>dr :YcmCompleter RefactorRename 

" opens goto but in different window styles
nnoremap <silent> <leader>dg :YcmCompleter GoToImprecise<cr>
nnoremap <silent> <leader><leader>dg :YcmCompleter GoTo<cr>

" go to the declaration
nnoremap <leader>dn :YcmCompleter GoToDeclaration<cr>
" the goto command currently tries to find a definition within a file,
" while this command will always try to find the definition
nnoremap <leader><leader>dn :YcmCompleter GoToDefinition<cr>


" open the documentation for the item under the cursor
" this one doesn't recompile the code
nnoremap <leader>dD :YcmCompleter GetDocImprecise<cr>
" this one does
nnoremap <leader><leader>dD :YcmCompleter GetDoc<cr>

" finds the type of the object under the cursor
nnoremap <leader>dt :YcmCompleter GetTypeImprecise<cr>
nnoremap <leader><leader>dt :YcmCompleter GetType<cr>


" allow enabling and disabling of ycm auto typing\
" turn off YCM
nnoremap <leader>do :let g:ycm_auto_trigger=0<CR>
" turn on YCM
nnoremap <leader>dO :let g:ycm_auto_trigger=1<CR>

" restart the ycm server
nnoremap <leader>dR :YcmRestartServer<CR>

" force recompilation and diagnostics
nnoremap <leader>dc :YcmForceCompileAndDiagnostics<CR>

endif
" }}}2
" fzf {{{2
if g:enabledPlugins['fzf'] ==# 1
set rtp+=~/.vim/bundle/fzf

endif
" }}}2
" CamelCaseMotion {{{2
if g:enabledPlugins['CamelCaseMotion'] ==# 1
set rtp+=~/.vim/bundle/CamelCaseMotion

let g:camelcasemotion_key = '<tab>'


endif
" }}}2
" scrollmode {{{2
if g:enabledPlugins['scrollmode'] ==# 1
set rtp+=~/.vim/bundle/scrollmode

" let g:ScrollMode_ExitScrollModeKeys = [
"     \ "<esc>",
"     \ "i",
"     \ "I",
"     \ "A",
"     \ "o",
"     \ "z",
" \]

" " keys to use for scrolling when scroll mode is active
" let g:ScrollMode_ScrollUpKeys = ["k"]
" let g:ScrollMode_ScrollDownKeys = ["j","e"]
" let g:ScrollMode_ScrollUpHardKeys = ["l"]
" let g:ScrollMode_ScrollDownHardKeys = ["h","p"]

" let g:ScrollMode_UpScrollSpeed = 5
" let g:ScrollMode_DownScrollSpeed = 1
" let g:ScrollMode_UpHardScrollSpeed = 1
" let g:ScrollMode_DownHardScrollSpeed = 9

endif
" }}}2
"}}}
"Search Functionality -----{{{

" makes all characters searched have literal value except backslash (\)
nnoremap / /\V
vnoremap / /\V
nnoremap ? ?\V
vnoremap ? ?\V

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


" allow the clearing of a previous search's highlighting
"nnoremap <leader>h :noh<cr> 

" toggles the display of search highlighting, but causes a new search
" to re-enable highlighting
nnoremap <silent><expr> <leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" easier text replacement
nnoremap \s :%s/\V//gc<left><left><left><left>

" same as above but uses "/ register for faster entry
nnoremap <leader>\s :%s/<c-r>///gc<left><left><left>

" selects the word under the cursor without jumping
nnoremap <leader>* :keepjumps normal! mq*`q<cr>

" allows the content under the cursor in visual mode to be searched
vnoremap // y/\V<c-r>=escape(@",'/\')<cr><cr>
" same as above but does not jump forwards
vmap <leader>// mq//`q
" also allows backwards search
vnoremap ?/ y?\V<c-r>=escape(@",'/\')<cr><cr>
"}}}
"Encodings and Language -----{{{

set encoding=utf-8
set fileencoding=utf-8

set spelllang=en_us

"}}}
"Display and Audio Settings -----{{{

if has("gui_running")
    let g:currentColor = "evening"
else
    let g:currentColor = "default"
endif

let g:barColor = 8
let g:guiBarColor = "#222222"
let g:backGroundStyle = "dark"

let g:defaultFont = "consolas:h11"

syntax on
set number
"set relativenumber
" faster screen
set ttyfast

" wrap lines
set wrap

" set the font
exec "set guifont=".g:defaultFont

" draws the screen in my prefered format
func! DrawScreenMyWay(...)
    let g:currentColor = a:0 >= 1 ? a:1 : g:currentColor
    " the second argument will either be the console color or the gui color
    " depending on whether console or gui vim is running
    if has ("gui_running")
        let g:guiBarColor = a:0 >= 2 ? a:2 : g:guiBarColor
    else
        let g:barColor = a:0 >= 2 ? a:2 : g:barColor
    endif

    exec "colorscheme ".g:currentColor

    if has ("gui_running")
        " highlights the columns to the right of 80"
        let &colorcolumn=join(range(81,999),",")"
    else
        " highlights the 81st column
        set colorcolumn=81
    endif
    " set background
    exec "set background=".g:backGroundStyle
    " using this color; change ctermbg to change the color of the highlight"
    exec "highlight ColorColumn ctermbg=".g:barColor." guibg=".g:guiBarColor
endfunc

exec "colorscheme ".g:currentColor

call DrawScreenMyWay()


" display statusline
" make statusline mandatory
set laststatus=2
" statusline settings
set statusline=w%{winnr()}\ \ %-4l\ %-3c\ %t\ %y%m\ %3p%%\ 


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
    autocmd FileType Scheme :setlocal softtabstop=2 shiftwidth=2
augroup END

"indent to the same level of the previous line"
set autoindent


"allows tab functionality to be changed locally (buffer) on the fly
func! SetTabFunctionality(...)
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
endfunc

"Displays the values of the most important indentation variables for the
"current buffer
func! DisplayTabSettings()
    exec 'echo "expandtab:"'.&l:expandtab
    exec 'echo "tabstop:"'.&l:tabstop
    exec 'echo "softtabstop:"'.&l:softtabstop
    exec 'echo "shiftwidth:"'.&l:shiftwidth
    exec 'echo "smarttab:"'.&l:smarttab
endfunc

"}}}
"Folding -----{{{
"Special folding functions ---{{{2


func! MarkdownLevel()
    let h = matchstr(getline(v:lnum), '^#\+')
    if empty(h)
        return "=" 
    else
        return ">" . len(h)
    endif
endfunc

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

augroup saveFunctionality
" NO TIMESTAMP:
autocmd BufWritePre * let &backupext ='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'),  ':', '', 'g').'~'

" TIMESTAMP:
" autocmd BufWritePre * let &backupext ='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'),  ':', '', 'g').'%%'.strftime("%Y-%m-%d-%H.%M.%S").'~'
augroup END

" don't back or save undo info for text files that start with !NoBackup
func! CheckIfNoBackup()
    return getline(1)=~'\v\C^\s*!NoBackup\s*$'
endfunc

func! SetNoBackup()
    setl nobackup
    setl noundofile
    echom "File is set to NoBackup"
endfunc

augroup saveFunctionality
    autocmd FileType text :if CheckIfNoBackup() | call SetNoBackup() | echom "Changes made in this filetype will not be backed up: nobackup has been globally set" | endif
    autocmd BufWritePre *.txt :if CheckIfNoBackup() | call SetNoBackup() | endif
augroup END


"}}}
"Gui Functionality -----{{{

" These settings are for use in a vim gui window not terminal vim
" Also note that "set vb t_vb=" has to be set in _gvimrc as well

if has("gui_running")

" Basic Gui Settings{{{2
" the default settings for the size of the gui window
let g:defaultGuiWindowSizeX = 32
let g:defaultGuiWindowSizeY = 100
" the large sizes for the gui window
let g:largeGuiWindowSizeX = 36
let g:largeGuiWindowSizeY = 125

" the default position for the window
let g:defaultGuiWindowPositionX = 54
let g:defaultGuiWindowPositionY = 109

" set the size of the vim window only at startup
augroup GuiSettings
autocmd GuiEnter * exec "set lines=".g:defaultGuiWindowSizeX | 
                \ exec "set columns=".g:defaultGuiWindowSizeY |
                \ let g:hasGuiWindowBeenResized = 1 | 
                \ exec "winpos ".g:defaultGuiWindowPositionX." "
                \ .g:defaultGuiWindowPositionY
augroup END
" position the window to the default position

" turn off unnecessary gui options
" also allows normal use of tab key in gui vim
" turn off menubar
set guioptions -=m
" turn off icon menubar
set guioptions -=T

"}}}2
" Resize Window Function{{{2
" resizes the gui window according to the given specification
" preset -> 0:
"   you may customize the window size by passing in an additional x and y
"   variable
" preset -> 1:
"   the 'default' window size is used
" preset -> 2:
"   sets a large gui window
" preset
func! SetGuiWindowSize(preset=1, ...)
    let x = g:defaultGuiWindowSizeX
    let y = g:defaultGuiWindowSizeY
    if a:preset ==# 0  
        let x = a:1
        let y = a:2
    elseif a:preset ==# 2
        let x = g:largeGuiWindowSizeX
        let y = g:largeGuiWindowSizeY
    endif

    exec "set lines=".x
    exec "set columns=".y
endfunc
"}}}2
" Set Window Position with Mapping{{{2
func! MoveGuiPositionUp(amount=15)
    let posx=getwinposx()
    let posy=getwinposy()
    let posy=posy-a:amount
    exec "winpos ".posx." ".posy
endfunc
func! MoveGuiPositionDown(amount=15)
    let posx=getwinposx()
    let posy=getwinposy()
    let posy=posy+a:amount
    exec "winpos ".posx." ".posy
endfunc
func! MoveGuiPositionLeft(amount=30)
    let posx=getwinposx()
    let posy=getwinposy()
    let posx=posx-a:amount
    exec "winpos ".posx." ".posy
endfunc
func! MoveGuiPositionRight(amount=30)
    let posx=getwinposx()
    let posy=getwinposy()
    let posx=posx+a:amount
    exec "winpos ".posx." ".posy
endfunc
" allow the user to reposition the window with these keys
nnoremap <silent> <pageup> :call MoveGuiPositionLeft()<cr>
nnoremap <silent> <pagedown> :call MoveGuiPositionDown()<cr>
nnoremap <silent> <home> :call MoveGuiPositionUp()<cr>
nnoremap <silent> <end> :call MoveGuiPositionRight()<cr>
nnoremap <silent> <s-pageup> :call MoveGuiPositionLeft(150)<cr>
nnoremap <silent> <s-pagedown> :call MoveGuiPositionDown(50)<cr>
nnoremap <silent> <s-home> :call MoveGuiPositionUp(50)<cr>
nnoremap <silent> <s-end> :call MoveGuiPositionRight(150)<cr>
"}}}2
" Set Window Size With Mappings{{{2
func! DecreaseGuiCols(amount=3)
    let nlines = &lines
    let ncolumns = &columns
    let ncolumns=ncolumns-a:amount
    exec "set lines=".nlines." columns=".ncolumns
endfunc

func! DecreaseGuiLines(amount=3)
    let nlines = &lines
    let ncolumns = &columns
    let nlines=nlines-a:amount
    exec "set lines=".nlines." columns=".ncolumns
endfunc

func! IncreaseGuiLines(amount=3)
    let nlines = &lines
    let ncolumns = &columns
    let nlines=nlines+a:amount
    exec "set lines=".nlines." columns=".ncolumns
endfunc

func! IncreaseGuiCols(amount=3)
    let nlines = &lines
    let ncolumns = &columns
    let ncolumns=ncolumns+a:amount
    exec "set lines=".nlines." columns=".ncolumns
endfunc
" allow the user to change the size of the window with these keys
" in insert mode
nnoremap <silent> <m-pageup> :call DecreaseGuiCols()<cr>
nnoremap <silent> <m-pagedown> :call DecreaseGuiLines()<cr>
nnoremap <silent> <m-home> :call IncreaseGuiLines()<cr>
nnoremap <silent> <m-end> :call IncreaseGuiCols()<cr>
"}}}2
"Cache Window Size{{{2
" these are used to save a certain window size for later reuse
let g:cachedWindowSizeX = g:defaultGuiWindowSizeX
let g:cachedWindowSizeY = g:defaultGuiWindowSizeY

func! SetCachedWindowSize()
    let g:cachedWindowSizeX = &lines
    let g:cachedWindowSizeY = &columns
endfunc

nnoremap g<pageup> :call SetCachedWindowSize()<cr>

func! ResetToCachedWindowSize()
    exec "set lines=".g:cachedWindowSizeX." columns=".g:cachedWindowSizeY
endfunc

nnoremap <silent> g<pagedown> :call ResetToCachedWindowSize()<cr>
"}}}2
" Cache Window Position{{{2
" these are used to save a certain window position for later reuse
let g:cachedWindowPositionX = g:defaultGuiWindowPositionX
let g:cachedWindowPositiolnY = g:defaultGuiWindowPositionY

func! SetCachedWindowPosition()
    let g:cachedWindowPositionX = getwinposx()
    let g:cachedWindowPositionY = getwinposy()
endfunc

nnoremap g<home> :call SetCachedWindowPosition()<cr>

func! ResetToCachedWindowPosition()
    exec "winpos ".g:cachedWindowPositionX." ".g:cachedWindowPositionY
endfunc

nnoremap <silent> g<end> :call ResetToCachedWindowPosition()<cr>
"}}}2

endif

"}}}
" Windowing{{{
" Allows a window to be created rightbelow when the shift key is pressed
nnoremap <silent> <c-w>S :rightbelow split<cr>
nnoremap <silent> <c-w>V :rightbelow vsplit<cr>

" allow the arrow keys to create new windows
nnoremap <silent> <c-w><left> :leftabove vsplit<cr>
nnoremap <silent> <c-w><c-left> :leftabove vsplit<cr>
nnoremap <silent> <c-w><right> :rightbelow vsplit<cr>
nnoremap <silent> <c-w><c-right> :rightbelow vsplit<cr>
nnoremap <silent> <c-w><up> :leftabove split<cr>
nnoremap <silent> <c-w><c-up> :leftabove split<cr>
nnoremap <silent> <c-w><down> :rightbelow split<cr>
nnoremap <silent> <c-w><c-down> :rightbelow split<cr>

" allow easy window resizing
nnoremap <silent> <m-=> :resize +2<cr>
nnoremap <silent> <m--> :resize -2<cr>
nnoremap <silent> <m-.> :vertical resize -2<cr>
nnoremap <silent> <m-,> :vertical resize +2<cr>
" }}}
"Unix Settings -----{{{
" these are settings that are intended to be used primarily on unix enviroments

" find files and populate the quickfix list
" use :FindFile <file name> <location> to call this
func! FindFiles(filename, loc)
  let error_file = tempname()
  silent exe '!find '.a:loc.' -name "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file
  set errorformat=%f:%l:%m
  exe "cfile ". error_file
  copen
  call delete(error_file)
endfunc
command! -nargs=+ FindFile call FindFiles(<f-args>)

"}}}
"Key Remapping -----{{{
"Function Keys and Critical Mappings ---{{{2
"<F1> ---{{{3
" enable easy toggling of relative numbers
nnoremap <F1> :set relativenumber!<cr>

" also allow toggling of cursor highlighting
nnoremap <leader><F1> :set cul!<cr>

" allow toggling of number display
nnoremap -<F1> :set number!<cr>
"}}}3
"<F2> ---{{{3
" allow easy toggling of spell mode
nnoremap <F2> <esc>:set spell!<cr>
"}}}3
"<F3> ---{{{3
" allows the toggling of the highlighting of tabs
let g:tabsAreHighlighted = 0
syntax match Tab /\t/
func! ToggleTabHighlighting()
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
endfunc
nnoremap <F3> :call ToggleTabHighlighting()<cr>
"}}}
"<F4> ---{{{3
" displays all custom functions in this vimrc and followed by a call option
" NOTE: that this list must be updated as new custom functions are added to
" this vimrc
func! DisplayCustomFunctions()
    echom "1: DrawScreenMyWay"
    echom "2: SetGuiWindowSize"
    echom "3: DisplayTabSettings"
    echom "4: SetTabFunctionality"
    echom "5: RunMyNotesFold"
    echom ""
endfunc

" allow easy number selection and displays some advice about the selected
" function
func! SelectCustomFunctions(choice)
    if a:choice ==# 1
        echom "DrawScreenMyWay(color=g:currentColor)"
        echom "Description: Draws the screen using settings particular to this vim configuration"
        echom "Params:"
        echom "    color: The color to set the screen"
        echom ""

        let res = 'DrawScreenMyWay'
    elseif a:choice ==# 2
        echom "SetGuiWindowSize(preset=1, ...x, y)"
        echom "Description: Sets the size of the vim Gui"
        echom "Params:"
        echom "    preset:"
        echom "        preset -> 1: default"
        echom "        preset -> 2: large"
        echom "        preset -> 0: custom, pass in an additional x and y for screen size"
        echom "    x: The number of rows to include in the gui"
        echom "    y: The number of columns to include in the gui"
        echom ""

        let res = 'SetGuiWindowSize'
    elseif a:choice ==# 3
        echom "DisplayTabSettings()"
        echom "Description: Displays the settings currently used by vim's tab system"
        echom ""

        let res = 'DisplayTabSettings'
    elseif a:choice ==# 4
        echom "SetTabFunctionality(...TabVal, ExpandTab, HardTabVal)"
        echom "Description: Allows tab functionality to be changed locally (buffer) on the fly"
        echom "Params:"
        echom "    TabVal"
        echom "    ExpandTab"
        echom "    HardTabVal"
        echom ""

        let res = 'SetTabFunctionality'
    elseif a:choice ==# 5
        echom "RunMyNotesFold()"
        echom "Description: Sets up the current buffer for MyNotes style folding and syntax highlighting"
        echom ""

        let res = 'RunMyNotesFold'
    endif
    let res = res.'()'
    call feedkeys(':call '.res."\<left>")
endfunc

nnoremap <F4> :call DisplayCustomFunctions()<cr>:call SelectCustomFunctions()<left>
"}}}3
"<F5> ---{{{3
" grab the data from the quick_locations file in the .vim directory
let g:freqLocations = readfile(expand('$HOME/.vim/quick_locations.txt'))
" ensure that we only grab lines that match the syntax "label":path
" and are not comments
call filter(g:freqLocations, 'v:val !~ ''\v^\s*#'' && v:val =~ ''\v^".+":.+$''')

" display frequent locations
func! DisplayFrequentLocations()
    for i in range(0, len(g:freqLocations)-1)
        echom i+1 . ': ' . split(g:freqLocations[i], '"')[0]
    endfor
    echom ""
endfunc

" places the frequent location directory as a command for the user
func! SelectFrequentLocations(choice, editMode = 0)
    if a:choice <=# len(g:freqLocations) && a:choice >#0 
        let res = split(g:freqLocations[a:choice - 1], '":')[1]
        if a:editMode ==# 0
            let feed = ':edit '.res
        elseif a:editMode ==# 1
            let feed = ':split '.res
        elseif a:editMode ==# 2
            let feed = ':vsplit '.res
        elseif a:editMode ==# 3
            let feed = ':tabedit '.res
        endif
        call feedkeys(feed)
    endif
endfunc

" general buffer edit
nnoremap <F5> :call DisplayFrequentLocations()<cr>:call SelectFrequentLocations()<left>
" allows editing in a new horizontal window
nnoremap <leader><F5> :call DisplayFrequentLocations()<cr>:call SelectFrequentLocations(,1)<left><left><left>
" vertical window
nnoremap -<F5> :call DisplayFrequentLocations()<cr>:call SelectFrequentLocations(,2)<left><left><left>
" allows tab editing
nnoremap \<F5> :call DisplayFrequentLocations()<cr>:call SelectFrequentLocations(,3)<left><left><left>
"}}}3
"<F12> ---{{{3
" allows easy resourcing of the vimrc
nnoremap <F12> :source $MYVIMRC<cr>
"}}}3
"}}}2
"General Mappings ---{{{2
" "Scroll Mode {{{3
" " allows screen movement regardless of cursor in insert mode
" " makes j and k act like <c-e> and <c-y>
" " also allows h and l to scroll faster
" " press gl to activate, press gl or <esc> in normal mode to deactivate
" let g:ScrollEnabled = 0
" " save the current cursor settings
" let g:CursorHighlightFG = ""
" let g:CursorHighlightBG = ""

" let g:TerminalCursorSetting = ""

" func! ToggleScrollMode()
"     if g:ScrollEnabled ==# 0
"         " enter scroll mode
        
"         if has("gui_running")
"             " save previous cursor highlight settings
"             let g:CursorHighlightFG = synIDattr(synIDtrans(hlID("Cursor")), "fg")
"             let g:CursorHighlightBG = synIDattr(synIDtrans(hlID("Cursor")), "bg")
"             " clear the cursor highlighting
"             highlight Cursor guibg=NONE guifg=NONE
"         else
"             " save the value for later and disble t_ve
"             let g:TerminalCursorSetting = &t_ve
"             set t_ve=
"         endif

"         nnoremap j <c-e>
"         nnoremap k <c-y>
"         nnoremap h 3<c-e>
"         nnoremap l 3<c-y>
"         nnoremap <esc> :call ToggleScrollMode()<cr>
"         nnoremap i :call ToggleScrollMode()<cr>
"         nnoremap a :call ToggleScrollMode()<cr>
"         nnoremap I :call ToggleScrollMode()<cr>
"         nnoremap A :call ToggleScrollMode()<cr>
"         nnoremap o :call ToggleScrollMode()<cr>
"         nnoremap O :call ToggleScrollMode()<cr>
"         let g:ScrollEnabled = 1
"         echom "-- ScrollMode Enabled --"
"     else
"         " undo scroll mode
        
"         if has("gui_running")
"             " return cursor highlighting
"             exec "highlight Cursor guifg=".g:CursorHighlightFG
"             exec "highlight Cursor guibg=".g:CursorHighlightBG
"         else
"             " restore terminal cursor highlighting
"             let &t_ve = g:TerminalCursorSetting
"         endif

"         " unmap movement and modal keys
"         nunmap j
"         nunmap k
"         nunmap h
"         nunmap l
"         nunmap <esc>
"         nunmap i
"         nunmap a
"         nunmap I
"         nunmap A
"         nunmap o
"         nunmap O
"         let g:ScrollEnabled = 0
"         echom "-- ScrollMode Disabled --"
"     endif
" endfunc

" nnoremap gl :call ToggleScrollMode()<cr>
" "}}}3

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
" allow easy word movement
inoremap <M-w> <esc>lwi
inoremap <M-b> <esc>bi

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

"alternative way to enter insert mode
nnoremap <M-s> i

" exit insert mode without heading left (except for end of line)
inoremap <c-f> <esc><right>

" allows easier buffer searching
nnoremap <leader>l :ls<cr>:b

" allows easier writing
nnoremap <leader>w :write<cr>

" allows universal closing of a buffer without closing a window
nnoremap <silent> <leader><leader>q :bp<bar>sp<bar>bn<bar>bd!<CR>

" remaps _ to search a char backward (what comma usually does)
nnoremap _ ,

" allows easy access to the plus buffer
nnoremap <leader><leader> "+
vnoremap <leader><leader> "+

" cycle through buffers
nnoremap gb :bnext<cr>
nnoremap <leader>gb :bprev<cr>
"nnoremap <tab> :bnext<cr>
"nnoremap <s-tab> :bprev<cr>

" sets <c-w><c-t> to behave as :tabe %
nnoremap <c-w><c-t> :tabe %<cr>

" if ctrl-v does not work on linux, then use this
nnoremap <leader>V <c-v>


" allows macros to be run on multiple lines
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
func! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunc

" inserts the working directory
inoremap \\cd <c-r>=getcwd()<cr>
" inserts the home directory
inoremap \\~ <c-r>=$HOME<cr>

cnoreabbrev cd% cd %:p:h

" allows newlines to be added in normal mode, while staying in normal mode
nnoremap <leader>o mqo<esc>`q
nnoremap <leader>O mqO<esc>`q

" funtions like o, but leaves you in normal mode
nnoremap -o o<esc>
nnoremap -O O<esc>

" like above, but autopaste
nnoremap <leader>-o o<esc>"+p

" adds a semicolon to end of line then returns to same spot
nnoremap <leader>; mqA;<esc>`q
" also works in insert mode
inoremap <c-b>; <esc>mqA;<esc>`q<right>i

" wraps the selected visual area in quotes or parens
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`><right><right>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>`><right><right>
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>`><right><right>
vnoremap <leader>) <esc>`>a)<esc>`<i(<esc>`><right><right>

" repeats the char pressed after the s command v:count1 times
nnoremap <silent> s :<c-u>exec "normal i".repeat(nr2char(getchar()), v:count1)<cr>
nnoremap <silent> S :<c-u>exec "normal a".repeat(nr2char(getchar()), v:count1)<cr>

" causes the current line to be indented to the level of the previous level
" while in insert mode
:inoremap <c-d> <Esc>:call setline(".",substitute(getline(line(".")),'^\s*',matchstr(getline(line(".")-1),'^\s*'),''))<CR>I

" inserts braces while in insert mode
inoremap <c-b>b <esc>$a<space>{<cr>}<esc>O<tab>
" language specific
augroup braces
    " python: inserts the parens and the colon at the end
    autocmd FileType python :inoremap <buffer> <c-b>b ():<esc>hi
    " Csharp
    autocmd BufNewFile,BufRead *.cs :inoremap <buffer> <c-b>b <esc>$a<cr>{<cr>}<esc>O<tab>
augroup END

" places //DEBUG
inoremap <c-b>d //DEBUG<cr>//DEBUG<esc>O
augroup debugStatements
   autocmd FileType python :inoremap <c-b>d #DEBUG<cr>#DEBUG<esc>O
augroup END

" allows the use of -w and <c-i>b to move forwards and backwards
" in a camelCase word, also <c-i>e to go to the end of the current word
"
" explanation: /> is match new word, /<Bar> is pipe for regex, /u is next
" capital letter
"
" Bugs: using in visual mode with a backwards expanding selection
" will not work properly.
" Also cannot use numbers right now.
" Also <c-i>e will not go to the end if at the end of the line
"nnoremap <silent> <leader><tab>w :call search('\>\<Bar>\u', '')<cr>
"nnoremap <silent> <leader><tab>b :call search('\>\<Bar>\u', 'b')<cr>
"nnoremap <silent> <leader><tab>e <right>:call search('\>\<Bar>\u\<Bar>\$', '')<cr><left>
"onoremap <silent> <leader><tab>w :call search('\>\<Bar>\u', '')<cr>
"onoremap <silent> <leader><tab>b :call search('\>\<Bar>\u', 'b')<cr>
"onoremap <silent> <leader><tab>e <right>:call search('\>\<Bar>\u', '')<cr><leit>
"vnoremap <silent> <leader><tab>w <esc>:call search('\>\<Bar>\u', '')<cr>mqv`<o
"vnoremap <silent> <leader><tab>b <esc>:call search('\>\<Bar>\u', 'b')<cr>v`<o
"vnoremap <silent> <leader><tab>e <esc><right>:call search('\>\<Bar>\u', '')<cr>mqv`<o<left>

"}}}2
"}}}
" Macros {{{
"due to q being used in other mappings, allows QQ to be used to end macro
"recording
nnoremap Q <nop>
nnoremap QQ q

" enter will quick run the macro recorded in q
nnoremap <c-cr> @q 
" cycles the register values q -> m -> n -> b
nnoremap <silent> <leader>Q<cr> :let @b = @n <bar> let @n = @m <bar> let @m = @q<cr>
" quick check the macro registers
"nnoremap Q<cr> :reg q <bar> reg m <bar> reg n <bar> reg b <bar> reg v<cr>:
nnoremap Q<cr> :reg qmnbv<cr>:
" runs what is in register v
nnoremap <s-cr> @v 

" allows easier re-editing of a macro
nnoremap Qe q:ilet @q = '<c-r><c-r>q'<left>
" allows easier swapping of the primary macro register
nmap Q<c-cr> Q<cr>let @q = @
" allows easier swapping of the alternate macro register
nmap Q<s-cr> Q<cr>let @v = @

" swap the q and v register
nnoremap <silent> Q<backspace> :let q = @q <bar> let @q = @v <bar> let @v = q<cr>
" swaps the q and v register, cycles, then swaps p and v again
nmap <silent> <leader>Q<backspace> Q<backspace><leader>Q<cr>Q<backspace>

func! GetMacroHelpText() 
            echom "Macro Help:"
            echom "Q<F1> :- Open this help prompt"
            echom " "
            echom "@q :- Temporary register"
            echom "@v :- \"Permanent\" Register"
            echom "@m,n,b :- Cycle Registers"
            echom "<C-CR> :- Run macro in the q register"
            echom "<S-CR> :- Run macro in the v register"
            echom "Q<CR> :- Display all macro registers"
            echom "<leader>Q<CR> :- Cycle the content of the registers: q -> m -> n -> b"
            echom "Qe :- Quickly edit the macro in the q register"
            echom "Q<C-CR> :- Swap q register"
            echom "Q<S-CR> :- Swap v register"
            echom "Q<Backspace> :- Swap the q and v register"
            echom "<leader>Q<Backspace> :- swaps the q and v register, cycles, then swaps p and v again"
            echom "Ql :- Open the saved macro buffer in a split window"
            echom "Qy :- Copy the given macro under the cursor in the saved macro buffer"
            echom "<leader>Qy :- Cycle and copy the given macro under the cursor"
            echom ""
endfunc

" open the help prompt
nnoremap Q<F1> :call GetMacroHelpText()<cr>

" display saved macros
nnoremap Ql :split ~/.vim/user_macros.txt<cr>
" quickly copy macro on line (in user macro file) into q register
nnoremap Qy 0v$h"qy
" same as above, but cycle first
nmap <leader>Qy <leader>Q<cr>0v$h"qy
"}}}
" Terminal {{{
" open shell types easily
cnoreabbrev termp terminal pwsh
cnoreabbrev termb terminal bash
cnoreabbrev termc terminal cmd

"" make alt work for desired keys
tmap <expr> <m-h> SendToTerm("h")
tmap <expr> <m-j> SendToTerm("j")
tmap <expr> <m-k> SendToTerm("k")
tmap <expr> <m-l> SendToTerm("l")
tmap <expr> <m-o> SendToTerm("o")
func! SendToTerm(what)
  call term_sendkeys('', a:what)
  return ''
endfunc 
" }}}

"{{{Source Custom Modules
source ~/.vim/custom_modules/MyNotesFold/MyNotesFold.vim


"}}}
"{{{Source Vim Code Unique to this System
source ~/.vim/vimrc_exceptions.vim

"}}}
"Source Final Changes {{{
"}}}
