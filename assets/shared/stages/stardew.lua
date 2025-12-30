function onCreate()  
    makeLuaSprite('cielo', 'misc/aquino/stardew/cielo', -1100, -450)
    setProperty('cielo.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    setScrollFactor('cielo', 0.4, 0.4)
    scaleObject('cielo', 2, 1.8)
    addLuaSprite('cielo')

    makeLuaSprite('monts', 'misc/aquino/stardew/monts', -1300, -200)
    setProperty('monts.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    scaleObject('monts', 2, 1.8)
    setScrollFactor('monts', 0.8, 0.8)
    addLuaSprite('monts')

    makeLuaSprite('stage', 'misc/aquino/stardew/stage', -950, -300)
    setProperty('stage.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    scaleObject('stage', 2.1, 2.1)
    addLuaSprite('stage')
end