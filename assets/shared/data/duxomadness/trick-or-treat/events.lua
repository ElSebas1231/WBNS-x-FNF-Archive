function onCreatePost()
    setProperty('camZooming', true)
    setProperty('camZoomingMult', false)
end

function onBeatHit()
    if curBeat == 147 then
        setProperty('camZoomingMult', true)
    end
end