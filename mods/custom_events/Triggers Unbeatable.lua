local fellasFlip = 1
local fellasCount = 4
local enableHeadVelocity = true
local ropeFlip = 1
local duckTrick = -1
local disableFireBar = false

function onCreatePost()
    local fellaY = -480
    createFellas('Left',-400,fellaY)
    createFellas('Right',screenWidth + 100,fellaY)

    makeLuaSprite('duckShot','unwebonable/duckCrosshair',0,0)
    setProperty('duckShot.antialiasing',false)
    screenCenter('duckShot')
    setObjectCamera('duckShot','other')
    setProperty('duckShot.alpha',0.001)
    addLuaSprite('duckShot',true)
end

function resetHeadVelocity()
    for fellas = 0,fellasCount do
        if enableHeadVelocity then
            setProperty('FellasLeft'..fellas..'.velocity.y',1000)
            setProperty('FellasRight'..fellas..'.velocity.y',-1000)
        else
            setProperty('FellasLeft'..fellas..'.velocity.y',0)
            setProperty('FellasRight'..fellas..'.velocity.y',0)
        end
    end
end

function createFellas(side,x,y)
    local rope = 'Rope'..side
    makeAnimatedLuaSprite(rope,'unwebonable/ycbu_lightning',x,y)
    addAnimationByPrefix(rope,'rope','lightning',24,true)
    setScrollFactor(rope,0,0)
    scaleObject(rope,2,2.2)
    addLuaSprite(rope,true)
    setProperty(rope..'.alpha',0.001)

    for fellas = 0,fellasCount do
        local name = 'Fellas'..side..fellas
        makeAnimatedLuaSprite(name,'unwebonable/show-totems',(side == 'Right' and screenWidth + 70 or -440), y + (500*fellas))
        setScrollFactor(name,0,0)
        setObjectOrder(name,math.min(getObjectOrder('boyfriendGroup'),getObjectOrder('dadGroup'),getObjectOrder('gfGroup'))-1)
        setProperty(name..'.antialiasing', false)
        scaleObject(name,4,4)
        
        addAnimationByPrefix(name,'totem3','totem3 idle',24,true)
        addAnimationByPrefix(name,'totem2','totem2 idle',24,true)
        addAnimationByPrefix(name,'totem1','totem1 idle',24,true)

        playAnim(name, 'totem1')

        if side == 'Right' then
            setProperty(name..'.velocity.y',500)
        else
            setProperty(name..'.velocity.y',-500)
        end
        addLuaSprite(name,true)
        setProperty(name..'.alpha',0.001)
    end
end

function onUpdate(el)
    for fellas = 0,fellasCount do
        for i, names in pairs({'FellasLeft'..fellas,'FellasRight'..fellas}) do
            while getProperty(names..'.y') <= -400 and getProperty(names..'.velocity.y') < 0 do
                setProperty(names..'.y',getProperty(names..'.y') + 500 + screenHeight + 300)
            end
            while getProperty(names..'.y') >= screenHeight + 300 and getProperty(names..'.velocity.y') > 0 do
                setProperty(names..'.y', getProperty(names..'.y') - 500 - screenHeight - 300)
            end
        end
    end
end

function onEvent(name,v1,v2)
    if name == 'Triggers Unbeatable' then
        if v1 == '28' then
            if v2 == '0' or v2 == '' then
                for head = 0,fellasCount do
                    setProperty('FellasLeft'..head..'.alpha',0)
                    setProperty('FellasRight'..head..'.alpha',0)
                end
                setProperty('RopeLeft.alpha',0)
                setProperty('RopeRight.alpha',0)

            elseif v2 == '1' then
                for head = 0,fellasCount do
                    setProperty('FellasLeft'..head..'.alpha',1)
                    setProperty('FellasRight'..head..'.alpha',1)
                    setObjectOrder('FellasLeft'..head,getObjectOrder('RopeLeft')+1)
                    setObjectOrder('FellasRight'..head,getObjectOrder('RopeRight')+1)
                    if getProperty('FellasLeft'..head..'.animation.curAnim.name') == 'totem3' then
                        setProperty('FellasLeft'..head..'.flipX',false)
                    else
                        setProperty('FellasLeft'..head..'.flipX',true)
                    end
                    if getProperty('FellasRight'..head..'.animation.curAnim.name') == 'totem3' then
                        setProperty('FellasRight'..head..'.flipX',true)
                    else
                        setProperty('FellasRight'..head..'.flipX',false)
                    end
                end
                setProperty('RopeLeft.alpha',1)
                setProperty('RopeRight.alpha',1)
                enableFellasVelocity(true)
            elseif v2 == '2' then
                doFellasImpulse()
            elseif v2 == '4' then
                enableFellasVelocity(false)
                doFellasImpulse()
            elseif v2 == '5' then
                enableFellasVelocity(true)
            elseif v2 == '6' then
                local position = {-400, screenWidth + 100}

                if ropeFlip == 1 then
                    ropeLeftX = position[2]
                    ropeRightX = position[1]
                else
                    ropeLeftX = position[1]
                    ropeRightX = position[2]
                end
                
                for fellas = 0,fellasCount do
                    doTweenX('FellasLeftX'..fellas,'FellasLeft'..fellas,ropeLeftX - 50,stepCrochet*0.003,'linear')
                    doTweenX('FellasRightX'..fellas,'FellasRight'..fellas,ropeRightX-50,stepCrochet*0.003,'linear')
                end
                doFellasImpulse()
                doTweenX('RopeLeftX','RopeLeft',ropeLeftX,stepCrochet*0.003,'linear')
                doTweenX('RopeRightX','RopeRight',ropeRightX,stepCrochet*0.003,'linear')
                ropeFlip = ropeFlip * -1
                fellasFlip = ropeFlip

                debugPrint('fellasLeftX: '..fellasLeftX..' | fellasRightX: '..fellasRightX)
            elseif v2 == '7' then
                for fellas = 0,fellasCount do
                    playAnim('FellasRight'..fellas,'totem1')
                    playAnim('FellasLeft'..fellas,'totem1')
                end
            elseif v2 == '8' then
                for fellas = 0,fellasCount do
                    playAnim('FellasRight'..fellas,'totem3')
                    playAnim('FellasLeft'..fellas,'totem3')
                end
            elseif v2 == '9' then
                for fellas = 0,fellasCount do
                    playAnim('FellasRight'..fellas,'totem2')
                    playAnim('FellasLeft'..fellas,'totem2')
                end
            end
        elseif v1 == '29' then
            if v2 ~= '1'  then
                setProperty('duckShot.alpha',1)
                duckTrick = duckTrick * -1
                if duckTrick == 1 then
                    setProperty('duckShot.color',getColorFromHex("FFFFFF"))
                else
                    setProperty('duckShot.color',getColorFromHex("FF0000"))
                end
            else
                setProperty('duckShot.alpha',0)
                duckTrick = duckTrick -1
            end
        end
    end
end

function enableFellasVelocity(enable)
    enableHeadVelocity = enable
    resetHeadVelocity()
end
function doFellasImpulse()
    for fellas = 0,fellasCount do
        setProperty('FellasRight'..fellas..'.velocity.y',1000*fellasFlip*-1)
        setProperty('FellasLeft'..fellas..'.velocity.y',1000*fellasFlip)
    end
    runTimer('ResetFellasVelocity',stepCrochet*0.002)
    fellasFlip = fellasFlip * -1
end
function onTimerCompleted(tag)
    if tag == 'ResetFellasVelocity' then
        resetHeadVelocity()
    end
end