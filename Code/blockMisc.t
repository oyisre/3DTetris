%findBottom is used to find the bottom of the piece the player is using and assigning it's position to a variable.
proc findBottom (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    var tempY2 : int := sPointY
    for decreasing j : maxY .. 0
        for k : 0 .. maxZ
            for i : 0 .. maxX
                if cubes (i, j, k) = 1 then
                    tempY2 := j
                end if
            end for
        end for
    end for
        
    if tempY2 - sPointY = 1 then
        sPointY := tempY2
        if curPiece not= 4 then
            moveDown (cubes)
        end if
    elsif tempY2 - sPointY = 2 then
        sPointY := tempY2
        if curPiece not= 4 then
            moveDown (cubes)
            moveDown(cubes)
        end if
    else
        sPointY := tempY2
    end if
    
end findBottom

%clearLines will clear the line that's filled and move everything above it down
proc clearLines (numRows, startRow : int, var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    for j : startRow .. startRow + (numRows - 1)
        for i : 0 .. maxX
            for k : 0 .. maxZ
                cubes (i, j, k) := 0
            end for
        end for
    end for
        
    for j : startRow .. maxY
        for i : 0 .. maxX
            for k : 0 .. maxZ
                if cubes (i, j, k) >= 2 then
                    cubes (i, j - numRows, k) := cubes (i, j, k)
                    cubes (i, j, k) := 0
                end if
            end for
        end for
    end for
    
end clearLines

%checkLines scans to see if any lines are cleared
proc checkLines (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isClear : boolean := true
    var multiClear : int := 0
    var sRow : int
    
    for j : 0 .. maxY-5
        isClear := true
        for i : 0 .. maxX
            for k : 0 .. maxZ
                if cubes (i, j, k) <= 1 then
                    isClear := false
                end if
            end for
        end for
            if isClear = true then
            multiClear += 1
            sRow := j
        end if
        exit when multiClear > 0 and isClear = false
        exit when multiClear > 4
    end for
        
    if multiClear > 0 then
        clearLines (multiClear, sRow - (multiClear - 1), cubes)
    end if
end checkLines

%solidify turns the block into it's respective colour and stops it from moving
proc solidify (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    for i : 0 .. maxX
        for j : sPointY .. maxY
            for k : 0 .. maxZ
                if cubes (i, j, k) = 1 then
                    cubes (i, j, k) := curPiece + 1
                end if
            end for
        end for
    end for
        checkLines (cubes)
    inPlay := false
end solidify
