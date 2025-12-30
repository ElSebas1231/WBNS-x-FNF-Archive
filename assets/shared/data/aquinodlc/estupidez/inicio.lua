function onCreate()
    makeLuaSprite('negro', '', -500, 0)
    makeGraphic('negro', 12000, 12000, '000000')
    setObjectCamera('negro', 'hud')
    addLuaSprite('negro', true)
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 13.5, 'linear')
end