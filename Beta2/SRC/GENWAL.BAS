''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''  This program generates wall images then saves them in the       '''
'''       current\images\ directory.  Each wall is labeled the same  '''
'''       as the wall name described in notes.                       '''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SCREEN 13
wcolor = 8
dir$ = "c:\mydocu~1\programs\explor\redo\"
'dir$ = ""
DIM wall2(1 TO 950), wall3(1 TO 950), wall1(1 TO 2600)
DIM wall4(1 TO 950), wall5(1 TO 650), wall6(1 TO 650), wall7(1 TO 650)
DIM wall8(1 TO 160), wall9(1 TO 325), wall10(1 TO 160)
DIM wall11(1 TO 300), wall12(1 TO 150)

'Row One
'wall2
        CLS
        LINE (1, 1)-(25, 25)
        LINE (1, 1)-(1, 150)
        LINE (25, 25)-(25, 125)
        LINE (25, 125)-(1, 150)
        PAINT (2, 5), wcolor, 15
        LINE (1, 47)-(25, 58)
        LINE (1, 101)-(25, 91)
        GET (1, 1)-(25, 150), wall2

DEF SEG = VARSEG(wall2(1))
BSAVE dir$ + "images\" + "wall2.img", VARPTR(wall2(1)), (950 * 4)
DEF SEG

'Wall3
        CLS
        LINE (1, 25)-(25, 1)
        LINE (1, 25)-(1, 125)
        LINE (25, 1)-(25, 150)
        LINE (25, 150)-(1, 125)
        PAINT (5, 50), wcolor, 15
        LINE (25, 101)-(1, 91)
        LINE (25, 47)-(1, 58)
        GET (1, 1)-(25, 150), wall3
        CLS

DEF SEG = VARSEG(wall3(1))
BSAVE dir$ + "images\" + "wall3.img", VARPTR(wall3(1)), (950 * 4)
DEF SEG


'Row In Front
        CLS
'        wall1
        LINE (1, 1)-(100, 100), 15, B
        PAINT (5, 5), wcolor, 15
        LINE (1, 33)-(100, 33)
        LINE (1, 66)-(100, 66)
        LINE (50, 1)-(50, 33)
        LINE (50, 66)-(50, 100)
        GET (1, 1)-(100, 100), wall1
        CLS

DEF SEG = VARSEG(wall1(1))
BSAVE dir$ + "images\" + "wall1.img", VARPTR(wall1(1)), (2600 * 4)
DEF SEG

        CLS
'        wall4
        LINE (1, 1)-(25, 100), 15, B
        PAINT (5, 5), wcolor, 15
        LINE (1, 33)-(25, 33)
        LINE (1, 66)-(25, 66)
        GET (1, 1)-(25, 100), wall4
        CLS

DEF SEG = VARSEG(wall4(1))
BSAVE dir$ + "images\" + "wall4.img", VARPTR(wall4(1)), (950 * 4)
DEF SEG


'       wall5
        LINE (1, 1)-(1, 100)
        LINE (1, 1)-(25, 25)
        LINE (25, 25)-(25, 75)
        LINE (1, 100)-(25, 75)
        PAINT (2, 5), wcolor, 15
        LINE (1, 33)-(25, 42)
        LINE (1, 66)-(25, 58)
        LINE (17, 17)-(17, 39)
        LINE (17, 61)-(17, 83)
        GET (1, 1)-(25, 100), wall5
        CLS

DEF SEG = VARSEG(wall5(1))
BSAVE dir$ + "images\" + "wall5.img", VARPTR(wall5(1)), (650 * 4)
DEF SEG

'       wall6
        LINE (1, 25)-(25, 1)
        LINE (1, 25)-(1, 75)
        LINE (1, 75)-(25, 100)
        LINE (25, 100)-(25, 1)
        PAINT (5, 50), wcolor, 15
        LINE (1, 42)-(25, 33)
        LINE (1, 58)-(25, 66)
        LINE (8, 18)-(8, 39)
        LINE (8, 61)-(8, 82)
        GET (1, 1)-(25, 100), wall6

DEF SEG = VARSEG(wall6(1))
BSAVE dir$ + "images\" + "wall6.img", VARPTR(wall6(1)), (650 * 4)
DEF SEG

'2nd Row Back
'       wall7
        CLS
        LINE (1, 1)-(50, 50), 15, B
        PAINT (2, 2), wcolor, 15
        LINE (1, 17)-(50, 17)
        LINE (1, 34)-(50, 34)
        LINE (25, 1)-(25, 17)
        LINE (25, 34)-(25, 50)
        GET (1, 1)-(50, 50), wall7

DEF SEG = VARSEG(wall7(1))
BSAVE dir$ + "images\" + "wall7.img", VARPTR(wall7(1)), (650 * 4)
DEF SEG

'       wall8
        CLS
        LINE (1, 1)-(12, 12)
        LINE (1, 1)-(1, 50)
        LINE (1, 50)-(12, 37)
        LINE (12, 38)-(12, 12)
        PAINT (2, 5), wcolor, 15
        LINE (1, 16)-(12, 20)
        LINE (1, 34)-(12, 28)
        LINE (8, 9)-(8, 19)
        LINE (8, 30)-(8, 41)
        GET (1, 1)-(12, 50), wall8

DEF SEG = VARSEG(wall8(1))
BSAVE dir$ + "images\" + "wall8.img", VARPTR(wall8(1)), (160 * 4)
DEF SEG

'       wall9
        CLS
        LINE (1, 1)-(25, 50), 15, B
        PAINT (2, 2), wcolor, 15
        LINE (1, 17)-(25, 17)
        LINE (1, 34)-(25, 34)
        GET (1, 1)-(25, 50), wall9

DEF SEG = VARSEG(wall9(1))
BSAVE dir$ + "images\" + "wall9.img", VARPTR(wall9(1)), (325 * 4)
DEF SEG

'       wall10
        CLS
        LINE (12, 1)-(1, 12)
        LINE (1, 12)-(1, 38)
        LINE (1, 38)-(12, 50)
        LINE (12, 50)-(12, 1)
        PAINT (10, 5), wcolor, 15
        LINE (1, 20)-(12, 16)
        LINE (1, 28)-(12, 34)
        GET (1, 1)-(12, 50), wall10

DEF SEG = VARSEG(wall10(1))
BSAVE dir$ + "images\" + "wall10.img", VARPTR(wall10(1)), (160 * 4)
DEF SEG

'       wall11
        CLS
        LINE (1, 1)-(25, 25), 15, B
        PAINT (2, 2), wcolor, 15
        LINE (1, 8)-(25, 8)
        LINE (1, 17)-(25, 17)
        LINE (13, 1)-(13, 8)
        LINE (13, 17)-(13, 25)
        GET (1, 1)-(25, 25), wall11

DEF SEG = VARSEG(wall11(1))
BSAVE dir$ + "images\" + "wall11.img", VARPTR(wall11(1)), (300 * 4)
DEF SEG

'       wall12
        CLS
        LINE (1, 1)-(12, 25), 15, B
        PAINT (2, 2), wcolor, 15
        LINE (1, 17)-(12, 17)
        LINE (1, 8)-(12, 8)
        GET (1, 1)-(12, 25), wall12
CLS

DEF SEG = VARSEG(wall12(1))
BSAVE dir$ + "images\" + "wall12.img", VARPTR(wall12(1)), (150 * 4)
DEF SEG

