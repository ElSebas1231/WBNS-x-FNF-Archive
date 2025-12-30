local targetAngle = ''
local targetCamera = ''
local duration = 0
local ease = ''

local tag = ''

function onEvent(n, v1, v2)
    if n == 'Camera Angle' then
        local opts1 = stringSplit(v1, ",")
        local opts2 = stringSplit(v2, ",")
        
        targetAngle = (opts1[1] ~= '' or opts1[1] == nil) and opts1[1] or 0
        targetCamera = (opts1[2] ~= '' or opts1[2] == nil) and opts1[2] or 'camGame'
        
        duration = (tonumber(opts2[1]) ~= '' or opts2[1] == nil) and tonumber(opts2[1]) or 0
        ease = (opts2[2] ~= '' or opts2[2] == nil) and opts2[2] or 'linear'
        
        tag = 'cameraAngleTween'..targetCamera

        cancelTween(tag)
        doTweenAngle(tag, targetCamera, targetAngle, duration, ease)
    end
end

function onTweenCompleted(t)
    if t == tag then
        setProperty(targetCamera..'.angle', targetAngle)
    end
end