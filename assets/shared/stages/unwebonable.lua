local cambiogod = 0
local carlos = 0

local cantaaquino = false
local cantaduxo = false
local cantasoarinng = false
local cantaloco = false

function onCreate()
    makeLuaSprite("esaquino", "unwebonable/esaquino", -800, -80)
    setProperty('esaquino.alpha',0.001)        
    scaleObject('esaquino', 1.6, 1.6)    
    setProperty('esaquino.antialiasing',false)  
    addLuaSprite("esaquino")

    makeLuaSprite("esduxo", "unwebonable/esduxo", -750, -95)
    setProperty('esduxo.alpha',0.001)   
    scaleObject('esduxo', 1.62, 1.62)        
    setProperty('esduxo.antialiasing',false)  
    addLuaSprite("esduxo")

    makeLuaSprite("esloco", "unwebonable/esloco", -750, -95)
    setProperty('esloco.alpha',0.001)   
    scaleObject('esloco', 1.62, 1.62)       
    setProperty('esloco.antialiasing',false)  
    addLuaSprite("esloco")

    makeAnimatedLuaSprite("essoarinng", "unwebonable/essoarinng", -750, -95)
    addAnimationByIndices("essoarinng", "danceRight", "FondoBackroomsSoarinng idle","0,1,2,3,4,5,6,7,8,9,10,12,13,14", 24)
    addAnimationByIndices("essoarinng", "danceLeft", "FondoBackroomsSoarinng idle","15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30", 24)
    scaleObject('essoarinng', 1.625, 1.625)   
    setProperty('essoarinng.alpha',0.001)    
    setProperty('essoarinng.antialiasing',false)  
    addLuaSprite("essoarinng")

    makeAnimatedLuaSprite('estatic','unwebonable/estatic',0,0)
    addAnimationByPrefix('estatic','anim','idle0',24,true)
    scaleObject('estatic', 1.2, 1.2)
    setObjectCamera('estatic','hud')
    addLuaSprite('estatic',true)
end

function callShader(func,vars)
    callScript('extra_scripts/createShader',func,vars)
end

function setupShaders()
    addLuaScript('extra_scripts/createShader')
    callShader('createShader',{'tvShader','TvEffect'})
    callShader('createShader',{'glitchShader','GlitchEffect'})
    callShader('runShader',{'game',{'tvShader','glitchShader'}})
    callShader('runShader',{'hud','tvShader'})
    

    setShaderFloat('tvShader','frequency',0.1)
    setShaderFloat('tvShader','vignetteIntensity',0.05)
    setShaderFloat('tvShader','tvIntensity',0.001)
    setShaderFloat('tvShader','chromIntensity',0.003)

    setShaderFloat('glitchShader','intensity',0)
end

function onCreatePost()
    setupShaders()
    setProperty('gf.visible', false)
end

function onEvent(name,v1,v2,time)
    if name == 'roval' then
        if v1 == 'cambiogod' then
            if cambiogod == 0 then
                cambiogod = 1
            else
                cambiogod = 0
            end
        end

        if v1 == 'middlescroll' then
            tiempocarlos = v2
            if carlos == 0 then
                carlos = 1
            else
                carlos = 0
            end

            if tiempocarlos == 'extra' then
                if carlos == 3 then
                    carlos = 0
                else
                    carlos = 3
                end
            end
        end
    end

    if name == 'cambiastage' then
        if v1 == 'cambio' then
            if v2 == 'aquino' then
                cantaaquino = true
                cantaduxo = false
                cantaloco = false

                if time == 568502.51 then
                    setProperty('estatic.alpha',0.7)
                    doTweenAlpha('staticAlpha','estatic',0,0.5,'linear')
                end
            end

            if v2 == 'loco' or v2 == 'locochon' then
                cantaaquino = false
                cantaduxo = false
                cantaloco = true
            end

            if v2 == 'duxo' then
                cantaaquino = false
                cantaduxo = true
                cantaloco = false

                if time == 574319.480791878 then
                    setProperty('estatic.alpha',0.7)
                    doTweenAlpha('staticAlpha','estatic',0,0.5,'linear')
                end
            end

            if v2 == 'nadie' then
                cantaaquino = false
                cantaduxo = false
                cantaloco = false
            end

            if time >= 592076.382632369 then
                setProperty('estatic.alpha',0.7)
                doTweenAlpha('staticAlpha','estatic',0,0.5,'linear')
            end
        end

        if v1 == 'oppstage' then
            local stageopp = split(v2)
            if v2 == '' then
                stageopp[1] = 'aquino'
                stageopp[2] = 0
                stageopp[3] = 0.001
            end
            if v2:match(",") == nil then
                stageopp[2] = 0
                stageopp[3] = 0.001
            end
            stage = (stageopp[1])
            opp = (stageopp[2])
            tiempoopp = (stageopp[3])
            if stage == 'locochon' then
                stage = 'loco'
            end

            cancelTween('opa'..stage)
            doTweenAlpha('opa'..stage, 'es'..stage, opp, tiempoopp)
        end
    end
end

function onUpdate()
    if carlos == 1 then
        if tiempocarlos == '' then
            tiempocarlos = 0.01
        end
        for i = 4, 7 do
            espacio = 300 + (i-3)*112
            noteTweenX('n'..i, i, espacio, tiempocarlos)
        end

        for i = 0, 3 do
            noteTweenAlpha('na'..i, i, 0, tiempocarlos)
        end
    elseif carlos == 0 then
        if tiempocarlos == '' then
            tiempocarlos = 0.01
        end
        for i = 4, 7 do
            espacio = 620 + (i-3)*112
            noteTweenX('n'..i, i, espacio, tiempocarlos)
        end

        for i = 0, 3 do
            noteTweenAlpha('na'..i, i, 1, tiempocarlos)
        end     
    end

    if mustHitSection then
        cameraSetTarget('boyfriend')
        cantasoarinng = true
    else
        cameraSetTarget('dad')
        cantasoarinng = false
    end

    if cambiogod == 1 then
        setProperty('essoarinng.alpha', (cantasoarinng and 1 or 0.001))
        setProperty('esaquino.alpha', (cantaaquino and 1 or 0.001))
        setProperty('esloco.alpha', (cantaloco and 1 or 0.001))
        setProperty('esduxo.alpha', (cantaduxo and 1 or 0.001))
    end

    if cambiogod == 0 and curSection == 107 or cambiogod == 0 and curSection == 197 then
        setProperty('essoarinng.alpha', 0.001)
    end
end

function onMoveCamera(focus)
    if curFocus ~= focus then
        setProperty('estatic.alpha',0.7)
        doTweenAlpha('staticAlpha','estatic',0,0.5,'linear')
        if focus == 'dad' then
            cantabf = false
            cantadad = true
        else
            cantabf = true
            cantadad = false
        end
        curFocus = focus
        setProperty('boyfriend.visible', cantabf)
        setProperty('dad.visible', cantadad)
    end
end

function split(s)
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end

function onGameOverStart()
    setProperty('boyfriend.visible',false)
    makeAnimatedLuaSprite('noSignalBG','unwebonable/YCBU_GameOver_Assets',0,0)
    addAnimationByPrefix('noSignalBG','anim','color screen',0,true)
    scaleObject('noSignalBG',1.5,1.5)
    setScrollFactor('noSignalBG',0,0)
    screenCenter('noSignalBG')
    addLuaSprite('noSignalBG',true)

    makeAnimatedLuaSprite('noSignalText','unwebonable/YCBU_GameOver_Assets',0,0)
    addAnimationByPrefix('noSignalText','anim','text',24,true)
    scaleObject('noSignalText',1.5,1.5)
    updateHitbox('noSignalText')
    setScrollFactor('noSignalText',0,0)
    addLuaSprite('noSignalText',true)
    screenCenter('noSignalText')
end

function onGameOver()
    local substate = 'substates.GameOverSubstate'
    if version <= '0.6.3' then
        substate = 'GameOverSubstate'
    end
    setPropertyFromClass(substate,'deathSoundName','UBdeath')
    setPropertyFromClass(substate,'loopSoundName','gameOverUB')
    setPropertyFromClass(substate,'endSoundName','gameOverEndUB')
end

local danceRight = false
function onBeatHit()
        if curBeat % 2 == 0 then
        danceRight = not danceRight
        if danceRight then
            playAnim("essoarinng", "danceRight", true)
        else
             playAnim("essoarinng", "danceLeft", true)
        end
    end
end