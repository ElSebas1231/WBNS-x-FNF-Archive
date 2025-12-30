function onCreate()
    precacheImage('all wbns/acto 1/Act_2_Intro')

    makeAnimatedLuaSprite('Act2Eye','all wbns/acto 1/Act_2_Intro',0,0)
    setObjectCamera('Act2Eye','other')
    scaleObject('Act2Eye',0.8,0.8)
    addAnimationByPrefix('Act2Eye','eyes','EyesBG',24,false)
    screenCenter('Act2Eye')
    addLuaSprite('Act2Eye',true)
    updateHitbox('Act2Eye')
    setProperty('Act2Eye.alpha',0.001)
end
function onEvent(name,v1,v2)
    if name == 'Triggers All Stars' then
        if v1 == '1' then
            if v2 == '0' then
                setProperty('camGame.visible', false)
                setProperty('camHUD.visible', false)
            elseif v2 == '1' then
                playAnim('Act2Intro','anim',true)

                setProperty('Act2Intro.y',getProperty('Act2Intro.y')+200)
                setProperty('Act2Intro.angle',-20)
                doTweenAngle('Act2IntroAngle','Act2Intro',10,2,'expoOut')
                doTweenY('Act2IntroY','Act2Intro',getProperty('Act2Intro.y')-300,1,'linear')
                doTweenX('Act2IntroScaleX','Act2Intro.scale',0.2,1,'linear')
                doTweenY('Act2IntroScaleY','Act2Intro.scale',0.2,1,'linear')
                doTweenAlpha('Act2IntroAlpha','Act2Intro',1,0.2,'cubeIn')
            elseif v2 == '2' then
                cancelTween('Act2IntroAlpha')
                doTweenAlpha('Act2IntroAlpha','Act2Intro',0,0.6,'cubeIn')
            elseif v2 == '3' then
                playAnim('Act2Eye','eyes',true)
                doTweenAlpha('Act2EyesAlpha','Act2Eye',1,0.3,'circOut')
                setProperty('Act2Eye.y',getProperty('Act2Eye.y')+150)
                doTweenY('Act2EyesY','Act2Eye',getProperty('Act2Eye.y')-100,0.3,'circOut')
                doTweenX('Act2EyesScaleX','Act2Eye.scale',1.1,0.6,'expoIn')
                doTweenY('Act2EyesScaleY','Act2Eye.scale',1.1,0.6,'expoIn')
            end
        elseif v1 == '2' then
            cancelTween('Act2IntroY')
            cancelTween('Act2IntroAngle')
            cancelTween('Act2IntroScaleX')
            cancelTween('Act2IntroScaleY')
            cancelTween('Act2IntroAlpha')
            cancelTween('Act2EyesAlpha')
            cancelTween('Act2EyesScaleX')
            cancelTween('Act2EyesScaleY')
            removeLuaSprite('Act2Intro', true)
            removeLuaSprite('Act2Eye',true)
            setProperty('camGame.visible', true)
            setProperty('camHUD.visible', true)
        end
    end
end