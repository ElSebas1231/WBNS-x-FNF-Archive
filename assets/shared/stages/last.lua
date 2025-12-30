local x = -900
local y = -600

local scale = 1.2

function onCreate()
    makeLuaSprite('bg0', nil, x, y)
    makeGraphic('bg0', 2500, 2500, '001a61')
    scaleObject('bg0', scale, scale)
    addLuaSprite('bg0')

    makeLuaSprite('bg1', 'last/bg1', x + 300, y + 120)
    scaleObject('bg1', scale - 0.2, scale - 0.2)
    addLuaSprite('bg1')

    makeLuaSprite('bg2', 'last/bg2', x, y + 130)
    scaleObject('bg2', scale - 0.2, scale - 0.2)
    setScrollFactor('bg2', 0.9, 1)
    addLuaSprite('bg2')

    makeLuaSprite('bg3', 'last/bg3', x + 200, y + 140)
    scaleObject('bg3', scale - 0.2, scale - 0.2)
    setScrollFactor('bg3', 1.05, 1)
    addLuaSprite('bg3')

    makeLuaSprite('bg4', 'last/bg4', x + 300, y + 150)
    scaleObject('bg4', scale - 0.2, scale - 0.2)
    setScrollFactor('bg4', 0.95, 1)
    addLuaSprite('bg4')

    makeLuaSprite('fg1', 'last/fg1', x, y)
    scaleObject('fg1', scale, scale)
    addLuaSprite('fg1')

    makeLuaSprite('fg2', 'last/fg2', x, y)
    scaleObject('fg2', scale, scale)
    addLuaSprite('fg2')
end