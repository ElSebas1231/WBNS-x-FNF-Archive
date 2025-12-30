function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'c370 hide' then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0)
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			end
		end
	end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == 'c370 hide' then
        runHaxeCode("game.opponentStrums.members["..noteData.."].playAnim('static', true);")
    end
end