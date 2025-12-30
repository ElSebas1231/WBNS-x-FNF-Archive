function onCreate()
    makeLuaSprite('noticieroBG', 'misc/c3jo/noticiero/noticieroBG', -1200, 0)
    setProperty('noticieroBG.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    addLuaSprite('noticieroBG')
end