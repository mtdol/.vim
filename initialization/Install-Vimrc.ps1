<# 
.DESCRIPTION
Sets up the vim environment on the current computer.
This script should be able to be rerun many times after initial
instalation without destroying data (ie. This script could be run
to repair the install.)

This utility requires admin privileges to make symbolic links;
Otherwise the program will run, but will not be able to make symbolic links.
#>

# create symbolic links to all files that are read in the ~ directory
if (Test-Path ~\.vimrc -eq $false) {
    new-item -ItemType SymbolicLink -Path ~\.vimrc -Target ~\.vim\.vimrc
}
if (Test-Path ~\.gvimrc -eq $false) {
    new-item -ItemType SymbolicLink -Path ~\.gvimrc -Target ~\.vim\.gvimrc
}
if (Test-Path ~\.vsvimrc -eq $false) {
    new-item -ItemType SymbolicLink -Path ~\.vsvimrc -Target ~\.vim\.vsvimrc
}

# causes .vim/vimfiles to just lead back to .vim (vim on windows uses the
# vimfiles directory, but it is easier for versioning to just use .vim)
if (Test-Path ~\.vim\vimfiles -eq $false) {
    new-item -ItemType SymbolicLink -Path ~\vimfiles -Target ~\.vim\
}

# now create necessary sub-directories, if they do not exist
if (Test-Path ~\.vim\vimbackups -eq $false) {
    mkdir ~\.vim\vimbackups
}
if (Test-Path ~\.vim\vimbackups\backups -eq $false) {
    mkdir ~\.vim\vimbackups\backups
}
if (Test-Path ~\.vim\vimbackups\swaps -eq $false) {
    mkdir ~\.vim\vimbackups\swaps
}
if (Test-Path ~\.vim\vimbackups\undos -eq $false) {
    mkdir ~\.vim\vimbackups\undos
}

# create necessary files, if they do not exist
if (Test-Path ~\.vim\quick_locations.txt -eq $false) {
    Set-Content ~\.vim\quick_locations.txt "# this is a comment`nentries are of form `"label`":path`n`n# This File`n`"Quick Locations`":~\.vim\quick_locations.txt"
}
if (Test-Path ~\.vim\vimrc_exceptions.vim -eq $false) {
    New-Item ~\.vim\vimrc_exceptions.vim
}
if (Test-Path ~\.vim\pre_vimrc_exceptions.vim -eq $false) {
    New-Item ~\.vim\pre_vimrc_exceptions.vim
}
