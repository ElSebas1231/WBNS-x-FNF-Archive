function onCreate()  
    makeLuaSprite('bg1', 'misc/c3jo/main/bg1', -850, -400)
    setProperty('bg1.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    setScrollFactor('bg1', 0.9, 1)
    addLuaSprite('bg1')

    makeLuaSprite('bg2', 'misc/c3jo/main/bg2', -850, -400)
    setProperty('bg2.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('bg2')

    makeLuaSprite('bg3', 'misc/c3jo/main/bg3', -850, -400)
    setProperty('bg3.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('bg3')

    setObjectOrder('bg2', getObjectOrder('gfGroup')+1)
    setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup'))
    setObjectOrder('bg3', getObjectOrder('boyfriendGroup')-1)
end

function onEvent(n, v1, v2)
    if n == 'roval_color' then
        if v1 == '' then
            doTweenAlpha('bg2T', 'bg2', 1, 0.01)
            doTweenAlpha('bg3T', 'bg3', 1, 0.01)
        else
            doTweenAlpha('bg2T', 'bg2', 0, 0.01)
            doTweenAlpha('bg3T', 'bg3', 0, 0.01)
        end
    end
end