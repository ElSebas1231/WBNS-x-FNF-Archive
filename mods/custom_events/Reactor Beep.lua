function onEvent(n,v1,v2)
	if n == "Reactor Beep" then
		if flashingLights then  cameraFlash('other', 'FF0000',0.4 , true) end
	end
end