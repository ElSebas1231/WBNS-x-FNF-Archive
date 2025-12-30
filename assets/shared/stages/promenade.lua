function onCreate()
    makeLuaSprite('promenadeBG', 'misc/aquino/promenade/aquino_bg', -800, -320)
    setProperty('promenadeBG.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    scaleObject('promenadeBG', 1.2, 1.2)
    addLuaSprite('promenadeBG')
end

function onCreatePost()
    initLuaShader('adjustColor')

    for i, v in ipairs({'dad', 'gf', 'boyfriend'}) do
        setSpriteShader(v, 'adjustColor')
        setShaderFloat(v, 'hue', -35)
        setShaderFloat(v, 'saturation', -15)
        setShaderFloat(v, 'brightness', -30)
    end
end