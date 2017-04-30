%A bunch of variables used for drawing the game field and handling controls
var sideL : real := 0.05
var startPos : real := -0.4
var startPosX : real := 0
var startPosTemp : real
var startPosZ : real := 0
var startPosZTemp : real
var sX : real := startPosX
var sY : real := startPos
var sZ : real := startPosZ
var eX : real := startPosX + sideL
var eY : real := startPos + sideL
var eZ : real := startPosZ - sideL
var curRotationX, curRotationY : real
var curTime, curTime2 : int
var scaleFactor : int := 0
var secondProg : int := 0
var lastKeyDelay : int := 0
var lastKeyPress : int := 0 % 1 = Left Arrow, 2 = Right Arrow, 3 = Up Arrow, 4 = Down Arrow, 5 = 'q', 6 = 'e', 7 = Spacebar
var movementDelay : int
var keyPress : boolean
var reverseKeys, reverseKeys2 : boolean := false
var startScale : int
var reservePiece : int

%playGameFire resets the array for the game field and starts playing music
proc playGameFirst (difficulty: int, var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    for j : 0 .. maxY
        for i : 0 .. maxX
            for k : 0 .. maxZ
                cubes (i, j, k) := 0
            end for
        end for
    end for
        curMusic := true
    fork playMusic(0)
    
end playGameFirst

%Rotates the game field
proc rotate
    GL.ClearMatrix ()
    GL.Rotate (curRotationX, 1, 0, 0)
    GL.Rotate (curRotationY, 0, 1, 0)
    if scaleFactor >= 0 then
        GL.Scale (0.98 ** scaleFactor, 0.98 ** scaleFactor, 0.98 ** scaleFactor)
    else
        var tempScale : real := 0.99 ** scaleFactor
            for i : 0 .. (scaleFactor - (scaleFactor * 2))
            tempScale := tempScale / 0.99
        end for
            GL.Scale (tempScale, tempScale, tempScale)
    end if
    isChanged := true
end rotate

%Resets the camera
proc resetView
    curRotationY := 45
    curRotationX := -15
    scaleFactor := startScale
    rotate
    isChanged := true
end resetView

%Initializes the drawing variables
proc setDrawVars (startPosN, startPosZN : real)
    sX := startPosX
    sY := startPosN
    sZ := startPosZN
    eX := startPosX + sideL
    eY := startPosN + sideL
    eZ := startPosZN - sideL
end setDrawVars

proc quickQuit
    quit
end quickQuit

%The main game loop
proc playGame (var cubes : array 0 .. *, 0 .. *, 0 .. * of int, var tempCubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    %Creating the input window and pause window
    var infoWin, scoreLabel, pausedLabel, pausedLabel2 : int
    infoWin := Window.Open ("position:right;bottom,graphics:500,400")
    put "A & D to Rotate Left & Right"
    put "W & S to Rotate Up & Rown"
    put "Hold Shift to Increase Rotation Speed"
    put "R & F to Zoom out and in"
    put "Left and Right Arrows to move pieces Left and Right"
    put "Q & E to move pieces forward and backward."
    put "Down to move pieces down (Soft Drop)."
    put "Up to Rotate pieces, hold Shift to Rotate in the Z-axis."
    put "Space to Hard Drop or spawn a new piece."
    put "Tab to Reset the Camera"
    put "LAlt to Pause"
    
    inputWin := Window.Open ("position:right;top,graphics:360;400")
    scoreLabel := GUI.CreateLabelFull(180,100,"0",0,0,GUI.CENTER,mainFont)
    pausedLabel := GUI.CreateLabelFull(180,225,"",0,0,GUI.CENTER,mainFont)
    pausedLabel2 := GUI.CreateLabelFull(180,175,"",0,0,GUI.CENTER,mainFont)
    
    var windowWidth : int := maxx
    var windowHeight : int := maxy
    
    var screenWidth : int := Config.Display (cdScreenWidth)
    var screenHeight : int := Config.Display (cdScreenHeight)
    
    Window.SetPosition (inputWin, screenWidth-windowWidth, screenHeight-windowHeight)
    
    const width := 1000
    const height := 1000
    var res := GL.NewWin (width, height)
    
    resetView
    curTime := Time.Elapsed ()
    curTime2 := Time.Elapsed()
    
    
    loop
        %The code used to scan for input is run every 60th of a second to standardize game speed
        if (Time.Elapsed () - curTime2) > (1000 / 60) then
            secondProg += 1
            Input.KeyDown (key)
            keyPress := false
            if key (KEY_ALT) then
                GUI.SetLabel(pausedLabel, "GAME IS PAUSED")
                GUI.SetLabel(pausedLabel2, "Press 'z' to resume")
                Input.Flush
                loop
                    if getchar = 'z' or getchar = 'Z' then
                        exit
                    end if
                end loop
                GUI.SetLabel(pausedLabel, " ")
                GUI.SetLabel(pausedLabel2, " ")
            end if
            if key (KEY_CTRL) then
                reservePiece := curPiece
                
            end if
            if key (KEY_LEFT_ARROW) xor key (KEY_RIGHT_ARROW) then
                if key (KEY_LEFT_ARROW) then
                    if lastKeyPress not= 1 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys = false then
                            moveLeft (cubes)
                        else
                            moveRight (cubes)
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys = false then
                                moveLeft (cubes)
                            else
                                moveRight (cubes)
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                else
                    if lastKeyPress not= 2 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys = false then
                            moveRight (cubes)
                        else
                            moveLeft  (cubes)
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 2
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys = false then
                                moveRight (cubes)
                            else
                                moveLeft (cubes)
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key (KEY_DOWN_ARROW) then
                if lastKeyPress not= 4 and Time.Elapsed - lastKeyDelay > 75 then
                    moveDown  (cubes)
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 4
                    secondProg := (movementDelay div 2)
                    scoreManager ("softdrop")
                    GUI.SetLabel(scoreLabel, intstr(score))
                else
                    if Time.Elapsed - lastKeyDelay > 75 then
                        moveDown  (cubes)
                        lastKeyDelay := Time.Elapsed
                        if inPlay = true then
                            secondProg := (movementDelay div 2)
                        end if
                        scoreManager ("softdrop")
                        GUI.SetLabel(scoreLabel, intstr(score))
                    end if
                end if
                keyPress := true
            end if
            if key (KEY_UP_ARROW) then
                if key (KEY_UP_ARROW) and key (KEY_SHIFT) then
                    if lastKeyPress not= 3 then
                        findBottom  (cubes)
                        %if key (KEY_SHIFT) then
                        %    rotatePiece (2, 2)
                        %else
                        rotatePiece (2, 1, cubes, tempCubes)
                        %end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 3
                        secondProg := ((movementDelay div 2) - movementDelay)
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            findBottom (cubes)
                            %if key (KEY_SHIFT) then
                            %    rotatePiece (2, 2)
                            %else
                            rotatePiece (2, 1, cubes, tempCubes)
                            %end if
                            lastKeyDelay += 250
                            secondProg := ((movementDelay div 2) - movementDelay)
                        end if
                    end if
                elsif key (KEY_UP_ARROW) then
                    if lastKeyPress not= 3 then
                        findBottom (cubes)
                        %if key (KEY_SHIFT) then
                        %rotatePiece (1, 2)
                        %else
                        rotatePiece (1, 1, cubes, tempCubes)
                        %end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 3
                        secondProg := ((movementDelay div 2) - movementDelay)
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            findBottom (cubes)
                            %if key (KEY_SHIFT) then
                            %    rotatePiece (1, 2)
                            %else
                            rotatePiece (1, 1, cubes, tempCubes)
                            %end if
                            lastKeyDelay += 250
                            secondProg := ((movementDelay div 2) - movementDelay)
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key (' ') then
                if inPlay = true and (lastKeyPress not= 5 or Time.Elapsed - lastKeyDelay > 350) then
                    for i : 0 .. maxY
                        moveDown (cubes)
                        scoreManager ("softdrop")
                    end for
                        solidify (cubes)
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 5
                    GUI.SetLabel(scoreLabel, intstr(score))
                elsif inPlay = false and (lastKeyPress not= 5 or Time.Elapsed - lastKeyDelay > 350) then
                    solidify (cubes)
                    canWin := canSpawn (cubes)
                    canWin := isNotLost(cubes)
                    if canWin = true then
                        spawnPiece (cubes)
                    end if
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 5
                    GUI.SetLabel(scoreLabel, intstr(score))
                end if
                isChanged := true
                keyPress := true
            end if
            if key ('q') xor key ('e') then
                if key ('q') then
                    if lastKeyPress not= 5 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys2 = false then
                            moveForward (cubes)
                        else
                            moveBackward (cubes)
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 5
                        secondProg -= 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys2 = false then
                                moveForward (cubes)
                            else
                                moveBackward (cubes)
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                else
                    if lastKeyPress not= 6 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys2 = false then
                            moveBackward (cubes)
                        else
                            moveForward (cubes)
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 6
                        secondProg -= 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys2 = false then
                                moveBackward (cubes)
                            else
                                moveForward (cubes)
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key ('a') xor key ('d') then
                if key ('a') then
                    if key (KEY_SHIFT) then
                        curRotationY += 3
                    else
                        curRotationY += 1
                    end if
                    if curRotationY >= 180 then
                        curRotationY := -180
                    end if
                else
                    if key (KEY_SHIFT) then
                        curRotationY -= 3
                    else
                        curRotationY -= 1
                    end if
                    if curRotationY <= -180 then
                        curRotationY := 180
                    end if
                end if
            end if
            if key ('w') xor key ('s') then
                if key ('w') then
                    if key (KEY_SHIFT) then
                        curRotationX += 3
                    else
                        curRotationX += 1
                    end if
                    if curRotationX > 90 then
                        curRotationX := 90
                    end if
                else
                    if key (KEY_SHIFT) then
                        curRotationX -= 3
                    else
                        curRotationX -= 1
                    end if
                    if curRotationX < -90 then
                        curRotationX := -90
                    end if
                end if
            end if
            if key ('r') xor key ('f') then
                if key ('r') then
                    if scaleFactor < 50 then
                        scaleFactor += 1
                    elsif scaleFactor >= 50 and scaleFactor <= startScale then
                        scaleFactor += 1
                    end if
                else
                    if scaleFactor > -30 then % set to -3
                        scaleFactor -= 1
                    end if
                end if
                isChanged := true
            end if
            if key (KEY_TAB) then
                resetView
            end if
            %exit when key ('t')
            if keyPress = false then
                lastKeyPress := 0
            end if
            curTime2 := Time.Elapsed()
            
        end if
        
        %The drawing of the game field is tied to the fps chosed in the settings menu
        if (Time.Elapsed () - curTime) > (1000 / fps) then
            Window.SetActive(inputWin)
            rotate ()
            if isChanged = true then
                setDrawVars (startPos, startPosZ)
                GL.SetLight (0)
                GL.Cls ()
                
                %%Drawing Fields
                %Bottom Field
                for i : 0 .. maxZ+1
                    GL.DrawLine (sX, sY, sZ - (i * sideL), sX + ((maxX+1) * sideL), sY, sZ - (i * sideL), 255, 255, 255)
                end for
                    for i : 0 .. maxX+1
                    GL.DrawLine (sX + (i * sideL), sY, sZ, sX + (i * sideL), sY, sZ - ((maxZ+1) * sideL), 255, 255, 255)
                end for
                    
                %Main Fields (Front, Left, Back, Right)
                if curRotationY >= -90 and curRotationY <= 90 then
                    for i : 0 .. maxY-4
                        GL.DrawLine (sX, sY + (i * sideL), sZ, sX + ((maxX+1) * sideL), sY + (i * sideL), sZ, 255, 255, 255)
                    end for
                        for i : 0 .. maxX+1
                        GL.DrawLine (sX + (i * sideL), sY, sZ, sX + (i * sideL), sY + ((maxY-4) * sideL), sZ, 255, 255, 255)
                    end for
                        GL.DrawLine (sX, sY, sZ, sX + ((maxX+1) * sideL), sY, sZ, 255, 0, 0)
                    reverseKeys := false
                end if
                if curRotationY >= 0 and curRotationY <= 180 then
                    for i : 0 .. maxY-4
                        GL.DrawLine (sX, sY + (i * sideL), sZ, sX, sY + (i * sideL), sZ - ((maxZ+1) * sideL), 255, 255, 255)
                    end for
                        for i : 0 .. maxZ+1
                        GL.DrawLine (sX, sY, sZ - (i * sideL), sX, sY + ((maxY-4) * sideL), sZ - (i * sideL), 255, 255, 255)
                    end for
                        GL.DrawLine (sX, sY, sZ, sX, sY, sZ - ((maxZ+1) * sideL), 0, 255, 0)
                    reverseKeys2 := false
                end if
                if curRotationY >= 90 or (curRotationY >= -180 and curRotationY <= -90) then
                    for i : 0 .. maxY-4
                        GL.DrawLine (sX, sY + (i * sideL), sZ - ((maxZ+1) * sideL), sX + ((maxX+1) * sideL), sY + (i * sideL), sZ - ((maxZ+1) * sideL), 255, 255, 255)
                    end for
                        for i : 0 .. maxX+1
                        GL.DrawLine (sX + (i * sideL), sY, sZ - ((maxZ+1) * sideL), sX + (i * sideL), sY + ((maxY-4) * sideL), sZ - ((maxZ+1) * sideL), 255, 255, 255)
                    end for
                        GL.DrawLine (sX, sY, sZ - ((maxZ+1) * sideL), sX + ((maxX+1) * sideL), sY, sZ - ((maxZ+1) * sideL), 255, 0, 0)
                    reverseKeys := true
                end if
                if curRotationY >= -180 and curRotationY <= 0 then
                    for i : 0 .. maxY-4
                        GL.DrawLine (sX + ((maxX+1) * sideL), sY + (i * sideL), sZ, sX + ((maxX+1) * sideL), sY + (i * sideL), sZ - ((maxZ+1) * sideL), 255, 255, 255)
                    end for
                        for i : 0 .. maxZ+1
                        GL.DrawLine (sX + ((maxX+1) * sideL), sY, sZ - (i * sideL), sX + ((maxX+1) * sideL), sY + ((maxY-4) * sideL), sZ - (i * sideL), 255, 255, 255)
                    end for
                        GL.DrawLine (sX + ((maxX+1) * sideL), sY, sZ, sX + ((maxX+1) * sideL), sY, sZ - ((maxZ+1) * sideL), 0, 255, 0)
                    reverseKeys2 := true
                end if
                
                %Reference Lines
                if curRotationY >= 0 and curRotationY < 90 then
                    GL.DrawLine (sX, sY, sZ, sX, sY + ((maxY-4) * sideL), sZ, 0, 0, 255)
                elsif curRotationY >= 90 and curRotationY < 180 then
                    GL.DrawLine (sX, sY, sZ - ((maxZ+1) * sideL), sX, sY + ((maxY-4) * sideL), sZ - ((maxZ+1) * sideL), 0, 0, 255)
                elsif curRotationY >= -180 and curRotationY < -90 then
                    GL.DrawLine (sX + ((maxX+1) * sideL), sY, sZ - ((maxZ+1) * sideL), sX + ((maxX+1) * sideL), sY + ((maxY-4) * sideL), sZ - ((maxZ+1) * sideL), 0, 0, 255)
                elsif curRotationY >= -90 and curRotationY < 0 then
                    GL.DrawLine (sX + ((maxX+1) * sideL), sY, sZ, sX + ((maxX+1) * sideL), sY + ((maxY-4) * sideL), sZ, 0, 0, 255)
                end if
                
                %Draw Cubes
                startPosTemp := startPos
                startPosZTemp := startPosZ
                
                for i : 0 .. maxX
                    for j : 0 .. maxZ
                        for k : 0 .. maxY-5
                            if cubes (i, k, j) >= 1 then
                                tempC := cubes (i, k, j)
                                startPos := startPosTemp + (sideL * k)
                                startPosX := sideL * i
                                startPosZ := startPosZTemp - (sideL * j)
                                setDrawVars (startPos, startPosZ)
                                
                                GL.DrawFillTriangle (eX, sY, sZ, eX, eY, sZ, sX, eY, sZ, colours (tempC, 1, 1), colours (tempC, 2, 1), colours (tempC, 3, 1))
                                GL.DrawFillTriangle (sX, sY, sZ, eX, sY, sZ, sX, eY, sZ, colours (tempC, 1, 1), colours (tempC, 2, 1), colours (tempC, 3, 1))
                                
                                GL.DrawFillTriangle (eX, sY, eZ, eX, eY, eZ, sX, eY, eZ, colours (tempC, 1, 1), colours (tempC, 2, 1), colours (tempC, 3, 1))
                                GL.DrawFillTriangle (sX, sY, eZ, eX, sY, eZ, sX, eY, eZ, colours (tempC, 1, 1), colours (tempC, 2, 1), colours (tempC, 3, 1))
                                
                                GL.DrawFillTriangle (eX, eY, eZ, eX, eY, sZ, sX, eY, eZ, colours (tempC, 1, 3), colours (tempC, 2, 3), colours (tempC, 3, 3))
                                GL.DrawFillTriangle (eX, eY, sZ, sX, eY, eZ, sX, eY, sZ, colours (tempC, 1, 3), colours (tempC, 2, 3), colours (tempC, 3, 3))
                                
                                GL.DrawFillTriangle (sX, sY, sZ, eX, sY, sZ, sX, sY, eZ, colours (tempC, 1, 3), colours (tempC, 2, 3), colours (tempC, 3, 3))
                                GL.DrawFillTriangle (sX, sY, eZ, eX, sY, eZ, eX, sY, sZ, colours (tempC, 1, 3), colours (tempC, 2, 3), colours (tempC, 3, 3))
                                
                                GL.DrawFillTriangle (sX, sY, sZ, sX, eY, sZ, sX, eY, eZ, colours (tempC, 1, 2), colours (tempC, 2, 2), colours (tempC, 3, 2))
                                GL.DrawFillTriangle (sX, sY, sZ, sX, sY, eZ, sX, eY, eZ, colours (tempC, 1, 2), colours (tempC, 2, 2), colours (tempC, 3, 2))
                                
                                GL.DrawFillTriangle (eX, eY, sZ, eX, sY, sZ, eX, sY, eZ, colours (tempC, 1, 2), colours (tempC, 2, 2), colours (tempC, 3, 2))
                                GL.DrawFillTriangle (eX, eY, eZ, eX, eY, sZ, eX, sY, eZ, colours (tempC, 1, 2), colours (tempC, 2, 2), colours (tempC, 3, 2))
                                
                            end if
                        end for
                    end for
                end for
                    
                startPos := startPosTemp
                startPosZ := startPosZTemp
                startPosX := 0
                
                GL.Update ()
                isChanged := false
            end if
            
            curTime := Time.Elapsed ()
            
            if secondProg >= movementDelay then
                playSound(1)
                if inPlay = false and canWin = true then
                    solidify (cubes)
                    if canSpawn (cubes) = false or isNotLost (cubes) = false then
                        canWin := false
                    else
                        spawnPiece (cubes)
                    end if
                elsif inPlay = true and canWin = true then
                    moveDown (cubes)
                end if
                isChanged := true
                secondProg := 0
                GUI.SetLabel(scoreLabel, intstr(score))
            end if
            
            if canWin = false then
                %put "You Lose"
                delay(1)
                GL.Cls ()
                GL.CloseWin ()
                GUI.CloseWindow(inputWin)
                GUI.CloseWindow(infoWin)
                return
            end if
        end if
    end loop
    
    quickQuit ()
    
end playGame
