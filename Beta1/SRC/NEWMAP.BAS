CLS
DIM text$(1000) 'may need to be up to 5000
dir$ = "c:\mydocu~1\programs\explor\"
OPEN dir$ + "maps.dat" FOR INPUT AS #1

FOR i = 1 TO 20
        INPUT #1, text$(i)
NEXT i
FOR i = 1 TO 20
        PRINT text$(i)
NEXT i
CLOSE #1
'OPEN dir$ + "new.txt" FOR APPEND AS #1
'a$ = "You Rock!"
'WRITE #1, a$
'CLOSE #1
'The following code will check any coordinated on the map and return
'what the value is.  In this case if the value is an X it returns one
'message where as if the value is anything else it returns a different
'message.  I plan on using this code for the map in Explor.  Or else I
'will convert this code to C and redo Explor as I plan.

x = 3
y = 3
IF MID$(text$(y), x, 1) = "X" THEN
        PRINT "Cool"
ELSE PRINT "Un-Cool"
END IF


