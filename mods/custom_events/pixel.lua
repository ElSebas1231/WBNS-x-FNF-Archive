if shadersEnabled then
    function onCreate()
        addHaxeLibrary('LuaUtils', 'psychlua')
        addHaxeLibrary('FunkinLua', 'psychlua')
        initLuaShader('Pixel')
        makeLuaSprite('pixel')
        setSpriteShader('pixel', 'Pixel')
        setShaderFloat('pixel', 'strength', 0)
        runHaxeCode([[
            if (game.camGame.filters == null) game.camGame.filters = [];
            game.camGame.filters.push(new ShaderFilter(game.getLuaObject("pixel").shader));

            function tweenPixel(uniformVar:String, toValue:Float, time:Float, ease:String) {
                FlxTween.num(game.getLuaObject("pixel").shader.getFloat(uniformVar), toValue, Conductor.stepCrochet * 0.001 * time / game.playbackRate, {ease: LuaUtils.getTweenEaseByString(ease)}, function(num:Float) {
                    game.getLuaObject("pixel").shader.setFloat(uniformVar, num);
                });
            }
        ]]) 
    end

    function onEvent(n, v1, v2)
        if n == 'pixel' or n == 'Pixel' then
            runHaxeFunction('tweenPixel', {'strength', tonumber(v1), tonumber(v2),'linear'})
        end
    end
end