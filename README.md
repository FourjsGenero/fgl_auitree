# fgl_auitree
Library functions that are useful to interrogate and manipulate the AUI Tree.

The historial reasoning for this library was that the original versions of Genero 1.2, 1.3 etc a lot of the methods you see in ui.Dialog, ui.Form were not available.  If developers wanted to hide fields, change action text etc, they had to resort to what was called DOM Tree or AUI Tree manipulation techniques to actually change the values in the AUI Tree.  As Genero has progressed, a lot of methods have been added to the ui.Dialog and ui.Form classes that save the Genero developer from having to create their own functions to do this.  What remains in this library are functions where an equivalent method does not exist in the Genero language yet.  This library used to be a lot bigger and gets smaller with each release, as you can see only a handful of functions remain.  

The basic technique is to find a node in the AUI Tree and set or get the attribute value.

## Instructions
Run the program, and then look at the code that is behind the scenes for any functionality you are interested in

## Examples

### Read and Set Field Attributes

This example toggles the hidden status of various containers.  It reads the current hidden value, and then sets it to the opposite.  The screenshot shows the before and after of a VBOX being hidden

<img alt="No elements hidden" src="https://user-images.githubusercontent.com/13615993/32255550-9c9a928a-bf0d-11e7-83ae-03369ab22607.png" width="50%" />
<img alt="VBox hidden" src="https://user-images.githubusercontent.com/13615993/32255549-9c5f2bc8-bf0d-11e7-823a-a068b54ca964.png" width="50%" />

### Determine Dialog Type

Identify if currently in an INPUT or CONSTRUCT.  Useful for generic code that may have to behave differently depending upon where called from.  The screenshot shows output when in a CONSTRUCT in the MESSAGE panel

<img alt="Dialog Type output" src="https://user-images.githubusercontent.com/13615993/32255548-9c2262d8-bf0d-11e7-9a5b-991999490f9a.png" width="50%" />

### TAG field

Use the TAG attribute to group a fields title label and description label so that when you hide a field, you do not have to explicitly hide the title or the description label.  Screenshot shows before and after as a field (and its title and description) are hidden

<img alt="No fields hidden" src="https://user-images.githubusercontent.com/13615993/32255547-9be5df84-bf0d-11e7-81de-0a071d8dfe43.png" width="50%" />
<img alt="Tagged fields hidden" src="https://user-images.githubusercontent.com/13615993/32255546-9b9cf5d0-bf0d-11e7-9feb-54f5b6487f6e.png" width="50%" />

### Array Copy

Techniques for copying an Entire Array.

<img alt="Array Copy" src="https://user-images.githubusercontent.com/13615993/32255544-9abca6e2-bf0d-11e7-9785-894e575ecb02.png" width="50%" />

(intention is to port this off as a seperate example one day)

### Style Add/Remove

Add or remove a style to a field based on current value.  The screenshot shows as value entered, style changes

<img alt="No values entered" src="https://user-images.githubusercontent.com/13615993/32255543-9a33fa5e-bf0d-11e7-8be2-596657c3f846.png" width="50%" />
<img alt="Styles changed as values entered" src="https://user-images.githubusercontent.com/13615993/32255542-99e48528-bf0d-11e7-99a3-ab7711d4bc10.png" width="50%" />

### Placeholder/Comment manipulation

Change comment, placeholder value at runtime.  SCreenshot shows placeholder added to field

<img alt="No placeholder" src="https://user-images.githubusercontent.com/13615993/32255541-9986da04-bf0d-11e7-8a4e-e3c5ccc01e5d.png" width="50%" />
<img alt="Placeholder set" src="https://user-images.githubusercontent.com/13615993/32255540-9933fef6-bf0d-11e7-8665-35703ea5aae8.png" width="50%" />

### TopMenu Builder

Add standard items to each TopMenu, in this case a File, Edit on the left and Help on the right.  Screensho shows Topmenu with File, Edit on left, Help on right

<img alt="TopMenu Example" src="https://user-images.githubusercontent.com/13615993/32255539-98f6cdce-bf0d-11e7-8021-b1a51687ed99.png" width="50%" />



## TODO
Port off arraycopy as a seperate example

