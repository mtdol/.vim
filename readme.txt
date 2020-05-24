!MyNotes
press za in normal mode to toggle a fold in vim
use ':h folding' for more information

Installation::
To install this custom version of vim, choose the appropriate initialization
script from .vim/initialization:
- 'Install-Vimrc.ps1' is for windows (7 and onwards)
- 'install_vimrc.sh' is for linux/mac

Important Note::
In order to have vim correctly load the .vimrc, it is important that there is
a symbolic link in the ~ directory to the file, where the symbolic link is 
named .vimrc.

This is usually handled by the setup scripts, but if you are not seeing the
symbolic links appear for some reason, you will need to create them.

Quick Locations::
quick_locations.txt is used by the <F5> key to display a quick list of
locations for editing. Lines that start with # are comments and quick links are
written in the form 
- "label":location -
and are loaded in the order they are listed

Vimrc Exceptions::
vimrc_exceptions.vim is loaded at the very end of the .vimrc and is used
to load code that is necessary for a particular system.

Custom Modules::
The custom_modules directory contains .vim scripts that are used to customize wthe 
experience of vim. These are loaded at the end of the .vimrc.

Here is an overview of the modules::2
MyNotesFold::3
Folds the notes into a particular pattern.

Sections::4
* "::" is used at the end of a line to mark a high level fold (for a section of text)
* "::2" is used to mark a section of indent level 2 and "/:2" is used at the beginning
of a line (important, the beginning, not the end) to mark the end of this section.
* The 2 in this expression can be generalized to any number 1-5 where 1 can be used
in addition to the plain "::" to mark a particular passage and "/:1" to mark its end
/:4
Lists::4
* '-' and '*' are used to make list elements who have colored syntax.
    - Place these at the start of a line or after whitespace on a line
    Any expression made by these contstructs will continue forever until:
        1. An Empty Line is reached
        2. Another construct is reached
        3. A particular terminator is reached
            * The symbol that was used to start the list is used as the terminator
            * The terminator must not be followed by whitespace, only a newline
* Lists can also be made with '\d*.+\s' and '\d+:+\s', ie. an optional (in the first case)
number followed by either arbitrarily many '.' or ':' followed by a space character
    - Examples:
        1. Element 1
        2. Element 2
            1.. Another element
                1... A sub element
            2.. Another
        12: colon Element
            . Plain Element
                .. Another Plain Element
        34. 2 digit number

* Term headers can also be made using a colon
    Expressions look like this:
        - There is no whitespace after the colon
/:4
Important Words::4
The exact words Note:, Remember:, Important:, and Todo: will trigger important
word syntax highlighting

The exact words NOTE, NOTE:, REMEMBER, REMEMBER:, IMPORTANT, IMPORTANT:,
TODO, and TODO: will trigger urgent syntax highlighting
/:4

Additionally it should be noted that this document features this brand of note
folding, so feel free to experiment around with it.

/:3
/:2

