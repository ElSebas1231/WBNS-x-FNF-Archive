function onCreate()
	makeLuaSprite('bege', '', -850, 0)
	makeGraphic('bege', screenWidth * 3, screenHeight * 3, 'ffffff')
	setObjectOrder('bege', getObjectOrder('gfGroup'))
	addLuaSprite('bege', false)
end