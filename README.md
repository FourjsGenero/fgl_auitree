# fgl_auitree
Library functions that are useful to interrogate and manipulate the AUI Tree.

The historial reasoning for this library was that the original versions of Genero 1.2, 1.3, a lot of the methods you see in ui.Dialog, ui.Form were not available.  If developers wanted to hide fields, change action text, they had to resort to what was called DOM Tree or AUI Tree manipulation techniques to actually change the values in the AUI Tree by manipulating the tree directory.  As Genero has progressed, a lot of methods have been added that save the Genero developer from having to do this.

The library used to be a lot bigger and gets smaller with each release.  

The basic technique is to find a node in the AUI Tree and set or get the attribute value.

## Instructions
Run the program, and then look at the code that is behind the scenes for any functionality you are interested in

This program used to include a generic list example, that has been ported off to fgl_zoom.  Might do the same for the generic menu example

## TODO
Port off arraycopy as a seperate example

Port off generic_menu as a seperate example
