function onEvent(name, value1, value2)   --shitty script made by Elizm

	if name == 'Change Icon Boppin' then

	    function onBeatHit()

			scaleObject('iconP1', value1)
			scaleObject('iconP2', value2)

		end

	end

end