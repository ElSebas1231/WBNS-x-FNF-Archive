local act4objects = 50
local act4objectsCreated = false

local HudAssets = {'healthBar.bg','healthBar','iconP1','iconP2','timeBar','timeBar.bg','timeTxt'}

function onCreate()
    createStage(0)
    onMoveCamera('dad') 
    precacheStage(1)
    setProperty('camGame.alpha', 0.0001)
    setProperty('camHUD.alpha', 0.0001)

    for i = 1, 2 do
        precacheStage(i)
    end
end

function createStage(stage)
    if stage == 0 then
        makeLuaSprite('act1sky', 'all wbns/acto 1/All WBNS_BG 1', -1900, -860)
        setScrollFactor('act1sky', 0.4, 0.4)
        addLuaSprite('act1sky')
    
        if not lowQuality then
            makeAnimatedLuaSprite('act1static','all wbns/acto 1/act1_stat', -1900, -860)
            addAnimationByPrefix('act1static', 'anim', 'act1_static', 24, true)
            setProperty('act1static.alpha', 0.3)
            setScrollFactor('act1static', 0.3, 0.3)
            scaleObject('act1static', 4, 4)
            addLuaSprite('act1static')

            makeLuaSprite('act1fire', 'all wbns/acto 1/All WBNS_BG 2', -1600, -860)
            setScrollFactor('act1fire', 0.5, 0.5)
            addLuaSprite('act1fire')
        
            makeLuaSprite('act1bgfire', 'all wbns/acto 1/All WBNS_BG 3', -3800, -800)
            setScrollFactor('act1bgfire', 1.2, 0.9)
            addLuaSprite('act1bgfire')
        end
    
        makeLuaSprite('act1bgbricks', 'all wbns/acto 1/All WBNS_BG 4', -3900, -860)
        addLuaSprite('act1bgbricks')
    
        makeLuaSprite('act1bgfloorbricks', 'all wbns/acto 1/All WBNS_BG 6', -4200, -900)
        scaleObject('act1bgfloorbricks', 1.2, 1)
        addLuaSprite('act1bgfloorbricks')

        makeLuaSprite('blackbg', '', screenWidth * -0.5, screenHeight * -0.5)
        makeGraphic('blackbg', screenWidth * 2, screenHeight * 2, '000000')
        setScrollFactor('blackbg', 0)
        setObjectCamera('blackbg', 'other')
        setObjectOrder('blackbg', getObjectOrder('camHUD') - 1)
        setProperty('blackbg.alpha', 0)
        addLuaSprite('blackbg', false)

        makeLuaSprite('act1gradient', 'all wbns/acto 1/act1_gradient', 0, 0)
        screenCenter('act1gradient')
        setObjectCamera('act1gradient', 'hud')
        addLuaSprite('act1gradient', true)
    elseif stage == 1 then
        makeLuaSprite('act2space', 'all wbns/acto 2/Bg_noseque1', -3800, -900)
        scaleObject('act2space', 1.2, 1.2)
        addLuaSprite('act2space')

        makeLuaSprite('act2planets', 'all wbns/acto 2/Bg_noseque3', -3400, -500)
        setScrollFactor('act2planets', 1, 0.8)
        addLuaSprite('act2planets')

        setProperty('dad.x', -1870)
        setProperty('dad.y', 430)
        setProperty('boyfriendGroup.x', -1950)
        setProperty('boyfriendGroup.y', 900)

        setProperty('gfGroup.x', -1950)
        setProperty('gfGroup.y', 780)
        setObjectOrder('gfGroup', getObjectOrder('dadGroup') + 1)
    elseif stage == 2 then
        makeLuaSprite('act3bg', 'all wbns/acto 3/nomachenhubierasidomejorencapas', -1900, -550);
        scaleObject('act3bg', 1.3, 1.3)
        addLuaSprite('act3bg')

        makeAnimatedLuaSprite('act3static', 'all wbns/acto 3/Act3_Static', -1900, -550)
        addAnimationByPrefix('act3static', 'anim', 'act3stat', 24, true)
        setProperty('act3static.alpha', 0.8)
        setGraphicSize('act3static', getProperty('act3bg.width'), getProperty('act3bg.height'))
        addLuaSprite('act3static', false)

        makeAnimatedLuaSprite('act3speakers', 'all wbns/acto 3/speakers', getProperty('gf.x') + 1690, getProperty('gf.y') - 300)
        addAnimationByPrefix('act3speakers', 'beat', 'speakers', 24, false)
        scaleObject('act3speakers', 1.4, 1.5)
        addLuaSprite('act3speakers')

        makeAnimatedLuaSprite('act3ultradeyes', 'all wbns/acto 3/ojos ultra d', 700, 550)
        scaleObject('act3ultradeyes', 1.9, 1.9)
        addLuaSprite('act3ultradeyes', true)
        
        makeLuaSprite('act3rtx','all wbns/acto 3/rtx', 0, 0)
        setObjectCamera('act3rtx','other')
        screenCenter('act3rtx')
        setProperty('act3rtx.alpha', 0)
        addLuaSprite('act3rtx',true)

        setProperty('boyfriendGroup.x', 1600)
        setProperty('boyfriendGroup.y', 520)
        setProperty('gfGroup.x', 0)
        setProperty('gfGroup.y', 300)
        setProperty('dadGroup.x', -300)
        setProperty('dadGroup.y', -450)
        setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
        setObjectOrder('dadGroup', getObjectOrder('gfGroup') + 1)
        setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') + 1)

        setProperty('defaultCamZoom', 0.75)
    elseif stage == 3 then
        isAct4 = true

        makeAnimatedLuaSprite('act4Stat', 'all wbns/acto 4/gray static', -1900, -800)
        setScrollFactor('act4Stat', 0.3, 0.3)
        addAnimationByPrefix('act4Stat', 'anim', 'static', 24, true)
        scaleObject('act4Stat', 4, 2)
        addLuaSprite('act4Stat', false)

        makeAnimatedLuaSprite('act4Ripple', 'all wbns/acto 4/bg ripple', -1900, -550)
        addAnimationByPrefix('act4Ripple', 'anim', 'bg ripple', 24, true)
        setScrollFactor('act4Ripple', 0.5, 0.5)
        scaleObject('act4Ripple', 3, 3)
        addLuaSprite('act4Ripple', false)

        makeLuaSprite('act4grassblock', 'all wbns/acto 4/grass block', 850, 1350)
        scaleObject('act4grassblock', 1.6, 1.6)
        addLuaSprite('act4grassblock', false)

        setProperty('defaultCamZoom', 0.6)
        setProperty('gf.visible', false)
        setProperty('boyfriendGroup.x', 870)
        setProperty('boyfriendGroup.y', 450)
        setProperty('dadGroup.x', -1520)
        setProperty('dadGroup.y', 0)

        if not act4objectsCreated then createAct4objects() else reOrderAct4Objects() end
    elseif stage == 4 then
        isAct4 = true

        for i,v in ipairs({'act4Stat', 'act4Ripple', 'act4grassblock'}) do setProperty(v..'.visible', false) end

        setProperty('boyfriendGroup.x', 520)
        setProperty('boyfriendGroup.y', -300)

        makeLuaSprite('act4spotlight', 'all wbns/acto 4/spotlight', -700, -900)
        scaleObject('act4spotlight', 3.3, 3.3)
        setProperty('act4spotlight.alpha', 0.5)
        setBlendMode('act4spotlight','add')
        addLuaSprite('act4spotlight', true)
        
        makeLuaSprite('act4grassblock2', 'all wbns/acto 4/grass_block_2', 1040, 350)
        scaleObject('act4grassblock2', 1.6, 1.6)
        addLuaSprite('act4grassblock2', false)

        makeLuaSprite('memory','all wbns/acto 4/loco_memoria_1', getProperty('boyfriendGroup.x') - 400, getProperty('boyfriendGroup.y') + 300)
        setProperty('memory.alpha', 0)
        addLuaSprite('memory', true)
    
        makeLuaSprite('memoryExe','all wbns/acto 4/loco_memoria_2', getProperty('boyfriendGroup.x') + 1200, getProperty('boyfriendGroup.y') - 100)
        setProperty('memoryExe.alpha', 0)
        addLuaSprite('memoryExe', true)

        if not middlescroll then
			noteTweenX('l1', 4, 412, 0.1)
			noteTweenX('d2', 5, 524, 0.1)
			noteTweenX('u3', 6, 636, 0.1)
			noteTweenX('l4', 7, 748, 0.1)
        end

        for i = 0, 3 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
        end
        setProperty('defaultCamZoom', 0.6)
        setProperty('dad.visible', false)
    elseif stage == 5 then
        isAct4 = true

        for i,v in ipairs({'act4Stat', 'act4Ripple', 'act4grassblock'}) do setProperty(v..'.visible', true) end

        makeAnimatedLuaSprite('Act_4_FINALE_Lightingmcqueen', 'all wbns/acto 4/Act_4_FINALE_Lightingmcqueen', -1480, -400)
        addAnimationByPrefix('Act_4_FINALE_Lightingmcqueen', 'idle', 'line', 20, true)
        scaleObject('Act_4_FINALE_Lightingmcqueen', 3, 3)
        addLuaSprite('Act_4_FINALE_Lightingmcqueen', true)
        
        if not middlescroll then
			noteTweenX('l1', 4, defaultPlayerStrumX0, 0.1)
			noteTweenX('d2', 5, defaultPlayerStrumX1, 0.1)
			noteTweenX('u3', 6, defaultPlayerStrumX2, 0.1)
			noteTweenX('l4', 7, defaultPlayerStrumX3, 0.1)
        end
        
        for i = 0, 3 do setPropertyFromGroup('strumLineNotes', i, 'alpha', 1) end
        
        setProperty('dad.visible', true)
        setProperty('boyfriendGroup.x', 250)
        setProperty('boyfriendGroup.y', 250)
        setProperty('dadGroup.x', -650)
        setProperty('dadGroup.y', 100)
    end
end

function onMoveCamera(focus)
    if focus == 'dad' then
        if dadName == 'ultra_d' then
            setProperty('defaultCamZoom', 0.4)
        end

        if dadName == 'mukasa' then
            setProperty('defaultCamZoom', 0.35)
        end

        if dadName == 'Ultra_D_final' then
            setProperty('defaultCamZoom', 0.35)
        end

        if luaSpriteExists('act3ultradeyes') then
            doTweenX('act3Dad','act3ultradeyes', 600, 1.5, 'quadinout')
        end
    end

    if focus == 'boyfriend' then
        if boyfriendName == 'loco_act_1' then
            setProperty('defaultCamZoom', 0.55)
        end
        if boyfriendName == 'loco_act_2' then
            setProperty('defaultCamZoom', 0.65)
        end

        if boyfriendName == 'locoact4' then
            setProperty('defaultCamZoom', 0.45)
        end

        if luaSpriteExists('act3ultradeyes') then
            doTweenX('act3Bf','act3ultradeyes', 750, 1.5, 'quadinout')
        end
    end

    if focus == 'gf' then
        if gfName == 'soaring-acto-1' then
            setProperty('defaultCamZoom', 0.65)
        end
    end
end

local strumCheck = true 
local dadCam = false
function onUpdate(el)
    if dadCam then
        cameraSetTarget('dad')
    end

    if isAct4 then
        for objects = 0, act4objects do
            local name = 'act4object'..objects
            if objects > act4objects/2 then
                setProperty(name..'.angle', getProperty(name..'.angle') + (50*el))
            else
                setProperty(name..'.angle', getProperty(name..'.angle') - (50*el))
            end
            if getProperty(name..'.x') <= -1500 then
                setAct3FloatingObject(objects,true)
            end
        end
    end

    if curStep >= 4480 then
        setProperty('camGame.alpha', 1)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if getProperty('gf.animation.curAnim.name') == 'idle' then
            if getProperty('gf.animation.curAnim.curFrame') == 0 then
                cancelTween('act3eyesbeat')
                doTweenY('act3eyesbeat','act3ultradeyes', 580, 0.1, 'quadout')
            end
        end

        if luaSpriteExists('act3speakers') then
            playAnim('act3speakers', 'beat', true)
        end
    end
end

function onTweenCompleted(t)
    if t == 'd' then
        dadCam = false
    end

    if t == 'act3eyesbea2' then
        cancelTween('act3eyesbeat2')
        setProperty('act3ultradeyes.y', 550)
    end

    if t == 'mem1al' then
        doTweenAlpha('mem1al2', 'memory', 0, 4.5, 'quadout')
    end

    if t == 'mem2al' then
        doTweenAlpha('mem2al2', 'memoryExe', 0, 4.5, 'quadout')
    end

    if t == 'camx' then
        setProperty('camFollow.x', getProperty('camFollow.x') + 40)
        setProperty('camFollow.y', getProperty('camFollow.y') - 250)
    end

    if t == 'camgz' then
        doTweenZoom('camgzd', 'camGame', 0.95, 1, 'cubein')
    end

    if t == 'act3eyesbeat' then
        setProperty('act3ultradeyes.y', 580)
        cancelTween('act3eyesbeat2')
        doTweenY('act3eyesbeat2','act3ultradeyes', 550, 0.4, 'quadinout')
    end

    if t == 'cg' then
        doTweenZoom('cg1', 'camGame', 2.5, 0.35, 'expoin')
        doTweenAlpha('rtx', 'act3rtx', 0, 0.35, 'quadinout')
    end
    
    if t == 'zg' then
        setProperty('defaultCamZoom', 0.5)
    end

    if t == 'bfz' then
        setProperty('defaultCamZoom', 1.3)
    end

    if t == 'hudY' then
        setProperty('camHUD.y', 0)
        setProperty('camHUD.angle', 0)
    end

    if t == 'bgAl' then
        setProperty('blackbg.y', 0)
    end

    if t == 'cg1' then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)
    end
end

function createAct4objects()
    if not act4objectsCreated then
        scale = getRandomInt(60, 115) / 100

        for objects = 0,act4objects do
            makeAnimatedLuaSprite('act4object'..objects, 'all wbns/acto 4/vainas del fondo', getRandomInt(3000, 3500) , getRandomInt(-500, 400))
            addAnimationByPrefix('act4object'..objects, 'anim', 'floating objects0', 0, false)
            setScrollFactor('act4object'..objects, 0.65 + (scale / 5), 0.65 + (scale / 5))
            scaleObject('act4object'..objects, scale, scale)
            setProperty('act4object'..objects..'.animation.curAnim.curFrame', objects % 10)
            setAct3FloatingObject(objects)
            addLuaSprite('act4object'..objects)
        end
        act4objectsCreated = true
    end
end

function setAct3FloatingObject(id, pos)
    local name = 'act4object'..id
    velocity = getRandomInt(95, 220) / (7 + (act4objects * 3))

    if pos then
        setProperty(name..'.x', getRandomInt(3000, 3500))
    end
    setProperty(name..'.velocity.x',getRandomInt(-150,-500))
    setProperty(name..'.animation.curAnim.curFrame', getRandomInt(0, 9))
end

function reOrderAct4Objects()
    for objects = 0,act4objects do
        removeLuaSprite('act4object'..objects, false)
        addLuaSprite('act4object'..objects)
        if boyfriendName == 'locoact4-2' or boyfriendName == 'locoact4-3' then setProperty('act4object'..objects..'color', getColorFromHex('4e4e4e')) end
    end
end

function removeAct4Objects()
    if act4objectsCreated then
        for objects = 0,act4objects do
            removeLuaSprite('act4object'..objects,true)
        end
        act4objectsCreated = false
    end
end

function precacheStage(stage)
    if stage == 1 then
        for i = 1, 3 do
            precacheImage('all wbns/acto 2/Bg_noseque'..i)
        end
    end

    if stage == 2 then
        precacheImage('all wbns/acto 2/rtx')
        precacheImage('all wbns/acto 2/nomachenhubierasidomejorencapas')
        precacheImage('all wbns/acto 2/ojos ultra d')
        precacheImage('all wbns/acto 2/speakers')
    end

    if stage == 3 then
        precacheImage('all wbns/acto 4/Act_4_FINALE_Lightingmcqueen')
        precacheImage('all wbns/acto 4/bg ripple')
        precacheImage('all wbns/acto 4/grass block')
        precacheImage('all wbns/acto 4/grass_block_2')
        precacheImage('all wbns/acto 4/gray static')
        precacheImage('all wbns/acto 4/spotlight')
        precacheImage('all wbns/acto 4/vainas del fondo')
    end
end

function removeStage(stage,destroy)
    if destroy ~= false then
        destroy = true
    end

    if stage == 0 then
        removeLuaSprite('act1sky', destroy)
        removeLuaSprite('act1static', destroy)
        if not lowQuality then
            removeLuaSprite('act1fire', destroy)
            removeLuaSprite('act1bgfire', destroy)
        end
        removeLuaSprite('act1bgbricks', destroy)
        removeLuaSprite('act1bgfloorbricks', destroy)
        removeLuaSprite('act1gradient', destroy)
        removeFromMemory('act1_gradient')
        removeFromMemory('act1_stat')
        for i = 1, 6 do
            removeFromMemory('All WBNS_BG '..i)
        end
    elseif stage == 1 then
        removeLuaSprite('act2space', destroy)
        removeLuaSprite('act2planets', destroy)

        for i = 1, 3 do
            removeFromMemory('Bg_noseque'..i)
        end
    elseif stage == 2 then
        removeLuaSprite('act3bg', destroy)
        removeLuaSprite('act3rtx', destroy)
        removeLuaSprite('act3dark', destroy)
        removeLuaSprite('act3ultradeyes', destroy)
        removeLuaSprite('act3speakers', destroy)
        removeLuaSprite('act3static', destroy)

        removeFromMemory('ojos ultra d')
        removeFromMemory('rtx')
        removeFromMemory('speakers')
    elseif stage == 3 then
        removeLuaSprite('act4Stat', destroy)
        removeLuaSprite('act4Ripple', destroy)
        removeLuaSprite('act4grassblock', destroy)
    elseif stage == 4 then
        removeLuaSprite('act4spotlight', destroy)
        removeLuaSprite('act4grassblock2', destroy)
        removeLuaSprite('memory', destroy)
        removeLuaSprite('memoryExe', destroy)
    elseif stage == 5 then
        removeLuaSprite('act4bg', destroy)
        removeLuaSprite('act4grassblock', destroy)
        removeLuaSprite('act4spotlight', destroy)
        removeLuaSprite('act4grassblock2', destroy)

        removeFromMemory('Act_4_FINALE_Lightingmcqueen')
        removeFromMemory('grass block')
        removeFromMemory('grass_block_2')
        removeFromMemory('gray static')
        removeFromMemory('loco_memoria_1')
        removeFromMemory('loco_memoria_2')
        removeFromMemory('spotlight')
        removeFromMemory('vainas del fondo')
    end
    callScript('scripts/optimization','optimizeStage',{'all final',stage})
end

function removeFromMemory(image,isCharacter)
    if not isCharacter then
        callScript('scripts/optimization','removeFromMemory',{image})
    else
        callScript('scripts/optimization','removeCharacterFromMemory',{image})
    end
end

function rgbToHex(array)
	return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function onEvent(n, v1, v2)
    if n == 'Triggers All Stars' then
        if v1 == '0' then
            if v2 == '0' then
                setProperty('aa.alpha', 1)
                playAnim('aa','intro', true)
            end
            
            if v2 == '1' then
                if flashingLights then
                    cameraFlash('hud','FF0000', 0.5)
                end
                setProperty('camGame.alpha', 1)
                setProperty('camHUD.alpha', 1)
                --setProperty('camGame.visible', true)
                --setProperty('camHUD.visible', true)
                setProperty('aa.alpha', 0.0001)
            end

            if v2 == '1.5' then
                removeLuaSprite('aa', true)
                removeFromMemory('All_WBNS_Intro')
            end
        end

        if v1 == '2' then
            removeStage(0)
            createStage(1)
            precacheStage(2)
            cameraFlash('game','000000', 1)
            removeFromMemory('loco_act_1', true)
            removeFromMemory('gfplayable', true)
            removeFromMemory('ultra_d', true)
            setProperty('gf.visible', false)
            setProperty('iconP5.visible', false)
            removeFromMemory('soarinng icon', true)
            onDestroy()
        end

        if v1 == '3' then
            if v2 == '1' then
                cameraSetTarget('dad')
                playAnim('dad', 'jumpscare', true)
                doTweenAlpha('hud', 'camHUD', 0.2, 0.2)
            end

            if v2 == '2' then
                doTweenAlpha('hud', 'camHUD', 1, 0.1)
                onMoveCamera(mustHitSection and 'dad' or 'boyfriend')
                cameraSetTarget(mustHitSection and 'dad' or 'boyfriend')
            end

            if v2 == '3' then
                -- doTweenAlpha('c70A', 'c70', 1, 0.5)
                -- doTweenAlpha('natA', 'natalon', 1, 0.5)
                runHaxeCode("game.iconP2.changeIcon('2002 icon');")
                setProperty('iconP2.alpha', 0)
                setHealthBarColors('7c3c14', rgbToHex(getProperty('boyfriend.healthColorArray')))
                for i = 2, 4 do
                    doTweenAlpha('icA'..i, 'iconP'..i, 1, 0.5)
                end
            end

            if v2 == '4' then
                doTweenAlpha('bgAl', 'blackbg', 1, 1.5, 'quadinout')
                doTweenAngle('hudA', 'camHUD', 15, 3.6, 'quadinout')
                doTweenAlpha('hudAl', 'camHUD', 0, 3.6, 'quadin')
                doTweenY('hudY', 'camHUD', 500, 3.6, 'quadinout')
            end
        end

        if v1 == '4' then
            if v2 == '0' then
                removeStage(1)
                createStage(2)
                precacheStage(3)
                setProperty('gf.alpha', 0)
                setProperty('natalon.visible', false)
                setProperty('c70.visible', false)
                for i = 3, 4 do
                    setProperty('iconP'..i..'.visible', false)
                end

                removeLuaSprite('c70', true)
                removeLuaSprite('natalon', true)
            end
            if v2 == '1' then
                cancelTween('bgAl')
                cancelTween('hudA')
                setProperty('gf.visible', true)
                setProperty('gf.alpha', 1)
                doTweenAlpha('rtx', 'act3rtx', 0.8, 1.5, 'quadinout')
                doTweenAlpha('bgAl', 'blackbg', 0, 2.4, 'quadout')
                doTweenY('d', 'dad', getProperty('dad.y') + 900, 1.6, 'quadinout')
                setProperty('defaultCamZoom', 0.5)
                dadCam = true
            end

            if v2 == '1-1' then
                doTweenZoom('zg', 'camGame', 0.35, 2.4, 'quadinout')
                doTweenAlpha('hudAl2', 'camHUD', 1, 2.4, 'quadin')
            end

            if v2 == '1-2' then
                doTweenAlpha('hudAl2', 'camHUD', 1, 1.2, 'quadin')
            end

            if v2 == '2' then
                if luaSpriteExists('act3ultradeyes') then
                    setProperty('act3ultradeyes.visible', false)
                end
                doTweenZoom('cg', 'camGame', 0.4, 1.2, 'quadinout')
                triggerEvent('Camera Follow Pos', '950', '1420')
            end

            if v2 == '4' then
                doTweenAlpha('judddd', 'camHUD', 0.8, 0.4, 'quadinout')
            end
        end

        if v1 == '5' then
            if v2 == '0' then
                cancelTween('cg')
                setProperty('bb.alpha', 1)
                playAnim('bb','voice', true)
                setProperty('camGame.visible', false)
                setProperty('camHUD.visible', false)
                doTweenX('bbscaleX','bb.scale', 1.3, 11)
                doTweenY('bbscaleY','bb.scale', 1.3, 11)
            end

            if v2 == '0-1' then
                removeStage(2)
                createStage(3)
                onMoveCamera(mustHitSection and 'dad' or 'boyfriend')
                cameraSetTarget(mustHitSection and 'dad' or 'boyfriend')
                triggerEvent('Camera Follow Pos', '', '')
            end

            if v2 == '1' then
                cancelTween('bbscaleX')
                cancelTween('bbscaleY')
                cancelTween('bgAl')
                setProperty('gf.alpha', 0)
                setProperty('blackbg.alpha', 1)
                setProperty('blackbg.visible', false)
                setProperty('gf.visible', false)
                removeLuaSprite('bb', true)
                removeFromMemory('Act_4_Voiceline')
            end

            if v2 == '1-1' then
                setProperty('camGame.visible', true)
                setProperty('camHUD.visible', true)

                cancelTween('hudA')
                cancelTween('hudAl')
                cancelTween('hudAl2')
                cancelTween('hudY')

                doTweenAlpha('hudAl2', 'camHUD', 1, 1.5, 'quadin')
                doTweenAlpha('bgAl', 'blackbg', 0, 2.4, 'quadout')
            end

            if v2 == '1-2' then
                cancelTween('bgA')
                doTweenAlpha('bgA', 'blackbg', 1, 1.6, 'quadinout')
                doTweenX('camx', 'camFollow', 1300, 1.6, 'quadinout')
                doTweenY('camy', 'camFollow', 1200, 1.6, 'quadinout')
                doTweenAlpha('camara', 'camGame', 0, 1.6, 'quadinout')
            end

            if v2 == '2' then
                createStage(4)
                cancelTween('bgA')
                cancelTween('bgAl')
                doTweenAlpha('bgAl', 'blackbg', 0, 0.8, 'quadinout')
                setProperty('cameraSpeed', 9999)
                setProperty('starsIcons.visible', false)
                setProperty('camGame.alpha', 1)
                for i = 1, #HudAssets do
                    setProperty(tostring(HudAssets[i])..'.visible', false)
                end
                for i = 0, 3 do
                    setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
                end

                if luaTextExists('scoreMM') then
                    setProperty('scoreMM.visible', false)
                end

                setProperty('defaultCamZoom', 0.6)
            end

            if v2 == '3' then
                if flashingLights then
                    cameraFlash('hud', 'ffffff', 0.5)
                end
                
                cancelTween('bgA')
                cancelTween('bgAl')
                setProperty('blackbg.alpha', 0)

                act4objects = 100
                setProperty('camFollow.x', 89)
                setProperty('camFollow.y', 480)
                local zoom = 0.9
                setProperty('camGame.zoom', zoom)
                setProperty('defaultCamZoom', zoom)
                setProperty('camZooming', false)
                setProperty('camZoomingMult', 0)
                setProperty('camZoomingDecay', 0)
                setProperty('isCameraOnForcedPos', true)
                setProperty('starsIcons.visible', true)
                
                for i = 1, #HudAssets do
                    setProperty(tostring(HudAssets[i])..'.visible', true)
                end
                for i = 0, 3 do
                    setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
                end

                if luaTextExists('scoreMM') then
                    setProperty('scoreMM.visible', true)
                end
                
                removeStage(4)
                createStage(5)
            end

            if v2 == '4' then
                cancelTween('bgA')
                cancelTween('bgAl')
                doTweenY('mem1', 'memory', getProperty('memory.y') - 300, 9)
                doTweenAlpha('mem1al', 'memory', 0.4, 4.5, 'quadin')
            end

            if v2 == '5' then
                cancelTween('bgA')
                cancelTween('bgAl')
                doTweenY('mem2', 'memoryExe', getProperty('memoryExe.y') + 900, 9)
                doTweenAlpha('mem2al', 'memoryExe', 0.4, 4.5, 'quadin')
            end

            if v2 == '6' then
                cancelTween('bgA')
                cancelTween('bgAl')
                setProperty('blackbg.alpha', 0)
                doTweenZoom('camgz', 'camGame', 1.3, 0.4, 'quadinout')
            end

            if v2 == '7' then
                setProperty('cameraSpeed', 1)
                setProperty('isCameraOnForcedPos', false)
                doTweenX('camX', 'camFollow', 350, 0.4, 'cubeIn')
                doTweenY('camY', 'camFollow', 550, 0.4, 'cubeIn')
                doTweenZoom('bfz', 'camGame', 1.3, 0.8, 'cubein')
            end

            if v2 == '8' then
                removeStage(5)
                removeAct4Objects()

                makeLuaSprite('redbg', nil, screenWidth, screenHeight)
                makeGraphic('redbg', screenWidth, screenHeight, 'ff0000')
                screenCenter('redbg')
                setObjectCamera('redbg', 'other')
                setScrollFactor('redbg', 0, 0)
                addLuaSprite('redbg')

                setProperty('camHUD.visible', false)
                setProperty('camGame.visible', false)
                setProperty('defaultCamZoom', 0.6)
                setProperty('camGame.zoom', 0.7)

                setProperty('act4end.alpha', 1)
                playAnim('act4end', 'anim', true)
            end

            if v2 == '9' then
                doTweenZoom('gmz', 'camGame', 0.25, 7.2, 'quadin')
                doTweenAlpha('act4endalpha', 'act4end', 0, 4.8, 'quadIn')
                doTweenX('act4endscalex', 'act4end.scale', 0.6, 4.8,'quadin')
                doTweenY('act4endscaley', 'act4end.scale', 0.6, 4.8,'quadin')
            end

            if v2 == '10' then
                doTweenAlpha('gameoveralpha', 'gameover', 1, 4.8, 'quadinout')
            end

            if v2 == '11' then
                cameraFade('game', '000000', 4.8)
            end
        end

        if v1 == '6' then
            local icon1 = (downscroll and 'starsIcons2' or 'starsIcons')
            local icon2 = (downscroll and 'starsIcons' or 'starsIcons2')

            playAnim(icon1, v2)
            setProperty(icon1..'.angle', 360)
            setProperty(icon1..'.visible', true)
            setProperty(icon2..'.visible', false)
            doTweenAngle('st', icon1, 0, 0.25, 'backout')

            if v2 == 'mictiaexe' then
                playAnim(icon1, v2)
                playAnim(icon2, 'natalanexe')

                setProperty('starsIcons.visible', true)
                setProperty('starsIconsicon2.visible', true)

                setProperty('starsIcons.angle', 360)
                setProperty('starsIcons2.angle', 360)

                cancelTween('st')
                doTweenAngle('st', 'starsIcons', 0, 0.25, 'backout')
                doTweenAngle('st2', 'starsIcons2', 0, 0.25, 'backout')
            end
        end
    end
end