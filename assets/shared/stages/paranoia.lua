local cameraFollow = {0, 0, 0, 0}
local curStage = "normal"

local initialBFX = 0
local initialBFY = 0

local initialDadX = 0
local initialDadY = 0

function onCreate() setProperty('camZooming', true) end
function onCreatePost() 
    addHaxeLibrary('FlxBackdrop', 'flixel.addons.display')

    runHaxeCode([[
        var late:FlxBackdrop;

        late = new FlxBackdrop(Paths.image('nightmare/latest'), 0x11);
        late.velocity.set(0, 0);
        late.scale.set(4, 4);
        late.antialiasing = ClientPrefs.data.antialiasing;
        late.visible = false;
        game.add(late);

        setVar('late', late);
    ]])

    initialBFX = getCharacterX('boyfriend')
    initialBFY = getCharacterY('boyfriend')

    initialDadX = getCharacterX('dad')
    initialDadY = getCharacterY('dad')

    changeStage("normal") 
end

function changeStage(stage)
	if stage == "pilares" then
        for i,v in ipairs({'BG', 'cadenas1', 'cadenas2', 'luna', 'nubes', 'suelo'}) do
            if luaSpriteExists(v) then
                removeLuaSprite(v, true)
            end
        end

        makeLuaSprite('nube',"nightmare/nube_paranoia", -1800, -1200)
        scaleObject('nube', 4, 4)
        addLuaSprite('nube')

        makeLuaSprite('pilardad',"nightmare/pilar_paranoia", 200 , 1400)
        scaleObject('pilardad', 2.5, 2.5)
        addLuaSprite('pilardad')

        makeLuaSprite('pilarbf',"nightmare/pilar_paranoia", 2120 , 1450)
        scaleObject('pilarbf', 1.7, 1.7)
        addLuaSprite('pilarbf')

        setCharacterX('dad', 650)

        setObjectOrder('late', getObjectOrder('nube'))
        setProperty('late.visible', true)
        tlBop()

        setProperty('defaultCamZoom', 0.4)

        curStage = "pilares"
	end

	if stage == "normal" then
		local x = -1400
                for i,v in ipairs({'BG2', 'luna2', 'pilarbf2', 'neurismo'}) do
            if luaSpriteExists(v) then
                removeLuaSprite(v, true)
            end
        end

        setProperty('late.visible', false)
		makeLuaSprite('BG',"nightmare/fondo_paranoia", x, -1200)
        scaleObject("BG", 4, 4)
	    addLuaSprite('BG')

        makeLuaSprite('luna',"nightmare/luna_paranoia", -350, -200)
        setScrollFactor('luna', 1.05, 1)
        scaleObject('luna', 2.5, 2.5)
        addLuaSprite('luna')

        makeLuaSprite('nubes',"nightmare/nube_paranoia", x - 200, -1200)
        setScrollFactor('nubes', 0.8, 1)
        scaleObject('nubes', 4, 4)
        addLuaSprite('nubes')

        makeLuaSprite("cadenas2", "nightmare/cadenas2", -500, -600)
        scaleObject("cadenas2", 2.5, 2.5)
        addLuaSprite("cadenas2")

        makeLuaSprite("suelo", "nightmare/suelo_paranoia", 0, 0)
        scaleObject("suelo", 2,2)
        addLuaSprite("suelo")

        makeLuaSprite("cadenas1", "nightmare/cadenas", -150, -400)
        scaleObject("cadenas1", 2.2, 2.2)
        addLuaSprite("cadenas1", true)
        
        setCharacterX('dad', initialDadX)
        setCharacterY('dad', initialDadY)

        setCharacterX('boyfriend', initialBFX)
        setCharacterY('boyfriend', initialBFY)
        setProperty('defaultCamZoom', 0.35)
        
        curStage = "normal"
	end

    if stage == 'pilares2' then
        for i,v in ipairs({'pilardad', 'pilarbf', 'nube'}) do
            if luaSpriteExists(v) then
                removeLuaSprite(v, true)
            end
        end
        
        setProperty('late.visible', false)

        makeLuaSprite('BG2',"nightmare/fondo_paranoia", -650, -200)
        scaleObject("BG2", 2, 2)
	    addLuaSprite('BG2')

        makeAnimatedLuaSprite('neurismo', 'nightmare/neurismo', -550, -350);
        addAnimationByPrefix('neurismo', 'idle', 'neurismo0', 12, true);
        setObjectOrder('neurismo', getObjectOrder('dadGroup'))
        scaleObject("neurismo", 1.8, 1.8)
        addLuaSprite('neurismo')

        makeLuaSprite('luna2',"nightmare/luna_paranoia", 400, 780)
        setObjectOrder('luna2', getObjectOrder('dadGroup')+1)
        addLuaSprite('luna2')

        makeLuaSprite('pilarbf2',"nightmare/pilar_paranoia", 1150 , 1600)
        setObjectOrder('pilarbf2', getObjectOrder('boyfriendGroup'))
        addLuaSprite('pilarbf2')

        setCharacterX('dad', 1200)
        setCharacterY('dad', 350)

        setCharacterX('boyfriend', 1350)
        setCharacterY('boyfriend', 1250)

        curStage = "pilares2"
    end
end

function onUpdate()
    if curStage == 'pilares2' then
        setProperty('defaultCamZoom', mustHitSection and 0.6 or 0.4)
    end
end

function onEvent(name, value1, value2)
    if name == "Change BG" then
        changeStage(value1)
    end

    if name == 'Add Camera Zoom' then
        tlBop()
    end
end

function tlBop()
        runHaxeCode([[
        var late = getVar('late');

        if (late.visible == false) return;
        
        var funnyTween1:FlxTween;
        var funnyTween2:FlxTween;

        late.alpha = 1;
        late.velocity.y = 200;

        if(funnyTween1 != null) funnyTween1.cancel();

        funnyTween1 = FlxTween.tween(late.velocity, {y: 0}, 0.4, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween) {
                funnyTween1 = null;
            }
        });

        if(funnyTween2 != null) funnyTween2.cancel();
        funnyTween2 = FlxTween.tween(late, {alpha: 0.25}, 0.4, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween) {
                funnyTween2 = null;
            }
        });
    ]])
end

function setPosition(obj, x, y)
	setProperty(obj..".x", x)
	setProperty(obj..".y", y)
end