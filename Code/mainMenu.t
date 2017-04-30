displayIntroWin

var instButton, playButton, quitButton, welcomeLabel, welcomeLabel2, soundRadio, musicRadio : int

proc soundToggle (isOn : boolean)
    if isOn = true then
        soundOn := true
    else
        soundOn := false
    end if
end soundToggle

proc musicToggle (isOn : boolean)
    if isOn = true then
        musicOn := true
    else
        musicOn := false
    end if
end musicToggle

%The main menu
mainWin := Window.Open ("position:center;center,graphics:500;250")

soundRadio := GUI.CreateCheckBox(115,125,"Sound",soundToggle)
musicRadio := GUI.CreateCheckBox(315,125,"Music",musicToggle)

playButton := GUI.CreateButtonFull (217, 125, 0, "Play!", settingsWin, 0, 'p', true)
instButton := GUI.CreateButtonFull (200, 75, 0, "Instructions", displayInstScreen, 0, 'i', false)
quitButton := GUI.CreateButtonFull (202, 25, 0, "Quit Game", GUI.Quit, 0, 'q', false)
welcomeLabel := GUI.CreateLabelFull (250, 190, "GRANDMASTER TETRIS",0,0,GUI.CENTER,mainFont)

loop
    exit when GUI.ProcessEvent
end loop
