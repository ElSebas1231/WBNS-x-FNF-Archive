-- This script made by BillyLOLwkwk
-- dont ever change this variable
local boyfriend_shadow = {
	path = '',
	scale = 1,
	flipX = false,
	noAntialiasing = false,
	color  = '00f2ff',
	cooldown = {true, true,true,true},
	shadow = false,
	range = 75,
	basedNote = false
}
local dad_shadow = {
	path = '',
	scale = 1,
	flipX = false,
	noAntialiasing = false,
	color = 'fc0303',
	cooldown = {true,true,true,true},
	shadow = false,
	range = 75,
	basedNote = false
}
-- you can change this one to custom it yourself
local duration = 0.35 -- for how long the shadow still
local num = 0
local tweenDirection = 'quadOut'

function rgbToHex(array) -- don't delete this please, i'm begging your. this is necessary
	return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function getIconColor(chr) -- get the color of the icon
	return getColorFromHex(rgbToHex(getProperty(chr .. ".healthColorArray")))
end

function boyfriendUpdateShadow() -- Update the boyfriend shadow (If the the character changed in the middle of song)
	boyfriend_shadow.path = getProperty('boyfriend.imageFile')
	boyfriend_shadow.scale = getProperty('boyfriend.jsonScale')
	boyfriend_shadow.flipX = getProperty('boyfriend.originalFlipX')
	boyfriend_shadow.noAntialiasing = getProperty('boyfriend.noAntialiasing')
	boyfriend_shadow.color = getIconColor('boyfriend')
end

function dadUpdateShadow() -- Update the dad shadow (If the the character changed in the middle of song)
	dad_shadow.path = getProperty('dad.imageFile')
	dad_shadow.scale = getProperty('dad.jsonScale')
	dad_shadow.flipX = getProperty('dad.originalFlipX')
	dad_shadow.noAntialiasing = getProperty('dad.noAntialiasing')
	dad_shadow.color = getIconColor('dad')
end

function onCreatePost() -- updating the shadow things
	boyfriendUpdateShadow()
	dadUpdateShadow()
end

function goodNoteHit(a,b,c,d) -- making the shadow for player
	if boyfriend_shadow.shadow and (d == false or (d == true and boyfriend_shadow.cooldown[b+1])) and c ~= 'GF Sing' then
		-- setup the shadow
		local tag = 'boyfriend_shadow'..tostring(num)
		local x = getProperty('boyfriend.x')
		local y = getProperty('boyfriend.y')
		makeAnimatedLuaSprite(tag, boyfriend_shadow.path, x, y)
		setProperty(tag..'.antialiasing', not boyfriend_shadow.noAntialiasing)
		setProperty(tag..'.scale.x', boyfriend_shadow.scale)
		setProperty(tag..'.scale.y', boyfriend_shadow.scale)
		setProperty(tag..'.offset.x', getProperty('boyfriend.offset.x'))
		setProperty(tag..'.offset.y', getProperty('boyfriend.offset.y'))
		if boyfriend_shadow.basedNote == true then
			if b == 0 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({194, 75, 153})))
			end
			if b == 1 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({0, 255, 255})))
			end
			if b == 2 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({18, 250, 5})))
			end
			if b == 3 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({249, 57, 63})))
			end
		else
			setProperty(tag..'.color', boyfriend_shadow.color)
		end
		setProperty(tag..'.antialiasing', boyfriend_shadow.noAntialiasing)
		setProperty(tag..'.angle', getProperty('boyfriend.angle'))
		setBlendMode(tag, 'ADD')
		if not boyfriend_shadow.flipX then
			setProperty(tag..'.flipX', true)
		end
		addAnimationByPrefix(tag, 'act', getProperty('boyfriend.animation.frameName'), 0, false)
		setObjectOrder(tag, getObjectOrder('boyfriendGroup')-1)
		addLuaSprite(tag, false)

		-- shadow job starts here
		doTweenAlpha(tag..'alpha', tag, 0,duration, tweenDirection)
		if b == 0 then
			doTweenX(tag, tag, x - boyfriend_shadow.range, duration, tweenDirection)
			runTimer('boyfriend_shadow_left', duration*2)
		end
		if b == 1 then
			doTweenY(tag, tag, y + boyfriend_shadow.range, duration, tweenDirection)
			runTimer('boyfriend_shadow_down', duration*2)
		end
		if b == 2 then
			doTweenY(tag, tag, y - boyfriend_shadow.range, duration, tweenDirection)
			runTimer('boyfriend_shadow_up', duration*2)
		end
		if b == 3 then
			doTweenX(tag, tag, x + boyfriend_shadow.range, duration, tweenDirection)
			runTimer('boyfriend_shadow_right', duration*2)
		end
		boyfriend_shadow.cooldown[b+1] = false
		num = num + 1
		--debugPrint('worked')
	end
end

function opponentNoteHit(a,b,c,d) -- Making the shadow for the opponent
	if dad_shadow.shadow and (d == false or (d == true and dad_shadow.cooldown[b+1])) and c ~= 'GF Sing' then
		-- setup the shadow
		local tag = 'dad_shadow'..tostring(num)
		local x = getProperty('dad.x')
		local y = getProperty('dad.y')
		makeAnimatedLuaSprite(tag, dad_shadow.path, x, y)
		setProperty(tag..'.antialiasing', not dad_shadow.noAntialiasing)
		setProperty(tag..'.scale.x', dad_shadow.scale)
		setProperty(tag..'.scale.y', dad_shadow.scale)
		setProperty(tag..'.offset.x', getProperty('dad.offset.x'))
		setProperty(tag..'.offset.y', getProperty('dad.offset.y'))
		if dad_shadow.basedNote == true then
			if b == 0 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({194, 75, 153})))
			end
			if b == 1 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({0, 255, 255})))
			end
			if b == 2 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({18, 250, 5})))
			end
			if b == 3 then
				setProperty(tag..'.color', getColorFromHex(rgbToHex({249, 57, 63})))
			end
		else
			setProperty(tag..'.color', dad_shadow.color)
		end
		setProperty(tag..'.antialiasing', not dad_shadow.noAntialiasing)
		setProperty(tag..'.angle', getProperty('dad.angle'))
		setBlendMode(tag, 'ADD')
		if dad_shadow.flipX then
			setProperty(tag..'.flipX', true)
		end
		addAnimationByPrefix(tag, 'act', getProperty('dad.animation.frameName'), 0, false)
		setObjectOrder(tag, getObjectOrder('dadGroup')-1)
		addLuaSprite(tag, false)
		
		-- shadow job starts here
		doTweenAlpha(tag..'alpha', tag, 0,duration, tweenDirection)
		if b == 0 then
			doTweenX(tag, tag, x - dad_shadow.range, duration, tweenDirection)
			runTimer('dad_shadow_left', duration*2)
		end
		if b == 1 then
			doTweenY(tag, tag, y + dad_shadow.range, duration, tweenDirection)
			runTimer('dad_shadow_down', duration*2)
		end
		if b == 2 then
			doTweenY(tag, tag, y - dad_shadow.range, duration, tweenDirection)
			runTimer('dad_shadow_up', duration*2)
		end
		if b == 3 then
			doTweenX(tag, tag, x + dad_shadow.range, duration, tweenDirection)
			runTimer('dad_shadow_right', duration*2)
		end
		dad_shadow.cooldown[b+1] = false
		num = num + 1
	end
end

function onTweenCompleted(tag) -- if the tweening is completed, then just erase the shadow to prevent overhead memory
	if stringStartsWith(tag, 'boyfriend_shadow') or stringStartsWith(tag, 'dad_shadow') then
		removeLuaSprite(tag, true)
	end
end

function onTimerCompleted(tag) -- to count the time of the delay between shadows (in sustain note scenario)
	if tag == 'boyfriend_shadow_left' then
		boyfriend_shadow.cooldown[1] = true
	end
	if tag == 'boyfriend_shadow_down' then
		boyfriend_shadow.cooldown[2] = true
	end
	if tag == 'boyfriend_shadow_up' then
		boyfriend_shadow.cooldown[3] = true
	end
	if tag == 'boyfriend_shadow_right' then
		boyfriend_shadow.cooldown[4] = true
	end
	if tag == 'dad_shadow_left' then
		dad_shadow.cooldown[1] = true
	end
	if tag == 'dad_shadow_down' then
		dad_shadow.cooldown[2] = true
	end
	if tag == 'dad_shadow_up' then
		dad_shadow.cooldown[3] = true
	end
	if tag == 'dad_shadow_right' then
		dad_shadow.cooldown[4] = true
	end
end

function onEvent(n,v1,v2) -- f*ck this documentation and my english
	if n == "Shadow_enabled" then -- want to enabled it or disable it
		if v1 == 'dad' then
			if v2 == 'true' or v2 == 't' then
				dad_shadow.shadow = true
			else
				dad_shadow.shadow = false
			end
		else
			if v2 == 'true' then
				boyfriend_shadow.shadow = true
			else
				boyfriend_shadow.shadow = false
			end
		end
		return;
	end
	if n == 'Shadow_range' then -- change the range broo
		if v2 == '' or v2 == ' ' then
			v2 = 75
		end
		v2 = tonumber(v2)
		if v1 == 'dad' then
			dad_shadow.range = v2 
		else
			boyfriend_shadow.range = v2
		end
		return;
	end
	if n == 'Shadow_tween' then -- change the tween type
		if v1 == '' or v1 == ' ' then
			tweenDirection = 'quadOut'
		else
			tweenDirection = v1
		end
		return;
	end
	if n == 'Shadow_note' then
		if v1 == 'boyfriend' or v1 == 'bf' then
			if v2 == 'true' or v2 == 't' then
				boyfriend_shadow.basedNote = true
			else
				boyfriend_shadow.basedNote = false
			end
		else
			if v2 == 'true' or v2 == 't' then
				dad_shadow.basedNote = true
			else
				dad_shadow.basedNote = false
			end
		end
	end
	if n == "Change Character" then
		boyfriendUpdateShadow()
		dadUpdateShadow()
	end
end