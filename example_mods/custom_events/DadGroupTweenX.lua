function onEvent(name, value1, value2)
	if name == 'DadGroupTweenX' then
		doTweenX('dadGroupMoveX', 'dadGroup', value1, value2, 'SineInOut')
	end
end