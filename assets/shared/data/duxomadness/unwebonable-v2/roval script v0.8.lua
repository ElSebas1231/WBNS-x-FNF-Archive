--Script creado por Roval, autorizo su uso para otros mods si me dan creditos :p
-- NO PERMITO SUBIR MI SCRIPT A GB O GAMEJOLT, ya lo hare cuando este mejor adaptado
-- Si tienes alguna duda con el script puedes hablarme por discord: Roval

-------------Parte del Script que si puedes modificar dependiendo que necesites---------------------------
int = 0; -- INTENSIDAD DE MOVIMIENTO DE CAMARA, mas = intenso
opacidadhud = 1; -- La opacidad del hud que tiene AL INICIO DE LA CANCION, luego lo cambias con el evento "hudz" o "hud"
zoomextra = 0; --Coloca con cuanto zoom extra quieres que inicie la cancion, el predeterminado de extra es 0 (solo el que tiene el stage)
velcaminicio = 1; --A que velocidad de camara inicias la cancion, el predeterminado es 1
seguircamara = true; -- ACTIVA O DESACTIVA LA CAMARA ACTIVA, false = desactivado
ocultargf = false; -- ACTIVA O DESACTIVA PARA OCULTAR O NO A LA GF, despues la puedes volver a colocar con el evento visible
mediocamara = true; -- ACTIVA O DESACTIVA - true = camara empieza desde el medio, luego tienes que cambiarlo con el evento "p" para que sea normal
showcasemode = false; -- SI ACTIVAS EL MODO SHOWCASE SE ELIMINA PUNTACION, BARRA DE TIEMPO Y EL SCORE -- Para subir videos con poco hud
saltearcontador = false; -- Saltear el contador del inicio de la cancion, puede generar bugs asi que no recomiendo usarlo tanto xd
pantallanegra = false; -- ACTIVA O DESACTIVA - true = la pantalla esta negra y con el evento "flash" o "flashz" lo quitas, pero despues cambia el color a blanco para que funcione como flash
opacidadflash = 1 -- SI ACTIVAS PANTALLA NEGRA, COMO QUIERES QUE EMPIECE EL FLASH NEGRO
atrasnegro = true; -- Activa o desactiva un fondo negro por detras de los personajes
opacidadfondo = 0 -- si activas ATRASNEGRO 




--OPTIMIZACION (NO DESHABILITAR NADA PARA USAR TODAS LAS FUNCIONES DEL SCRIPT) Modifica que usar y que no usar para optimizar recursos
usarflash = true --La imagen que esta adelante de los personajes, se usa como flash
usarfondo = true --La imagen de fondo de atras
usarluz = true --La luz que sale por delante de los personajes abajo de la pantalla - Requiere usar una imagen junto a este script
usarletras = true -- las letras de karaoke
usarmodchart = true --Funciones de modchart
usarextra = true --Funciones extra igual de importantes que el usar cam
usarmovimiento = true -- Funciones para mover Sprites
usarzoom = true --Funciones relacionadas con el zoom
centrox = 890 ; --Eje X de camara medio entre dad y bf
centroy = 525 ; --Eje Y de camara medio entre dad y bf
------


---------Parte necesaria del Script que no debes tocar excepto que le sepas------
si = 0; --Switch que activa o desactiva cierto evento
si2 = 0; --Switch que activa o desactiva cierto evento
si3 = 0; --Switch que activa o desactiva cierto evento
sibf = 0; --Switch que activa o desactiva cierto otro evento
sigf = 0; --Switch que activa o desactiva cierto otro evento
sidad = 0; --Switch que activa o desactiva cierto otro evento
---------------





if saltearcontador == true then
    function onCreate() -- Por cierto, si al activar esto y al iniciar la song por primera vez el audio esta bug, mejor desactiva esto :p
        setProperty('skipCountdown', true)
    end
end

--Aca te dejo un listado de todos eases/transiciones, puedes buscar en google como funciona cada uno de ellos
tiposease = {"linear","quadIn","quadOut","quadInOut","cubeIn","cubeOut","cubeInOut","quartIn","quartOut","quartInOut","quintIn","quintOut","quintInOut","sineIn","sineOut","sineInOut","bounceIn","bounceOut","bounceInOut","elasticIn","elasticOut","elasticInOut","backIn","backOut","backInOut"}
----------------------------------------------

function onCreatePost()
    zoom = getProperty('defaultCamZoom'); --Zoom que tiene el stage
    velocidad = getProperty('cameraSpeed'); --Velocidad al que va la camara - Se lo cambia con eventos o desde aca

    if usarfondo == true then
        makeLuaSprite('negro', '', -100, -100); --lo puse negro pq en un principio lo estaba, pero lo cambie para mejor configuracion
        makeGraphic('negro', 1280*2, 720*2, 'FFFFFF');
        setScrollFactor('negro', 0, 0); --Set Scroll factor = Determina cuanto se mueve al mover la camara, con 0 no se mueve, con 1 se mueve mucho
        screenCenter('negro'); -- Lo coloca al centro
        if atrasnegro == true then
            setProperty('negro.colorTransform.greenOffset', -255)
            setProperty('negro.colorTransform.redOffset', -255)
            setProperty('negro.colorTransform.blueOffset', -255)
            setProperty('negro.alpha',opacidadfondo); --Tiene la opacidad ajustada antes
        else
            setProperty('negro.alpha',0); --Es invisible hasta que lo actives
        end
        addLuaSprite('negro', false); --Se ubica ATRAS de los personajes


        makeLuaSprite('fondogod', '', -100, -100); --lo puse negro pq en un principio lo estaba, pero lo cambie para mejor configuracion
        makeGraphic('fondogod', 1280*2, 720*2, 'FFFFFF');
        setScrollFactor('fondogod', 0, 0); --Set Scroll factor = Determina cuanto se mueve al mover la camara, con 0 no se mueve, con 1 se mueve mucho
        screenCenter('fondogod'); -- Lo coloca al centro
        setProperty('fondogod.alpha',0); --Es invisible hasta que lo actives
        addLuaSprite('fondogod', false); --Se ubica ATRAS de los personajes
        setObjectOrder('fondogod', getObjectOrder('negro')+1)
    end

    if usarflash == true then
        makeLuaSprite('flash', '', -100, -100); 
        makeGraphic('flash', 1280*2, 720*2, 'FFFFFF'); --Esto si es blanco p
        setScrollFactor('flash', 0, 0);
        screenCenter('flash');
        if pantallanegra == true then
            setProperty('flash.colorTransform.greenOffset', -255)
            setProperty('flash.colorTransform.redOffset', -255)
            setProperty('flash.colorTransform.blueOffset', -255)
            setProperty('flash.alpha',opacidadflash);
        else
            setProperty('flash.alpha',0); -- esta transparente
        end
        addLuaSprite('flash', true); --Se ubica ADELANTE de los personajes  
    end


    if showcasemode == true then
        setProperty('scoreTxt.visible', false);
        setProperty('timeBar.visible', false);
        setProperty('timeBarBG.visible', false);
        setProperty('timeTxt.visible', false);       
    end

    if not (zoomextra == 0) then
        doTweenZoom('zoomtween', 'camGame', zoom + zoomextra, 0.001, 'linear')
        setProperty('defaultCamZoom', (zoom + zoomextra))  
    end

    if not (opacidadhud == 1) then
        doTweenAlpha('camaaHUD', 'camHUD', opacidadhud, 0.001)
    end

    if ocultargf == true then
        runTimer('gfvisible', 0.001)
    end

    if not (velcaminicio == 1) then
        setProperty('cameraSpeed', velcaminicio);
    end

    if usarluz == true then
        makeLuaSprite('luz', 'luz', -400, 400)
        setGraphicSize('luz', 2100, 500)
        setScrollFactor('luz', 0, 0.75)
        setProperty('luz.alpha', 0)
        setObjectCamera("luz", 'hud');
        --setBlendMode('luz', 'add')
        updateHitbox('luz')
        addLuaSprite('luz', true)
    end

    if usarletras == true then
        makeLuaText('texto', '', 1000, -180, 500)
        setTextFont('texto', 'vcr.ttf') --LA FUENTE QUE SE USA
        setTextColor('texto', 'f1f348') --AJUSTAS EL COLOR DEL TEXTO EN DAD
        setTextSize('texto', 50); -- EL TAMANO DE LA LETRA
        setTextAlignment('texto', 'center')
        setObjectCamera("texto", 'hud');
        addLuaText('texto')

        makeLuaText('textob', 'aaaaaaaaaaaa', 1560, getMidpointX('boyfriend')-760, getMidpointY('boyfriend')-300)

        setTextFont('textob', 'Pixel Emulator.otf') --LA FUENTE QUE SE USA        
        setScrollFactor('textob', 2, 2)
        setObjectCamera("textob", 'game');
        setTextColor('textob', 'ffffff') --AJUSTAS EL COLOR DEL TEXTO EN MEDIO
        setTextSize('textob', 60); -- EL TAMANO DE LA LETRA
        setProperty('textob.alpha', 0)
        
        
        setObjectOrder('textob', getObjectOrder('Boyfriend') + 3)
        
        addLuaText('textob')

        makeLuaText('textoc', '', 1000, 460, 500)
        setTextFont('textoc', 'vcr.ttf') --LA FUENTE QUE SE USA
        setTextColor('textoc', 'BFBFBF') --AJUSTAS EL COLOR DEL TEXTO EN BF
        setTextSize('textoc', 40); -- EL TAMANO DE LA LETRA
        setTextAlignment('textoc', 'center')
        setObjectCamera("textoc", 'hud');
        addLuaText('textoc')
    end

    if usarmodchart == true then
        strumYOrigin = getPropertyFromGroup('strumLineNotes', 0, 'y') --Saca el valor de la Y
        strumXOrigin = getPropertyFromGroup('strumLineNotes', 0, 'x') --Saca el valor de la X
    end




    if usarcam == true then
        if mediocamara == true then
            setProperty('camFollow.x', centrox)
            setProperty('camFollow.y', centroy)
            setProperty('camera.target.x', centrox)
            setProperty('camera.target.y', centroy)
            setProperty('isCameraOnForcedPos', false);
        end
    end
end



function onEvent(n,v1,v2)

    if n == "roval" then
        if usarmovimiento == true then
            if v1 == 'movx' then
                local movx = split(v2,",")            
                spritex = (movx[1])
                lugarx = tonumber(movx[2])
                tiempox = tonumber(movx[3])
                apodox = (spritex..'cola')

                if spritex == 'bf' or spritex == 'player' or spritex == 'jugador' or spritex == 'boyfriend' then
                    spritex = 'boyfriend'
                end
                if spritex == 'girlfriend' or spritex == 'gf' then
                    spritex = 'gf'
                end
                if spritex == 'opponent' or spritex == 'oponente' or spritex == 'rival' then
                    spritex = 'dad'
                end

                if lugarx == '' then
                    lugarx = 0
                end

                if tiempox == '' then
                    tiempox = 0.001
                end

                doTweenX(apodox, spritex, lugarx, tiempox)
            end

            if v1 == 'movy' then
                local movy = split(v2,",")            
                spritey = (movy[1])
                lugary = tonumber(movy[2])
                tiempoy = tonumber(movy[3])
                apodoy = (spritey..'colay')

                if spritey == 'bf' or spritey == 'player' or spritey == 'jugador' then
                    spritey = 'boyfriend'
                end
                if spritey == 'girlfriend' then
                    spritey = 'gf'
                end
                if spritey == 'opponent' or spritey == 'oponente' or spritey == 'rival' then
                    spritey = 'dad'
                end

                if lugary == '' then
                    lugary = 0
                end

                if tiempoy == '' then
                    tiempoy = 0.001
                end

                doTweenY(apodoy, spritey, lugary, tiempoy)
            end

            if v1 == 'movxz' then
                local movx = split(v2,",")            
                spritex = (movx[1])
                lugarx = tonumber(movx[2])
                tiempox = tonumber(movx[3])
                easex = (movx[4])
                apodox = (spritex..'cola')

                if spritex == 'bf' or spritex == 'player' or spritex == 'jugador' then
                    spritex = 'boyfriend'
                end
                if spritex == 'girlfriend' then
                    spritex = 'gf'
                end
                if spritex == 'opponent' or spritex == 'oponente' or spritex == 'rival' then
                    spritex = 'dad'
                end

                if lugarx == '' then
                    lugarx = 0
                end

                if tiempox == '' then
                    tiempox = 0.001
                end

                if easex == '' then
                    easex = 'linear'
                end

                doTweenX(apodox, spritex, lugarx, tiempox, easex)
            end

            if v1 == 'movyz' then
                local movy = split(v2,",")            
                spritey = (movy[1])
                lugary = tonumber(movy[2])
                tiempoy = tonumber(movy[3])
                easey = (movy[4])
                apodoy = (spritex..'colay')

                if spritey == 'bf' or spritey == 'player' or spritey == 'jugador' then
                    spritey = 'boyfriend'
                end
                if spritey == 'girlfriend' then
                    spritey = 'gf'
                end
                if spritey == 'opponent' or spritey == 'oponente' or spritey == 'rival' then
                    spritey = 'dad'
                end

                if lugary == '' then
                    lugary = 0
                end

                if tiempoy == '' then
                    tiempoy = 0.001
                end

                if easey == '' then
                    easey = 'linear'
                end
                doTweenY(apodoy, spritey, lugary, tiempoy, easey)
            end
        end

        if usarletras == true then
            if v1 == 'canta' then --Activar para cambiar el texto de karaoke
                if v2 == '' then
                    textito = '' --Si no escribes nada borras el texto
                else
                    textito = v2
                end
                setTextString('texto',  '' .. textito)
            end

            if v1 == 'cantab' then --Activar para cambiar el texto de karaoke - Segundo texto
                if v2 == '' then
                    textitob = '' --Si no escribes nada borras el texto
                else
                    textitob = v2
                end
                doTweenY('textitob', 'textob', getMidpointY('boyfriend')-300, 0.001)
                runTimer('muevetextob', 0.001)
                doTweenAlpha('textob', 'textob', 0.7, 0.15)
                setTextString('textob',  '' .. textitob)
                runTimer('fintextob', 0.3)
            end

            if v1 == 'cantac' then --Activar para cambiar el texto de karaoke - Segundo texto
                if v2 == '' then
                    textitoc = '' --Si no escribes nada borras el texto
                else
                    textitoc = v2
                end
                setTextString('textoc',  '' .. textitoc)
            end

            if v1 == 'cantacolor' then --Cambia el color
                local colortx = split(v2,",")            
                letras = (colortx[1])
                colorr = (colortx[2])

                if letras == '' then
                    letras = 'a'
                end

                if colorr == '' then
                    colorr = 'ffffff'
                end

                if letras == 'a' then
                    setTextColor('texto', colorr) --AJUSTAS EL COLOR DEL TEXTO EN DAD
                end
                if letras == 'b' then
                    setTextColor('textob', colorr) --AJUSTAS EL COLOR DEL TEXTO EN DAD
                end
                if letras == 'c' then
                    setTextColor('textoc', colorr) --AJUSTAS EL COLOR DEL TEXTO EN DAD
                end
            end
        end

        if usarfondo == true then

            if v1 == 'fondo' then --Ajustar opacidad del fondo atras de los personajes, en value2 puedes modificar el tiempo en el que se vuelve asi
                if v2 == '' then
                    opacidad = 0 --Si no colocas nada en v2 la velocidad predeterminada es 0 (Invisible)
                else
                    opacidad = v2
                end
                doTweenAlpha('negro', 'negro', opacidad, 0.13)
            end

            if v1 == 'fondoz' then --Ajustar opacidad y tiempo del fondo atras de los personajes, ejemplo: 0.45,0.01 
                local fondoz = split(v2,",")            
                fopacidad = tonumber(fondoz[1])
                ftiempoz = tonumber(fondoz[2])   

                if fopacidad == '' then         --Si no colocas nada en v2 la opacidad predeterminada es 0 (Invisible)
                    fopacidad = 0
                end

                if ftiempoz == '' then         -- No escribes tiempo, el predeterminado es 0.13
                    ftiempoz = 0.13 
                end
                doTweenAlpha('negro', 'negro', fopacidad, ftiempoz)
            end

            if v1 == 'fgod' then --Ajustar opacidad y tiempo del fondo atras de los personajes, ejemplo: 0.45,0.01 
                setProperty('fondogod.alpha', 0.2)
                doTweenAlpha('juanito', 'fondogod', 0, 2)
            end

            if v1 == 'fgodcolor' then --Cambiar de color el fondo en X tiempo - Lo contrarresta fondon al cambiarlo por negro siempre
                local fgcolorz = split(v2,",")            
                fgcolor = (fgcolorz[1])
                fgtiempo = tonumber(fgcolorz[2])   
    
                if fgcolor == '' then         -- Se vuelve negro si no escribes nada
                    fgcolor = '000000'
                end
    
                if fgtiempo == '' then         -- No escribes tiempo, el predeterminado es 0.01
                    fgtiempo = 0.01
                end

                local rojo, verde, azul = hex_rgb(fgcolor)
    
                setProperty('fondogod.colorTransform.greenOffset', (-verde))
                setProperty('fondogod.colorTransform.redOffset', (-rojo))
                setProperty('fondogod.colorTransform.blueOffset', (-azul))
            end

            

            if v1 == 'fcolor' then --Cambiar de color el fondo por el que te de la gana - Lo contrarresta el fondon al cambiarlo por negro siempre
                if v2 == '' then
                    fcolor = '000000' -- Se vuelve negro si no escribes nada
                else
                    fcolor = v2 --El color que escribas es en HEX o hexadecimal, se escribe 6 digitos (puede ser minuscula creo)
                end
                local rojo, verde, azul = hex_rgb(fcolor)
    
                setProperty('negro.colorTransform.greenOffset', (-verde))
                setProperty('negro.colorTransform.redOffset', (-rojo))
                setProperty('negro.colorTransform.blueOffset', (-azul))
            end

            if v1 == 'fcolorz' then --Cambiar de color el fondo en X tiempo - Lo contrarresta fondon al cambiarlo por negro siempre
                local fcolorz = split(v2,",")            
                fcolor = (fcolorz[1])
                ftiempo = tonumber(fcolorz[2])   
    
                if fcolor == '' then         -- Se vuelve negro si no escribes nada
                    fcolor = '000000'
                end
    
                if ftiempo == '' then         -- No escribes tiempo, el predeterminado es 0.01
                    ftiempo = 0.01
                end
    
                doTweenColor('fcoloro', 'negro', fcolor, ftiempo, 'linear')
            end

            if v1 == 'fondon' then --Fondo oscuro atras de los personajes, en value2 puedes modificar el tiempo en el que se vuelve asi
                if v2 == '' then
                    velfondo = 0.13 --Si no colocas nada en v2 la velocidad predeterminada es 0.13
                else
                    velfondo = v2
                end
                setProperty('negro.colorTransform.greenOffset', -255)
                setProperty('negro.colorTransform.redOffset', -255)
                setProperty('negro.colorTransform.blueOffset', -255)
                if si == 0 then
                    doTweenAlpha('negro', 'negro', 0.45, velfondo)
                    doTweenAlpha('camHUD', 'camHUD', 0.7, velfondo)
                    si = 1
                else
                    doTweenAlpha('negro', 'negro', 0, velfondo)
                    doTweenAlpha('camHUD', 'camHUD', 1, velfondo)
                    si = 0
                end
            end
        end

        if v1 == 'bfcolora' then --Cambiar de color a bf (No tan piola como el 0.7)

            if v2 == '' then
                bfcolor = 'FFFFFF' -- Se vuelve blanco si no escribes nada
            else
                bfcolor = v2 --El color que escribas es en HEX o hexadecimal, se escribe 6 digitos (puede ser minuscula creo)
            end

            if v2 == 'blanco' then
                setProperty('boyfriend.colorTransform.greenOffset', 255)
                setProperty('boyfriend.colorTransform.redOffset', 255)
                setProperty('boyfriend.colorTransform.blueOffset', 255)
            else
                local rojo, verde, azul = hex_rgb(bfcolor)
                setProperty('boyfriend.colorTransform.greenMultiplier', -255)
                setProperty('boyfriend.colorTransform.redMultiplier', -255)
                setProperty('boyfriend.colorTransform.blueMultiplier', -255)
                setProperty('boyfriend.colorTransform.greenOffset', (-verde))
                setProperty('boyfriend.colorTransform.redOffset', (-rojo))
                setProperty('boyfriend.colorTransform.blueOffset', (-azul))

            end
        end

        if v1 == 'dadcolora' then --Cambiar de color a bf (No tan piola como el 0.7)

            if v2 == '' then
                dadcolor = 'FFFFFF' -- Se vuelve blanco si no escribes nada
            else
                dadcolor = v2 --El color que escribas es en HEX o hexadecimal, se escribe 6 digitos (puede ser minuscula creo)
            end

            if v2 == 'blanco' then
                setProperty('dad.colorTransform.greenOffset', 255)
                setProperty('dad.colorTransform.redOffset', 255)
                setProperty('dad.colorTransform.blueOffset', 255)
            else
                local rojo, verde, azul = hex_rgb(dadcolor)
                setProperty('dad.colorTransform.greenMultiplier', -255)
                setProperty('dad.colorTransform.redMultiplier', -255)
                setProperty('dad.colorTransform.blueMultiplier', -255)
                setProperty('dad.colorTransform.greenOffset', (-verde))
                setProperty('dad.colorTransform.redOffset', (-rojo))
                setProperty('dad.colorTransform.blueOffset', (-azul))
            end
        end

        if usarflash == true then

            if v1 == 'flash' then --Flash, Si no metes nada en value2 la duracion es 2.1 segundos (Solo ajustar velocidad si es necesario)
                if v2 == '' then
                    flashtiempo = 1.9
                else
                    flashtiempo = v2
                end
                opacidadflash = 0
                setProperty('flash.colorTransform.greenOffset', 0)
                setProperty('flash.colorTransform.redOffset', 0)
                setProperty('flash.colorTransform.blueOffset', 0)
                setProperty('flash.alpha',0.75);
                doTweenAlpha('flash', 'flash', opacidadflash, flashtiempo, 'linear')
            end

            if v1 == 'flashz' then --Flash complejo, se ajusta la opacidad y el tiempo en value2
                local flashero = split(v2,",")            
                opacidadflash = tonumber(flashero[1])   
                flashtiempo = tonumber(flashero[2])

                if opacidadflash == '' then         -- No escribes opacidad, el predeterminado es 0.7, no se recomienda que sea mas alto
                    opacidadflash = 0.7
                end

                if flashtiempo == '' then         -- No escribes tiempo, el predeterminado es 0.2
                    flashtiempo = 0.2
                end
                setProperty('flash.alpha',opacidadflash);
                doTweenAlpha('flash', 'flash', 0, flashtiempo, 'linear')
            end

            if v1 == 'flasho' then --Flash al reves, una transicion hacia la opacidad que elijas 
                local flasheroa = split(v2,",")            
                flashopacidada = tonumber(flasheroa[1])   
                flashtiempoa = tonumber(flasheroa[2])

                if flashopacidada == '' then         -- No escribes opacidad, el predeterminado es 0.7, no se recomienda que sea mas alto
                    flashopacidada = 1
                end

                if flashtiempoa == '' then         -- No escribes tiempo, el predeterminado es 0.2
                    flashtiempoa = 0.2
                end
                doTweenAlpha('flash', 'flash', flashopacidada, flashtiempoa, 'linear')
            end

            if v1 == 'flcolor' then --Cambiar de color el flash
                if v2 == '' then
                    flcolor = 'FFFFFF' -- Se vuelve blanco si no escribes nada
                else
                    flcolor = v2 --El color que escribas es en HEX o hexadecimal, se escribe 6 digitos (puede ser minuscula creo)
                end
                local rojo, verde, azul = hex_rgb(flcolor)

                setProperty('flash.colorTransform.greenOffset', (-verde))
                setProperty('flash.colorTransform.redOffset', (-rojo))
                setProperty('flash.colorTransform.blueOffset', (-azul))
            end


            if v1 == 'flcolorz' then --Cambiar de color el flash en X tiempo
                local flcolorz = split(v2,",")            
                flcolor = (flcolorz[1])
                fltiempo = tonumber(flcolorz[2])   

                if flcolor == '' then         -- Se vuelve blanco si no escribes nada
                    flcolor = 'FFFFFF'
                end

                if fltiempo == '' then         -- No escribes tiempo, el predeterminado es 0.01
                    fltiempo = 0.01
                end
                doTweenColor('flcoloro', 'flash', flcolor, fltiempo, 'linear')
            end
        end
        
        if usarluz == true then

            if v1 == 'luz' then     --Lucesita que sale abajo de los personajes, requiere la imagen adjunta al script, sin ella no funciona
                -- Recomiendo usarlo con fondo negro, con el value2 puedes cambiar en el que desaparece, sino es 1.2 segundos por predeterminado
                if v2 == '' then
                    luztiempo = 1.2
                else
                    luztiempo = v2
                end

                setProperty('luz.alpha',0.7);
                doTweenAlpha('luza', 'luz', 0, luztiempo, 'linear')
            end

            if v1 == 'luzz' then --Lucesita compleja, se ajusta la opacidad y el tiempo en value2 - ejemplo: 0.5,1    - Recuerda respetar comas
                local lucero = split(v2,",")            
                luzopacidad = tonumber(lucero[1])   
                luztiempo = tonumber(lucero[2])

                if luzopacidad == '' then         -- No escribes opacidad, el predeterminado es 0.7, no se recomienda que sea mas alto
                    luzopacidad = 0.7
                end

                if luztiempo == '' then         -- No escribes tiempo, el predeterminado es 1.2
                    luztiempo = 1.2
                end
                setProperty('luz.alpha',luzopacidad);
                doTweenAlpha('luza', 'luz', 0, luztiempo, 'linear')
            end

            if v1 == 'luzcolor' then --Cambiar de color la luz de forma insta
                if v2 == '' then
                    luzcolor = 'FFFFFF' -- Se vuelve blanco si no escribes nada
                else
                    luzcolor = v2 --El color que escribas es en HEX o hexadecimal, se escribe 6 digitos (puede ser minuscula creo)
                end
                local rojo, verde, azul = hex_rgb(luzcolor)

                setProperty('luz.colorTransform.greenOffset', (-verde))
                setProperty('luz.colorTransform.redOffset', (-rojo))
                setProperty('luz.colorTransform.blueOffset', (-azul))
            end

            if v1 == 'luzcolorz' then --Cambiar de color el fondo en X tiempo - Lo contrarresta fondon al cambiarlo por negro siempre
                local luzcolorz = split(v2,",")            
                luzcolor = (luzcolorz[1])
                luztiempoo = tonumber(luzcolorz[2])   

                if luzcolor == '' then         -- Se vuelve blanco si no escribes nada
                    luzcolor = 'FFFFFF'
                end

                if luztiempoo == '' then         -- No escribes tiempo, el predeterminado es 0.01
                    luztiempoo = 0.01
                end
                doTweenColor('colorluz', 'luz', luzcolor, luztiempoo, 'linear')
            end
        end

        if usarextra == true then

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

            if v1 == 'angulocamz' then
                local camangle = split(v2,",")            
                gradoc = tonumber(camangle[1]) -- el normal es 0
                velc = tonumber(camangle[2])  -- el normal es 0.001
                easec = (camangle[3])  -- el normal es linear
                if gradoc == '' then
                    gradoc = 0
                end
                if velc == '' then
                    velc = 0.001
                end
                if easec == '' then
                    easec = 'linear'
                end
                doTweenAngle('camarangul', 'camera', gradoc, velc, easec)
            end

            if v1 == 'angulohud' then
                local hudangle = split(v2,",")            
                gradoh = tonumber(hudangle[1]) -- el normal es 0
                velh = tonumber(hudangle[2])  -- el normal es 0.001
                if gradoh == '' then
                    gradoh = 0
                end
                if velh == '' then
                    velh = 0.001
                end
                doTweenAngle('hudangul', 'camHUD', gradoh, velh, 'linear')
            end

            if v1 == 'angulohudz' then
                local hudangle = split(v2,",")            
                gradoh = tonumber(hudangle[1]) -- el normal es 0
                velh = tonumber(hudangle[2])  -- el normal es 0.001
                easeh = (camangle[3])  -- el normal es linear
                if gradoh == '' then
                    gradoh = 0
                end
                if velh == '' then
                    velh = 0.001
                end
                if easeh == '' then
                    easeh = 'linear'
                end
                doTweenAngle('hudangul', 'camHUD', gradoh, velh, easeh)
            end

            if v1 == 'boomzoom' then
                if v2 == '' then
                    zoomboom = 1
                else
                    zoomboom = v2
                end
                setProperty('camZoomingMult', zoomboom)
            end

            if v1 == 'boombeat' then --Univalor
                if v2 == '' then
                    bit = 4
                else
                    bit = v2
                end
                function onBeatHit()
                    if curBeat % bit == 0 then
                        triggerEvent("Add Camera Zoom",0.016,0.025)
                    end
                end
            end

            if v1 == 'boombeata' then --Doblevalor
                local boombeat = split(v2,",")            
                bit = tonumber(boombeat[1]) -- el normal es 4
                intboom = tonumber(boombeat[2])  -- el normal es 1
                if bit == '' then
                    bit = 4
                end
                if intboom == '' then
                    intboom = 1
                end
                function onBeatHit()
                    if curBeat % bit == 0 then
                        triggerEvent("Add Camera Zoom",0.016*intboom,0.025*intboom)
                    end
                end
            end

            if v1 == 'boombeatz' then -- Triplevalor
                local boombeat = split(v2,",")            
                bit = tonumber(boombeat[1]) -- el normal es 4
                intboom1 = tonumber(boombeat[2])  -- el normal es 1
                intboom2 = tonumber(boombeat[3])  -- el normal es 1
                if bit == '' then
                    bit = 4
                end
                if intboom1 == '' then
                    intboom1 = 1
                end
                if intboom2 == '' then
                    intboom2 = 1
                end
                function onBeatHit()
                    if curBeat % bit == 0 then
                        triggerEvent("Add Camera Zoom",0.016*intboom1,0.025*intboom2)
                    end
                end
            end
                

            if v1 == 'velcam' then --Ajusta la velocidad del movimiento de la camara - 1 solo valor en Value2
                if v2 == '' then
                    velocidad = 1 --Si no escribes nada el predeterminado siempre es 1
                else
                    velocidad = v2
                end
                setProperty('cameraSpeed', velocidad)
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

            if v1 == 'cam' then --Activa o desactiva el seguir camara con la nota, no se debe colocar nada en value 2
                if seguircamara == false then
                    seguircamara = true
                else
                    seguircamara = false
                end
            end

            if v1 == 'visible' then --oculta o pone visible a los personajes
                if v2 == 'bf' or v2 == 'boyfriend' or v2 == 'player' or v2 == 'jugador' then
                    runTimer('bfvisible', 0.001)
                end
                if v2 == 'gf' or v2 == 'girlfriend' then
                    runTimer('gfvisible', 0.001)
                end
                if v2 == 'dad' or v2 == 'opponent' or v2 == 'oponente' then
                    runTimer('dadvisible', 0.001)
                end
            end

            if v1 == 'int' then --ajusta opacidad del HUD - Simple (v2 = opacidad cambiada) 1 es 100% y 0 es 0% de opacidad
                if v2 == '' then --La opacidad es 1 si no escribes nada
                    v2 = 40
                end
                int = v2
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

        if usarzoom == true then
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
        end

        if usarmodchart == true then
            if v1 == 'modcharty' then --Complejo - Hacer modchart por valor y (Arriba = mas - Abajo = menos)     - Tiene 3 valores
                --                                 con Downscroll va al reves (En vez de arriba, va para abajo)  - (Distancia, Tiempo, Transicion)
                --                      Ejemplo: 25,0.13,linear (Las flechas van para arriba en 0.13 en transicion linear)
                local mochary = split(v2,",")       
                distancia = tonumber(mochary[1]) --distancia puede ser negativo
                tiempomod = tonumber(mochary[2])
                transmod = (mochary[3])

                if tonumber(distancia) == '' then --No creo que funcione//Si no escribes el predeterminado es 0 (Reinicia a la altura normal)
                    distancia = 0 
                end

                if distancia == '' then --No creo que funcione//Si no escribes el predeterminado es 0 (Reinicia a la altura normal)
                    distancia = 0
                end

                if tonumber(mochary[2]) == '' then --Si no escribes tiempo el predeterminado es 0.15
                    tiempomod = 0.15
                end

                if transmod == '' then --Si no escribes transicion lo escribis mal el predeterminado el linear
                    transmod = 'linear'
                end

                if not downscroll then -- En downscroll pasa al reves para que sea simetrico
                    for i = 0,7 do
                        for i = 0,7 do
                            noteTweenY('oppo0', 0, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('oppo1', 1, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('oppo2', 2, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('oppo3', 3, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('play0', 4, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('play1', 5, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('play2', 6, (strumYOrigin - distancia), tiempomod, transmod)
                            noteTweenY('play3', 7, (strumYOrigin - distancia), tiempomod, transmod)
                        end
                    end
                else
                    for i = 0,7 do
                        noteTweenY('oppo0', 0, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('oppo1', 1, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('oppo2', 2, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('oppo3', 3, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('play0', 4, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('play1', 5, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('play2', 6, (strumYOrigin + distancia), tiempomod, transmod)
                        noteTweenY('play3', 7, (strumYOrigin + distancia), tiempomod, transmod)
                    end
                end
            end

            if v1 == 'modchartx' then --Complejo - Hacer modchart por valor x (Izq = menos - Der = mas)-Tiene 3 valores (Distancia, Tiempo, Transicion)
                --                      Ejemplo: 25,0.13,linear (Las flechas van para la derecha en 0.13 en transicion linear)
                local mocharx = split(v2,",")       
                distanciax = tonumber(mocharx[1]) --distancia puede ser negativo
                tiempomodx = tonumber(mocharx[2])
                transmodx = (mocharx[3])

                if tonumber(distanciax) == '' then --No creo que funcione//Si no escribes el predeterminado es 0 (Reinicia a la distancia normal)
                    distanciax = 0
                end

                if distanciax == '' then --No creo que funcione//Si no escribes el predeterminado es 0 (Reinicia a la distancia normal)
                    distanciax = 0
                end

                if tonumber(mocharx[2]) == '' then --Si no escribes tiempo el predeterminado es 0.15
                    tiempomodx = 0.15
                end

                if transmodx == '' then --Si no escribes transicion lo escribis mal el predeterminado el linear
                    transmodx = 'linear'
                end

                for i = 0,7 do
                    for i = 0,7 do
                        noteTweenX('oppo0', 0, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('oppo1', 1, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('oppo2', 2, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('oppo3', 3, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('play0', 4, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('play1', 5, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('play2', 6, (strumYOrigin + distanciax), tiempomodx, transmodx)
                        noteTweenX('play3', 7, (strumYOrigin + distanciax), tiempomodx, transmodx)
                    end
                end
            end
        end


	end
end

--function onBeatHit()
--
--    if curStep >= 511 and curStep <= 765 then
--        triggerEvent('roval_color','negative,'..colorluzz,'0.01,todos')
--        triggerEvent('roval','fgodcolor',colorluzz..',0.01')
--        triggerEvent('roval','fgod','')
--    end
--    if (curBeat >= 4) then
--        if ((curBeat - 4 ) % 20 == 0) then
--            colorluzz = '38a4fc'
--        end
--    end
--
--    if (curBeat >= 8) then
--        if ((curBeat - 8 ) % 20 == 0) then
--            colorluzz = '38fc8c'
--        end
--    end
--
--    if (curBeat >= 12) then
--        if ((curBeat - 12 ) % 20 == 0) then
--            colorluzz = 'ff34f4'
--        end
--    end
--
--    if (curBeat >= 16) then
--        if ((curBeat - 16 ) % 20 == 0) then
--            colorluzz = 'ff4434'
--        end
--    end
--
--    if (curBeat >= 20) then
--        if ((curBeat - 20 ) % 20 == 0) then
--            colorluzz = 'ffa434'
--        end
--    end
--
--    local rojoa, verdea, azula = hex_rgb(colorluzz)
--    setProperty('luz.colorTransform.greenOffset', (-verdea))
--    setProperty('luz.colorTransform.redOffset', (-rojoa))
--    setProperty('luz.colorTransform.blueOffset', (-azula))
--end


function split(s, delimiter) -- Parte copiada de un script de RamenDominoes, porfa siganlo en GB que hace buenos eventos
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tostring(match));
    end
    return result;
end

function hex_rgb(hex)
    local rojo = 255 - tonumber("0x"..hex:sub(1,2))
    local verde = 255 - tonumber("0x"..hex:sub(3,4))
    local azul = 255 - tonumber("0x"..hex:sub(5,6))    
    return rojo, verde, azul 
end


if usarcam == true or usarextra == true then
    function onUpdate()
        setProperty('camFollow.x', centrox)
        setProperty('camera.target.x', centrox)
        setProperty('camFollow.y', centroy)
        setProperty('camera.target.y', centroy)            

        if usarextra == true then
            if si3 == 1 then
                if curStep % beatt == 0 then
                    setProperty('camHUD.angle',1.1)
                    doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')
                end
                if curStep % beatt == (beatt/2) then
                    setProperty('camHUD.angle',-1.1)
                    doTweenAngle('cama', 'camHUD', 0, 0.7, 'circOut')       --(60 / bpm) / 4 * 2
                end
            elseif si3 == 0 then
            end
        end
    end
end


function onTimerCompleted(tag, loops, loopsLeft)

    if usarextra == true then
        if tag == 'fininstacam' then
            setProperty('cameraSpeed', velocidad);
        end

        if tag == 'bfvisible' then
            if getProperty('boyfriend.visble') == false then
                setProperty('boyfriend.visible', true)
            else
                setProperty('boyfriend.visible', false)
            end
        end
        if tag == 'dadvisible' then
            if getProperty('dad.visble') == false then
                setProperty('dad.visible', true)
            else
                setProperty('dad.visible', false)
            end
        end
        if tag == 'gfvisible' then
            if getProperty('gf.visble') == false then
                setProperty('gf.visible', true)
            else
                setProperty('gf.visible', false)
            end
        end

        if tag == 'fintextob' then
            doTweenAlpha('textob', 'textob', getMidpointY('boyfriend')-300, 0.5)
        end

        if tag == 'muevetextob' then
            doTweenY('textitoab', 'textob', getMidpointY('boyfriend')-350, 0.7, 'quadOut')
        end
    end
end