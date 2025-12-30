function onEvent(name, value1, value2)
	if name == 'Camera Zoom Speed' then
		setProperty('camZooming', true)
		if value1 == '' or value1 == nil then camSpeed = 16 else camSpeed = tonumber(value1) end
		hud, game = string.match(value2, "(.*),(.*)")
		if hud == nil or hud == '' then hud = 0.03 else hud = hud or value2	end
		if game == nil or game == '' then game = 0.015 else game = (string.gsub(game, " ", "")) or game end
	end
end

function onStepHit()
	if curStep % camSpeed == 0 and (camSpeed ~= nil or camSpeed == '') and getProperty('defaultCamZoom') < 1.35 and cameraZoomOnBeat then
		setProperty('camGame.zoom', getProperty('camGame.zoom') + game)
		setProperty('camHUD.zoom', getProperty('camHUD.zoom') + hud)
	end
	if curStep % 16 == 0 then
		if hud <= '0.03' then setProperty('camHUD.zoom', getProperty('camHUD.zoom') - 0.03) end
		if game <= '0.015' then setProperty('camGame.zoom', getProperty('camGame.zoom') - 0.015) end
	end
end