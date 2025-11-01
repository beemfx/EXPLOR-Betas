'I've edited DEGIF6.BAS by Rich Geldreich and made it into a sub form that
'will easily allow me to incorporate it into other programs.  Think of it
'I can easily add cool logos to my games. Probably can easily be used to
'load a sheet of usable graphics us the GET function to get them at the
'proper coordinates. And use them later with PUT function. I'll make a demo
'of using it for that sometime. I already know it works because I tested it.

'When using pictures make sure they are 320 X 200 with no more than 256
'Color. It's screen 13 so that has to be so for it to work.

DECLARE SUB loadgif (AA$)
DIM SHARED dir$, ninja(4000)
dir$ = "c:\qbasic45\giload\"
loadgif ("image1.gif")
GET (0, 0)-(90, 90), ninja
CLS
WINDOW SCREEN (0, 0)-(160, 100)
PALETTE 0, 0
PUT (1, 10), ninja

  

SUB loadgif (AA$)
'
'DEGIF6.BAS - No frills GIF decoder for the VGA's 320x200x256 mode.
'By Rich Geldreich 1993 (Public domain, use as you wish.)
'This version should properly decode all LZW encoded images in
'GIF image files. I've finally added GIF89a and local colormap
'support, so it more closely follows the GIF specification. It
'still doesn't support the entire GIF89a specification, but it'll
'show most GIF files fine.
'The GIF decoding speed of this program isn't great, but I'd say
'for an all QB/PDS decoder it's not bad!
'Note: This program does not stop decoding the GIF image after the
'rest of the scanlines become invisible! This happens with images
'larger than the 320x200 screen. So if the program seems to be
'just sitting there, accessing your hard disk, don't worry...
'It'll beep when it's done.

DEFINT A-Z
'Prefix() and Suffix() hold the LZW phrase dictionary.
'OutStack() is used as a decoding stack.
'ShiftOut() as a power of two table used to quickly retrieve the LZW
'multibit codes.
DIM Prefix(4095), Suffix(4095), OutStack(4095), ShiftOut(8)

'The following line is for the QB environment(slow).
DIM YBase AS LONG, Powersof2(11) AS LONG, WorkCode AS LONG
'For a little more speed, unremark the next line and remark the one
'above, before you compile... You'll get an overflow error if the
'following line is used in the QB environment, so change it back.
'DIM YBase AS INTEGER, Powersof2(11) AS INTEGER, WorkCode AS INTEGER

'Precalculate power of two tables for fast shifts.
FOR a = 0 TO 8: ShiftOut(8 - a) = 2 ^ a: NEXT
FOR a = 0 TO 11: Powersof2(a) = 2 ^ a: NEXT

'Get GIF filename.
a$ = COMMAND$: LET a$ = dir$ + AA$: IF a$ = "" THEN END
'Add GIF extension if the given filename doesn't have one.
FOR a = LEN(a$) TO 1 STEP -1
    SELECT CASE MID$(a$, a, 1)
    CASE "\", ":": EXIT FOR
    CASE ".": Extension = -1: EXIT FOR
    END SELECT
NEXT
IF Extension = 0 THEN a$ = a$ + ".GIF"

'Open file for input so QB stops with an error if it doesn't exist.
OPEN a$ FOR INPUT AS #1: CLOSE #1
OPEN a$ FOR BINARY AS #1

'Check to see if GIF file. Ignore GIF version number.
a$ = "      ": GET #1, , a$
IF LEFT$(a$, 3) <> "GIF" THEN PRINT "Not a GIF file.": END

'Get logical screen's X and Y resolution.
GET #1, , TotalX: GET #1, , TotalY: GOSUB GetByte
'Calculate number of colors and find out if a global palette exists.
NumColors = 2 ^ ((a AND 7) + 1): NoPalette = (a AND 128) = 0
'Retrieve background color.
GOSUB GetByte: Background = a

'Get aspect ratio and ignore it.
GOSUB GetByte

'Retrieve global palette if it exists.
IF NoPalette = 0 THEN P$ = SPACE$(NumColors * 3): GET #1, , P$

DO 'Image decode loop

'Skip by any GIF extensions.
'(With a few modifications this code could also fetch comments.)
DO
    'Skip by any zeros at end of image (why must I do this? the
    'GIF spec never mentioned it)
    DO
        IF EOF(1) THEN GOTO AllDone 'if at end of file, exit
        GOSUB GetByte
    LOOP WHILE a = 0           'loop while byte fetched is zero

    SELECT CASE a
    CASE 44  'We've found an image descriptor!
        EXIT DO
    CASE 59  'GIF trailer, stop decoding.
        GOTO AllDone
    CASE IS <> 33
        PRINT "Unknown GIF extension type.": END
    END SELECT
    'Skip by blocked extension data.
    GOSUB GetByte
    DO: GOSUB GetByte: a$ = SPACE$(a): GET #1, , a$: LOOP UNTIL a = 0
LOOP
'Get image's start coordinates and size.
GET #1, , XStart: GET #1, , YStart: GET #1, , XLength: GET #1, , YLength
XEnd = XStart + XLength: YEnd = YStart + YLength

'Check for local colormap, and fetch it if it exists.
GOSUB GetByte
IF (a AND 128) THEN
    NoPalette = 0
    NumColors = 2 ^ ((a AND 7) + 1)
    P$ = SPACE$(NumColors * 3): GET #1, , P$
END IF

'Check for interlaced image.
Interlaced = (a AND 64) > 0: PassNumber = 0: PassStep = 8

'Get LZW starting code size.
GOSUB GetByte

'Calculate clear code, end of stream code, and first free LZW code.
ClearCode = 2 ^ a
EOSCode = ClearCode + 1
FirstCode = ClearCode + 2: NextCode = FirstCode
StartCodeSize = a + 1: CodeSize = StartCodeSize

'Find maximum code for the current code size.
StartMaxCode = 2 ^ (a + 1) - 1: MaxCode = StartMaxCode

BitsIn = 0: BlockSize = 0: BlockPointer = 1

X = XStart: y = YStart: YBase = y * 320&

'Set screen 13 in not set yet.
IF FirstTime = 0 THEN
    'Go to VGA mode 13 (320x200x256).
    SCREEN 13: DEF SEG = &HA000
END IF

'Set palette, if there was one.
IF NoPalette = 0 THEN
    'Use OUTs for speed.
    OUT &H3C8, 0
    FOR a = 1 TO NumColors * 3: OUT &H3C9, ASC(MID$(P$, a, 1)) \ 4: NEXT
    'Save palette of image to disk.
    'OPEN "pal." FOR BINARY AS #2: PUT #2, , P$: CLOSE #2
END IF

IF FirstTime = 0 THEN
  'Clear entire screen to background color. This isn't
  'done until the image's palette is set, to avoid flicker
  'on some GIFs.
    LINE (0, 0)-(319, 199), Background, BF
    FirstTime = -1
END IF

'Decode LZW data stream to screen.
DO
    'Retrieve one LZW code.
    GOSUB GetCode
    'Is it an end of stream code?
    IF Code <> EOSCode THEN
        'Is it a clear code? (The clear code resets the sliding
        'dictionary - it *should* be the first LZW code present in
        'the data stream.)
        IF Code = ClearCode THEN
            NextCode = FirstCode
            CodeSize = StartCodeSize
            MaxCode = StartMaxCode
            DO: GOSUB GetCode: LOOP WHILE Code = ClearCode
            IF Code = EOSCode THEN GOTO ImageDone
            LastCode = Code: LastPixel = Code
            IF X < 320 AND y < 200 THEN POKE X + YBase, LastPixel
            X = X + 1: IF X = XEnd THEN GOSUB NextScanLine
        ELSE
            CurCode = Code: StackPointer = 0

            'Have we entered this code into the dictionary yet?
            IF Code >= NextCode THEN
                IF Code > NextCode THEN GOTO AllDone 'Bad GIF if this happens.
               'mimick last code if we haven't entered the requested
               'code into the dictionary yet
                CurCode = LastCode
                OutStack(StackPointer) = LastPixel
                StackPointer = StackPointer + 1
            END IF

            'Recursively get each character of the string.
            'Since we get the characters in reverse, "push" them
            'onto a stack so we can "pop" them off later.
            'Hint: There is another, much faster way to accomplish
            'this that doesn't involve a decoding stack at all...
            DO WHILE CurCode >= FirstCode
                OutStack(StackPointer) = Suffix(CurCode)
                StackPointer = StackPointer + 1
                CurCode = Prefix(CurCode)
            LOOP

            LastPixel = CurCode
            IF X < 320 AND y < 200 THEN POKE X + YBase, LastPixel
            X = X + 1: IF X = XEnd THEN GOSUB NextScanLine

            '"Pop" each character onto the display.
            FOR a = StackPointer - 1 TO 0 STEP -1
                IF X < 320 AND y < 200 THEN POKE X + YBase, OutStack(a)
                X = X + 1: IF X = XEnd THEN GOSUB NextScanLine
            NEXT

            'Can we put this new string into our dictionary? (Some GIF
            'encoders will wait a bit when the dictionary is full
            'before sending a clear code- this increases compression
            'because the dictionary's contents are thrown away less
            'often.)
            IF NextCode < 4096 THEN
                'Store new string in the dictionary for later use.
                Prefix(NextCode) = LastCode
                Suffix(NextCode) = LastPixel
                NextCode = NextCode + 1
                'Time to increase the LZW code size?
                IF (NextCode > MaxCode) AND (CodeSize < 12) THEN
                    CodeSize = CodeSize + 1
                    MaxCode = MaxCode * 2 + 1
                END IF
            END IF
            LastCode = Code
        END IF
    END IF
LOOP UNTIL Code = EOSCode
ImageDone:

LOOP

AllDone:
GOTO 20

'Slowly reads one byte from the GIF file...
GetByte: a$ = " ": GET #1, , a$: a = ASC(a$): RETURN

'Moves down one scanline. If the GIF is interlaced, then the number
'of scanlines skipped is based on the current pass.
NextScanLine:
    IF Interlaced THEN
        y = y + PassStep
        IF y >= YEnd THEN
            PassNumber = PassNumber + 1
            SELECT CASE PassNumber
            CASE 1: y = 4: PassStep = 8
            CASE 2: y = 2: PassStep = 4
            CASE 3: y = 1: PassStep = 2
            END SELECT
        END IF
    ELSE
        y = y + 1
    END IF
    X = XStart: YBase = y * 320&
RETURN

'Reads a multibit code from the data stream.
GetCode:
    WorkCode = LastChar \ ShiftOut(BitsIn)
   'Loop while more bits are needed.
    DO WHILE CodeSize > BitsIn
'Reads a byte from the LZW data stream. Since the data stream is
'blocked, a check is performed for the end of the current block
'before each byte is fetched.
        IF BlockPointer > BlockSize THEN
          'Retrieve block's length
            GOSUB GetByte: BlockSize = a
            a$ = SPACE$(BlockSize): GET #1, , a$
            BlockPointer = 1
        END IF
      'Yuck, ASC() and MID$() aren't that fast.
        LastChar = ASC(MID$(a$, BlockPointer, 1))
        BlockPointer = BlockPointer + 1
      'Append 8 more bits to the input buffer
        WorkCode = WorkCode OR LastChar * Powersof2(BitsIn)
        BitsIn = BitsIn + 8
    LOOP
  'Take away x number of bits.
    BitsIn = BitsIn - CodeSize
  'Return code to caller.
    Code = WorkCode AND MaxCode
RETURN
20

END SUB

