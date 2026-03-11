local grandeONo = 3.2
function onCreate()
    makeLuaSprite("bg", "ratman/11",-100, 300)
    addLuaSprite("bg")
    scaleObject("bg", grandeONo-0.15,  grandeONo-0.15)  
    setScrollFactor("bg", 0.92, 0.92)

    if not lowQuality then
        makeLuaSprite("roquitas1", "ratman/16",-220, -100)
        addLuaSprite("roquitas1")
        scaleObject("roquitas1", grandeONo+0.4,  grandeONo)  
        setScrollFactor("roquitas1", 0.935, 0.935)
    
        makeLuaSprite("roquitas2", "ratman/17",-100, -100)
        addLuaSprite("roquitas2")
        scaleObject("roquitas2", grandeONo,  grandeONo)  
        setScrollFactor("roquitas2", 0.95, 0.95)
    end

    makeLuaSprite("gfPlatform", "ratman/12", -550, -200)
    addLuaSprite("gfPlatform", false)
    scaleObject("gfPlatform", grandeONo+0.4, grandeONo+0.4)  
    setScrollFactor("gfPlatform", 1, 1)

    makeLuaSprite("bfPlatform", "ratman/14", 140, 20)
    addLuaSprite("bfPlatform")
    scaleObject("bfPlatform", grandeONo,  grandeONo)  
    setObjectOrder('bfPlatform', getObjectOrder('boyfriendGroup')-1)
    setScrollFactor("bfPlatform", 1.1, 1.1)

    makeLuaSprite("extraPlatform", "ratman/15",  -100, 1350)
    addLuaSprite("extraPlatform")
    scaleObject("extraPlatform", grandeONo-0.9, grandeONo-0.9)  
    setScrollFactor("extraPlatform", 1.1, 1.1)

    makeLuaSprite("dadPlatform", "ratman/15", 0, 0)
    addLuaSprite("dadPlatform")
    scaleObject("dadPlatform", grandeONo+0.2, grandeONo+0.2)  
    setScrollFactor("dadPlatform", 1.1, 1.1)
    
    if not lowQuality then
        makeLuaSprite("foreground", "ratman/19", -30,280)
        addLuaSprite("foreground", true)
        scaleObject("foreground", grandeONo+0.2, grandeONo+0.2)  
        setScrollFactor("foreground", 1.14, 1.4)
    end

    makeAnimatedLuaSprite('explosion', 'ratman/explosion', -150, 0);
    addAnimationByPrefix('explosion', 'explosion', 'explosion', 20, false)
    setProperty('explosion.antialiasing', false)
    setProperty('explosion.visible', false)
    scaleObject('explosion', 2.5, 2.5)
    addLuaSprite('explosion', true)
end

function onEvent(n,v1,v2)
    if n == 'Trigger Starman' then
        if v1 == '1-2' then
            doTweenY('intro', 'extraPlatform', 350, 1.5, 'smoothstepout')
        end
    end
end

function onCreatePost()
    setScrollFactor("boyfriend", 1.1, 1.1)
    setScrollFactor("dad", 1.1, 1.1)
    setScrollFactor("gf",1,1)
end