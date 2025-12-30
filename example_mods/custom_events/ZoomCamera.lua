local defaultZoom = 1
local stageZoom = 1
local duration = 4
local direct = true
local ease = 'linear'

-- Values for determinate the duration in steps
local secsPerMin = 60
local msPerMin = 1000
local durSecond = 60
local defaultTimeSignature = 4

-- v1 = duration, mode
-- v2 = ease, zoom

function onCreate()
    stageZoom = (curStage ~= nil and getProperty('defaultCamZoom') or defaultZoom)
    -- WHATEVER YOU DO, DON'T EVEN DELETE THIS LINE OR ZOOM WILL BE 0 AND WILL FUCK UP YOUR GAME
    targetZoom = stageZoom
end

local zooming = false
function onEvent(n, v1, v2)
    if n == 'ZoomCamera' then
        local opts1 = stringSplit(v1, ",")
        local opts2 = stringSplit(v2, ",")

        duration = (tonumber(opts1[1]) ~= nil and tonumber(opts1[1]) or duration)
        isDirect = (opts1[2] == 'true' or opts1[2] == '' and true or false) -- Yeah, this kinda sucks
        
        ease = (opts2[1] ~= nil and opts2[1] or ease)
        zoom = (tonumber(opts2[2]) ~= nil and tonumber(opts2[2]) or 1)
        targetZoom = zoom * stageZoom

        if isDirect then
            cancelTween('camZoomInstant')
            doTweenZoom('camZoomInstant', 'camGame', targetZoom, 0.0001, ease)
        else
            local beatLengthMs = ((secsPerMin / curBpm) * msPerMin)
            local stepLengthMs = beatLengthMs / defaultTimeSignature
            local durSeconds = stepLengthMs * duration / 1000

            cancelTween('camZoom')
            doTweenZoom('camZoom', 'camGame', targetZoom, durSeconds, ease)
            zooming = true
        end 
    end
end

function onUpdate()
    if zooming then
        setProperty('defaultCamZoom', getProperty('camGame.zoom'))
    else
        setProperty('defaultCamZoom', targetZoom)
    end
end

-- For some reasons this get called starting the song, why? idk
function onTweenCompleted(t)
    if t == 'camZoom' or 'camZoomInstant' then
        zooming = false
        setProperty('defaultCamZoom', targetZoom)
    end
end