function onEvent(n,v1,v2)
    if n == "Song Name" then
        if v1 ~= '' and v2 ~= '' then
            texts = {'song', 'composer'}

            y = 300
            yOff = 20
            for i = 1, #texts do
                makeLuaText(texts[i], '', 800, 0, y - yOff + (i-1)*80)
                screenCenter(texts[i], 'x')
                setTextFont(texts[i], 'Pixel Emulator.otf')
                setTextSize(texts[i], 55 - (i-1)*10)
                setTextColor(texts[i], '000000')
                setTextBorder(texts[i], 3, 'f02828')
                setProperty(texts[i]..'.alpha', 0)
            end
            setTextString('song', v1)
            setTextString('composer', v2)

            makeLuaSprite('barBG', '', 0, y + 70 - yOff)
            makeGraphic('barBG', string.len('composer') * 80 + 10, 10, 'f02828')
            screenCenter('barBG', 'x')
            setObjectCamera('barBG', 'hud')
            setProperty('barBG.alpha', 0)
        
            makeLuaSprite('bar', '', 0, y + 73 - yOff)
            makeGraphic('bar', string.len('composer') * 80, 4, '000000')
            screenCenter('bar', 'x')
            setObjectCamera('bar', 'hud')
            setProperty('bar.alpha', 0)

            addLuaText('song')
            addLuaText('composer')
            addLuaSprite('barBG', true)
            addLuaSprite('bar', true)

            everything = {'song', 'composer', 'barBG', 'bar'}
            for i = 1, #everything do
                doTweenY(everything[i]..'y', everything[i], getProperty(everything[i]..'.y') + 20, 0.5, 'sineOut')
                doTweenAlpha(everything[i]..'a', everything[i], 1, 0.5, 'sineOut')
            end
        elseif v1 == 'me lol' then
            makeLuaText('kornelbut', 'VOCAL REMIX BY: NEXOV', 800, 0, y + 120)
            screenCenter('kornelbut', 'x')
            setTextFont('kornelbut', 'Pixel Emulator.otf')
            setTextSize('kornelbut', 30)
            setTextColor('kornelbut', '000000')
            setTextBorder('kornelbut', 2, 'f02828')
            setProperty('kornelbut.alpha', 0)

            addLuaText('kornelbut')
            doTweenY('kornelbuty', 'kornelbut', getProperty('kornelbut.y') + 20, 0.5, 'sineOut')
            doTweenAlpha('kornelbuta', 'kornelbut', 1, 0.5, 'sineOut')
        elseif v1 == '' and v2 == '' then
            for i = 1, #everything do
                doTweenAlpha(everything[i]..'Bye', everything[i], 0, 0.5, 'sineOut')
            end
            doTweenAlpha('kornelbutBye', 'kornelbut', 0, 0.5, 'sineOut')
        end
    end
end

function onUpdate()
    if botPlay then
        makeGraphic('barBG', string.len('composer') * 80 + 10, 10, '25cd49')
    else
        makeGraphic('barBG', string.len('composer') * 80 + 10, 10, 'f02828')
    end
end

function onTweenCompleted(tag)
    if tag == 'songBye' then
        removeLuaText('song', true)
        removeLuaText('composer', true)
        removeLuaSprite('barBG', true)
        removeLuaSprite('bar', true)
        removeLuaText('kornelbut', true)
    end
end