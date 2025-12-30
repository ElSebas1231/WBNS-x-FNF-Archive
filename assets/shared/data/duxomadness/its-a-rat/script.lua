function onCreate()
    makeLuaSprite('negro', '', -900, -300)
    makeGraphic('negro', 12000, 12000, '000000')
    setObjectCamera('negro', 'HUD')
    addLuaSprite('negro', true)
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 3.8, 'cubeinout')
end

function onEvent(n,v1,v2)
    if n == 'Flash Camera' then
        setBlendMode("flash", 'add')
        setObjectCamera("flash",'other')
    end
end