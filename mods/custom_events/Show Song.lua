
local curLevel = 0
local maxLevels = 0
local songPos = 0
local colorText = 'FF0000'
local credits = {
    {
        song = 'Unwebonable',
        musician = 'REDTV53 FT. IRONIK \n COVER BY: NEXOV',
        musician2 = 'Scrumbo_',
        musician3 = 'THE WAHBOX FT. REDTV33',
        musician4 = 'REDTV53 FT. FRIEDFRICK'
    }
 }
function onCreate()
    for events = 0,getProperty('eventNotes.length')-1 do
        if getPropertyFromGroup('eventNotes',events,'event') == 'Show Song' and getPropertyFromGroup('eventNotes',events,'value1') ~= '1' then
            maxLevels = maxLevels + 1
        end
    end
    for i, songs in pairs(credits) do
        if songs.song ~= nil and songs.song == songName then
            songPos = i
            if songs.color ~= nil then
                colorText = songs.color
            end
            break
        end
    end

    createMarioText('marioName',songName)
    createMarioText('marioCredits')

    makeLuaSprite('marioLineBG',nil,0,0)
    setObjectCamera('marioLineBG','other')
    setProperty('marioLineBG.alpha',0.01)
    addLuaSprite('marioLineBG',false)
    setScrollFactor('marioLineBG',0,0)


    makeLuaSprite('marioLine',nil,0,0)
    setObjectCamera('marioLine','other')
    setProperty('marioLine.alpha',0.01)
    setScrollFactor('marioLine',0,0)
    addLuaSprite('marioLine',false)
end
function createLine()
    --local lineSize = string.len(getTextString('marioName')) * 35
    local lineSize = string.len(getTextString('marioName'))
    if luaTextExists('marioCredits') then
        local text = getTextString('marioCredits')
        if getProperty('marioCredits.textField.numLines') >= 2 then
            local newLine = 0
            repeat
                local _,l = string.find(lineSize,'\n',newLine,true)
                if l ~= nil then
                    lineSize = math.max(lineSize,string.len(string.sub(text,l)))
                    newLine = l
                else
                    newLine = nil
                end
            until newLine == nil
        else
            lineSize = math.max(lineSize,string.len(text))
        end
    end
    lineSize = lineSize * 35
    local linePosX = screenWidth/2 - (lineSize/2) - 5


    makeGraphic('marioLineBG',lineSize + 10,12,colorText)
    setProperty('marioLineBG.x',linePosX)
    updateHitbox('marioLineBG')


    makeGraphic('marioLine',lineSize,6,'000000')
    setProperty('marioLine.x',linePosX + 5)
    updateHitbox('marioLine')
end
function onEvent(name,v1,v2)
    if name == 'Show Song' then
        local marioTexts = {'marioName','marioCredits','marioLine','marioLineBG'}
        if v1 ~= '1' then
            curLevel = curLevel + 1
            if maxLevels > 1 then
                setTextString('marioName',credits[songPos]['song']..'(Level '..curLevel..')')
            end
            if credits[songPos]["musician"..curLevel] ~= nil then
                setTextString('marioCredits',credits[songPos]["musician"..curLevel])
            elseif credits[songPos]["musician"] ~= nil then
                setTextString('marioCredits',credits[songPos]["musician"])
            else
                setTextString('marioCredits','Undefined')
            end
            createLine()
            
        end


        local height = (screenHeight/2) - 50
        local pos = {height - 50,height+15,height+3,height}
        for i, texts in pairs(marioTexts) do
            cancelTween(texts..'Exit')
            cancelTween(texts..'Y')
            cancelTween(texts..'Alpha')
            if v1 ~= '1' then
                setProperty(texts..'.y',pos[i])
                doTweenY(texts..'Y',texts,pos[i] + 50,1,'expoOut')
                doTweenAlpha(texts..'Alpha',texts,1,1,'expoOut')
            else
                doTweenAlpha(texts..'Exit',texts,0,1,'expoIn')
            end
        end
    end
end
function createMarioText(tag,string)
    makeLuaText(tag,string,screenWidth,0,0)
    setTextFont(tag,'super-mario-bros-nes.ttf')
    setTextBorder(tag,2,colorText)
    setTextSize(tag,35)
    setProperty(tag..'.antialiasing',false)
    setProperty(tag..'.color','000000')
    setObjectCamera(tag,'other')
    addLuaText(tag,true)
    setProperty(tag..'.alpha',0.01)
end
function onTweenCompleted(tag)
    if tag == 'marioNameExit' then
        if curLevel >= maxLevels then
            removeLuaSprite('marioLine',true)
            removeLuaSprite('marioLineBG',true)
            removeLuaText('marioName',true)
            removeLuaText('marioCredits',true)
        end
    end
end