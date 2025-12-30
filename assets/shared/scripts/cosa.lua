function onCreate()
    makeAnimatedLuaSprite("intro", "grasa/grasa_intro", 1680, -200)
    addAnimationByPrefix("intro", "introduccion", "aquino intro", 24, false)
    addAnimationByIndices("intro", "idle", "aquino intro", "0", 0, false)
    addLuaSprite("intro", true)
    objectPlayAnimation("intro", "idle", true, 0)
end

function onCreatePost()
    triggerEvent("Camera Follow Pos", getProperty("intro.x")+300, getProperty("intro.y")+300)
end

function onSongStart()
    objectPlayAnimation("intro", "introduccion", true, 0)
end

function onBeatHit()
    if curBeat == 4 then
        doTweenY("introGoUp", "intro", -500, 0.3, "circInOut")
        triggerEvent("Camera Follow Pos", nil, nil)
        setProperty("defaultCamZoom", 0.5)
    end
end

-- function onCreatePost()
--     initLuaShader('DropShadow')
--     local color = hex2rgb('3CDDEF')

--     for i, v in pairs({'dad', 'boyfriend', 'gf'}) do
--         setSpriteShader(v, 'DropShadow')
--         setShaderFloat(v, 'hue', -20)
--         setShaderFloat(v, 'saturation', -20)
--         setShaderFloat(v, 'brightness', -10)
--         setShaderFloat(v, 'contrast', -20)

--         setShaderFloat(v, 'ang', 90)
--         setShaderFloat(v, 'dist', 20)
--         setShaderFloatArray(v, 'dropColor', {color.r, color.g, color.b})
--     end
-- end

-- function onUpdatePost(elapsed)
--     for i, v in pairs({'dad', 'boyfriend', 'gf'}) do
--         setShaderFloatArray(v, 'uFrameBounds', {0, 0, getProperty(v..'._frame.frame.width'), getProperty(v..'._frame.frame.height')})
--     end
-- end

-- function hex2rgb(hex)
--     return {
--         r = tonumber("0x"..hex:sub(1, 2)) / 255,
--         g = tonumber("0x"..hex:sub(3, 4)) / 255,
--         b = tonumber("0x"..hex:sub(5, 6)) / 255
--     }
-- end