proc toMenu (winID : int)

    GUI.CloseWindow (winID)
    GUI.ResetQuit

end toMenu

%Standard intro window
proc displayIntroWin

    var winID, quitButton, continueButton, welcomeLabel, welcomeLabel2 : int

    winID := Window.Open ("position:center;center,graphics:500;300")
    continueButton := GUI.CreateButtonFull (215, 25, 0, "Continue", GUI.Quit, 0, 'C', true)
    welcomeLabel := GUI.CreateLabelFull (250, 225, "Welcome to", 0, 0, GUI.CENTER, mainFont)
    welcomeLabel2 := GUI.CreateLabelFull (250, 175, "GRANDMASTER TETRIS", 0, 0, GUI.CENTER, mainFont)

    loop
	exit when GUI.ProcessEvent
    end loop

    GUI.ResetQuit
    GUI.CloseWindow (winID)

end displayIntroWin
