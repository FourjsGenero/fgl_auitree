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