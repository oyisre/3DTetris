var playAgainButton, backButton : int
var playAgain : int := 1

proc buttonPressed
    if GUI.GetEventWidgetID = playAgainButton then
	playAgain := 2
    elsif GUI.GetEventWidgetID = backButton then
	playAgain := 3
    end if
    GUI.Quit
end buttonPressed

%The game over screen allows players to either play again or return to the menu
fcn gameOverScreen : boolean
    
    var gameOverWin, difficultyLabel, sizeLabel, rowsLabel, colsLabel, layersLabel, newHighLabel, mainLabel, scoreLabel : int
    var diffStr : string
    playAgain := 1
    
    gameOverWin := Window.Open("position:center;center,graphics:400;500")
    
    if curDiff = 1 then
	diffStr := "Difficulty: Easy"
    elsif curDiff = 2 then
	diffStr := "Difficulty: Medium"
    elsif curDiff = 3 then
	diffStr := "Difficulty: Hard"
    elsif curDiff = 4 then
	diffStr := "Difficulty: Impossible"
    end if
    
    difficultyLabel := GUI.CreateLabelFull(200,375,diffStr,0,0,GUI.CENTER,thirdFont)
    sizeLabel := GUI.CreateLabelFull(200,300,"Size: " + intstr(cols) + "x" + intstr(rows) + "x" + intstr(layers),0,0,GUI.CENTER,secondFont)
    scoreLabel := GUI.CreateLabelFull(200,180,"Score: " + intstr(score),0,0,GUI.CENTER,mainFont)
    playAgainButton := GUI.CreateButtonFull(75, 100, 0, "Play Again", buttonPressed, 0, 'p', true)
    backButton := GUI.CreateButtonFull(225, 100, 0, "Back to Menu", buttonPressed, 0, 'b', true)
    
    loop
	exit when GUI.ProcessEvent
    end loop
    
    GUI.ResetQuit
    GUI.CloseWindow(gameOverWin)
    
    curMusic := false
    Music.PlayFileStop
    
    if playAgain = 2 then
	result true
    elsif playAgain = 3 then
	result false
    end if
    
end gameOverScreen
