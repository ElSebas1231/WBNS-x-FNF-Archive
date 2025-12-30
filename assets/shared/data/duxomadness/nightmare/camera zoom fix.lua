function onEvent(n,v1,v2)
	if n == 'Add Camera Zoom' then
		setProperty('camGame.zoom', getProperty('camGame.zoom') + tonumber(v1))
		setProperty('camHUD.zoom', getProperty('camHUD.zoom') + tonumber(v2))
	end
end

function onUpdate(elapsed)
	defaultZoom = getProperty('defaultCamZoom')
	zoomDecay = getProperty('camZoomingDecay')

	setProperty('camGame.zoom', math.lerp(defaultZoom, getProperty('camGame.zoom'), math.exp(-elapsed * 4.011 * zoomDecay * playbackRate)))
	setProperty('camHUD.zoom', math.lerp(1, getProperty('camHUD.zoom'), math.exp(-elapsed * 6.011 * zoomDecay * playbackRate)))
end

function math.lerp(a, b, t)
	return a + (b - a) * t
end
