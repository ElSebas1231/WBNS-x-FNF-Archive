function onEvent(name, value1, value2)
	if name == 'BfGroupTweenX' then
		doTweenX('bfGroupMoveX', 'boyfriend', value1, value2, 'SineInOut')
	end
end