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
#       arraycopy.4gl Example Genero 4GL code to copy entire array to clipboard
#
#       December 2008 reuben
#

#+
#+ arraycopy.4gl Copy array to clipboard function (copy_entire_array) and private
#+               functions needed by this routine
#+


TYPE col_map_Type RECORD
   idx INTEGER,
   format STRING
END RECORD 

#+ Copy entire array to the clipboard inluding any changes to the sort order,
#+ column order, hidden columns, column headers.
#+
#+ Copies the entire array used in a DYNAMIC ARRAY or INPUT ARRAY statement to the clipboard
#+ respecting the row/column order of the displayed array.  Differs from built-in 
#+ functions in Genero versions 2.1 and earlier in that it takes the whole array,
#+ not just the visible part of the array.  
#+
#+ @code
#+ DEFINE arr DYNAMIC ARRAY OF RECORD
#+    ...
#+ END RECORD
#+ DEFINE doc om.DomDocument
#+ DEFINE root_node, table_node om.DomNode
#+ DEFINE id INTEGER
#+
#+ DISPLAY ARRAY arr TO scr.*
#+    ON ACTION copy_entire_array
#+       LET doc = ui.Interface.getdocument()
#+       LET root = doc.getdocumentelement()
#+       LET id = root.getAttribute("focus")
#+       LET table_node = doc.getelementbyid(id)
#+       CALL copy_entire_array(base.TypeInfo.create(arr),table_node,TRUE)
#+
#+ @param array_node om.DomNode The root node of the base.TypeInfo of the program array
#+ @param table_node om.DomNode The table node of the array in the AUI tree
#+ #param do_headings_flag SMALLINT TRUE/FALSE to indicate if table column headings
#+                                  should be copied to the clipboard
#+
FUNCTION copy_entire_array(array_node, table_node, do_headings_flag)
DEFINE array_node,table_node, record_node,field_node, table_column_node om.DomNode
DEFINE do_headings_flag SMALLINT
DEFINE i,j,result INTEGER
DEFINE sb base.StringBuffer
DEFINE row_map DYNAMIC ARRAY OF INTEGER
DEFINE col_map DYNAMIC ARRAY OF col_map_Type
DEFINE value STRING

   LET sb = base.StringBuffer.create()

   -- Populate the mapping arrays with the pointers to each column and row in
   -- the array
   CALL init_row_map(row_map, array_node, table_node)
   CALL init_col_map(col_map, array_node, table_node)
   
   IF do_headings_flag THEN
      -- do column headings
      FOR j = 1 TO col_map.getLength()
         LET table_column_node = table_node.getChildByIndex(col_map[j].idx)
         CALL sb.append(table_column_node.getAttribute("text"))
         IF j = col_map.getLength() THEN
            -- end of line delimiter
            CALL sb.append(ASCII(10))
         ELSE
            -- field delimiter
            CALL sb.append(ASCII(9))
         END IF
      END FOR
   END IF

   FOR i = 1 TO row_map.getLength()
      LET record_node = array_node.getchildbyindex(row_map[i])
      FOR j = 1 TO col_map.getLength()
         -- Add the value to the stringbuffer taking into account the format
         -- attribute if there is one.
         -- In order to use the format attribute have to turn the variable into
         -- a type that matches the format, hence the use of 0+ and DATE() 
         LET field_node = record_node.getChildByIndex(col_map[j].idx)
         IF col_map[j].format IS NOT NULL THEN
            CASE simplify_datatype(field_node.getAttribute("type"))
               WHEN "numeric"
                  LET value = (0+field_node.getAttribute("value")) USING col_map[j].format
               WHEN "date"
                  LET value = DATE(field_node.getAttribute("value")) USING col_map[j].format    
               OTHERWISE
                  LET value = field_node.getAttribute("value") USING col_map[j].format
            END CASE
         ELSE
            LET value = field_node.getAttribute("value")
         END IF
         CALL sb.append(value)
         
         IF j = col_map.getLength() THEN
            -- end of line delimiter
            CALL sb.append(ASCII(10))
         ELSE
            -- end of field delimiter
            CALL sb.append(ASCII(9))
         END IF
      END FOR      
   END FOR
   
   -- Clear the clipboard and add the result
   CALL ui.Interface.FrontCall("standard","cbclear", [],result)
   CALL ui.Interface.FrontCall("standard","cbset", sb.tostring(),result)
END FUNCTION



#+ Initialise the row map reference array 
#+
#+ Populates the row map reference array with pointers to indicate what 
#+ actual row is the first row, what actual row is the second row in the 
#+ screen array etc.  Once completed, row_map[i].idx indicates the index of the 
#+ ith row in the screen array.  
#+
#+ @code
#+ DEFINE row_map DYNAMIC ARRAY OF INTEGER
#+ DEFINE array_node om.DomNode
#+ DEFINE table_node om.DomNode
#+ CALL init_row_map(col_map, array_node, table_node)
#+
#+ @param col_map DYNAMIC ARRAY OF INTEGER 
#+ @param array_node om.DomNode The root node of the base.TypeInfo of the program array
#+ @param table_node om.DomNode The table node of the array in the AUI tree
#+
#+ @return col_map is now populated
#+
PRIVATE FUNCTION init_row_map(row_map, array_node, table_node)
DEFINE row_map DYNAMIC ARRAY OF INTEGER
TYPE sortType RECORD
   idx INTEGER,
   string STRING,
   number FLOAT,
   date DATE,
   datetime DATETIME YEAR TO FRACTION(4)
END RECORD
DEFINE sort DYNAMIC ARRAY OF sortType
DEFINE swap sortType
DEFINE sort_column INTEGER
DEFINE sort_type STRING
DEFINE sort_datatype STRING
DEFINE array_node, record_node, table_node, field_node om.DomNode
DEFINE i,j INTEGER
DEFINE row_count INTEGER
DEFINE swap_flg SMALLINT

   LET row_count = array_node.getChildCount()
  
   LET sort_column = table_node.getAttribute("sortColumn")
   IF sort_column IS NULL THEN
      LET sort_column = -1
   END IF
   
   LET sort_type = table_node.getAttribute("sortType")
   IF sort_type IS NULL THEN
      LET sort_type = "asc"
   END IF
   
   IF sort_column = -1 THEN
      -- Set the initial order equal to index value and exit
      FOR i = 1 TO row_count
         LET row_map[i] = i
      END FOR
      
   ELSE
      -- First column is 0 so add 1 to match our indexes
      LET sort_column = sort_column + 1
      
      LET record_node = array_node.getChildByIndex(1)
      LET field_node = record_node.getChildByIndex(sort_column)
      LET sort_datatype = simplify_datatype(field_node.getAttribute("type"))
       -- Populate with sort values
      FOR i = 1 TO row_count
         LET record_node = array_node.getChildByIndex(i)
         LET field_node = record_node.getChildByIndex(sort_column)
         LET sort[i].idx = i
         LET sort[i].string = field_node.getAttribute("value")
         WHENEVER ANY ERROR CONTINUE
         CASE sort_datatype
            WHEN "numeric"
               LET sort[i].number = field_node.getAttribute("value")
            WHEN "date"
               LET sort[i].date = field_node.getAttribute("value")
         END CASE
         WHENEVER ANY ERROR STOP
      END FOR
       FOR i = 1 TO row_count
         FOR j = (i+1) TO row_count
            LET swap_flg = FALSE
            CASE sort_datatype
               WHEN "numeric"
                  IF sort[i].number > sort[j].number THEN
                     LET swap_flg = TRUE
                  END IF
               WHEN "date"
                  IF sort[i].date > sort[j].date THEN
                     LET swap_flg = TRUE
                  END IF
               OTHERWISE -- well just use string comparison
                  IF sort[i].string > sort[j].string THEN
                     LET swap_flg = TRUE
                  END IF
            END CASE
             -- In the event of a tie, the row with the lesser index will be first
            -- This is the same rule used by Genero
            IF NOT swap_flg THEN
               IF sort[i].string = sort[j].string THEN
                  IF sort[i].idx > sort[j].idx THEN
                     LET swap_flg = TRUE
                  END IF
               END IF
            END IF
            IF swap_flg THEN
               LET swap.* = sort[j].*
               LET sort[j].* = sort[i].*
               LET sort[i].* = swap.*
            END IF
         END FOR
      END FOR
      FOR i = 1 TO row_count
         LET row_map[i] = sort[i].idx
      END FOR

      -- Reverse order if sortType is desc
      IF sort_type = "desc" THEN
         FOR i = 1 TO row_count/2
            LET j = row_map[row_count-i+1]
            LET row_map[row_count-i+1] = row_map[i]
            LET row_map[i] = j
         END FOR
      END IF
   END IF
END FUNCTION



#+ Initialise the column map reference array 
#+
#+ Populates the column map reference array with pointers to indicate what 
#+ column is the first column, what actual column is the second column in the 
#+ screen array etc.  Once completed, col_map[i].idx indicates the index of the 
#+ ith visible column in the screen array.  col_map[i].format indicates the 
#+ format of this column
#+
#+ @code
#+ DEFINE col_map DYNAMIC ARRAY OF col_map_type
#+ DEFINE array_node om.DomNode
#+ DEFINE table_node om.DomNode
#+ CALL init_col_map(col_map, array_node, table_node)
#+
#+ @param col_map DYNAMIC ARRAY OF col_map 
#+ @param array_node om.DomNode The root node of the base.TypeInfo of the program array
#+ @param table_node om.DomNode The table node of the array in the AUI tree
#+
#+ @return col_map is now populated
#+
PRIVATE FUNCTION init_col_map(col_map, array_node, table_node)
DEFINE col_map DYNAMIC ARRAY OF col_map_Type
DEFINE array_node , record_node, table_node, table_column_node, table_column_widget_node om.DomNode
DEFINE i,j INTEGER
DEFINE col_count INTEGER
TYPE sortType RECORD
   idx INTEGER,
   tabIndex INTEGER,
   hidden INTEGER,
   format STRING
END RECORD
DEFINE sort DYNAMIC ARRAY OF sortType
DEFINE swap sortType

   LET record_node = array_node.getChildByIndex(1)
   FOR i = 1 TO record_node.getChildCount()
      LET table_column_node = table_node.getchildbyindex(i)
      
      LET sort[i].idx = i
      LET sort[i].tabIndex = table_column_node.getAttribute("tabIndex")
      LET sort[i].hidden = table_column_node.getAttribute("hidden")
      LET table_column_widget_node = table_column_node.getChildByIndex(1)
      LET sort[i].format = table_column_widget_node.getAttribute("format")
   END FOR
   
   -- Remove hidden columns from consideration
   LET col_count = sort.getLength()
   FOR i = col_count TO 1 STEP -1
      IF sort[i].hidden = 1 THEN
         CALL sort.deleteElement(i)
      END IF
      IF sort[i].hidden = 2 THEN
         CALL sort.deleteElement(i)
      END IF
   END FOR
   
   -- Swap columns if tabIndex greater
   LET col_count = sort.getLength()
   
   FOR i = 1 TO col_count
      FOR j = (i+1) TO col_count
         IF sort[i].tabIndex > sort[j].tabIndex THEN
            LET swap.* = sort[i].*
            LET sort[i].* = sort[j].*
            LET sort[j].* = swap.* 
         END IF
      END FOR
   END FOR
   
   -- Pass values into col_map
   FOR i = 1 TO col_count
      LET col_map[i].idx = sort[i].idx
      LET col_map[i].format = sort[i].format
   END FOR
END FUNCTION



#+ Identify whether the 4GL datatype is a number, date, else a string 
#+
#+ This function breaks a 4GL data type into one of three broad categorites,
#+ either it is numeric, a date, or a string.  We don't distinguish datetime
#+ from string as they have the same sort order
#+
#+ @code
#+ CASE simplify_datatype(field_node.getAttribute("type")
#+    WHEN "numeric"
#+    WHEN "date"
#+    OTHERWISE
#+ END CASE
#+
#+ @param datatype string  4GL Data type e.g. INTEGER, DECIMAL(11,2), STRING, DATE etc.
#+
#+ @return simple_datatype string Either numeric, date, or string
#+
PRIVATE FUNCTION simplify_datatype(datatype)
DEFINE datatype, simple_datatype STRING
   CASE
      WHEN datatype = "INTEGER" 
         OR datatype = "SMALLINT" 
         OR datatype MATCHES "DEC*"
         OR datatype MATCHES "FLOAT*"
         OR datatype MATCHES "REAL*"
         OR datatype MATCHES "DOUBLE*"
         OR datatype MATCHES "SMALLFLOAT"
         OR datatype MATCHES "MONEY*"
         LET simple_datatype = "numeric"
      WHEN datatype = "DATE"
         LET simple_datatype = "date"
      OTHERWISE
         LET simple_datatype = "string"
    END CASE
    RETURN simple_datatype
 END FUNCTION