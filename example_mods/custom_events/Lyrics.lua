function onEvent(name, value1, value2)

    if name == "Lyrics" then

        makeLuaText('captions', 'Lyrics go here', 1100, 100, 550)
        setTextString('captions', value1)
        setTextFont('captions', 'vcr.ttf')
        setTextColor('captions', value2)
if value2 == '' then
setTextColor('captions', 'ffffff')
end
        setTextSize('captions', 35);
        addLuaText('captions')
	setObjectCamera('captions', 'other');
        setTextAlignment('captions', 'center')
        --removeLuaText('captions', true)
        
    end
end

