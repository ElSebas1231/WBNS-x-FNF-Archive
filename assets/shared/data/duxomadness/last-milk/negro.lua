function onCreate()
    makeLuaSprite('negro', '', -900, -300)
    makeGraphic('negro', 12000, 12000, '000000')
    setObjectCamera('negro', 'game')
    addLuaSprite('negro', true)

    makeLuaSprite('negro1', '', -900, -300)
    makeGraphic('negro1', 12000, 12000, '000000')
    setObjectCamera('negro1', 'hud')
    addLuaSprite('negro1', true)
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 15, 'sineinout')
    doTweenAlpha('bai2', 'negro1', 0, 15, 'sineinout')
end

function onUpdate()
    if getPropertyFromClass('backend.Conductor', 'songPosition') / 1000 >= 15 then -- If song time is greater or equal than 15 secs, removes the sprite
        if luaSpriteExists('negro') then 
            cancelTween('bai')
            cancelTween('bai2')
            removeLuaSprite('negro', true)
            removeLuaSprite('negro1', true)
        end
    end
end