function onEvent(name, value1, value2)
	if name == 'BlackOut' then
		if value1 == 'true' then
		makeLuaSprite('BlackFlash', 'BlackFlash', -10000, 0);
		scaleObject('BlackFlash', 55, 55);
		setObjectCamera('BlackFlash', 'game')
		addLuaSprite('BlackFlash', true)
		setProperty('BlackFlash.visible', true);
		elseif value1 == 'false' then
		setProperty('BlackFlash.visible', false)
			end
		end
	end