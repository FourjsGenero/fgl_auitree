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
FUNCTION action_node_get(name)
DEFINE name STRING
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
FUNCTION field_node_get(name, child)
DEFINE name STRING
DEFINE child SMALLINT
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
FUNCTION field_tag_set(tag, attribute, child, value)
DEFINE tag, attribute, value STRING
DEFINE child SMALLINT
DEFINE i INTEGER
DEFINE n om.DomNode
DEFINE nl om.NodeList
DEFINE w ui.Window

   LET w = ui.Window.getCurrent()
   LET n = w.getNode()
   LET nl = n.selectByPath(SFMT("//*[@tag=\"%1\"]",tag))
   FOR i = 1 TO nl.getlength()
      LET n = nl.item(i)
      IF child THEN
         LET n = n.getfirstchild()
      END IF
      CALL n.setattribute(attribute,value)
   END FOR
END FUNCTION





#+ action_comment_set Change the comment attribute of a given action
FUNCTION action_comment_set(action, comment)
DEFINE action, comment STRING
DEFINE n om.DomNode

    CALL ui.Dialog.getCurrent().setActionComment(action, comment)
    -- Below code replaced by new setActionComment method
    --LET n = action_node_get(action)
    --IF n IS NOT NULL THEN
         --CALL n.setAttribute("comment", comment)
    --END IF
END FUNCTION

#+ action_text_set Change the text attribute of a given action
FUNCTION action_text_set(action, text)
DEFINE action, text STRING
DEFINE n om.DomNode

    CALL ui.Dialog.getCurrent().setActionText(action, text)
    -- Below code replaced by new setActionText method
    --LET n = action_node_get(action)
    --IF n IS NOT NULL THEN
        --CALL n.setAttribute("text", text)
    --END IF
END FUNCTION





#+ field_format_set Change the format attribute of a given field
FUNCTION field_format_set(name, format)
DEFINE name, format STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("format",format)
   END IF
END FUNCTION





#+ field_justify_set Set the justify attribute of a given field
FUNCTION field_justify_set(name, justify)
DEFINE name, justify STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("justify",justify)
   END IF
END FUNCTION


#+ field_width_set Set the width attribute of a given field
FUNCTION field_width_set(name, width)
DEFINE name STRING
DEFINE width INTEGER
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("width",width)
   END IF
END FUNCTION



#+ field_comment_set Set the comment attribute of a given field
FUNCTION field_comment_set(name, comment)
DEFINE name STRING
DEFINE comment STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("comment",comment)
   END IF
END FUNCTION



#+ field_comment_get Get the hidden attribute of a given field
FUNCTION field_comment_get(name)
DEFINE name STRING
DEFINE comment STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      LET comment = n.getAttribute("comment")
   END IF
   RETURN comment
END FUNCTION




#+ field_placeholdert_set Set the placeholder attribute of a given field
FUNCTION field_placeholder_set(name, placeholder)
DEFINE name STRING
DEFINE placeholder STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      CALL n.setAttribute("placeholder",placeholder)
   END IF
END FUNCTION



#+ field_placeholder_get Get the hidden attribute of a given field
FUNCTION field_placeholder_get(name)
DEFINE name STRING
DEFINE placeholder STRING
DEFINE n om.DomNode

   LET n = field_node_get(name, TRUE)
   IF n IS NOT NULL THEN
      LET placeholder = n.getAttribute("placeholder")
   END IF
   RETURN placeholder
END FUNCTION




#+ field_style_add Add a style to a space delimited list of styles
FUNCTION field_style_add(name, style)
DEFINE name STRING
DEFINE style STRING, styletest STRING
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
FUNCTION field_style_remove(name, style)
DEFINE name STRING
DEFINE style STRING, styletest STRING
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



#+ tablecolumn_title_set Set the title attribute of a given field
FUNCTION tablecolumn_title_set(name, title)
DEFINE name, title STRING
DEFINE n om.DomNode

    CALL ui.Window.getCurrent().getForm().setElementText(name, title)
    -- Below code replaced by setElementText method
    --LET n = field_node_get(name, FALSE)
    --IF n IS NOT NULL THEN
        --CALL n.setAttribute("text",title)
    --END IF
END FUNCTION



#+ button_text_set Set the title attribute of a given field
FUNCTION button_text_set(name, value)
DEFINE name, value STRING


    CALL ui.Window.getCurrent().getForm().setElementText(name, value)
END FUNCTION

#+ field_hidden_get Get the hidden attribute of a given field
FUNCTION field_hidden_get(name)
DEFINE name STRING
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


#+ dialogType_get(fieldname) Return the dialogType attribute of a given field
FUNCTION dialogType_get()
DEFINE dialogType STRING
DEFINE w ui.Window
DEFINE n,r om.DomNode
DEFINE nl om.NodeList
 
   LET n = field_node_get(FGL_DIALOG_GETFIELDNAME(), FALSE)
   IF n IS NOT NULL THEN
      LET dialogType = n.getAttribute("dialogType")
   ELSE  
      LET w = ui.Window.getCurrent()
      LET r= w.getnode()
      LET nl = r.selectByPath("//DialogInfo")
      IF nl.getlength() = 1 THEN
         LET n = nl.item(1)
         LET dialogType = n.getAttribute("dialogType")
      END IF
   END IF 
   RETURN dialogType
END FUNCTION

#+ topmenuoption(filename STRING) Load a topmenu file and add to it our standard File,Edit, Help entries
FUNCTION loadtopmenu_standard(filename)
DEFINE filename STRING
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