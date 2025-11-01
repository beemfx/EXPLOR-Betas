''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''   CREDIT.BAS                                                       '''
'''                                                                    '''
'''     Copyright (c) 2001, Blaine Myers, Beem Software                '''
'''                                                                    '''
'''  Credits opens the stated file and scrolls it up the screen        '''
'''  like the credits in a movie.  A credit file is a simple text file '''
'''  you can add a color by writing COLOR # at the begining of the line'''
'''  supports color 1 to 15. Typing // at the beggining of a line will '''
'''  ignore that line.  Credits may be as many lines as the size of    '''
'''  clist$                                                            '''
'''                                                                    '''
''' IMPORTANT NOTE: Credit files must have END written when the credits'''
'''                 should be terminated.  If END does not appear an   '''
'''                 error will occur.                                  '''
'''                                                                    '''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DECLARE SUB credits (file$)

SCREEN 13

' Make the following line a remark when compiling
CHDIR "c:\mydocu~1\programs\explor\redo\"
credits ("credit.txt")

SUB credits (file$)
DIM clist$(1000)
ctq = 1
OPEN file$ FOR INPUT AS #5
listlen = 0
DO
    listlen = listlen + 1
    LINE INPUT #5, clist$(listlen)
'   PRINT clist$(listlen)
'   FOR p = 1 TO 100000: NEXT
LOOP UNTIL clist$(listlen) = "END"
CLOSE #5
listlen = listlen - 1
CLS
LOCATE 24, 1
FOR i = 1 TO listlen '110
IF (LEFT$(clist$(i), 5) = "COLOR") THEN
'   PRINT MID$(clist$(i), 7, 3)
   IF MID$(clist$(i), 7, 2) = "1" THEN COLOR 1
   IF MID$(clist$(i), 7, 2) = "2" THEN COLOR 2
   IF MID$(clist$(i), 7, 2) = "3" THEN COLOR 3
   IF MID$(clist$(i), 7, 2) = "4" THEN COLOR 4
   IF MID$(clist$(i), 7, 2) = "5" THEN COLOR 5
   IF MID$(clist$(i), 7, 2) = "6" THEN COLOR 6
   IF MID$(clist$(i), 7, 2) = "7" THEN COLOR 7
   IF MID$(clist$(i), 7, 2) = "8" THEN COLOR 8
   IF MID$(clist$(i), 7, 2) = "9" THEN COLOR 9
   IF MID$(clist$(i), 7, 2) = "10" THEN COLOR 10
   IF MID$(clist$(i), 7, 2) = "11" THEN COLOR 11
   IF MID$(clist$(i), 7, 3) = "12" THEN COLOR 12
   IF MID$(clist$(i), 7, 3) = "13" THEN COLOR 13
   IF MID$(clist$(i), 7, 3) = "14" THEN COLOR 14
   IF MID$(clist$(i), 7, 3) = "15" THEN COLOR 15
ELSEIF LEFT$(clist$(i), 2) = "//" THEN
  'Just ignore it
ELSE
   FOR j = 1 TO 200000: NEXT
   PRINT clist$(i)
   IF INKEY$ = CHR$(27) THEN
      i = listlen
      ctq = 10
   END IF
END IF
NEXT

IF ctq = 10 THEN
        'NOthing
ELSE
   FOR i = 1 TO 24
      FOR j = 1 TO 200000: NEXT
   PRINT ""
   IF INKEY$ = CHR$(27) THEN i = 24
NEXT
END IF
COLOR 15
CLS

END SUB

