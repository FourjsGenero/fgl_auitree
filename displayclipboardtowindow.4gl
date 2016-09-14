--If cbget frontcall not available in Web, use selection_to_string technique
FUNCTION display_clipboard_to_window()
DEFINE s STRING
DEFINE sb base.StringBuffer

    LET sb = base.StringBuffer.create()
    CALL sb.append("<table><tr><td>")
    CALL sb.append(s)
    CALL sb.append("</table>")
    CALL sb.replace(ASCII(9),"</td><td>", 0)
    CALL sb.replace(ASCII(10),"</td></tr><tr><td>", 0)
    CALL ui.Interface.frontCall("standard","cbget","",s)
    OPEN WINDOW w WITH FORM "displayclipboardtowindow"
    INPUT s FROM clipboard ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
    LET int_flag = 0
    CLOSE WINDOW w
END FUNCTION



FUNCTION selection_to_string(d, name)
DEFINE d ui.Dialog
DEFINE name STRING
DEFINE s STRING

    -- Have a look at copyall functionality in fgl_zoom example if you have
    -- multi row sleection already enabled and want to preserve selected rows
    CALL d.setSelectionMode(name,1)
    CALL d.setSelectionRange(name,1,-1,1)
    LET s = d.selectionToString(name)
    
    OPEN WINDOW w WITH FORM "displayclipboardtowindow" ATTRIBUTES(TEXT="Select and Copy")
    INPUT s FROM clipboard ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
    LET int_flag = 0
    CLOSE WINDOW w

    CALL d.setSelectionMode(name, 0)
END FUNCTION