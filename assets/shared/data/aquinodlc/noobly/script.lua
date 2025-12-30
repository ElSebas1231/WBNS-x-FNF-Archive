function onCreatePost()
    setProperty('gf.alpha', 0)
    runHaxeCode([[
       FlxTween.tween(game.gf, {y: game.gf.y + 50}, (Conductor.crochet / 150), {ease: FlxEase.smoothStepOut, type: 4});
    ]])

    makeAnimatedLuaSprite('j1', 'misc/aquino/noobly/jojos-menacing', getProperty('gf.x'), getProperty('gf.y'))
    addAnimationByPrefix('j1', 'idle', 'anim0', 48)
    scaleObject('j1', 0.5, 0.5)
    setProperty('j1.alpha', 0)
    addLuaSprite('j1')

    makeAnimatedLuaSprite('j2', 'misc/aquino/noobly/jojos-menacing', getProperty('gf.x') + 200, getProperty('gf.y') + 200)
    addAnimationByPrefix('j2', 'idle', 'anim0', 48)
    scaleObject('j2', 0.5, 0.5)
    setProperty('j2.alpha', 0)
    addLuaSprite('j2')

    makeAnimatedLuaSprite('j3', 'misc/aquino/noobly/jojos-menacing', getProperty('gf.x'), getProperty('gf.y') + 400)
    addAnimationByPrefix('j3', 'idle', 'anim0', 48)
    scaleObject('j3', 0.5, 0.5)
    setProperty('j3.alpha', 0)
    addLuaSprite('j3')

    setObjectOrder('j1', getObjectOrder('dadGroup')-1)
    setObjectOrder('j2', getObjectOrder('dadGroup')-1)
    setObjectOrder('j3', getObjectOrder('dadGroup')-1)
end

function onEvent(n, v1, v2)
    if n == 'stand_thing' then
        setProperty('gf.color', getColorFromHex('fffff0'))
        doTweenAlpha('t1', 'gf', 0.8, 0.2)

        for i = 1, 3 do
            setProperty('j'..i..'.alpha', 1)
            doTweenY('tj'..i, 'j'..i, getProperty('j'..i..'.y') - 1000, 2.5,'smoothStepOut')
            doTweenAlpha('tAj'..i, 'j'..i, 0, 2, 'smoothStepOut')
        end
    end
end

function onTweenCompleted(t)
    if t == 't1' then
        setProperty('gf.color', 16777215)
    end
end