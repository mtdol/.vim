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
* quick_locations.txt is used by the <F5> key to display a quick list of
** locations for editing. Lines that start with # are comments and quick links are
** written in the form:

- "label":location

** and are loaded in the order they are listed

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
* '-', '*', and '~' are used to make elements that have colored syntax.
    1. Place these at the start of a line or after whitespace on a line
    2. Any expression made by these contstructs will continue until the end of the line
    3. The expression can be nullified by placing anything before it on the line
        ~ Ex:
            /~ will not highlight
    4. The idiomatic way to continue a highlighted line is to double the symbol
        ~ Ex: 
            - This is a line of text that will end up being too long
            -- and will have to be continued on the next line.

* Lists can be constructed by a number followed by either
** arbitrarily many '.' or ':' followed by a space character
** or just a '.' followed by space
    ~ Ex:
        1. Element 1
        2. Element 2
            1.. Another element
                1... A sub element
            2.. Another
        12: colon Element
            . Plain Element
                .. Another Plain Element
        34. 2 digit number

/:4
Important Words::4
The exact words Note:, Remember:, Important:, and Todo: will trigger important
word syntax highlighting

The exact words NOTE, NOTE:, REMEMBER, REMEMBER:, IMPORTANT, IMPORTANT:,
TODO, and TODO: will trigger urgent syntax highlighting
/:4
Definitions::4
* Definitions can be marked with the ":-" construct
~ Ex:
    This is a term :-
        This is its definition

- The definition can either be placed on the same line as the construct
-- or on the next line (usually indented)

/:4
Additionally it should be noted that this document features this brand of note
folding, so feel free to experiment around with it.

/:3
/:2

