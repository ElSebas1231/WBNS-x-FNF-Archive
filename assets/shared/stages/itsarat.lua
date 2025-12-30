
function onCreate()
    makeLuaSprite("bg", "itsarat/bg", 400, -400)
    addLuaSprite("bg")
    scaleObject("bg",3.7, 3.7)  

    makeLuaSprite("foreground", "itsarat/foreground", 330, 100)
    addLuaSprite("foreground", true)
    scaleObject("foreground",3.39, 3) 
    setScrollFactor("foreground", 0.85, 0.85)

    makeLuaSprite("weas", "itsarat/weas", 400, -600)
    addLuaSprite("weas")
    scaleObject("weas", 3.7, 3.7) 
end