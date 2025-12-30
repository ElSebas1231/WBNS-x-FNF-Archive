function onCreate()
    precacheImage('All_WBNS_Intro')
    precacheImage('Act_4_Voiceline')

    precacheImage('all wbns/acto 4/Act_4_FINALE_Gameover')
    precacheImage('all wbns/acto 4/locochon_morido')

    makeAnimatedLuaSprite('aa', 'All_WBNS_Intro', 0, 0)
    addAnimationByPrefix('aa', 'intro', 'intro anim', 24, false)
    screenCenter('aa')
    setObjectCamera('aa', 'other')
    setProperty('aa.alpha', 0)
    addLuaSprite('aa', true)

    makeAnimatedLuaSprite('bb', 'Act_4_Voiceline', 0, 0)
    addAnimationByPrefix('bb', 'voice', 'thingy', 24, false)
    screenCenter('bb')
    setObjectCamera('bb', 'other')
    setProperty('bb.alpha', 0)
    addLuaSprite('bb', true)

    makeAnimatedLuaSprite('starsIcons','all wbns/acto 4/iconAct4',0,0)
    for i, icons in pairs({'2002','aquino-battle','beta-duxo','c3jo-traje','C37','capicuy','creare-un-mundo','duxo-irl','king-of-the-biome','mictiaexe','mishu','mr-a','mukasa','natalanexe','natalon','perrolol','soaringdead','sx', 't-odio-aquino', 'tomycatt', 'v-2002'}) do
        addAnimationByPrefix('starsIcons', icons, icons, 1, false)
    end
    setProperty('starsIcons.visible', false)
    setObjectCamera('starsIcons', 'hud')
    addLuaSprite('starsIcons', true)

    makeAnimatedLuaSprite('starsIcons2','all wbns/acto 4/iconAct4',0,0)
    for i, icons in pairs({'2002','aquino-battle','beta-duxo','c3jo-traje','C37','capicuy','creare-un-mundo','duxo-irl','king-of-the-biome','mictiaexe','mishu','mr-a','mukasa','natalanexe','natalon','perrolol','soaringdead','sx', 't-odio-aquino', 'tomycatt', 'v-2002'}) do
        addAnimationByPrefix('starsIcons2', icons, icons, 1, false)
    end
    setProperty('starsIcons2.visible', false)
    setObjectCamera('starsIcons2', 'hud')
    addLuaSprite('starsIcons2', true)

    makeAnimatedLuaSprite('act4end', 'all wbns/acto 4/locochon_morido', 100)
    addAnimationByPrefix('act4end', 'anim', 'loco empalado' ,24 ,false)
    scaleObject('act4end', 1.2, 1.2)
    setScrollFactor('act4end', 0, 0)
    screenCenter('act4end')
    setObjectCamera('act4end', 'other')
    setProperty('act4end.alpha', 0.001)
    addLuaSprite('act4end', true)

    makeLuaSprite('gameover','all wbns/acto 4/Act_4_FINALE_Gameover')
    setScrollFactor('gameover', 0, 0)
    setObjectCamera('gameover', 'other')
    setProperty('gameover.alpha', 0.001)
    setProperty('gameover.antialiasing', false)
    screenCenter('gameover')
    addLuaSprite('gameover', true)
    
    addHaxeLibrary('HealthIcon', 'objects')
    runHaxeCode([[
        var iconP3:HealthIcon;
        var iconP4:HealthIcon;
        var iconP5:HealthIcon;

		iconP3 = new HealthIcon('c370 icon', false);
		game.uiGroup.add(iconP3);

        iconP4 = new HealthIcon('natalon icon', false);
		game.uiGroup.add(iconP4);

        iconP5 = new HealthIcon('soarinng icon', true);
		game.uiGroup.add(iconP5);
        
        setVar('iconP3', iconP3);
        setVar('iconP4', iconP4);
        setVar('iconP5', iconP5);
    ]])
    setObjectOrder('iconP5', getObjectOrder('iconP1') - 1)
    for i = 3, 4 do
        setProperty('iconP'..i..'.alpha', 0)
        setObjectOrder('iconP'..i, getObjectOrder('iconP2') - 1)
    end
end

local extraIcon1XOff = -50
local extraIcon1YOff = -50

local extraIcon2XOff = -50
local extraIcon2YOff = 70

local iconScaleOff = 0.35

function onUpdate(el)
    scaleObject('iconP3', getProperty('iconP2.scale.x') - 0.2, getProperty('iconP2.scale.y') - 0.2)
    setProperty('iconP3.x', getProperty('iconP2.x') - 60)
    setProperty('iconP3.y', getProperty('iconP2.y') - 60)
    setProperty('iconP3.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))

    setProperty('starsIcons.x', getProperty('iconP2.x') + extraIcon1XOff)
    setProperty('starsIcons.y', getProperty('iconP2.y') + extraIcon1YOff)
    setProperty('starsIcons.alpha', getProperty('iconP2.alpha') * 0.55)
    scaleObject('starsIcons', getProperty('iconP2.scale.x') - iconScaleOff, getProperty('iconP2.scale.y') - iconScaleOff)

    setProperty('starsIcons2.x', getProperty('iconP2.x') + extraIcon2XOff)
    setProperty('starsIcons2.y', getProperty('iconP2.y') + extraIcon2YOff)
    setProperty('starsIcons2.alpha', getProperty('iconP2.alpha') * 0.55)
    scaleObject('starsIcons2', getProperty('iconP2.scale.x') - iconScaleOff, getProperty('iconP2.scale.y') - iconScaleOff)

    scaleObject('iconP4', getProperty('iconP2.scale.x') - 0.2, getProperty('iconP2.scale.y') - 0.2)
    setProperty('iconP4.x', getProperty('iconP2.x') - 80)
    setProperty('iconP4.y', getProperty('iconP2.y') + 30)
    setProperty('iconP4.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))

    scaleObject('iconP5', getProperty('iconP1.scale.x') - 0.2, getProperty('iconP1.scale.y') - 0.2)
    setProperty('iconP5.x', getProperty('iconP1.x') + 50)
    setProperty('iconP5.y', getProperty('iconP1.y') - 75)
    setProperty('iconP5.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
end