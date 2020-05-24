# Sets up the environment required for the vimrc

# Since we are storing .vimrc, .gvimrc, and .vsvimrc in the ~/.vim/ directory
# we need to make a symbolic link to these in the ~ directory
if [ ! -f ~/.vimrc ]
then
ln -s ~/.vim/.vimrc ~/.vimrc
fi

if [ ! -f ~/.gvimrc ]
then
ln -s ~/.vim/.gvimrc ~/.gvimrc
fi

if [ ! -f ~/.vsvimrc ]
then
ln -s ~/.vim/.vsvimrc ~/.vsvimrc
fi

# make necessary directories
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

# make necessary files
if [ ! -f ~/.vim/quick_locations.txt ]
then
printf '# this is a comment\nentries are of form "label":path\n\n# This File\n"Quick Locations":~/.vim/quick_locations.txt' > ~/.vim/quick_locations.txt
fi

if [ ! -f ~/.vim/vimrc_exceptions.vim ]
then
touch ~/.vim/vimrc_exceptions.vim
fi
