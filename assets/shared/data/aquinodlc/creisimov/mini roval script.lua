--Script creado por Roval, autorizo su uso para otros mods si me dan creditos :p
-- NO PERMITO SUBIR MI SCRIPT A GB O GAMEJOLT, ya lo hare cuando este mejor adaptado
-- Si tienes alguna duda con el script puedes hablarme por discord: Roval

-------------Parte del Script que si puedes modificar dependiendo que necesites---------------------------
opacidadhud = 0; -- La opacidad del hud que tiene AL INICIO DE LA CANCION, luego lo cambias con el evento "hudz" o "hud"
zoomextra = 0; --0.2 --Coloca con cuanto zoom extra quieres que inicie la cancion, el predeterminado de extra es 0 (solo el que tiene el stage)
showcasemode = false; -- SI ACTIVAS EL MODO SHOWCASE SE ELIMINA PUNTACION, BARRA DE TIEMPO Y EL SCORE -- Para subir videos con poco hud
saltearcontador = false; -- Saltear el contador del inicio de la cancion, puede generar bugs asi que no recomiendo usarlo tanto xd
pantallanegra = true; -- ACTIVA O DESACTIVA - Pone a camGame en 0
tiempopantalla = 2.70 -- TIEMPO QUE SE QUEDARÁ LA PANTALLA NEGRA
fondo = true; -- ACTIVA O DESACTIVA - Pone el sprite bg al inicio de la canción
colorfondo = '000000' -- negro
opacidadfondo = 1 -- SI ACTIVAS FONDO, LA OPACIDAD
tiempofondo = 0.01 -- TIEMPO QUE SE QUEDARÁ EL FONDO
----------------------------------------------------------------------------------------------------------
si3 = 0


if saltearcontador == true then
    function onCreate() -- Por cierto, si al activar esto y al iniciar la song por primera vez el audio esta bug, mejor desactiva esto :p
        setProperty('skipCountdown', true)
    end
end

function onCreatePost()
    zoom = getProperty('defaultCamZoom'); --Zoom que tiene el stage
    velocidad = getProperty('cameraSpeed'); --Velocidad al que va la camara - Se lo cambia con eventos o desde aca
    strumYOrigin = getPropertyFromGroup('strumLineNotes', 0, 'y') --Saca el valor de la Y
    strumXOriginBF = getPropertyFromGroup('strumLineNotes', 4, 'x') --Saca el valor de la Y

    makeLuaSprite('negro', '', -100, -100); --lo puse negro pq en un principio lo estaba, pero lo cambie para mejor configuracion
    makeGraphic('negro', 1280*2, 720*2, 'FFFFFF');
    setScrollFactor('negro', 0, 0); --Set Scroll factor = Determina cuanto se mueve al mover la camara, con 0 no se mueve, con 1 se mueve mucho
    screenCenter('negro'); -- Lo coloca al centro
    setProperty('negro.alpha',0); --Es invisible hasta que lo actives
    setProperty('negro.color',getColorFromHex(colorfondo))
    addLuaSprite('negro', false); --Se ubica ATRAS de los personajes

    makeLuaSprite('aquisi', 'aquisigano', -1280, -100) -- -800
    setObjectCamera('aquisi', 'hud')
    setProperty('aquisi.scale.x',0.26)
    setProperty('aquisi.scale.y',0.26)
    addLuaSprite('aquisi', true)


    if zoomextra ~= 0 then
        doTweenZoom('zoomtween', 'camGame', zoom + zoomextra, 0.001, 'linear')
        setProperty('defaultCamZoom', (zoom + zoomextra))  
    end

    if pantallanegra == true then
        setProperty('camGame.alpha',0); -- Camgame en negro
    end

    if showcasemode == true then
        setProperty('scoreTxt.alpha', 0.00001);
        setProperty('timeBar.alpha', 0.00001);
        setProperty('timeBarBG.alpha', 0.00001);
        setProperty('timeTxt.alpha', 0.00001);
    end

    if opacidadhud ~= 1 then
        setProperty('camHUD.alpha', opacidadhud)
    end
    setProperty('scoreTxt.alpha', 0.00001);
end

function onCountdownStarted()
    if pantallanegra then
        runTimer('finoscuro', tiempopantalla)
    end
    if fondo then
        doTweenAlpha('opanegro','negro',0,tiempofondo)
    end
end

function onTweenCompleted(n)
    if n == 'opanegro' then
        if getProperty('negro.alpha') == 0 then --Revisa si el bg n está invisible para eliminarlo (Optimización)
            removeLuaSprite('negro',true)
        end
    end 
end


function onEvent(n,v1,v2)

    if n == "roval" then

        if v1 == 'aquisigano' then
            doTweenY('aquisii','aquisi',-790,0.4,'quadOut')
            doTweenAngle('aquisio','aquisi',-720,0.4,'quadOut')
        end
        if v1 == 'aquisiganoend' then
            doTweenAlpha('oaoao','aquisi',0,0.1,'quadOut')
        end

        if v1 == 'vetedad' then
            for i = 0,3 do
                setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
            end
        end

        if v1 == 'vendad' then
            for i = 0,3 do
                setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
            end
        end

        if v1 == 'extracolor' then
            setProperty('boyfriend.color',getColorFromHex('ffffff'))
        end
        hud = {'scoreTxt', 'timeBar', 'timeBarBG', 'timeTxt', 'healthBarBG', 'healthBar', 'iconP1', 'iconP2'}
        for i = 1, 4 do
            if v1 == 'showcase' then
                if getProperty(hud[i]..'.alpha') == 0.00001 then
                    setProperty(hud[i]..'.alpha',1)
                else
                    setProperty(hud[i]..'.alpha',0.00001)
                end
            end
        end
        for i = 5, #hud do
            if v1 == 'vida' then
                if getProperty(hud[i]..'.alpha') == 0.00001 then
                    setProperty(hud[i]..'.alpha',1)
                else
                    setProperty(hud[i]..'.alpha',0.00001)
                end
            end
        end
        for i = 2, 4 do
            if v1 == 'tiempo' then
                if getProperty(hud[i]..'.alpha') == 0.00001 then
                    setProperty(hud[i]..'.alpha',1)
                else
                    setProperty(hud[i]..'.alpha',0.00001)
                end
            end
        end

        if v1 == 'alphabf' then
            local alphero = split(v2,",")
            opacidad = tonumber(alphero[1])
            tiempo = tonumber(alphero[2])
            transicion = alphero[3]
            local hola = v2:match('^[^,]*,[^,]*$') ~= nil
            if v2 == '' then
                opacidad = 1
                tiempo = 0.001
                transicion = 'linear'
            end
            if alphero[1] == '' then
                opacidad = 1
                tiempo = 0.001
                transicion = 'linear'
            elseif v2:match(",") == nil then
                tiempo = 0.001
                transicion = 'linear'
            elseif hola then
                transicion = 'linear'
            end
            doTweenAlpha('bola', 'boyfriend', opacidad, tiempo, transicion)
        end

        if v1 == 'flechasdad' then
            local flechero = split(v2,",")            
            distancia = tonumber(flechero[1])
            tiempofl = tonumber(flechero[2])
            transfl = flechero[3]

            if flechero[1] == '' then
                distancia = 0
            end
            if flechero[2] == '' then
                tiempofl = 0.01
            end
            if flechero[3] == '' then
                transfl = 'linear'
            end
            runTimer('flechasdad')
            for i = 0,3 do
                if not downscroll then 
                    noteTweenY('flecha'..i, i, (strumYOrigin - distancia), tiempofl, transfl)
                else
                    noteTweenY('flecha'..i, i, (strumYOrigin + distancia), tiempofl, transfl)
                end
            end
        end

        if v1 == 'flechasbf' then
            local flechero = split(v2,",")            
            distancia = tonumber(flechero[1])
            tiempofl = tonumber(flechero[2])
            transfl = flechero[3]

            if flechero[1] == '' then
                distancia = 0
            end
            if flechero[2] == '' then
                tiempofl = 0.01
            end
            if flechero[3] == '' then
                transfl = 'linear'
            end
            runTimer('flechasbf')
            for i = 4,7 do
                if not downscroll then -- En downscroll pasa al reves para que sea simetrico
                    noteTweenY('flecha'..i, i, (strumYOrigin - distancia), tiempofl, transfl)
                else
                    noteTweenY('flecha'..i, i, (strumYOrigin + distancia), tiempofl, transfl)
                end
            end
        end

        if v1 == 'flechasbfx' then
            local flecherox = split(v2,",")            
            distancia = tonumber(flecherox[1])
            tiempofl = tonumber(flecherox[2])
            transfl = flecherox[3]

            if flecherox[1] == '' then
                distancia = 0
            end
            if flecherox[2] == '' then
                tiempofl = 0.01
            end
            if flecherox[3] == '' then
                transfl = 'linear'
            end
            for i = 4,7 do
                DistOgBF = (i-4) * 112 + strumXOriginBF
                noteTweenX('flechax'..i, i, (DistOgBF + distancia), tiempofl, transfl)
            end
        end

        if v1 == 'boomzoom' then
            if v2 == '' then
                zoomboom = 1
            else
                zoomboom = v2
            end
            setProperty('camZoomingMult', zoomboom)
        end

        if v1 == 'beathud' then --Mover hud con beat
            if v2 == '' then
                beatt = 8 --Si no colocas nada en v2 el beat sera 8
            else
                beatt = v2
            end

            if si3 == 0 then
                si3 = 1
            else
                si3 = 0
            end
        end

        if v1 == 'zoom' then --Ajustar solo zoom agregado, 1 valor en value2 (zoom extra)
            if v2 == '' then -- ZOOM EXTRA: Zoom extra a la que tiene el stage, puede ser negativo, con 0 o nada vuelve al zoom del stage
                v2 = 0
            end
            doTweenZoom('zoomtween', 'camGame', zoom + v2, 0.2, 'linear')
            setProperty('defaultCamZoom', zoom + v2)  
        end

        if v1 == 'zooma' then --2 valores (Zoom agregado,Tiempo,Tipo de transicion), ejemplo: 0.5,3      Solo numeros negativos en zoomextra
            local zoomero = split(v2,",")            
            zoomextra = tonumber(zoomero[1])   
            zoomtiempo = tonumber(zoomero[2])

            if tonumber(zoomero[2]) == '' then         -- No escribes tiempo, el predeterminado es 0.2, para hacer instantaneo tiempo = 0.001
                zoomtiempo = 0.2
            end

            doTweenZoom('zoomtween', 'camGame', (zoom + zoomextra), zoomtiempo, 'linear')
            setProperty('defaultCamZoom', (zoom + zoomextra))  
        end

        if v1 == 'angulocam' then
            local camangle = split(v2,",")            
            gradoc = tonumber(camangle[1]) -- el normal es 0
            velc = tonumber(camangle[2])  -- el normal es 0.001
            if gradoc == '' then
                gradoc = 0
            end
            if velc == '' then
                velc = 0.001
            end
            doTweenAngle('camarangul', 'camera', gradoc, velc, 'linear')
        end

        if v1 == 'zoomz' then --Zoom mas complejo, 3 valores (Zoom agregado,Tiempo,Tipo de transicion), ejemplo: 0.2,5,backInOut
            local zumero = split(v2,",")       --Mismas reglas que la anterior
            zumextra = tonumber(zumero[1])
            zumtiempo = tonumber(zumero[2])
            zumtipo = (zumero[3])

            if tonumber(zumextra) == '' then --No creo que funcione//Si no escribes zoom extra el predeterminado es 0 (El que tiene el stage)
                zumextra = 0
            end

            if tonumber(zumero[2]) == '' then --Si no escribes tiempo el predeterminado es 0.2
                zumtiempo = 0.2
            end

            if zumtipo == '' then --Si no escribes transicion lo escribis mal el predeterminado el linear
                zumtipo = 'linear'
            end

            doTweenZoom('zoomtween', 'camGame', (zoom + zumextra), zumtiempo, zumtipo)
            setProperty('defaultCamZoom', (zoom + zumextra))  
        end

        if v1 == 'hud' then --ajusta opacidad del HUD - Simple (v2 = opacidad cambiada) 1 es 100% y 0 es 0% de opacidad
            if v2 == '' then --La opacidad es 1 si no escribes nada
                v2 = 1
            end
            opacidadhud = v2
            doTweenAlpha('camHUD', 'camHUD', opacidadhud, 0.12) --El tiempo predeterminado es 0.12s
        end

        if v1 == 'hudz' then
            local hudero = split(v2,",")            
            opacidadhud = tonumber(hudero[1])   
            hudtiempo = tonumber(hudero[2])
            if opacidadhud == '' then         -- No escribes opacidad, el predeterminado es 1
                opacidadhud = 1
            end
            if hudtiempo == '' then         -- No escribes tiempo, el predeterminado es 1.2
                hudtiempo = 1.2
            end
            doTweenAlpha('camHUD', 'camHUD', opacidadhud, hudtiempo)
        end
	end
end

function split(s) --Función con la que se dividen los valores del evento
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end

function onUpdate()
    if si3 == 1 then
        cosa = false
        if cosa == true then
            if curStep % beatt == 0 then
                setProperty('camHUD.angle',1.1)
                doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')
            end
            if curStep % beatt == (beatt/2) then
                setProperty('camHUD.angle',-1.1)
                doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')       --(60 / bpm) / 4 * 2
            end
        else
            if curStep % beatt == 0 then
                setProperty('camHUD.angle',-1.1)
                doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')       --(60 / bpm) / 4 * 2
            end
            if curStep % beatt == (beatt/2) then
                setProperty('camHUD.angle',1.1)
                doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')
            end
        end
    elseif si3 == 0 then
        cosa = true
    end
end

function onTimerCompleted(n, loops, loopsLeft)
    if n == 'finoscuro' then
        setProperty('camGame.alpha', 1);
    end
end

function onTweenCompleted(a,b,c)
    if a == 'aquisii' then
        doTweenY('aquisii2','aquisi',-810,2,'quadOut')
        doTweenAngle('aquisio2','aquisi',-728,2,'quadOut')
    end
end