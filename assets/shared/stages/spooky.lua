local x = 10
local y = 50
local scale = 0.85

function onCreatePost()

    makeLuaSprite('bgNoDoor', 'spooky/spunki2', x, y)
    scaleObject('bgNoDoor', scale, scale)
    addLuaSprite('bgNoDoor')

    makeLuaSprite('bgDoor', 'spooky/spunki', x, y)
    scaleObject('bgDoor', scale, scale)
    setObjectOrder('bgDoor', getObjectOrder('dadGroup')+1)
    addLuaSprite('bgDoor')

    for i, v in ipairs({'dad', 'gf'}) do setProperty(v .. '.visible', false) end
end

function onEvent(n, v1, v2)
    if n == 'Change BG' then
        for i, v in ipairs({'dad', 'gf'}) do setProperty(v .. '.visible', true) end
        removeLuaSprite('bgDoor', true)
    end
end