function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'c370' then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			setPropertyFromGroup('unspawnNotes', i, 'lowPriority', true)
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true); --Miss has no penalties
			end
		end
	end
end