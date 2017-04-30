%This procedure will start the game with any variables needed
proc initializeGame (difficulty, cols, rows, layers, fpsNew : int)
    
    canWin := true
    inPlay := false
    isChanged := true
    
    score := 0
    
    case difficulty of
    label 1 :
        movementDelay := 60
        scoreMult := 1
    label 2 :
        movementDelay := 30
        scoreMult := 1.5
    label 3 :
        movementDelay := 15
        scoreMult := 3
    label 4 :
        movementDelay := 5
        scoreMult := 6
    end case
    
    fps := fpsNew
    maxX := cols - 1
    maxY := rows + 4
    maxZ := layers - 1
    startScale := -30 + ceil (((maxX + maxY + maxZ) - 22) * 1.4)
    var cubes : array 0 .. maxX, 0 .. maxY + 1, 0 .. maxZ of int %X, Y, Z
    var tempCubes : array 0 .. maxX, 0 .. maxY + 1, 0 .. maxZ of int
    
    playGameFirst (difficulty, cubes)
    playGame (cubes, tempCubes)
    
end initializeGame

var winID, continueButton, difficultyField, easyCheck, mediumCheck, hardCheck, impossibleCheck : int
var rowsSlide, colsSlide, layersSlide, rowsLabel, colsLabel, layersLabel : int
var regularCheck, slowCheck, customCheck, fpsField : int
var bigCheck, normalCheck, smallCheck, customSizeCheck, rowsField, colsField, layersField : int
var difficultyLabel, fpsLabel, sizeLabel : int

proc radioPressed
    if GUI.GetEventWidgetID = easyCheck then
        curDiff := 1
    elsif GUI.GetEventWidgetID = mediumCheck then
        curDiff := 2
    elsif GUI.GetEventWidgetID = hardCheck then
        curDiff := 3
    elsif GUI.GetEventWidgetID = impossibleCheck then
        curDiff := 4
    elsif GUI.GetEventWidgetID = regularCheck then
        fpsType := 1
    elsif GUI.GetEventWidgetID = slowCheck then
        fpsType := 2
    elsif GUI.GetEventWidgetID = customCheck then
        fpsType := 3
    elsif GUI.GetEventWidgetID = bigCheck then
        sizeType := 2
    elsif GUI.GetEventWidgetID = normalCheck then
        sizeType := 1
    elsif GUI.GetEventWidgetID = smallCheck then
        sizeType := 3
    elsif GUI.GetEventWidgetID = customSizeCheck then
        sizeType := 4
    end if
end radioPressed

proc textField (s : string)
    
end textField

proc slideMoved (num : int)
    if GUI.GetEventWidgetID = rowsSlide then
        rows := num
        GUI.SetLabel(rowsLabel, (intstr(num) + " Rows"))
    elsif GUI.GetEventWidgetID = colsSlide then
        cols := num
        GUI.SetLabel(colsLabel, (intstr(num) + " Columns"))
    elsif GUI.GetEventWidgetID = layersSlide then
        layers := num
        GUI.SetLabel(layersLabel, (intstr(num) + " Layers"))
    end if
end slideMoved

%This window allows players to set options as they please
proc settingsWin
    
    var sWin : int
    cols := 12
    rows := 20
    layers := 12
    curDiff := 1
    fpsType := 1
    Window.Hide (mainWin)
    
    sWin := Window.Open ("position:center;center,graphics:600;300")
    GUI.SetBackgroundColour(grey)
    
    continueButton := GUI.CreateButtonFull (250, 50, 0, "Start Game", GUI.Quit, 0, '^s', true)
    
    difficultyLabel := GUI.CreateLabelFull(25, 225, "Difficulty",0,0,0,thirdFont)
    easyCheck := GUI.CreateRadioButton (25, 200, "Easy Mode", 0, radioPressed)
    mediumCheck := GUI.CreateRadioButton (25, 175, "Medium Mode", easyCheck, radioPressed)
    hardCheck := GUI.CreateRadioButton (25, 150, "Hard Mode", mediumCheck, radioPressed)
    impossibleCheck := GUI.CreateRadioButton (25, 125, "Impossible Mode", hardCheck, radioPressed)
    
    fpsLabel := GUI.CreateLabelFull(200,225,"Frames Per Second",0,0,0,thirdFont)
    regularCheck := GUI.CreateRadioButton (200, 200, "Default (60)", 0, radioPressed)
    slowCheck := GUI.CreateRadioButton (200, 175, "Low (30)", regularCheck, radioPressed)
    customCheck := GUI.CreateRadioButton (200, 150, "Custom:", slowCheck, radioPressed)
    fpsField := GUI.CreateTextFieldFull (275, 150, 25, "60", textField, GUI.INDENT, 0, GUI.INTEGER)
    
    sizeLabel := GUI.CreateLabelFull(400,275, "Size of Game Field",0,0,0,thirdFont)
    colsSlide := GUI.CreateVerticalSlider(385, 125, 100, 5, 25, 12, slideMoved)
    rowsSlide := GUI.CreateVerticalSlider(460, 125, 100, 8, 35, 20, slideMoved)
    layersSlide := GUI.CreateVerticalSlider(535, 125, 100, 5, 25, 12, slideMoved)
    colsLabel := GUI.CreateLabelFull(390, 250, "12 Columns",0,0,GUI.CENTER,fourthFont)
    rowsLabel := GUI.CreateLabelFull(460, 250, "20 Rows",0,0,GUI.CENTER,fourthFont)
    layersLabel := GUI.CreateLabelFull(540, 250, "12 Layers",0,0,GUI.CENTER,fourthFont)
    
    
    loop
        exit when GUI.ProcessEvent
    end loop
    
    GUI.ResetQuit
    GUI.CloseWindow (sWin)
    
    if fpsType = 1 then
        fps := 60
    elsif fpsType = 2 then
        fps := 30
    elsif fpsType = 3 then
        if strintok (GUI.GetText(fpsField), 10) then
            fps := strint(GUI.GetText(fpsField))
        else
            fps := 60
        end if
    end if
    
    if fps < 1 then
        fps := 1 
    end if
    
    loop
        initializeGame (curDiff, cols, rows, layers, fps)
        exit when gameOverScreen = false
    end loop
    
    Window.Show(mainWin)
    return
    
end settingsWin
