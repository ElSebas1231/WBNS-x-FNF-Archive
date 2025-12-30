local dodgeTime = 0
local attackTime = -1
local attack = 0
local bfMisses = false
function onCreate()
    makeLuaSprite('turmoilWarning','Turmoil_HARHARHARHAR',0,0)
    setObjectCamera('turmoilWarning','hud')
    screenCenter('turmoilWarning')
    setProperty('turmoilWarning.alpha',0.001)
    addLuaSprite('turmoilWarning',false)

    makeAnimatedLuaSprite('turmoilSpace', 'button',20,screenHeight-150)
    addAnimationByPrefix('turmoilSpace','static','button no press',0,false)
    addAnimationByPrefix('turmoilSpace','pressed','button press',24,false)
    setObjectCamera('turmoilSpace','hud')
    scaleObject('turmoilSpace',0.2,0.2)
    setProperty('turmoilSpace.alpha',0.001)
    addLuaSprite('turmoilSpace',false)

    precacheSound('warningT1')
    precacheSound('teethslam')
end
function onEvent(name,v1,v2)
    if name == 'Turmoil Attack' then
        attack = 3
        doTweenAlpha('buttonTurmoil', 'turmoilSpace',1,0.5,'circOut')
        cancelTween('turmoilWarningScaleX')
        cancelTween('turmoilWarningScaleY')
        setProperty('turmoilWarning.alpha',1)
        doTweenAlpha('turmoilWarningAlpha','turmoilWarning',0.3,stepCrochet*0.003,'cubeOut')
        scaleObject('turmoilWarning',0.7,0.7)

        screenCenter('turmoilWarning')
        setProperty('turmoilWarning.y',getProperty('turmoilWarning.y')-100)
        doTweenY('turmoilWarningY','turmoilWarning',getProperty('turmoilWarning.y')+100,math.min(stepCrochet*0.003,0.1),'cubeOut')
        playSound('warningT1')
        runTimer('turmoilDodge',stepCrochet*0.004)
    end
end

function onTimerCompleted(tag)
    if tag == 'turmoilDodge' then
        if attack == 1 then
            playAnim('dad','attack',true)
            setProperty('dad.specialAnim',true)
            
            playSound('teethslam',0.6)
            attackTime = 0.1
            doTweenAlpha('buttonTurmoil','turmoilSpace',0,0.5,'circIn')
            cameraShake('game',0.02,0.1)
        else
            attack = attack - 1
            local time = math.min(stepCrochet*0.004,0.1)
            doTweenX('turmoilWarningScaleX','turmoilWarning.scale',getProperty('turmoilWarning.scale.x')+0.15,time,'backOut')
            doTweenY('turmoilWarningScaleY','turmoilWarning.scale',getProperty('turmoilWarning.scale.y')+0.15,time,'backOut')
            setProperty('turmoilWarning.alpha',1)
            if attack == 1 then
                doTweenAlpha('turmoilWarningAlpha','turmoilWarning',0,time,'cubeOut')
                disableNotes(false,700)

                setProperty('dad.specialAnim',true)
                setProperty('dad.heyTimer',1)
            else
                doTweenAlpha('turmoilWarningAlpha','turmoilWarning',0.3,time,'cubeOut')
            end
            playSound('warningT1')
            runTimer('turmoilDodge',stepCrochet*0.004)
        end
    end
end
function bfDodge()
    dodgeTime = 0.15
    disableNotes(true,350)
    playAnim('boyfriend','dodge',true)
    setProperty('boyfriend.specialAnim',true)
    bfMisses = getProperty('boyfriend.hasMissAnimations',false)
end
function onUpdate(el)
    if dodgeTime > 0 then
        playAnim('turmoilSpace','pressed',false)
        dodgeTime = math.max(0,dodgeTime - el)
        if dodgeTime == 0 then
            setProperty('boyfriend.hasMissAnimations',bfMisses)
        end
    else
        playAnim('turmoilSpace','static')
        if keyboardJustPressed('SPACE') and not botPlay or botPlay and attackTime > 0 then
            bfDodge()
        end
    end
    if attackTime > 0 then
        if dodgeTime > 0 then
            attackTime = -1
        else
            attackTime = attackTime - el
            if attackTime <= 0 then
                setHealth(getHealth()-0.75)
            end
        end
    end
end
function disableNotes(press,time)
    for notes = 0,getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes',notes,'strumTime') - getSongPosition() <= time and getPropertyFromGroup('notes',notes,'mustPress') == press then
            setPropertyFromGroup('notes',notes,'noAnimation',true)
        end
    end
end