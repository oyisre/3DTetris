%isNotLost is used to check if the game is lost before a piece is spawned
fcn isNotLost (var cubes : array 0 .. *, 0 .. *, 0 .. * of int) : boolean
    for i : 0 .. maxX
        for j : maxY-5 .. maxY-2
            for k : 0 .. maxZ
                if cubes (i, j, k) not= 0 then
                    result false
                end if
            end for
        end for
    end for
    result true
end isNotLost

%canSpawn is used to determine if the next piece can be spawned
function canSpawn ( var cubes : array 0 .. *, 0 .. *, 0 .. * of int ) : boolean
    
    var startNX : int := maxX div 2
    var startNZ : int := maxZ div 2
    sPointX := startNX
    sPointZ := startNZ
    var temp1 : int := 0
    var spawnVoid : boolean := false
    
    for i : startNX - 1 .. startNX + 1
        for j : maxY-5 .. maxY-2
            for k : startNZ - 1 .. startNZ + 1
                if cubes (i, j, k) not= 0 then
                    spawnVoid := true
                    result false
                end if
            end for
        end for
    end for
        
    result true
    
end canSpawn

%spawnPiece decides on which piece to spawn and creates it in the array
proc spawnPiece ( var cubes : array 0 .. *, 0 .. *, 0 .. * of int)
    
    curPiece := Rand.Int (1, 7)
    sPointY := maxY-5
    case curPiece of
    label 1 :
        cubes (sPointX - 1, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-3, sPointZ) := 1
    label 2 :
        cubes (sPointX - 1, maxY-5, sPointZ) := 1
        cubes (sPointX - 1, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
    label 3 :
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-3, sPointZ) := 1
        cubes (sPointX - 1, maxY-3, sPointZ) := 1
    label 4 :
        cubes (sPointX - 1, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX + 1, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
    label 5 :
        cubes (sPointX - 1, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX + 1, maxY-5, sPointZ) := 1
    label 6 :
        cubes (sPointX - 1, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
        cubes (sPointX + 1, maxY-4, sPointZ) := 1
    label 7 :
        cubes (sPointX, maxY-5, sPointZ) := 1
        cubes (sPointX, maxY-4, sPointZ) := 1
        cubes (sPointX, maxY-3, sPointZ) := 1
        cubes (sPointX, maxY-2, sPointZ) := 1
    end case
    
    inPlay := true
    
end spawnPiece
