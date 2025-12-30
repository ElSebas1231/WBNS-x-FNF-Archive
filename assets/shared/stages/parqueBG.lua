function onCreate()
    makeLuaSprite('cielo', 'misc/aquino/parqueBG/cielo', -950, -700)
    scaleObject('cielo', 1.2, 1.2)
    addLuaSprite('cielo')

    makeLuaSprite('arboles', 'misc/aquino/parqueBG/arboles', -950, -740)
    scaleObject('arboles', 1.2, 1.2)
    setScrollFactor('arboles', 0.9, 1)
    addLuaSprite('arboles')

    makeLuaSprite('columnas', 'misc/aquino/parqueBG/columnas', -950, -850)
    scaleObject('columnas', 1.2, 1.2)
    setScrollFactor('columnas', 1.05, 1)
    addLuaSprite('columnas')

    makeLuaSprite('piso', 'misc/aquino/parqueBG/piso', -950, -735)
    scaleObject('piso', 1.2, 1.2)
    addLuaSprite('piso')
end