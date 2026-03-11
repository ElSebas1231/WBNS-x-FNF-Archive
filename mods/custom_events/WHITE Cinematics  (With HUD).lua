--Created by RamenDominoes (Please credit if using this, thanks! <3)

function onCreatePost()

    makeLuaSprite('UpperBar(With HUD)q', 'empty', -210, -550)
	makeGraphic('UpperBar(With HUD)q', 1900, 550, 'ffffff')
	setObjectCamera('UpperBar(With HUD)q', 'HUD')
	addLuaSprite('UpperBar(With HUD)q', false)

    makeLuaSprite('LowerBar(With HUD)q', 'empty', -210, 720)
	makeGraphic('LowerBar(With HUD)q', 1900, 550, 'ffffff')
	setObjectCamera('LowerBar(With HUD)q', 'HUD')
	addLuaSprite('LowerBar(With HUD)q', false)

    UpperBar = getProperty('UpperBar(With HUD)q.y')
	LowerBar = getProperty('LowerBar(With HUD)q.y')

    for Notes = 0,7 do 
        StrumY = getPropertyFromGroup('strumLineNotes', Notes, 'y')
    end
end

function onEvent(name, value1, value2)
	
	if name == 'WHITE Cinematics  (With HUD)' then
	
		Speed = tonumber(value1)
		Distance = tonumber(value2)

--ENTRANCES

		if Speed and Distance > 0 then

			doTweenY('With HUD1', 'UpperBar(With HUD)q', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('With HUD2', 'LowerBar(With HUD)q', LowerBar - Distance, Speed, 'QuadOut')

		end

		if downscroll and Speed and Distance > 0 then
		
			doTweenY('With HUD1', 'UpperBar(With HUD)q', UpperBar + Distance, Speed, 'QuadOut')
			doTweenY('With HUD2', 'LowerBar(With HUD)q', LowerBar - Distance, Speed, 'QuadOut')

		end

		if Distance <= 0 then

			doTweenY('With HUD1', 'UpperBar(With HUD)q', UpperBar, Speed, 'QuadIn')
			doTweenY('With HUD2', 'LowerBar(With HUD)q', LowerBar, Speed, 'QuadIn')

		end	
	end
end
