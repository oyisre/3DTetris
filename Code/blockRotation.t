%rotatePiece handles the rotation of any piece.
proc rotatePiece (axis, dir : int, var cubes : array 0 .. *, 0 .. *, 0 .. * of int, var tempCubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    findBottom (cubes)
    delay (10)
    if inPlay = false then
        return
    end if
    var rotateVoid : boolean := false
    var tempY : int := sPointY
    var tempX : int := sPointX
    var tempZ : int := sPointZ
    var movedX, movedZ, movedY : int := 0
    var insOffsetX, insOffsetY, insOffsetZ : int := 0
    var moveX, moveY, moveZ : int := 0
    var isLine : boolean := false
    
    %If the piece has no room to rotate because of a wall, it is moved farther from the wall. Once the rotation is complete, the block will move back in the opposite direction.
    for i : 0 .. 5
        if tempX - 2 < 0 then
            moveRight (cubes)
            movedX := 1
        end if
        if tempX + 2 > (maxX) then
            moveLeft (cubes)
            movedX := 2
        end if
        if tempY - 2 < 0 then
            moveUp (cubes)
            movedY := 1
        end if
        if tempZ - 2 < 0 then
            moveForward (cubes)
            movedZ := 1
        end if
        if tempZ + 2 > (maxZ) then
            moveBackward (cubes)
            movedZ := 2
        end if
        tempX := sPointX
        tempY := sPointY
        tempZ := sPointZ
    end for
        
    if tempX - 2 < 0 or tempX + 2 > (maxX) or tempY - 2 < 0 or tempZ - 2 < 0 or tempZ + 2 > (maxZ) then
        if movedX > 0 or movedZ > 0 then
            for i : 0 .. 5
                if movedX = 1 then
                    moveLeft (cubes)
                end if
                if movedX = 2 then
                    moveRight (cubes)
                end if
                if movedZ = 1 then
                    moveBackward (cubes)
                end if
                if movedZ = 2 then
                    moveForward (cubes)
                end if
            end for
        end if
        if movedY = 1 then
            if sPointY > 0 then
                moveDown (cubes)
            end if
        end if
        
        return
    end if
    
    %Depending on the piece, the pivot point of the block will differ. This part of the code sets the pivot point
    case curPiece of
    label 1 :
        tempY := sPointY + 1
    label 2 :
        tempY := sPointY + 1
    label 3 :
        tempY := sPointY + 1
    label 4 :
        if cubes (tempX, tempY + 1, tempZ) = 1 and ((cubes (tempX + 1, tempY + 1, tempZ) = 1 or cubes (tempX - 1, tempY + 1, tempZ) = 1) or (cubes(tempX,tempY+1,tempZ-1) = 1 or cubes(tempX, tempY+1,tempZ+1) = 1)) then
            tempY := sPointY + 1
        end if
    label 5 :
        tempY := sPointY + 1
    label 6 :
        tempY := sPointY + 1
    label 7 :
        isLine := true
    label :
        put "Error curPiece ", curPiece
        return
    end case
    
    %Copies the array to a temporary one
    for i : 0 .. maxX
        for j : 0 .. maxY
            for k : 0 .. maxZ
                if cubes (i, j, k) not= 1 then
                    tempCubes (i, j, k) := cubes (i, j, k)
                else
                    tempCubes (i, j, k) := 0
                end if
            end for
        end for
    end for
        
    %The standard rotation only works for everything but line pieces.
    if isLine = false then
        for i : tempX - 1 .. tempX + 1
            for j : tempY - 1 .. tempY + 1
                for k : tempZ - 1 .. tempZ + 1
                    if (i >= 0 and i <= maxX) and j >= 0 and (k >= 0 and k <= maxZ) then
                        if cubes (i, j, k) = 1 then
                            
                            moveX := insOffsetX
                            moveY := insOffsetY
                            moveZ := insOffsetZ
                            
                            if axis = 1 then
                                
                                if dir = 1 then
                                    if i < tempX then
                                        if j > tempY then
                                            moveX += 2
                                            moveY += 0
                                        elsif j = tempY then
                                            moveX += 1
                                            moveY += 1
                                        elsif j < tempY then
                                            moveX += 0
                                            moveY += 2
                                        end if
                                    elsif i = tempX then
                                        if j > tempY then
                                            moveX += 1
                                            moveY += -1
                                        elsif j = tempY then
                                            moveX += 0
                                            moveY += 0
                                        elsif j < tempY then
                                            moveX += -1
                                            moveY += 1
                                        end if
                                    elsif i > tempX then
                                        if j > tempY then
                                            moveX += 0
                                            moveY += -2
                                        elsif j = tempY then
                                            moveX += -1
                                            moveY += -1
                                        elsif j < tempY then
                                            moveX += -2
                                            moveY += 0
                                        end if
                                    end if
                                else
                                    if i < tempX then
                                        if j > tempY then
                                            moveX += 0
                                            moveY += -2
                                        elsif j = tempY then
                                            moveX += 1
                                            moveY += -1
                                        elsif j < tempY then
                                            moveX += 2
                                            moveY += 0
                                        end if
                                    elsif i = tempX then
                                        if j > tempY then
                                            moveX += -1
                                            moveY += -1
                                        elsif j = tempY then
                                            moveX += 0
                                            moveY += 0
                                        elsif j < tempY then
                                            moveX += 1
                                            moveY += 1
                                        end if
                                    elsif i > tempX then
                                        if j > tempY then
                                            moveX += -2
                                            moveY += 0
                                        elsif j = tempY then
                                            moveX += -1
                                            moveY += 1
                                        elsif j < tempY then
                                            moveX += 0
                                            moveY += 2
                                        end if
                                    end if
                                end if
                                
                                if cubes (i + moveX, j + moveY, k) > 2 then
                                    rotateVoid := true
                                end if
                            else
                                if dir = 1 then
                                    if k < tempZ then
                                        if j > tempY then
                                            moveZ += 2
                                            moveY += 0
                                        elsif j = tempY then
                                            moveZ += 1
                                            moveY += 1
                                        elsif j < tempY then
                                            moveZ += 0
                                            moveY += 2
                                        end if
                                    elsif k = tempZ then
                                        if j > tempY then
                                            moveZ += 1
                                            moveY += -1
                                        elsif j = tempY then
                                            moveZ += 0
                                            moveY += 0
                                        elsif j < tempY then
                                            moveZ += -1
                                            moveY += 1
                                        end if
                                    elsif k > tempZ then
                                        if j > tempY then
                                            moveZ += 0
                                            moveY += -2
                                        elsif j = tempY then
                                            moveZ += -1
                                            moveY += -1
                                        elsif j < tempY then
                                            moveZ += -2
                                            moveY += 0
                                        end if
                                    end if
                                else
                                    if k < tempZ then
                                        if j > tempY then
                                            moveZ += 0
                                            moveY += -2
                                        elsif j = tempY then
                                            moveZ += 1
                                            moveY += -1
                                        elsif j < tempY then
                                            moveZ += 2
                                            moveY += 0
                                        end if
                                    elsif k = tempZ then
                                        if j > tempY then
                                            moveZ += -1
                                            moveY += -1
                                        elsif j = tempY then
                                            moveZ += 0
                                            moveY += 0
                                        elsif j < tempY then
                                            moveZ += 1
                                            moveY += 1
                                        end if
                                    elsif i > tempZ then
                                        if j > tempY then
                                            moveZ += -2
                                            moveY += 0
                                        elsif j = tempY then
                                            moveZ += -1
                                            moveY += 1
                                        elsif j < tempY then
                                            moveZ += 0
                                            moveY += 2
                                        end if
                                    end if
                                end if
                                
                                if cubes (i, j + moveY, k + moveZ) > 2 then
                                    rotateVoid := true
                                end if
                            end if
                        end if
                    else
                        rotateVoid := true
                    end if
                end for
            end for
        end for
            
        %If the rotation is valid, this part of the code will actually rotate it
        if rotateVoid = false then
            for i : tempX - 1 .. tempX + 1
                for j : tempY - 1 .. tempY + 1
                    for k : tempZ - 1 .. tempZ + 1
                        if (i >= 0 and i <= maxX) and j >= 0 and (k >= 0 and k <= maxZ) then
                            if cubes (i, j, k) = 1 then
                                moveX := insOffsetX
                                moveY := insOffsetY
                                moveZ := insOffsetZ
                                if axis = 1 then
                                    if dir = 1 then
                                        if i < tempX then
                                            if j > tempY then
                                                moveX += 2
                                                moveY += 0
                                            elsif j = tempY then
                                                moveX += 1
                                                moveY += 1
                                            elsif j < tempY then
                                                moveX += 0
                                                moveY += 2
                                            end if
                                        elsif i = tempX then
                                            if j > tempY then
                                                moveX += 1
                                                moveY += -1
                                            elsif j = tempY then
                                                moveX += 0
                                                moveY += 0
                                            elsif j < tempY then
                                                moveX += -1
                                                moveY += 1
                                            end if
                                        elsif i > tempX then
                                            if j > tempY then
                                                moveX += 0
                                                moveY += -2
                                            elsif j = tempY then
                                                moveX += -1
                                                moveY += -1
                                            elsif j < tempY then
                                                moveX += -2
                                                moveY += 0
                                            end if
                                        end if
                                    else
                                        if i < tempX then
                                            if j > tempY then
                                                moveX += 0
                                                moveY += -2
                                            elsif j = tempY then
                                                moveX += 1
                                                moveY += -1
                                            elsif j < tempY then
                                                moveX += 2
                                                moveY += 0
                                            end if
                                        elsif i = tempX then
                                            if j > tempY then
                                                moveX += -1
                                                moveY += -1
                                            elsif j = tempY then
                                                moveX += 0
                                                moveY += 0
                                            elsif j < tempY then
                                                moveX += 1
                                                moveY += 1
                                            end if
                                        elsif i > tempX then
                                            if j > tempY then
                                                moveX += -2
                                                moveY += 0
                                            elsif j = tempY then
                                                moveX += -1
                                                moveY += 1
                                            elsif j < tempY then
                                                moveX += 0
                                                moveY += 2
                                            end if
                                        end if
                                    end if
                                    
                                    if cubes (i + moveX, j + moveY, k) < 2 then
                                        tempCubes (i + moveX, j + moveY, k) := cubes (i, j, k)
                                    end if
                                else
                                    if dir = 1 then
                                        if k < tempZ then
                                            if j > tempY then
                                                moveZ += 2
                                                moveY += 0
                                            elsif j = tempY then
                                                moveZ += 1
                                                moveY += 1
                                            elsif j < tempY then
                                                moveZ += 0
                                                moveY += 2
                                            end if
                                        elsif k = tempZ then
                                            if j > tempY then
                                                moveZ += 1
                                                moveY += -1
                                            elsif j = tempY then
                                                moveZ += 0
                                                moveY += 0
                                            elsif j < tempY then
                                                moveZ += -1
                                                moveY += 1
                                            end if
                                        elsif k > tempZ then
                                            if j > tempY then
                                                moveZ += 0
                                                moveY += -2
                                            elsif j = tempY then
                                                moveZ += -1
                                                moveY += -1
                                            elsif j < tempY then
                                                moveZ += -2
                                                moveY += 0
                                            end if
                                        end if
                                    else
                                        if k < tempZ then
                                            if j > tempY then
                                                moveZ += 0
                                                moveY += -2
                                            elsif j = tempY then
                                                moveZ += 1
                                                moveY += -1
                                            elsif j < tempY then
                                                moveZ += 2
                                                moveY += 0
                                            end if
                                        elsif k = tempZ then
                                            if j > tempY then
                                                moveZ += -1
                                                moveY += -1
                                            elsif j = tempY then
                                                moveZ += 0
                                                moveY += 0
                                            elsif j < tempY then
                                                moveZ += 1
                                                moveY += 1
                                            end if
                                        elsif i > tempZ then
                                            if j > tempY then
                                                moveZ += -2
                                                moveY += 0
                                            elsif j = tempY then
                                                moveZ += -1
                                                moveY += 1
                                            elsif j < tempY then
                                                moveZ += 0
                                                moveY += 2
                                            end if
                                        end if
                                    end if
                                    if cubes (i, j + moveY, k + moveZ) < 2 then
                                        tempCubes (i, j + moveY, k + moveZ) := cubes (i, j, k)
                                    end if
                                end if
                            end if
                        end if
                    end for
                end for
            end for
                
            for i : 0 .. maxX
                for j : 0 .. maxY
                    for k : 0 .. maxZ
                        if cubes (i, j, k) = 0 and tempCubes (i, j, k) = 0 then
                            cubes (i, j, k) := 0
                        elsif cubes (i, j, k) = 1 and tempCubes (i, j, k) = 0 then
                            cubes (i, j, k) := 0
                        elsif cubes (i, j, k) = 0 and tempCubes (i, j, k) = 1 then
                            cubes (i, j, k) := 1
                        elsif cubes (i, j, k) = 1 and tempCubes (i, j, k) = 1 then
                            cubes (i, j, k) := 1
                        else
                            cubes (i, j, k) := tempCubes (i, j, k)
                        end if
                    end for
                end for
            end for        
                findBottom (cubes)
            playSound(2)
        end if
        
    else %LINE ROTATION HERE
        
        %Line rotation is hard coded since there are only 4 cases.
        if cubes(sPointX, sPointY, sPointZ) = 1 and cubes(sPointX,sPointY+1,sPointZ) = 1 and cubes(sPointX, sPointY+2, sPointZ) = 1 and cubes(sPointX,sPointY+3,sPointZ) = 1 then
            if axis = 1 then
                if sPointX+2 > maxX or sPointX-1 < 0 then
                    return
                else
                    if cubes(sPointX-1, sPointY+1, sPointZ) < 2 and cubes(sPointX,sPointY+1,sPointZ) < 2 and cubes(sPointX+1, sPointY+1, sPointZ) < 2 and cubes(sPointX+2,sPointY+1,sPointZ) < 2 then
                        cubes(sPointX, sPointY, sPointZ) := 0
                        cubes(sPointX,sPointY+1,sPointZ) :=  0
                        cubes(sPointX, sPointY+2, sPointZ) :=  0
                        cubes(sPointX,sPointY+3,sPointZ) := 0
                        cubes(sPointX-1, sPointY+1, sPointZ) := 1
                        cubes(sPointX,sPointY+1,sPointZ) := 1
                        cubes(sPointX+1, sPointY+1, sPointZ) := 1
                        cubes(sPointX+2,sPointY+1,sPointZ) := 1
                        sPointY += 1
                        sPointX -= 1
                        playSound(2)
                    end if
                end if
            else
                if sPointZ+2 > maxZ or sPointZ-1 < 0 then
                    return
                else
                    if cubes(sPointX, sPointY+1, sPointZ-1) < 2 and cubes(sPointX,sPointY+1,sPointZ) < 2 and cubes(sPointX, sPointY+1, sPointZ+1) < 2 and cubes(sPointX,sPointY+1,sPointZ+2) < 2 then
                        cubes(sPointX, sPointY, sPointZ) := 0
                        cubes(sPointX,sPointY+1,sPointZ) :=  0
                        cubes(sPointX, sPointY+2, sPointZ) :=  0
                        cubes(sPointX,sPointY+3,sPointZ) := 0
                        cubes(sPointX, sPointY+1, sPointZ-1) := 1
                        cubes(sPointX,sPointY+1,sPointZ) := 1
                        cubes(sPointX, sPointY+1, sPointZ+1) := 1
                        cubes(sPointX,sPointY+1,sPointZ+2) := 1
                        sPointY += 1
                        sPointZ -= 1
                        playSound(2)
                    end if
                end if
            end if
        elsif cubes(sPointX, sPointY, sPointZ) = 1 and cubes(sPointX+1,sPointY,sPointZ) = 1 and cubes(sPointX+2, sPointY, sPointZ) = 1 and cubes(sPointX+3,sPointY,sPointZ) = 1 then
            if axis = 1 then
                if sPointY+2 > maxY or sPointY-1 < 0 then
                    return
                else
                    if cubes(sPointX+1, sPointY-1, sPointZ) < 2 and cubes(sPointX+1,sPointY,sPointZ) < 2 and cubes(sPointX+1, sPointY+1, sPointZ) < 2 and cubes(sPointX+1,sPointY+2,sPointZ) < 2 then
                        cubes(sPointX, sPointY, sPointZ) := 0
                        cubes(sPointX+1,sPointY,sPointZ) := 0
                        cubes(sPointX+2, sPointY, sPointZ) := 0
                        cubes(sPointX+3,sPointY,sPointZ) := 0
                        cubes(sPointX+1, sPointY-1, sPointZ) := 1
                        cubes(sPointX+1,sPointY,sPointZ) := 1
                        cubes(sPointX+1, sPointY+1, sPointZ) := 1
                        cubes(sPointX+1,sPointY+2,sPointZ) := 1
                        sPointX += 1
                        sPointY -= 1
                        playSound(2)
                    end if
                end if
            end if
        elsif cubes(sPointX, sPointY, sPointZ) = 1 and cubes(sPointX,sPointY,sPointZ+1) = 1 and cubes(sPointX, sPointY, sPointZ+2) = 1 and cubes(sPointX,sPointY,sPointZ+3) = 1 then
            if axis = 2 then
                if sPointZ+2 > maxZ or sPointZ-1 < 0 then
                    return
                else
                    if cubes(sPointX, sPointY-1, sPointZ+1) < 2 and cubes(sPointX,sPointY,sPointZ+1) < 2 and cubes(sPointX, sPointY+1, sPointZ+1) < 2 and cubes(sPointX,sPointY+2,sPointZ+1) < 2 then
                        cubes(sPointX, sPointY, sPointZ) := 0
                        cubes(sPointX,sPointY,sPointZ+1) := 0
                        cubes(sPointX, sPointY, sPointZ+2) := 0
                        cubes(sPointX,sPointY,sPointZ+3) := 0
                        cubes(sPointX, sPointY-1, sPointZ+1) := 1
                        cubes(sPointX,sPointY,sPointZ+1) := 1
                        cubes(sPointX, sPointY+1, sPointZ+1) := 1
                        cubes(sPointX,sPointY+2,sPointZ+1) := 1
                        sPointY -= 1
                        sPointZ += 1
                        playSound(2)
                    end if
                end if
            end if
        end if
        
    end if
    
    isChanged := true
    findBottom (cubes)
    
    if movedX > 0 or movedZ > 0 then
        for i : 0 .. 5
            if movedX = 1 then
                moveLeft (cubes)
            end if
            if movedX = 2 then
                moveRight (cubes)
            end if
            if movedZ = 1 then
                moveBackward (cubes)
            end if
            if movedZ = 2 then
                moveForward (cubes)
            end if
        end for
    end if
    
    if movedY = 1 then
        if sPointY > 0 then
            moveDown (cubes)
        end if
        if sPointY > 0 then
            moveDown (cubes)
        end if
        if sPointY > 0 then
            moveDown (cubes)
        end if
    end if
    
end rotatePiece