ag = 30
agW = 360
local modcharts = true
local defaultX = {}
local defaultY = {}

function onCreatePost()
    for strum = 0,7 do
        table.insert(defaultX,getPropertyFromGroup('strumLineNotes',strum,'x'))
        table.insert(defaultY,getPropertyFromGroup('strumLineNotes',strum,'y'))
    end
end

function onEvent(name, v1, v2)
	if name == 'NoteTweest' then

noteTweenAngle("kkkk", 0, -ag, 0.00001)
noteTweenAngle("tttt", 3, ag, 0.00001)

noteTweenAngle("iiii", 4, -ag, 0.00001)
noteTweenAngle("yyyy", 7, ag, 0.00001)

ag = -ag
agW = -agW
setPropertyFromGroup('strumLineNotes',0,'x',getPropertyFromGroup('strumLineNotes',0,'x')-30)
noteTweenX('noteTweenX'..0, 0, defaultX[(0%4) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',1,'x',getPropertyFromGroup('strumLineNotes',1,'x')-12)
noteTweenX('noteTweenX'..1, 1, defaultX[(1%4) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',2,'x',getPropertyFromGroup('strumLineNotes',2,'x')+12)
noteTweenX('noteTweenX'..2, 2, defaultX[(2%4) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',3,'x',getPropertyFromGroup('strumLineNotes',3,'x')+30)
noteTweenX('noteTweenX'..3, 3, defaultX[(3%4) + 1], stepCrochet*0.001*2, 'sineInOut')


setPropertyFromGroup('strumLineNotes',4,'x',getPropertyFromGroup('strumLineNotes',4,'x')-30)
noteTweenX('noteTweenX'..4, 4, defaultX[(4%8) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',5,'x',getPropertyFromGroup('strumLineNotes',5,'x')-12)
noteTweenX('noteTweenX'..5, 5, defaultX[(5%8) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',6,'x',getPropertyFromGroup('strumLineNotes',6,'x')+12)
noteTweenX('noteTweenX'..6, 6, defaultX[(6%8) + 1], stepCrochet*0.001*2, 'sineInOut')
setPropertyFromGroup('strumLineNotes',7,'x',getPropertyFromGroup('strumLineNotes',7,'x')+30)
noteTweenX('noteTweenX'..7, 7, defaultX[(7%8) + 1], stepCrochet*0.001*2, 'sineInOut')

if v1 == '1' then
noteTweenAngle("jjjjppp", 1, -agW, stepCrochet*0.001*4, 'backOut')
noteTweenAngle("oooopppp", 2, agW, stepCrochet*0.001*4, 'backOut')

noteTweenAngle("iiiippp", 5, -agW, stepCrochet*0.001*4, 'backOut')
noteTweenAngle("yyyypppp", 6, agW, stepCrochet*0.001*4, 'backOut')
end
	end
end

function onTweenCompleted(name)
if name == 'kkkk' then
noteTweenAngle("kkkk2", 0, 0, stepCrochet*0.001*5.5, 'cubeOUT')
noteTweenAngle("iiii2", 4, 0, stepCrochet*0.001*5.5, 'cubeOUT')
noteTweenAngle("tttt2", 3, 0, stepCrochet*0.001*5.5, 'cubeOUT')
noteTweenAngle("yyyy2", 7, 0, stepCrochet*0.001*5.5, 'cubeOUT')
end
end