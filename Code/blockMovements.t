%All the procedures in the file work with the same logic: check if the movement is valid, then perform it.
proc moveDown ( var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    var jEnd : int
    
    if sPointY+3 > maxY then
	jEnd := maxY
    else
	jEnd := sPointY+3
    end if
    
    for i : 0 .. maxX
	for j : sPointY .. jEnd
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if j - 1 < 0 or cubes (i, j - 1, k) >= 2 then
			inPlay := false
		    end if
		end if
	    end for
	end for
    end for
	if inPlay = true then
	for i : 0 .. maxX
	    for j : sPointY .. sPointY + 3
		for k : 0 .. maxZ
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i, j - 1, k) := 1
		    end if
		end for
	    end for
	end for
	    sPointY -= 1
	isChanged := true
    end if
end moveDown

proc moveUp (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isMoveValid := true
    for i : 0 .. maxX
	for j : sPointY .. sPointY + 3
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if j + 1 > maxY-4 or cubes (i, j + 1, k) >= 2 then
			isMoveValid := false
		    end if
		end if
	    end for
	end for
    end for
	if isMoveValid = true and inPlay = true then
	for i : 0 .. maxX
	    for decreasing j : sPointY+3 .. sPointY
		for k : 0 .. maxZ
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i, j + 1, k) := 1
		    end if
		end for
	    end for
	end for
	    sPointY += 1
	isChanged := true
    end if
end moveUp

proc moveLeft (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isMoveValid := true
    for i : 0 .. maxX
	for j : sPointY .. sPointY + 3
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if i - 1 < 0 or cubes (i - 1, j, k) >= 2 then
			isMoveValid := false
		    end if
		end if
	    end for
	end for
    end for
	
    if isMoveValid = true and inPlay = true then
	for i : 0 .. maxX
	    for j : sPointY .. sPointY + 3
		for k : 0 .. maxZ
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i - 1, j, k) := 1
		    end if
		end for
	    end for
	end for
	    sPointX -= 1
	isChanged := true
    end if
end moveLeft

proc moveRight (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isMoveValid := true
    for i : 0 .. maxX
	for j : sPointY .. sPointY + 3
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if i + 1 > maxX or cubes (i + 1, j, k) >= 2 then
			isMoveValid := false
		    end if
		end if
	    end for
	end for
    end for
	if isMoveValid = true and inPlay = true then
	for decreasing i : maxX .. 0
	    for j : sPointY .. sPointY + 3
		for k : 0 .. maxZ
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i + 1, j, k) := 1
		    end if
		end for
	    end for
	end for
	    sPointX += 1
	isChanged := true
    end if
end moveRight

proc moveForward (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isMoveValid := true
    for i : 0 .. maxX
	for j : sPointY .. sPointY + 3
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if k + 1 > maxZ or cubes (i, j, k + 1) >= 2 then
			isMoveValid := false
		    end if
		end if
	    end for
	end for
    end for
	if isMoveValid = true and inPlay = true then
	for i : 0 .. maxX
	    for j : sPointY .. sPointY + 3
		for decreasing k : maxZ .. 0
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i, j, k + 1) := 1
		    end if
		end for
	    end for
	end for
	    sPointZ += 1
	isChanged := true
    end if
end moveForward

proc moveBackward (var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    var isMoveValid := true
    for i : 0 .. maxX
	for j : sPointY .. sPointY + 3
	    for k : 0 .. maxZ
		if cubes (i, j, k) = 1 then
		    if k - 1 < 0 or cubes (i, j, k - 1) >= 2 then
			isMoveValid := false
		    end if
		end if
	    end for
	end for
    end for
	if isMoveValid = true and inPlay = true then
	for i : 0 .. maxX
	    for j : sPointY .. sPointY + 3
		for k : 0 .. maxZ
		    if cubes (i, j, k) = 1 then
			cubes (i, j, k) := 0
			cubes (i, j, k - 1) := 1
		    end if
		end for
	    end for
	end for
	    sPointZ -= 1
	isChanged := true
    end if
end moveBackward
