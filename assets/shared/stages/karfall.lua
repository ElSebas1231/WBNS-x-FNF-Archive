function onCreate()
    makeLuaSprite('pared', 'misc/aquino/karfall/pared', -420, -200)
    scaleObject('pared', 0.8, 0.8)
    setProperty('pared.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('pared')

    makeLuaSprite('misc', 'misc/aquino/karfall/misc', -420, -200)
    scaleObject('misc', 0.8, 0.8)
    setProperty('misc.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('misc')

    makeLuaSprite('piso', 'misc/aquino/karfall/piso', -420, -200)
    scaleObject('piso', 0.8, 0.8)
    setProperty('piso.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('piso')
end