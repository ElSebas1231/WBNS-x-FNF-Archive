 --Hud Sacado del Nevados' Gallery, Programado por Josno (Yo)
--Tienes el permiso de modificarlo o mejorarlo a tu gusto!

function onCreatePost()
	--Precache images lol
	precacheImage('customYoutubeHud/black')
	precacheImage('customYoutubeHud/redline')
	precacheImage('customYoutubeHud/videohud')
	precacheImage('customYoutubeHud/timeBarBG')
	precacheImage('customYoutubeHud/grrsubtitulos')
	precacheImage('customYoutubeHud/loadingYoutube')
	precacheImage('customYoutubeHud/tandeo')
	
	--Property
	setProperty('countdownReady.visible', false)
	setProperty('countdownSet.visible', false)
	setProperty('countdownGo.visible', false)
	--setProperty('introSoundsSuffix', '-NULL')
	
	--Sprites
	makeLuaSprite('blackVignette', 'customYoutubeHud/black', 0, 0)
	setObjectCamera('blackVignette', 'other')
	setProperty('blackVignette.alpha', 0.5)
	addLuaSprite('blackVignette', true)
	
	makeLuaSprite('blackScreen', empty, 0, 0)
	makeGraphic('blackScreen', 1280, 720, '000000')
	setObjectCamera('blackScreen', 'other')
	setProperty('blackScreen.alpha', 1)
	addLuaSprite('blackScreen', true)
	
	makeAnimatedLuaSprite('loadingZZZ', 'customYoutubeHud/loadingYoutube', 0, 0)
	addAnimationByPrefix('loadingZZZ', 'load', 'loading0', 60, true)
	setObjectCamera('loadingZZZ', 'other')
	screenCenter('loadingZZZ', 'xy')
	
	makeLuaSprite('videoHud', 'customYoutubeHud/videohud', 48.5, 20)
	setObjectCamera('videoHud', 'other')
	addLuaSprite('videoHud', false)
	
	makeLuaSprite('newTimeBarBG', 'customYoutubeHud/timeBarBG', 25, 0)
	setProperty('newTimeBarBG.alpha', 0.6)
	setObjectCamera('newTimeBarBG', 'other')
	addLuaSprite('newTimeBarBG', true)

	makeLuaSprite('newTimeBar', null, 0, 0)
	makeGraphic('newTimeBar', 1235, 5, 'FF0000')
	setObjectCamera('newTimeBar', 'other')
	setProperty('newTimeBar.scale.x', 0)
	setProperty('newTimeBar.origin.x', 0)
	addLuaSprite('newTimeBar', true)
	
	makeLuaSprite('newTimeBarWhite', null, 0, 0)
	makeGraphic('newTimeBarWhite', 1235, 5, 'FFFFFF')
	setObjectCamera('newTimeBarWhite', 'other')
	setProperty('newTimeBarWhite.scale.x', 0)
	setProperty('newTimeBarWhite.origin.x', 0)
	setProperty('newTimeBarWhite.alpha', 0.4)
	addLuaSprite('newTimeBarWhite', true)
	
	--Text
	makeLuaText('videoTitle', 'AQUINO SE VOLVIO GRASOSO OFICIALMENTE :vv', 0, 20, 15)
	setTextFont('videoTitle', 'YoutubeRoboto-Light.ttf')
	setObjectCamera('videoTitle', 'other')
	setTextAlignment('videoTitle', 'left')
	setTextBorder('videoTitle', textSize, textColor)
	setTextSize('videoTitle', 27)
	addLuaText('videoTitle')
	
	setTextSize('scoreTxt', 15)
	setProperty('scoreTxt.y', 675)
	setObjectCamera('scoreTxt', 'other')
	setTextAlignment('scoreTxt', 'center')
	setTextBorder('scoreTxt', 0, '000000')
	setTextFont('scoreTxt', 'YoutubeRoboto-SemiBold.ttf')
	
	makeLuaText('/', '/', 10, 235, 681)
	setTextFont('/', 'YoutubeRoboto-Light.ttf')
	setTextAlignment('/', 'center')
	setTextBorder('/', 0, '000000')
	setObjectCamera('/', 'other')
	setProperty('/.x', 235)
	setProperty('/.y', 681)
	setTextSize('/', 18.5)
	addLuaText('/')
	
	--Fixes Order
	setObjectOrder('blackScreen', getObjectOrder('blackVignette') + 1)
	setObjectOrder('loadingZZZ', getObjectOrder('blackVignette') + 2)
	setObjectOrder('videoHud', getObjectOrder('blackVignette') + 3)
	setObjectOrder('scoreTxt', getObjectOrder('blackVignette') + 3)
	setObjectOrder('videoTitle', getObjectOrder('blackVignette') + 3)
	setObjectOrder('timeElapsed', getObjectOrder('blackVignette') + 3)
	setObjectOrder('/', getObjectOrder('blackVignette') + 3)
	setObjectOrder('grr', getObjectOrder('blackVignette') + 1)
	setObjectOrder('redline', getObjectOrder('blackVignette') + 3)
	setObjectOrder('songTime', getObjectOrder('blackVignette') + 3)
	setObjectOrder('newTimeBar', getObjectOrder('blackVignette') + 3)
	setObjectOrder('newTimeBarWhite', getObjectOrder('blackVignette') + 2)
	setObjectOrder('newTimeBarBG', getObjectOrder('blackVignette') + 2)
	
	--Timer Lmao
	if getPropertyFromClass('ClientPrefs', 'timeBarType') ~= 'Disabled' then
		makeLuaText('timeElapsed', '0:00', 50, 195, 681)
		setTextFont('timeElapsed', 'YoutubeRoboto-Light.ttf')
		setTextAlignment('timeElapsed', 'left')
		setTextBorder('timeElapsed', 0, '000000')
		setObjectCamera('timeElapsed', 'other')
		setProperty('timeElapsed.x', 195)
		setProperty('timeElapsed.y', 681)
		setTextSize('timeElapsed', 18.5)
		addLuaText('timeElapsed')
		
		makeLuaText('songTime', '0:00', 50, 249, 681)
		setTextFont('songTime', 'YoutubeRoboto-Light.ttf')
		setTextAlignment('songTime', 'left')
		setTextBorder('songTime', 0, '000000')
		setObjectCamera('songTime', 'other')
		setProperty('songTime.x', 249)
		setProperty('songTime.y', 681)
		setTextSize('songTime', 18.5)
		addLuaText('songTime')
	end
end

function onUpdate(elapsed)
	--Hud Things
	setProperty('timeTxt.visible', false)
	setProperty('timeBar.visible', false)
	setProperty('timeBarBG.visible', false)
	setProperty('healthBar.visible', false)
	setProperty('healthBarBG.visible', false)
	setProperty('Health.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
	setPropertyFromClass('Main','fpsVar.visible',false)
	
	--NewTimeBar Things
	setProperty('newTimeBarBG.y', 664)
	setProperty('newTimeBar.y', getProperty('newTimeBarBG.y'))
	setProperty('newTimeBar.x', getProperty('newTimeBarBG.x'))
	setProperty('newTimeBarWhite.y', getProperty('newTimeBarBG.y'))
	setProperty('newTimeBarWhite.x', getProperty('newTimeBarBG.x'))
	setTextColor('scoreTxt', 'FFFFFF')
end

function onCountdownTick(counter) --CustomCountdown
	if counter == 0 then
		--Red Line lmao
	elseif counter == 1 then
		setProperty('countdownReady.visible', false)
	elseif counter == 2 then
		setProperty('countdownSet.visible', false)
	elseif counter == 3 then
		setProperty('countdownGo.visible', false)
		removeLuaSprite('blackScreen', true)
	elseif counter == 4 then
		--muere mierda
		removeLuaSprite('loadingZZZ', true)
	end
end

function onSongStart() --Timer Things
	checkForLength = true;
	songTime = getProperty('songLength') / 1000
	
	removeLuaSprite('blackScreen', true)
	--removeLuaSprite('loadingZZZ', true)
	
	setTextString('songTime', formatTime(songLength))
	doTweenX('timeBarFill', 'newTimeBar.scale', 1, songTime, 'linear')
	doTweenX('timeBarWhiteFill', 'newTimeBarWhite.scale', 1, songTime, 'SineOut')
end

function onUpdatePost()
	if checkForLength then
		setTextString('timeElapsed', formatTime(getSongPosition() - noteOffset))
	end
end

function formatTime(ms)
	s = math.floor(ms/1000);
	return string.format('%01d:%02d', (s/60)%60, s%60)
end

function getSongLeft()
	return formatTime(songLength - (getSongPosition() - noteOffset))
end
