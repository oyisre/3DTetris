proc startGame (difficulty : int)
    
    const width := 1000
    const height := 1000
    var res := GL.NewWin (width, height)
    View.Set ("graphics:360;500,nobuttonbar")
    GUI.SetBackgroundColour (purple)
    put "a & d to rotate left & right"
    put "w & s to rotate up & down"
    put "Hold shift to speed rotation speed"
    put "q & e to zoom in and out"
    put "Press space to reset"
    
    %Load array
    var sWord : string
    var stream : int
    
    open : stream, "cubesTest.txt", get
    
    for j : 0 .. (maxY-5)
        for k : 0 .. maxZ
            for i : 0 .. maxX
                get : stream, skip
                exit when eof (stream)
                get : stream, sWord
                cubes (i, j, k) := 0 %strint (sWord)
            end for
        end for
            get : stream, skip
    end for
        
    for j : (maxY-5) .. maxY
        for i : 0 .. maxX
            for k : 0 .. maxZ
                cubes (i, j, k) := 0
            end for
        end for
    end for
        
    for j : 0 .. maxY
        for i : 0 .. maxX
            for k : 0 .. maxZ
                cubes (i, j, k) := 0
            end for
        end for
    end for
        
    close : stream
    
end startGame

procedure DoNothing
    
end DoNothing

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

proc resetView
    curRotationY := 45
    curRotationX := -15
    scaleFactor := startScale
    rotate
    isChanged := true
end resetView

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

proc playGame
    
    resetView
    curTime := Time.Elapsed ()
    
    loop
        if (Time.Elapsed () - curTime) > (1000 / 60) then
            secondProg += 1
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
                                
                                /*
                                GL.DrawFillTriangle (eX, sY, sZ, eX, eY, sZ, sX, eY, sZ, 146, 51, 51)
                                GL.DrawFillTriangle (sX, sY, sZ, eX, sY, sZ, sX, eY, sZ, 146, 51, 51)
                                
                                GL.DrawFillTriangle (eX, sY, eZ, eX, eY, eZ, sX, eY, eZ, 31, 38, 250)
                                GL.DrawFillTriangle (sX, sY, eZ, eX, sY, eZ, sX, eY, eZ, 31, 38, 250)
                                
                                GL.DrawFillTriangle (eX, eY, eZ, eX, eY, sZ, sX, eY, eZ, 17, 238, 24)
                                GL.DrawFillTriangle (eX, eY, sZ, sX, eY, eZ, sX, eY, sZ, 17, 238, 24)
                                
                                GL.DrawFillTriangle (sX, sY, sZ, eX, sY, sZ, sX, sY, eZ, 226, 109, 19)
                                GL.DrawFillTriangle (sX, sY, eZ, eX, sY, eZ, eX, sY, sZ, 226, 109, 19)
                                
                                GL.DrawFillTriangle (sX, sY, sZ, sX, eY, sZ, sX, eY, eZ, 245, 27, 245)
                                GL.DrawFillTriangle (sX, sY, sZ, sX, sY, eZ, sX, eY, eZ, 245, 27, 245)
                                
                                GL.DrawFillTriangle (eX, eY, sZ, eX, sY, sZ, eX, sY, eZ, 27, 245, 230)
                                GL.DrawFillTriangle (eX, eY, eZ, eX, eY, sZ, eX, sY, eZ, 27, 245, 230)
                                */
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
            
            Input.KeyDown (key)
            keyPress := false
            if key ('a') xor key ('d') then
                if key ('a') then
                    if lastKeyPress not= 1 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys = false then
                            moveLeft ()
                        else
                            moveRight ()
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys = false then
                                moveLeft ()
                            else
                                moveRight ()
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                else
                    if lastKeyPress not= 2 and Time.Elapsed - lastKeyDelay > 75 then
                        if reverseKeys = false then
                            moveRight ()
                        else
                            moveLeft ()
                        end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 2
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            if reverseKeys = false then
                                moveRight ()
                            else
                                moveLeft ()
                            end if
                            lastKeyDelay -= 5
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key ('s') then
                if lastKeyPress not= 4 and Time.Elapsed - lastKeyDelay > 75 then
                    moveDown ()
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 4
                    secondProg := (movementDelay div 2)
                else
                    if Time.Elapsed - lastKeyDelay > 75 then
                        moveDown ()
                        lastKeyDelay := Time.Elapsed
                        if inPlay = true then
                            secondProg := (movementDelay div 2)
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key ('w') xor key ('x') then
                if key ('w') then
                    if lastKeyPress not= 3 then
                        findBottom
                        %if key (KEY_SHIFT) then
                        %rotatePiece (1, 2)
                        %else
                        rotatePiece (1, 1)
                        %end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 3
                        secondProg := ((movementDelay div 2) - movementDelay)
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            findBottom
                            %if key (KEY_SHIFT) then
                            %    rotatePiece (1, 2)
                            %else
                            rotatePiece (1, 1)
                            %end if
                            lastKeyDelay -= 125
                            secondProg := ((movementDelay div 2) - movementDelay)
                        end if
                    end if
                end if
                if key ('x') then
                    if lastKeyPress not= 3 then
                        findBottom
                        %if key (KEY_SHIFT) then
                        %    rotatePiece (2, 2)
                        %else
                        rotatePiece (2, 1)
                        %end if
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 3
                        secondProg := ((movementDelay div 2) - movementDelay)
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            findBottom
                            %if key (KEY_SHIFT) then
                            %    rotatePiece (2, 2)
                            %else
                            rotatePiece (2, 1)
                            %end if
                            lastKeyDelay -= 125
                            secondProg := ((movementDelay div 2) - movementDelay)
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key (' ') then
                if inPlay = true and (lastKeyPress not= 5 or Time.Elapsed - lastKeyDelay > 350) then
                    for i : 0 .. maxY
                        moveDown ()
                    end for
                        solidify ()
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 5
                elsif inPlay = false and (lastKeyPress not= 5 or Time.Elapsed - lastKeyDelay > 350) then
                    solidify ()
                    canWin := canSpawn ()
                    if canWin = true then
                        spawnPiece ()
                    end if
                    lastKeyDelay := Time.Elapsed
                    lastKeyPress := 5
                end if
                isChanged := true
                keyPress := true
            end if
            if key ('q') xor key ('e') then
                if key ('q') then
                    if lastKeyPress not= 5 and Time.Elapsed - lastKeyDelay > 75 then
                        moveForward ()
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 5
                        secondProg -= 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            moveForward ()
                            lastKeyDelay -= 5
                        end if
                    end if
                else
                    if lastKeyPress not= 6 and Time.Elapsed - lastKeyDelay > 75 then
                        moveBackward ()
                        lastKeyDelay := Time.Elapsed
                        lastKeyPress := 6
                        secondProg -= 1
                    else
                        if Time.Elapsed - lastKeyDelay > 500 then
                            moveBackward ()
                            lastKeyDelay -= 5
                        end if
                    end if
                end if
                keyPress := true
            end if
            if key (KEY_LEFT_ARROW) xor key (KEY_RIGHT_ARROW) then
                if key (KEY_LEFT_ARROW) then
                    if key (KEY_SHIFT) then
                        curRotationY += 3
                    else
                        curRotationY += 1
                    end if
                    if curRotationY >= 180 then
                        curRotationY := -180
                    end if
                    rotate ()
                else
                    if key (KEY_SHIFT) then
                        curRotationY -= 3
                    else
                        curRotationY -= 1
                    end if
                    if curRotationY <= -180 then
                        curRotationY := 180
                    end if
                    rotate ()
                end if
            end if
            if key (KEY_UP_ARROW) xor key (KEY_DOWN_ARROW) then
                if key (KEY_UP_ARROW) then
                    if key (KEY_SHIFT) then
                        curRotationX += 3
                    else
                        curRotationX += 1
                    end if
                    if curRotationX > 90 then
                        curRotationX := 90
                    end if
                    rotate ()
                else
                    if key (KEY_SHIFT) then
                        curRotationX -= 3
                    else
                        curRotationX -= 1
                    end if
                    if curRotationX < -90 then
                        curRotationX := -90
                    end if
                    rotate ()
                end if
            end if
            if key ('r') xor key ('f') then
                if key ('r') then
                    if scaleFactor < 50 then
                        scaleFactor += 1
                        rotate ()
                    elsif scaleFactor >= 50 and scaleFactor <= startScale then
                        scaleFactor += 1
                        rotate()
                    end if
                else
                    if scaleFactor > -30 then % set to -3
                        scaleFactor -= 1
                        rotate ()
                    end if
                end if
                isChanged := true
                put scaleFactor
            end if
            if key (KEY_TAB) then
                resetView
            end if
            exit when key ('t')
            if keyPress = false then
                lastKeyPress := 0
            end if
            
        else
            delay (10)
        end if
        
        if secondProg >= movementDelay then
            if inPlay = false and canWin = true then
                solidify ()
                if canSpawn () = false then
                    put "You Lose"
                    canWin := false
                else
                    spawnPiece ()
                end if
            elsif inPlay = true and canWin = true then
                moveDown ()
            end if
            isChanged := true
            %put "1 Second"
            secondProg := 0
        end if
        
    end loop
    
    GL.Cls ()
    GL.CloseWin ()
    quickQuit ()
    
end playGame