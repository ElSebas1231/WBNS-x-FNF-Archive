function onCreate()
    addHaxeLibrary('LuaUtils', 'psychlua')
    addHaxeLibrary('FunkinLua', 'psychlua')
    initLuaShader('vignette')
    makeLuaSprite('vignette')
    setSpriteShader('vignette', 'VignetteEffect')
    setShaderFloat('vignette', 'size', 0)
    setShaderFloat('vignette', 'strength', 1)
    runHaxeCode([[
        if (game.camGame.filters == null) game.camGame.filters = [];
        game.camGame.filters.push(new ShaderFilter(game.getLuaObject("vignette").shader));

        function tweenVignette(uniformVar:String, toValue:Float, time:Float, ease:String) {
            FlxTween.num(game.getLuaObject("vignette").shader.getFloat(uniformVar), toValue, Conductor.stepCrochet * 0.001 * time / game.playbackRate, {ease: LuaUtils.getTweenEaseByString(ease)}, function(num:Float) {
                game.getLuaObject("vignette").shader.setFloat(uniformVar, num);
            });
        }
    ]]) 
end

function onEvent(n, v1, v2)
    if n == 'Oscuridad' then
        local opts1 = stringSplit(v1, ",")
        local opts2 = stringSplit(v2, ",")

        strength = (tonumber(opts1[1]) ~= nil and tonumber(opts1[1]) or 1)
        durationStrength = (tonumber(opts1[2]) ~= nil and tonumber(opts1[2]) or 1)

        size = (tonumber(opts2[1]) ~= nil and tonumber(opts2[1]) or 0)
        durationSize = (tonumber(opts2[2]) ~= nil and tonumber(opts2[2]) or 1)

        runHaxeFunction('tweenVignette', {'strength', strength, durationStrength, 'smoothstepin'})
        runHaxeFunction('tweenVignette', {'size', size, durationSize, 'smoothstepin'})
    end
end