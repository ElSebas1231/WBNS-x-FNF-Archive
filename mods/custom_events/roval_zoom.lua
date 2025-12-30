function onCreatePost()
    zoom = getProperty('defaultCamZoom'); --Zoom que tiene el stage
end
function onEvent(n,v1,v2)
    if n == "roval_zoom" then
        local zumito = split(v2)
        if v2:match(",") == nil then
            zumito[2] = "linear"
        end
        zoomextra = v1
        zoomtiempo = (zumito[1])
        zoomease = (zumito[2])
        if zoomextra == '' then
            zoomextra = 0
        end
        if zoomtiempo == '' then
            zoomtiempo = 0.2
        end
        if zoomease == '' then
            zoomease = 'linear'
        end
        unezooms = (zoom + zoomextra)
        doTweenZoom('zoomtween', 'camGame', unezooms, zoomtiempo, zoomease)
        setProperty('defaultCamZoom', unezooms)  
    end
end

function split(s)
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end
