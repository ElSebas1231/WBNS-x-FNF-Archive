function onCreate()
    makeLuaSprite('negro', '', -900, -300)
    makeGraphic('negro', 12000, 12000, '000000')
    setObjectCamera('negro', 'HUD')
    addLuaSprite('negro', true)
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 3.8, 'cubeinout')
end