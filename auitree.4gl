#
#       (c) Copyright 2008, Four Js AsiaPac - www.4js.com.au/local
#
#       MIT License (http://www.opensource.org/licenses/mit-license.php)
#
#       Permission is hereby granted, free of charge, to any person
#       obtaining a copy of this software and associated documentation
#       files (the "Software"), to deal in the Software without restriction,
#       including without limitation the rights to use, copy, modify, merge,
#       publish, distribute, sublicense, and/or sell copies of the Software,
#       and to permit persons to whom the Software is furnished to do so,
#       subject to the following conditions:
#
#       The above copyright notice and this permission notice shall be
#       included in all copies or substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#       NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#       BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#       ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#       CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#       THE SOFTWARE.
#
#       auitree.4gl Example Genero 4GL code to copy entire array to clipboard
#
#       December 2008 reuben
#


#+ auitree.4gl Some library functions to be used in manipulating the AUI/DOM tree
#+             These can be used as a starting point for production code.  They
#+             may need fine tuning to cater for your coding practises and will
#+             definitely need better error handling.
#+             The primary purpose is to show you what is possible.
#+             Any library functions that manipualte the AUI/DOM tree should be
#+             tested on every new Genero version as the structure of the tree
#+             may change between versions. 
#+             Also keep checking the ui.Dialog, ui.Form, ui.Window classes
#+             documentation as may find that a method here has an official
#+             Genero equivalent 

#+ action_node_get Return the node that defines a given action
FUNCTION action_node_get(name STRING) RETURNS om.DomNode
DEFINE w ui.Window
DEFINE n,f om.DomNode
DEFINE nl om.nodeList

   LET w = ui.Window.getCurrent()
   LET n = w.getNode()
   LET nl = n.selectByPath(SFMT("//Action[@name=\"%1\"]",name))
   IF nl.getLength() != 1 THEN
      LET nl = n.selectByPath(SFMT("//MenuAction[@name=\"%1\"]",name))
   END IF
   IF nl.getLength() = 1 THEN
      LET f=  nl.item(1)
   END IF
   RETURN f
END FUNCTION


#+ field_node_get Return the node that defines a given field.
FUNCTION field_node_get(name STRING, child SMALLINT) RETURNS om.DomNode
DEFINE w ui.Window
DEFINE n,f om.DomNode
DEFINE nl om.nodeList

   LET w = ui.Window.getCurrent()
   LET n = w.getNode()
   
   LET nl = n.selectByPath(SFMT("//FormField[@colName=\"%1\"]",name))
   IF nl.getLength() != 1 THEN
      LET nl = n.selectByPath(SFMT("//TableColumn[@colName=\"%1\"]",name))
   END IF
   IF nl.getLength() != 1 THEN
      LET nl = n.selectByPath(SFMT("//Matrix[@colName=\"%1\"]",name))
   END IF
   IF nl.getLength() != 1 THEN
      LET nl = n.selectByPath(SFMT("//*[@name=\"%1\"]",name))
   END IF
   
   IF nl.getLength() = 1 THEN
      LET f = nl.item(1)
      IF child THEN
         LET f = f.getChildByIndex(1)
      ELSE
         LET f=  nl.item(1)
      END IF
   END IF
   RETURN f
END FUNCTION


#+ field_tag_set Change the attribute of a list of fields that have been given the same tag value
FUNCTION field_tag_set(tag STRING, attribute STRING, child INTEGER, value STRING) RETURNS ()
DEFINE i INTEGER
DEFINE n, p om.DomNode
DEFINE nl om.NodeList
DEFINE w ui.Window

   LET w = ui.Window.getCurrent()
   LET n = w.getNode()
   LET nl = n.selectByPath(SFMT("//*[@tag=\"%1\"]",tag))
   FOR i = 1 TO nl.getlength()
      LET n = nl.item(i)
      -- Test if we have child of FormField, Matrix, TableColumn
      -- If we have then we have found the child node, and we really want the parent node
      LET p = n.getParent()
      IF p.getTagName() = "FormField"
      OR p.getTagName() = "TableColumn"
      OR p.getTagName() = "Matrix" THEN 
         LET n = p
      END IF
      IF child THEN
         LET n = n.getfirstchild()
      END IF
      CALL n.setattribute(attribute,value)
   END FOR
END FUNCTION



#+ field_format_set Change the format attribute of a given field
FUNCTION field_format_set(name STRING, format STRING) RETURNS ()
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("format",format)
   END IF
END FUNCTION





#+ field_justify_set Set the justify attribute of a given field
FUNCTION field_justify_set(name STRING, justify STRING) RETURNS ()
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("justify",justify)
   END IF
END FUNCTION


#+ field_width_set Set the width attribute of a given field
FUNCTION field_width_set(name STRING, width INTEGER) RETURNS ()
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("width",width)
   END IF
END FUNCTION



#+ field_comment_set Set the comment attribute of a given field
FUNCTION field_comment_set(name STRING, comment STRING) RETURNS ()
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("comment",comment)
   END IF
END FUNCTION



#+ field_comment_get Get the hidden attribute of a given field
FUNCTION field_comment_get(name STRING) RETURNS STRING
DEFINE comment STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      LET comment = n.getAttribute("comment")
   END IF
   RETURN comment
END FUNCTION




#+ field_placeholdert_set Set the placeholder attribute of a given field
FUNCTION field_placeholder_set(name STRING, placeholder STRING) RETURNS ()
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("placeholder",placeholder)
   END IF
END FUNCTION



#+ field_placeholder_get Get the hidden attribute of a given field
FUNCTION field_placeholder_get(name STRING) RETURNS STRING
DEFINE placeholder STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      LET placeholder = n.getAttribute("placeholder")
   END IF
   RETURN placeholder
END FUNCTION




#+ field_style_add Add a style to a space delimited list of styles
FUNCTION field_style_add(name STRING, style STRING)
DEFINE styletest STRING
DEFINE n om.DomNode
DEFINE value STRING
DEFINE w ui.Window
DEFINE f ui.Form

   LET n = field_node_get(name, TRUE)
   LET value = " ",n.getAttribute("style")," "
   LET styletest = " ", style, " "
   IF value.getIndexOf(styletest, 1) > 0 THEN
      # no need to add
   ELSE
      # add at beginning, maybe should add ability to position in list
      LET value = style, value
      
      LET w = ui.Window.getCurrent()
      LET f = w.getForm()
      CALL f.setFieldStyle(name, value.trim())
   END IF
   
END FUNCTION


#+ field_style_remove Remove a style from a space delimited list of styles
FUNCTION field_style_remove(name STRING, style STRING) RETURNS ()
DEFINE styletest STRING
DEFINE n om.DomNode
DEFINE pos INTEGER
DEFINE value STRING
DEFINE w ui.Window
DEFINE f ui.Form

   LET n = field_node_get(name, TRUE)
   LET value = " ",n.getAttribute("style")," "
   LET styletest = " ", style, " "
   LET pos = value.getIndexOf(styletest, 1)
   IF pos > 0 THEN
      LET value = value.subString(1, pos-1)," ", value.subString(pos + styletest.getLength(), value.getLength())
      
      LET w = ui.Window.getCurrent()
      LET f = w.getForm()
      CALL f.setFieldStyle(name, value.trim())
   ELSE
      # no need to remove
   END IF
   
END FUNCTION



#+ field_hidden_get Get the hidden attribute of a given field
FUNCTION field_hidden_get(name STRING) RETURNS INTEGER
DEFINE hidden INTEGER
DEFINE n om.DomNode

   LET n = field_node_get(name, FALSE)
   IF n IS NOT NULL THEN
      LET hidden = n.getAttribute("hidden")
   END IF
   IF hidden IS NULL THEN
      LET hidden = 0
   END IF
   RETURN hidden
END FUNCTION


#+ dialogType_get(fieldname) Return the dialogType attribute of current field
FUNCTION dialogType_get() RETURNS STRING
DEFINE l_field_node om.DomNode

   LET l_field_node = ui.Interface.getDocument().getElementById(ui.Interface.getRootNode().getAttribute("focus"))
   CASE
       WHEN l_field_node.getTagName() = "MenuAction"
           RETURN "Menu"
       WHEN  l_field_node IS NOT NULL 
           RETURN l_field_node.getAttribute("dialogType")
       OTHERWISE
           RETURN NULL
   END CASE
END FUNCTION



#+ topmenuoption(filename STRING) Load a topmenu file and add to it our standard File,Edit, Help entries
FUNCTION loadtopmenu_standard(filename STRING)
DEFINE w ui.Window
DEFINE f ui.Form
DEFINE doc om.DomDocument
DEFINE fn, fcn om.DomNode
DEFINE i INTEGER
DEFINE tmg, tmc om.DomNode

   LET doc = ui.Interface.getdocument()
   LET w = ui.Window.getCurrent()
   LET f = w.getForm()
   LET fn = f.getnode()
   
   CALL f.loadtopmenu(filename)
   FOR i = 1 TO fn.getChildCOunt()
      LET fcn = fn.getchildbyindex(i)
      IF fcn.gettagname() = "TopMenu" THEN
         -- Note do edit before file so can use childbyindex(1) and insertbefore
         -- Add edit topmenu group to beginning
         LET tmg = doc.createElement("TopMenuGroup")
         CALL fcn.insertBefore(tmg, fcn.getChildByIndex(1))
         CALL tmg.setAttribute("text", "Edit")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "editcut")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "editcopy")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "editpaste")
         LET tmg = doc.createElement("TopMenuGroup")
         
         -- Add file topmenu group to beginning
         CALL tmg.setAttribute("text", "File")
         CALL fcn.insertBefore(tmg, fcn.getChildByIndex(1))
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "accept")
         CALL tmc.setAttribute("text", "OK")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "cancel")
         CALL tmc.setAttribute("text", "Escape")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "print")
         CALL tmc.setAttribute("text", "Print")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "close")
         CALL tmc.setAttribute("text", "Exit Program")
        
         -- Note help is inserted at end so can use appendChild
         LET tmg = doc.createElement("TopMenuGroup")
         CALL fcn.appendChild(tmg)
         CALL tmg.setAttribute("text", "Help")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "help")
         CALL tmc.setAttribute("text", "Help")
         LET tmc = tmg.createChild("TopMenuCommand")
         CALL tmc.setAttribute("name", "about")
         CALL tmc.setAttribute("text", "About")
         
         -- Note I have simply hard-coded the entries for file,edit, help
         -- but they could be in an individual topmenu file to read as well
         -- The important thing is we should only need to define the File, Edit,
         -- and Help entries once.  If we need to make a change it is add an
         -- entry in one place only and now that it applies to all programs
         
         -- have finished so can exit
         EXIT FOR         
      END IF
   END FOR
END FUNCTION



FUNCTION windowType_get() RETURNS STRING
DEFINE w ui.Window
DEFINE wn om.DomNode
DEFINE ws STRING

    -- Look up window style, then get entry from StyleList
    LET w = ui.Window.getCurrent()
    LET wn = w.getNode()
    LET ws = wn.getAttribute("style")
    RETURN nvl(styleattribute_get("Window", ws, NULL, "windowType"), "normal")
   
END FUNCTION


-- This has not been thoroghly tested
FUNCTION styleattribute_get(element STRING, style STRING, pseudo STRING, attribute STRING)
DEFINE stylelist_node, style_node, attribute_node om.DomNode
DEFINE stylelist_list, style_list, attribute_list om.NodeList
DEFINE i, j INTEGER
DEFINE xpath STRING

    LET stylelist_list = ui.Interface.getRootNode().selectByTagName("StyleList")
    IF stylelist_list.getLength() = 1 THEN
        -- GOOD, a style has been loaded
        LET stylelist_node = stylelist_list.item(1)
    ELSE
        -- Something has gone wrong, or there is no style, get out of there.  Should we error if > 1
        -- Calling function should handle default case for nothing returned
        RETURN NULL
    END IF

    -- Precedence from http://4js.com/online_documentation/fjs-fgl-manual-html/#fgl-topics/c_fgl_presentation_styles_precedence.html
    FOR i = 1 TO 8
        CASE i 
            WHEN 1 LET xpath = SFMT("//Style[@name=\"%1.%2:%3\"]",element, style, pseudo)
            WHEN 2 LET xpath = SFMT("//Style[@name=\".%2:%3\"]",element, style, pseudo)
            WHEN 3 LET xpath = SFMT("//Style[@name=\"%1.%2\"]",element, style, pseudo)
            WHEN 4 LET xpath = SFMT("//Style[@name=\"%1:%3\"]",element, style, pseudo)
            WHEN 5 LET xpath = SFMT("//Style[@name=\":%3\"]",element, style, pseudo)
            WHEN 6 LET xpath = SFMT("//Style[@name=\".%2\"]",element, style, pseudo)
            WHEN 7 LET xpath = SFMT("//Style[@name=\"%1\"]",element, style, pseudo)
            WHEN 8 LET xpath = "//Style[@name=\"*\"]"
        END CASE
        LET style_list = stylelist_node.selectByPath(xpath)
        FOR j = 1 TO style_list.getLength()
            LET style_node = style_list.item(j)
            LET xpath =  SFMT("//StyleAttribute[@name=\"%1\"]",attribute)
            LET attribute_list = style_node.selectByPath(xpath)
            IF attribute_list.getLength() = 1 THEN
                LET attribute_node = attribute_list.item(1)
                RETURN attribute_node.getAttribute("value")
            END IF
        END FOR
    END FOR
    RETURN NULL

END FUNCTION


-- These could possibly be in a separate ui_radigroup module

PUBLIC TYPE ui_RadioGroup om.DomNode

#! Returns the om.DomNode corresponding to a RadioGroup field
FUNCTION ui_RadioGroup_forName(name STRING) RETURNS ui_RadioGroup
DEFINE rg ui_RadioGroup

DEFINE w ui.Window

    -- Find the Form Field node with the specified fieldname
    LET w = ui.Window.getCurrent()
    LET rg = w.findNode("FormField", name)
    IF rg IS NOT NULL THEN
        -- If FormField found, the first child will the widget node
        LET rg = rg.getFirstChild()
        -- Check that it is a RadioGroup, otherwise return null
        IF rg.getTagName() != "RadioGroup" THEN
            INITIALIZE rg TO NULL
        END IF
    END IF
    RETURN rg
END FUNCTION


#! Clear the child nodes of a RadioGroup node
FUNCTION ui_RadioGroup_clear(rg ui_RadioGroup)

    -- Check that we are starting with a RadioGroup node
    IF rg.getTagName() != "RadioGroup" THEN
        -- Should throw an exception here
        RETURN
    END IF
    
    -- Remove all the child node, starting at the last one
    -- and working forwards
    VAR i INTEGER
    FOR i = rg.getChildCount() TO 1 STEP -1
        CALL rg.removeChild(rg.getChildByIndex(i))
    END FOR
END FUNCTION



FUNCTION ui_RadioGroup_addItem(rg ui_RadioGroup, name STRING, text STRING)
DEFINE child om.DomNode

    -- Check that we are starting with a RadioGroup node
    IF rg.getTagName() != "RadioGroup" THEN
        -- Should throw an exception here
        RETURN
    END IF

    -- Add a new node of type Item
    LET child = rg.createChild("Item")

    -- Set the name and text attribute values
    CALL child.setAttribute("name", name)
    CALL child.setAttribute("text", text)
END FUNCTION



