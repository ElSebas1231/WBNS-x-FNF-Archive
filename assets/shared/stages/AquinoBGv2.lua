local stagePrefix = 'Dia'

function onCreate()
	if string.lower(songName) == 'made in 2002' then
		stagePrefix = 'Noche'
	else 
		stagePrefix = 'Dia'
	end

    makeLuaSprite('cielo', 'AquinoBGv2/'..stagePrefix..'/cielo', 0, 0);
	setLuaSpriteScrollFactor('cielo', 1.01, 1);
	addLuaSprite('cielo')
	
	makeLuaSprite('nubes', 'AquinoBGv2/'..stagePrefix..'/nubes', 0, 0);
	setLuaSpriteScrollFactor('nubes', 0.9, 1);
	addLuaSprite('nubes')

	makeLuaSprite('isla1', 'AquinoBGv2/'..stagePrefix..'/isla1', 0, 0);
	setLuaSpriteScrollFactor('isla1', 1, 0.8);
	addLuaSprite('isla1', false);

	makeLuaSprite('isla2', 'AquinoBGv2/'..stagePrefix..'/isla2', 0, 0);
	setLuaSpriteScrollFactor('isla2', 1.1, 0.9);
	addLuaSprite('isla2', false);

    makeLuaSprite('isla3', 'AquinoBGv2/'..stagePrefix..'/isla3', 0, 0);
	setLuaSpriteScrollFactor('isla3', 0.9, 0.8);
	addLuaSprite('isla3', false);

	makeLuaSprite('isla4', 'AquinoBGv2/'..stagePrefix..'/isla4', -100, -50);
	setLuaSpriteScrollFactor('isla4', 1.1, 1);
    addLuaSprite('isla4', false);

	makeLuaSprite('principal', 'AquinoBGv2/'..stagePrefix..'/isla_principal', 0, 0);
	setLuaSpriteScrollFactor('principal', 1, 1);
	addLuaSprite('principal', false);

	makeLuaSprite('arboles', 'AquinoBGv2/'..stagePrefix..'/arboles', 0, 0);
	setLuaSpriteScrollFactor('arboles', 1, 1);
	addLuaSprite('arboles', false);

	if stagePrefix == 'Noche' then
		makeAnimatedLuaSprite('anthony', 'AquinoBGv2/Noche/anthony', 100, 680);
		addAnimationByPrefix('anthony', 'idle', 'anthony idle0', 24, false);
		scaleObject('anthony', 1.7, 1.7);
		addLuaSprite('anthony')
	
		makeAnimatedLuaSprite('duxo', 'AquinoBGv2/Noche/duxo', 400, 680);
		addAnimationByPrefix('duxo', 'idle', 'duxo idle0', 24, false);
		scaleObject('duxo', 1.7, 1.7);
		addLuaSprite('duxo')
	end

	makeLuaSprite('arbusto', 'AquinoBGv2/'..stagePrefix..'/arbusto', 0, 0);
	setLuaSpriteScrollFactor('arbusto', 1, 1);
	addLuaSprite('arbusto', false);

	makeLuaSprite('arbusto2', 'AquinoBGv2/'..stagePrefix..'/arbusto2', 0, 0);
	setLuaSpriteScrollFactor('arbusto2', 1, 1);
	addLuaSprite('arbusto2', false);

	startTween('tweenIsla1', 'isla1', {y = getProperty('isla1.y') + 40}, 3.5, {type = 'PINGPONG', ease = 'quadInOut'})
	startTween('tweenIsla2', 'isla2', {y = getProperty('isla2.y') + 20}, 3.5, {type = 'PINGPONG', ease = 'quadInOut', startDelay = '0.5'})
	startTween('tweenIsla3', 'isla3', {y = getProperty('isla3.y') + 30}, 3.5, {type = 'PINGPONG', ease = 'quadInOut', startDelay = '1'})
	startTween('tweenIsla4', 'isla4', {y = getProperty('isla4.y') + 10}, 3.5, {type = 'PINGPONG', ease = 'quadInOut', startDelay = '1.5'})
end

function onBeatHit()
	charDance(curBeat)
end

function onCountdownTick(t)
	charDance(t)
end

function charDance(beat)
	if beat % getProperty('dad.danceEveryNumBeats') == 0 then
		if luaSpriteExists('anthony') then
			playAnim('anthony', 'idle', true)
		end

		if luaSpriteExists('duxo') then
			playAnim('duxo', 'idle', true)
		end
	end
end

function onUpdate()
	setProperty('defaultCamZoom', (mustHitSection and 0.6 or 0.7))
end