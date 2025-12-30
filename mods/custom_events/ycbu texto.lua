
local scoring = false

local text = ''
local resetColor = ''

local scoreState = 0
function onCreate()
    makeLuaText('ycbuText','',screenWidth+500,-250,screenHeight/2 - 50)
    setTextSize('ycbuText',240)
    setTextFont('ycbuText','maicralogo.ttf')
    setProperty('ycbuText.scale.y',2.5)
    setTextBorder('ycbuText',0,'000000')
    setProperty('ycbuText.autoSize',false)
    
    runHaxeCode([[
            game.modchartTexts.get('ycbuText').cameras = [game.camGame];
            game.modchartTexts.get('ycbuText').scrollFactor.set(0,0);
            game.insert(game.members.indexOf(game.dadGroup)-2,game.modchartTexts.get('ycbuText'));
            return;
    ]])
end

function onEvent(name,v1,v2)
    if name == 'ycbu texto' then
        scoring = false

        text = v1
        if v1 ~= '' then
            text = string.upper(string.gsub(v1,';','\n'))
        end
        setTextString('ycbuText',text)
        
        
        local foundedLines = false
        local dialogue = v1
        resetColor = 'FFFFFF'
        if songName == 'Unwebonable' and (curStep >= 4798 and curStep < 4816 or curStep >= 6108 and curStep < 6127 or curStep >= 6140 and curStep < 6159 or curStep >= 6175 and curStep < 6224)then
            resetColor = '000000'
        end
  
        repeat
            foundedLines = false
            if string.find(dialogue,'\n',0,true) then
                foundedLines = true
                local _,comma = string.find(dialogue,';',0,true)
                dialogue = string.sub(dialogue,0,comma)
            end
        until foundedLines == false

        detectYCBUOffset()
        setProperty('ycbuText.color',getColorFromHex('F77E63'))
        runTimer('resetYcbuColor',0.1)
    elseif name == 'Triggers Unbeatable' and v1 == '26' then
        scoring = true
        scoreState = 0
    end
end

function onTimerCompleted(tag)
    if tag == 'resetYcbuColor' then
        if resetColor == nil then
            resetColor = '000000'
        end

        setProperty('ycbuText.color',getColorFromHex(resetColor))
    end
end

function detectYCBUOffset()
    setProperty('ycbuText.fieldHeight', 300 * getProperty('ycbuText.textField.numLines'))
end

function onUpdate(el)
    local minOrder = math.min(getObjectOrder('dadGroup'),getObjectOrder('boyfriendGroup'),getObjectOrder('gfGroup')) - 1
    if getObjectOrder('ycbuText') ~= minOrder then
        setObjectOrder('ycbuText',minOrder)
    end
    if scoring then
        scoreState = scoreState + (el*3.5)
        local score = ''
        local scorePos = math.floor(scoreState)
        if scoreState < 3 then
            for pos = 0,5 do
                if pos < scorePos then
                    score = '9'
                else
                    score = score..tostring(getRandomInt(0,9))
                end
            end
        else
            score = '100000'
        end
        setTextString('ycbuText',text..'\n'..tostring(score))
        detectYCBUOffset()
        if scoreState >= 3 then
            scoring = false
            setProperty('ycbuText.color',getColorFromHex(resetColor))
        else
            setProperty('ycbuText.color',getColorFromHex('F77E63'))
        end
    end
end