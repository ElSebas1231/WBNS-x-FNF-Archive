-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Fade Screen' then
	duration = tonumber(value1)

	targetAlpha = tonumber(value2);
	cancelTween("dadFadeEventTween")
		doTweenAlpha('dadFadeEventTween', 'black', targetAlpha, duration, 'linear')
	--debugPrint('Event triggered: ', name, duration, targetAlpha);
    end
end

function onCreate()
makeLuaSprite("black","",-400,0)
doTweenAlpha()
        makeGraphic("black",4280,4020,'000000')
        setScrollFactor("black",0,0)
        setObjectCamera("black","other")
        setProperty('black.alpha', 0)
        addLuaSprite("black",true)
end
