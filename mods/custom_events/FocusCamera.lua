local PositionX = 0
local PositionY = 0
local targetChar = 'boyfriend'
local duration = 4
local ease = 'classic'

-- Values for determinate the duration in steps
local secsPerMin = 60
local msPerMin = 1000
local durSecond = 60
local defaultTimeSignature = 4

-- v1 = Target (Boyfriend | Dad | Girlfriend | Position | Reset),Duration
-- v2 = Ease,X,Y

function onEvent(n, v1, v2)
    if n == 'FocusCamera' then
        local opts1 = stringSplit(v1, ",")
        local opts2 = stringSplit(v2, ",")

        targetChar = (opts1[1] ~= '' and opts1[1] or targetChar)    
        duration = (tonumber(opts1[2]) ~= nil and tonumber(opts1[2]) or duration)    
        ease = (opts2[1] ~= '' and opts2[1] or 'classic')

        PositionX = (tonumber(opts2[2]) ~= nil and tonumber(opts2[2]) or PositionX)
        PositionY = (tonumber(opts2[3]) ~= nil and tonumber(opts2[3]) or PositionY)

        if string.lower(targetChar) ~= 'position' then
            if ease == 'classic' then
                if string.lower(targetChar) == 'reset' then
                    setProperty('isCameraOnForcedPos', false)
                    cameraSetTarget(mustHitSection and 'boyfriend' or 'dad') -- Target whoever is their section
                    runHaxeCode(" game.game.callOnScripts('onMoveCamera', ["..mustHitSection and 'boyfriend' or 'dad'..   "]); ")
                else
                    cancelAllTweens()
                    if string.lower(targetChar) == 'dad' or string.lower(targetChar) == 'boyfriend' then
                        setProperty('isCameraOnForcedPos', false)
                        cameraSetTarget(targetChar)
                        runHaxeCode(" game.callOnScripts('onMoveCamera', ["..targetChar.."]); ")
                    elseif string.lower(targetChar) == 'gf' or string.lower(targetChar) == 'girlfriend' then -- For targeting gf
                        setProperty('isCameraOnForcedPos', false)
                        runHaxeCode([[
                            game.camFollow.setPosition(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
                            game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
                            game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];
                            game.callOnScripts('onMoveCamera', ['gf'];
                        ]])
                    end
                    runHaxeCode([[ game.callOnScripts('onSectionHit'); ]])
                    setProperty('isCameraOnForcedPos', true)
                end
            else
                local beatLengthMs = ((secsPerMin / curBpm) * msPerMin)
                local stepLengthMs = beatLengthMs / defaultTimeSignature
                local durSeconds = stepLengthMs * duration / 1000

                if ease == 'classic' then
                    ease = 'linear'
                end

                if string.lower(targetChar) == 'reset' then
                    cancelAllTweens()
                    setProperty('isCameraOnForcedPos', false)
                    cameraSetTarget(mustHitSection and 'boyfriend' or 'dad') -- Target whoever is their section
                elseif string.lower(targetChar) == 'boyfriend' then
                    cancelAllTweens()
                    setProperty('isCameraOnForcedPos', false)

                    charCamX = getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]')
                    charCamY = getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
                    camOffsetX = getMidpointX('boyfriend') - 100 - charCamX
                    camOffsetY = getMidpointY('boyfriend') - 100 + charCamY
                    
                    targetCamFollowX = PositionX + camOffsetX
                    targetCamFollowY = PositionY + camOffsetY

                    setProperty('isCameraOnForcedPos', true)
                    doTweenX('camXBoyfriend', 'camFollow', targetCamFollowX, durSeconds, ease)
                    doTweenY('camYBoyfriend', 'camFollow', targetCamFollowY, durSeconds, ease) 
                elseif string.lower(targetChar) == 'dad' then
                    cancelAllTweens()
                    setProperty('isCameraOnForcedPos', false)
                    
                    charCamX = getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
                    charCamY = getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
                    camOffsetX = getMidpointX('dad') + 150 + charCamX
                    camOffsetY = getMidpointY('dad') - 100 + charCamY

                    targetCamFollowX = PositionX + camOffsetX
                    targetCamFollowY = PositionY + camOffsetY

                    setProperty('isCameraOnForcedPos', true)
                    doTweenX('camXDad', 'camFollow', targetCamFollowX, durSeconds, ease)
                    doTweenY('camYDad', 'camFollow', targetCamFollowY, durSeconds, ease) 
                elseif string.lower(targetChar) == 'girlfriend' or string.lower(targetChar) == 'gf' then 
                    cancelAllTweens()
                    setProperty('isCameraOnForcedPos', false)
                    
                    charCamX = getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]')
                    charCamY = getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]')
                    camOffsetX = getMidpointX('gf') + charCamX
                    camOffsetY = getMidpointY('gf') + charCamY

                    targetCamFollowX = PositionX + camOffsetX
                    targetCamFollowY = PositionY + camOffsetY

                    setProperty('isCameraOnForcedPos', true)
                    doTweenX('camXGirlFriend', 'camFollow', targetCamFollowX, durSeconds, ease)
                    doTweenY('camYGirlFriend', 'camFollow', targetCamFollowY, durSeconds, ease) 
                end
            end
        else
            local beatLengthMs = ((secsPerMin / curBpm) * msPerMin)
            local stepLengthMs = beatLengthMs / defaultTimeSignature
            local durSeconds = stepLengthMs * duration / 1000

            setProperty('isCameraOnForcedPos', true)
            cancelAllTweens()

            ease = (opts2[1] ~= '' and opts2[1] or 'linear')
            doTweenX('camXPosition', 'camFollow', PositionX, durSeconds, ease)
            doTweenY('camYPosition', 'camFollow', PositionY, durSeconds, ease)
        end
    end
end

function cancelAllTweens()
    cancelTween('camXBoyfriend')
    cancelTween('camYBoyfriend')
    cancelTween('camXDad')
    cancelTween('camYDad')
    cancelTween('camXGirlFriend')
    cancelTween('camYGirlFriend')
    cancelTween('camXPosition')
    cancelTween('camYPosition')
end