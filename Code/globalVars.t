var maxX, maxY, maxZ : int
var colours : array 1 .. 8, 1 .. 3, 1 .. 3 of int
var key : array char of boolean
var sPointX,sPointZ, score, tempC, inputWin, mainWin, cols, rows, layers : int
var curDiff, curFPS, curRows,curCols,curLayers,mainFont, secondFont, thirdFont, fourthFont : int
var sPointY, curPiece : int := 0
var fps, fpsTemp : int := 60
var fpsType, sizeType : int := 1
var isChanged, canWin : boolean := true
var scoreMult : real
var soundOn, musicOn, curMusic, inPlay : boolean := false

mainFont := Font.New ("Palatino:24:Bold")
secondFont := Font.New ("sans serif:16:bold")
thirdFont := Font.New ("sans serif:12:bold")
fourthFont := Font.New ("sans serif:8:bold")

%Initializing colour values from an RGB colour picker
%RED
colours (6, 1, 1) := 255
colours (6, 2, 1) := 0
colours (6, 3, 1) := 0
colours (6, 1, 2) := 255
colours (6, 2, 2) := 128
colours (6, 3, 2) := 128
colours (6, 1, 3) := 128
colours (6, 2, 3) := 0
colours (6, 3, 3) := 0

%ORANGE
colours (4, 1, 1) := 255
colours (4, 2, 1) := 128
colours (4, 3, 1) := 0
colours (4, 1, 2) := 255
colours (4, 2, 2) := 193
colours (4, 3, 2) := 129
colours (4, 1, 3) := 200
colours (4, 2, 3) := 100
colours (4, 3, 3) := 0

%YELLOW
colours (3, 1, 1) := 255
colours (3, 2, 1) := 255
colours (3, 3, 1) := 0
colours (3, 1, 2) := 255
colours (3, 2, 2) := 255
colours (3, 3, 2) := 128
colours (3, 1, 3) := 128
colours (3, 2, 3) := 128
colours (3, 3, 3) := 0

%GREEN
colours (7, 1, 1) := 0
colours (7, 2, 1) := 255
colours (7, 3, 1) := 0
colours (7, 1, 2) := 128
colours (7, 2, 2) := 255
colours (7, 3, 2) := 128
colours (7, 1, 3) := 0
colours (7, 2, 3) := 128
colours (7, 3, 3) := 0

%CYAN
colours (8, 1, 1) := 0
colours (8, 2, 1) := 255
colours (8, 3, 1) := 255
colours (8, 1, 2) := 160
colours (8, 2, 2) := 229
colours (8, 3, 2) := 229
colours (8, 1, 3) := 0
colours (8, 2, 3) := 128
colours (8, 3, 3) := 128

%BLUE
colours (2, 1, 1) := 0
colours (2, 2, 1) := 0
colours (2, 3, 1) := 255
colours (2, 1, 2) := 128
colours (2, 2, 2) := 128
colours (2, 3, 2) := 255
colours (2, 1, 3) := 0
colours (2, 2, 3) := 0
colours (2, 3, 3) := 128

%PURPLE
colours (5, 1, 1) := 128
colours (5, 2, 1) := 0
colours (5, 3, 1) := 255
colours (5, 1, 2) := 192
colours (5, 2, 2) := 128
colours (5, 3, 2) := 255
colours (5, 1, 3) := 64
colours (5, 2, 3) := 0
colours (5, 3, 3) := 128

%PINK
colours (1, 1, 1) := 255
colours (1, 2, 1) := 0
colours (1, 3, 1) := 255
colours (1, 1, 2) := 255
colours (1, 2, 2) := 128
colours (1, 3, 2) := 255
colours (1, 1, 3) := 128
colours (1, 2, 3) := 0
colours (1, 3, 3) := 128

%var cubes : array 0 .. maxX, 0 .. maxY, 0 .. maxZ of int %X, Y, Z
%var tempCubes : array 0 .. maxX, 0 .. maxY, 0 .. maxZ of int