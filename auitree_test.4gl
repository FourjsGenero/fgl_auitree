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
#       auitree_test.4gl Example Genero 4GL code to copy entire array to clipboard
#
#       December 2008 reuben
#

IMPORT util

IMPORT FGL auitree
IMPORT FGL arraycopy


DEFINE topmenugroup STRING
DEFINE topmenuarray DYNAMIC ARRAY OF RECORD
   topmenucommand, topmenuaction STRING
END RECORD
   
MAIN

DEFINE svalue DECIMAL
DEFINE dummy, dummy2, dummy3 STRING

DEFINE where_clause STRING
DEFINE inputfield CHAR(10)

DEFINE tcode01, tcode02 CHAR(10)
DEFINE tdesc01, tdesc02 CHAR(30)

DEFINE sfield01, sfield02, sfield03 INTEGER

DEFINE cpfield01 STRING
DEFINE comment_value, placeholder_value STRING

DEFINE w ui.Window
DEFINE f ui.Form
DEFINE r om.DomNode
DEFINE d om.DomDocument

DEFINE arrcopy DYNAMIC ARRAY OF RECORD
   accode CHAR(10),
   acdesc CHAR(40),
   acactual DECIMAL(11,2),
   acbudget DECIMAL(11,2),
   acvariance DECIMAL(11,2),
   aclastuseddate DATE,
   aclastusedtime DATETIME HOUR TO SECOND,
   aclastuseddatetime DATETIME YEAR TO SECOND
END RECORD
DEFINE i,j, size, len INTEGER
DEFINE dialogtype_display_arr DYNAMIC ARRAY OF RECORD
    display_field STRING
END RECORD
DEFINE dialogtype_input_arr DYNAMIC ARRAY OF RECORD
    input_field STRING
END RECORD
DEFINE styleattribute_value STRING

   OPTIONS FIELD ORDER FORM
   OPTIONS INPUT WRAP
   CLOSE WINDOW SCREEN
   
   CALL ui.Interface.LoadStyles("auitree_test.4st")
      
   LET svalue = 0
   
      -- populate random sized array with random data
   LET size = util.Math.rand(100)+100
   FOR i = 1 TO size
      FOR j = 1 TO 3
         LET arrcopy[i].accode[j] = ASCII(util.Math.rand(26)+65)
      END FOR
      LET len = util.Math.rand(4) + 8
      LET arrcopy[i].acdesc[1] = ASCII(util.Math.rand(26)+65)
      FOR j = 2 TO len
         LET arrcopy[i].acdesc[j] = ASCII(util.Math.rand(26)+97)
      END FOR
      LET arrcopy[i].acbudget = util.Math.rand(100000)/100
      LET arrcopy[i].acactual = arrcopy[i].acbudget * (0.5+ util.Math.rand(10000)/10000)
      LET arrcopy[i].acvariance = arrcopy[i].acactual - arrcopy[i].acbudget
      LET arrcopy[i].aclastuseddate = TODAY - (util.Math.rand(365))
      LET arrcopy[i].aclastusedtime = EXTEND(SFMT("%1:%2:%3",util.Math.rand(24),util.Math.rand(60),util.Math.rand(60)),HOUR TO SECOND)
      LET arrcopy[i].aclastuseddatetime = EXTEND(SFMT("%1-%2-%3 %4", YEAR(arrcopy[i].aclastuseddate), MONTH(arrcopy[i].aclastuseddate), DAY(arrcopy[i].aclastuseddate), arrcopy[i].aclastusedtime), YEAR TO SECOND)
   END FOR
   LET dialogtype_display_arr[1].display_field = "Display Array Test"
   LET dialogtype_input_arr[1].input_field = "Input Array Test"
   

   
   OPEN WINDOW auitree_test WITH FORM "auitree_test" 
   
   LET d = ui.Interface.getdocument()
   LET r = d.getdocumentelement()
   LET w = ui.Window.getCurrent()
   LET f= w.getForm()

   CALL field_width_set("accode",3)
   CALL field_width_set("acdesc",15)
   
   CALL auitree.loadtopmenu_standard("auitree_test")
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      -- First folder page
      INPUT dummy FROM dummy 
      END INPUT
       
      -- Toggle the hidden attribute of the containers
      INPUT dummy2 FROM dummy2
      BEFORE INPUT
         
         ON ACTION toggle_vbx1
            CALL f.setElementHidden("vbx1",1-auitree.field_hidden_get("vbx1"))
            
         ON ACTION toggle_hbx1
            CALL f.setElementHidden("hbx1",1-auitree.field_hidden_get("hbx1"))
            
         ON ACTION toggle_hbx2
            CALL f.setElementHidden("hbx2",1-auitree.field_hidden_get("hbx2"))
            
         ON ACTION toggle_grp11
            CALL f.setElementHidden("grp11",1-auitree.field_hidden_get("grp11"))
            
         ON ACTION toggle_grp12
            CALL f.setElementHidden("grp12",1-auitree.field_hidden_get("grp12"))
            
         ON ACTION toggle_grp21
            CALL f.setElementHidden("grp21",1-auitree.field_hidden_get("grp21"))
            
         ON ACTION toggle_grp22
            CALL f.setElementHidden("grp22",1-auitree.field_hidden_get("grp22"))
            
         ON ACTION toggle_grd11
            CALL f.setElementHidden("grd11",1-auitree.field_hidden_get("grd11"))
            
         ON ACTION toggle_grd12
            CALL f.setElementHidden("grd12",1-auitree.field_hidden_get("grd12"))
            
         ON ACTION toggle_grd21
            CALL f.setElementHidden("grd21",1-auitree.field_hidden_get("grd21"))
           
         ON ACTION toggle_grd22
            CALL f.setElementHidden("grd22",1-auitree.field_hidden_get("grd22"))
            
         
      END INPUT
      
      CONSTRUCT BY NAME where_clause ON constructfield
         ON ACTION dialogtype
            MESSAGE auitree.dialogType_get()
      END CONSTRUCT
      INPUT inputfield FROM inputfield ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         ON ACTION dialogtype
            MESSAGE auitree.dialogType_get()
      END INPUT
      DISPLAY ARRAY dialogtype_display_arr TO dialogtype_display_scr.*
        ON ACTION dialogtype  ATTRIBUTES(DEFAULTVIEW=YES, TEXT="Test")
            MESSAGE auitree.dialogType_get()
      END DISPLAY
      INPUT ARRAY dialogtype_input_arr FROM dialogtype_input_scr.*  ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        ON ACTION dialogtype  ATTRIBUTES(DEFAULTVIEW=YES, TEXT="Test")
            MESSAGE auitree.dialogType_get()
      END INPUT
      -- Use the tag attribute to show/hide more than one screen widget at a 
      -- time.
      INPUT tcode01, tdesc01, tcode02, tdesc02, dummy3  FROM tcode01, tdesc01, tcode02, tdesc02, dummy3 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
            LET tcode01 = "100"
            LET tdesc01 = "One Hundred"
            LET tcode02 = "200"
            LET tdesc02 = "Two Hundred"
         ON ACTION show_field01
            CALL auitree.field_tag_set("tfield01", "hidden", FALSE, 0)
         ON ACTION hide_field01
            CALL auitree.field_tag_set("tfield01", "hidden", FALSE, 1)
         ON ACTION show_field02
            CALL auitree.field_tag_set("tfield02", "hidden", FALSE, 0)
         ON ACTION hide_field02
            CALL auitree.field_tag_set("tfield02", "hidden", FALSE, 1)
      END INPUT
   
      -- Array from which we can test the copy entire array functionality
      DISPLAY ARRAY arrcopy TO arrcopy.*
         ON ACTION copyentirearraywithheadings
            CALL arraycopy.copy_entire_array(base.TypeInfo.create(arrcopy), d.getelementbyid(r.getAttribute("focus")),TRUE)
         
         ON ACTION copyentirearraywithoutheadings
            CALL arraycopy.copy_entire_array(base.TypeInfo.create(arrcopy), d.getelementbyid(r.getAttribute("focus")),FALSE)

         ON ACTION displayentirearraywithheadingstowindow
            CALL arraycopy.copy_entire_array(base.TypeInfo.create(arrcopy), d.getelementbyid(r.getAttribute("focus")),TRUE)
            CALL display_clipboard_to_window()

         ON ACTION selectiontostring
            CALL selection_to_string(DIALOG,"arrcopy")
      END DISPLAY
      
      -- Fields to enter values and have the style changed based on the value
      INPUT sfield01, sfield02, sfield03 FROM sfield01, sfield02, sfield03 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
            CALL addremovestyle_process("sfield02", addremovestyle_valid(sfield02))
            CALL addremovestyle_process("sfield03", addremovestyle_valid(sfield03))
         
         ON ACTION dialogtouched
            CASE FGL_DIALOG_GETFIELDNAME()
               WHEN "sfield02" CALL addremovestyle_process("sfield02", addremovestyle_valid(FGL_DIALOG_GETBUFFER()))
               WHEN "sfield03" CALL addremovestyle_process("sfield03", addremovestyle_valid(FGL_DIALOG_GETBUFFER()))  
            END CASE
      END INPUT

      INPUT BY NAME cpfield01 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
        ON ACTION comment_set
            PROMPT "Enter comment" For comment_value
            CALL auitree.field_comment_set("cpfield01", comment_value)
        ON ACTION placeholder_set
            PROMPT "Enter placeholder" For placeholder_value
            CALL auitree.field_placeholder_set("cpfield01", placeholder_value)
        ON ACTION get
            CALL FGL_WINMESSAGE("Info",SFMT("Comment=%1, Placeholder=%2", auitree.field_comment_get("cpfield01"), auitree.field_placeholder_get("cpfield01")),"info")
      END INPUT

      ON ACTION menu_test ATTRIBUTES(TEXT="Menu Test")
        MENU ""
            ON ACTION dialogtype ATTRIBUTES(DEFAULTVIEW=YES, TEXT="Test")
                MESSAGE auitree.dialogType_get()
            ON ACTION exit ATTRIBUTES(TEXT="Exit")
                EXIT MENU
        END MENU

        ON ACTION stylereader_window_normal 
           OPEN WINDOW dc WITH FORM "displayclipboardtowindow" ATTRIBUTES(TEXT="Test windowType Style Attibute")
            MENU ""
                ON ACTION test
                    LET styleattribute_value = auitree.windowtype_get()
                    CALL FGL_WINMESSAGE("Info",SFMT("windowType=%1",styleattribute_value),"info")
                    EXIT MENU
                ON ACTION close
                    EXIT MENU
            END MENU
            CLOSE WINDOW dc

        ON ACTION stylereader_window_dialog 
            OPEN WINDOW dc WITH FORM "displayclipboardtowindow"  ATTRIBUTES(TEXT="Test windowType Style Attibute", STYLE="dialog")
            MENU ""
                ON ACTION test
                    LET styleattribute_value = auitree.windowtype_get()
                    CALL FGL_WINMESSAGE("Info",SFMT("windowType=%1",styleattribute_value),"info")
                    EXIT MENU
                ON ACTION close
                    EXIT MENU
            END MENU
            CLOSE WINDOW dc

        

      ON ACTION close
         EXIT DIALOG
  
   END DIALOG
  
   CLOSE WINDOW auitree_test
END MAIN



FUNCTION addremovestyle_process(fieldname, valid)
DEFINE fieldname STRING
DEFINE valid SMALLINT

   IF valid THEN
      CALL auitree.field_style_remove(fieldname, "invalid")
   ELSE
      CALL auitree.field_style_add(fieldname, "invalid")
   END IF 

END FUNCTION




FUNCTION addremovestyle_valid(value)
DEFINE value INTEGER

   IF value > 0 THEN
      #OK
   ELSE
      RETURN FALSE
   END IF
   
   IF value MOD 2 = 0 THEN
      #Ok
   ELSE
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION