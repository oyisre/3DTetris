%playSound will play the indicated sound when called
proc playSound (select : int)
    
    if soundOn = true then
        var filePath : string := File.FullPath ("soundManager.t")
        filePath := File.Parent (filePath)
        filePath := filePath + "/Sounds/"
        if select = 1 then
            Music.PlayFileReturn (filePath + "blip.WAV")
        elsif select = 2 then
            Music.PlayFileReturn (filePath + "rotate.WAV")
        end if
    end if
    
end playSound

%playMusic will start playing a random track from the list below
process playMusic (select : int)
    
    var filePath : string := File.FullPath ("soundManager.t")
    var randN : int := select
    filePath := File.Parent (filePath)
    filePath := filePath + "/Sounds/"
    
    if randN = 0 then
        randN := Rand.Int(1,7)
    end if
    
    loop
        if musicOn = true and curMusic = true then
        % no copyright infringements here!!!!!
            Music.PlayFile (filePath + "rotate.WAV")
            if randN = 0 then
                randN := Rand.Int(1,7)
            elsif randN = 6 then
                randN := 1
            else
                randN += 1
            end if
        end if
        exit when curMusic = false
    end loop
    
end playMusic