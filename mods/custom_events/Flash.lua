function onCreate()
	if flashingLights then
		makeLuaSprite('flashColor', nil, 0, 0)
		setObjectCamera('flashColor', 'camHUD')
		setProperty('flashColor.alpha', 0)
		addLuaSprite('flashColor')
	end
end

function onEvent(n,v1,v2,st)
	if n == 'Flash' then
		if flashingLights then
			opNum = tonumber(v1)
			if opNum >= 0 and opNum <= 3 then
				loadGraphic('flashColor', 'lights/light'..v1)
				scaleObject('flashColor', 2, 2)
				screenCenter('flashColor')
				if getProperty('flashColor.alpha') ~= 1 then setProperty('flashColor.alpha', 1) end
				cancelTween('flTw')
		
				if v2 == '' or v2 == nil then
					doTweenAlpha('flTw', 'flashColor', 0, 0.5, 'linear')
				else
					doTweenAlpha('flTw', 'flashColor', 0, tonumber(v2), 'linear')
				end
			else 
				debugPrint('Flash ST:'..st..' | Error on input. Value 1 should be an number between 0 and 3', 'ef3f3f')
			end
		end
	end
end