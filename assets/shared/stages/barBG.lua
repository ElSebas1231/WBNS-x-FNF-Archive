function onCreate()
    makeLuaSprite('barBG', 'misc/aquino/barBG/bar', -460, -120)
    scaleObject('barBG', 2.4, 2.2)
    setProperty('barBG.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('barBG')

    function onCreatePost()
        setProperty('gf.visible', false)
    end
end