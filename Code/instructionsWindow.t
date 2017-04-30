proc displayInstScreen
    
    Window.Hide(mainWin)
    var winID, closeButton, instructionsLabel, instructionsText : int
    var tempLine : string := ""
    var curY : int := 575
    
    winID := Window.Open ("position:center;center,graphics:700;600")
    closeButton := GUI.CreateButtonFull (300, 25, 0, "Back to Menu", GUI.Quit, 0, 'b', true)
    instructionsLabel := GUI.CreateLabelFull(350,700,"",0,0,GUI.CENTER,thirdFont)
    
    open : instructionsText, File.Parent(File.FullPath("instructionsWindow.t")) + "/Code/instructions.txt", get
    %The number before the line in the text file will indicate what type of font should be used for it.
    loop
        exit when eof (instructionsText)
        get : instructionsText, skip
        get : instructionsText, tempLine : 1
        if tempLine = "1" then
            get : instructionsText, tempLine : *
            instructionsLabel := GUI.CreateLabelFull(350,curY,tempLine,0,0,GUI.CENTER,secondFont)
        else
            get : instructionsText, tempLine : *
            instructionsLabel := GUI.CreateLabelFull(350,curY,tempLine,0,0,GUI.CENTER,thirdFont)
        end if
        exit when eof (instructionsText)
        curY -= 25
    end loop
    
    close : instructionsText
    
    loop
        exit when GUI.ProcessEvent
    end loop
    
    GUI.ResetQuit
    GUI.CloseWindow (winID)
    Window.Show(mainWin)
    
end displayInstScreen