
local modcharts = true
local defaultX = {}
local defaultY = {}

function onCreatePost()
    for strum = 0,7 do
        table.insert(defaultX,getPropertyFromGroup('strumLineNotes',strum,'x'))
        table.insert(defaultY,getPropertyFromGroup('strumLineNotes',strum,'y'))
    end
end
n = 12
m = 30
function onEvent(name, value1, value2)
	if name == 'NoteTweest3' then


setPropertyFromGroup('strumLineNotes',0,'x',getPropertyFromGroup('strumLineNotes',0,'x')+m)
noteTweenX('noteTweenX'..0, 0, defaultX[(0%4) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',1,'x',getPropertyFromGroup('strumLineNotes',1,'x')+n)
noteTweenX('noteTweenX'..1, 1, defaultX[(1%4) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',2,'x',getPropertyFromGroup('strumLineNotes',2,'x')-n)
noteTweenX('noteTweenX'..2, 2, defaultX[(2%4) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',3,'x',getPropertyFromGroup('strumLineNotes',3,'x')-m)
noteTweenX('noteTweenX'..3, 3, defaultX[(3%4) + 1], 0.4, 'sineInOut')


setPropertyFromGroup('strumLineNotes',4,'x',getPropertyFromGroup('strumLineNotes',4,'x')+m)
noteTweenX('noteTweenX'..4, 4, defaultX[(4%8) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',5,'x',getPropertyFromGroup('strumLineNotes',5,'x')+n)
noteTweenX('noteTweenX'..5, 5, defaultX[(5%8) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',6,'x',getPropertyFromGroup('strumLineNotes',6,'x')-n)
noteTweenX('noteTweenX'..6, 6, defaultX[(6%8) + 1], 0.4, 'sineInOut')
setPropertyFromGroup('strumLineNotes',7,'x',getPropertyFromGroup('strumLineNotes',7,'x')-m)
noteTweenX('noteTweenX'..7, 7, defaultX[(7%8) + 1], 0.4, 'sineInOut')

m = -m
n = -n
	end
end