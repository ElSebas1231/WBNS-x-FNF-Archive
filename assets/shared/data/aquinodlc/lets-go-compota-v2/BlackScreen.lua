function onCreate()
	makeLuaSprite('negro', '', 0, 0)
    makeGraphic('negro', 1280, 720, '000000')
    setObjectCamera('negro', 'hud')
    screenCenter('negro')
    addLuaSprite('negro', true)
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 15, 'linear')
end

function onUpdate()
    if getPropertyFromClass('backend.Conductor', 'songPosition') / 1000 >= 15 then -- If song time is greater or equal than 15 secs, removes  the sprite
        if luaSpriteExists('negro') then 
            cancelTween('bai')
            removeLuaSprite('negro', true)
        end
    end
end