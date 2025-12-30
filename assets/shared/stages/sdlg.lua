
function onCreate()
    makeLuaSprite("bg", "sdlg/sdlg_bg", -400, -400)
    addLuaSprite("bg")
    scaleObject("bg", 2.5, 2.5)

    makeAnimatedLuaSprite("intro", "sdlg/grasa_intro", 1680, -200)
    addAnimationByPrefix("intro", "introduccion", "aquino intro", 24, false)
    addAnimationByIndices("intro", "idle", "aquino intro", "0", 0, false)
    addLuaSprite("intro", true)
    objectPlayAnimation("intro", "idle", true, 0)
end

function onCreatePost()
    triggerEvent("Camera Follow Pos", getProperty("intro.x")+300, getProperty("intro.y")+300)
end

function onSongStart()
    objectPlayAnimation("intro", "introduccion", true, 0)
end

function onBeatHit()
    if curBeat == 4 then
        doTweenY("introGoUp", "intro", -500, 0.3, "circInOut")
        triggerEvent("Camera Follow Pos", nil, nil)
        setProperty("defaultCamZoom", 0.5)
    end
    if curBeat == 304 then
        makeLuaSprite("bg", "sdlg/Loquendo", 0,230)
        addLuaSprite("bg")
        scaleObject("bg", 8, 8)
        setProperty("bg.antialiasing", false)
        setProperty("defaultCamZoom", 0.65)
    end
end