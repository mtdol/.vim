# Sets up the environment required for the vimrc

# Since we are storing .vimrc, .gvimrc, and .vsvimrc in the ~/.vim/ directory
# we need to make a symbolic link to these in the ~ directory
ln -s ~/.vim/.vimrc ~/.vimrc
ln -s ~/.vim/.gvimrc ~/.gvimrc
ln -s ~/.vim/.vsvimrc ~/.vsvimrc

if [ ! -d ~/.vim ]
then
mkdir ~/.vim
fi

if [ ! -d ~/.vim/vimbackups ]
then
mkdir ~/.vim/vimbackups
fi

if [ ! -d ~/.vim/vimbackups/backups ]
then
mkdir ~/.vim/vimbackups/backups
fi

if [ ! -d ~/.vim/vimbackups/swaps ]
then
mkdir ~/.vim/vimbackups/swaps
fi

if [ ! -d ~/.vim/vimbackups/undos ]
then
mkdir ~/.vim/vimbackups/undos
fi

if [ ! -f ~/.vim/quick_locations.txt ]
then
printf '# this is a comment\nentries are of form "label":path\n\n# This File\n"Quick Locations":~\.vim\quick_locations.txt > ~/.vim/quick_locations.txt'
fi

if [ ! -f ~/.vim/vimrc_exceptions.vim ]
then
touch ~/.vim/vimrc_exceptions.vim
fi
