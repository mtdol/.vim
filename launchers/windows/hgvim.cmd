@echo off
START gvim --cmd "let g:Cli_Plugs = 'YouCompleteMe:1 vim_ctrlspace:1'" %*
