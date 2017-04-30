%scoreManager is called when something is done to increase the score. It'll take into account the score multiplier as well
proc scoreManager (action : string)
    
    case action of
    label "clear1":
        score += ceil(800*scoreMult)
    label "clear2":
        score += ceil(2600*scoreMult)
    label "clear3":
        score += ceil(6500*scoreMult)
    label "clear4":
        score += ceil(14000*scoreMult)
    label "softdrop":
        score += 1
    label :
        put "what"
    end case
end scoreManager