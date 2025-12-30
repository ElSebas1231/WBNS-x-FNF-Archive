function onEvent(name, value1, value2)
    if name == "Cam Zoom" then
        if value2 == nil or value2 == '' then
			setProperty('defaultCamZoom', tonumber(value1))
		else
            doTweenZoom('camZoom','camGame', tonumber(value1), tonumber(value2), 'sineInOut')
		end    
    end
end

function onTweenCompleted(name)
	if name == 'camZoom' then
		setProperty("defaultCamZoom", getProperty('camGame.zoom')) 
	end
end