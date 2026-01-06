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

    makeAnimatedLuaSprite('trans', 'nightmare/estailus miado', 0, 100)
    addAnimationByPrefix('trans', 'idle', 'stai', 14, false)
    setProperty('trans.visible', false)
    setObjectCamera('trans', 'hud')
    screenCenter('trans', 'x')
    addLuaSprite('trans')
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
                for i,v in ipairs({'BG2', 'luna2', 'pilarbf2', 'neurismo', 'cuerpoAndreh', 'cuerpoAquino', 'cuerpoC3jo', 'cuerpoDuxo', 'cuerpoLoco', 'cuerpoMictia'}) do
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
        scaleObject("BG2", 2.2, 2.2)
	    addLuaSprite('BG2')

        makeAnimatedLuaSprite('neurismo', 'nightmare/neurismo', -650, -500);
        addAnimationByPrefix('neurismo', 'idle', 'neurismo0', 12, true);
        setObjectOrder('neurismo', getObjectOrder('dadGroup'))
        setProperty('neurismo.antialiasing', true)
        scaleObject("neurismo", 4.5, 4.5)
        addLuaSprite('neurismo')

        makeLuaSprite('luna2',"nightmare/luna_paranoia", 400, 780)
        setObjectOrder('luna2', getObjectOrder('dadGroup')+1)
        addLuaSprite('luna2')

        makeLuaSprite('pilarbf2',"nightmare/pilar_paranoia", 1150 , 1600)
        setObjectOrder('pilarbf2', getObjectOrder('boyfriendGroup'))
        addLuaSprite('pilarbf2')

        makeLuaSprite('cuerpoAndreh',"nightmare/cuerpo_andreh", -50, -400)
        scaleObject('cuerpoAndreh', 2, 2)
        addLuaSprite('cuerpoAndreh')

        -- Lo sé, un poco raro que salga Aquino xd
        makeLuaSprite('cuerpoAquino',"nightmare/cuerpo_aquino", 350, -550)
        scaleObject('cuerpoAquino', 3, 3)
        addLuaSprite('cuerpoAquino')

        makeLuaSprite('cuerpoC3jo',"nightmare/cuerpo_c3jo", 720, -400)
        scaleObject('cuerpoC3jo', 2, 2)
        addLuaSprite('cuerpoC3jo')

        makeLuaSprite('cuerpoDuxo',"nightmare/cuerpo_duxo", 1900, -280)
        scaleObject('cuerpoDuxo', 1.2, 1.2)
        addLuaSprite('cuerpoDuxo')

        makeLuaSprite('cuerpoLoco',"nightmare/cuerpo_locochon", 2250, -260)
        scaleObject('cuerpoLoco', 1.3, 1.3)
        addLuaSprite('cuerpoLoco')
        
        makeLuaSprite('cuerpoMictia',"nightmare/cuerpo_mictia", 2650, -500)
        scaleObject('cuerpoMictia', 3.4, 3.4)
        addLuaSprite('cuerpoMictia')

        for i,v in ipairs({'cuerpoAndreh', 'cuerpoAquino', 'cuerpoC3jo', 'cuerpoDuxo', 'cuerpoLoco', 'cuerpoMictia'}) do
            setObjectOrder(v, getObjectOrder('dadGroup')+1)
            setProperty(v..'.alpha', 0)
        end

        setCharacterX('dad', 1200)
        setCharacterY('dad', 350)

        setCharacterX('boyfriend', 1350)
        setCharacterY('boyfriend', 1250)

        curStage = "pilares2"
    end

    if stage == "pilares3" then
        for i,v in ipairs({'nube', 'pilardad', 'pilarbf', 'BG', 'cadenas1', 'cadenas2', 'luna', 'nubes', 'suelo'}) do
            if luaSpriteExists(v) then
                removeLuaSprite(v, true)
            end
        end

        makeLuaSprite('bgR',"nightmare/fondo_paranoia", -950, -200)
        scaleObject("bgR", 2, 2)
	    addLuaSprite('bgR')

        makeLuaSprite('nube',"nightmare/nube_paranoia", -1800, -1200)
        scaleObject('nube', 4, 4)
        addLuaSprite('nube')

        makeLuaSprite('pilardad',"nightmare/pilar_paranoia", 300, 1450)
        scaleObject('pilardad', 2, 2)
        addLuaSprite('pilardad')

        makeLuaSprite('pilarbf',"nightmare/pilar_paranoia", 1600 , 2010)
        scaleObject('pilarbf', 2, 2)
        addLuaSprite('pilarbf')

        makeAnimatedLuaSprite('pelito', 'nightmare/pelito', getProperty('dad.x') - 750, getProperty('dad.y') - 120)
        addAnimationByPrefix('pelito', 'idle', 'pelito', 20, true)
        setObjectOrder('pelito', getObjectOrder('dad'))
        addLuaSprite('pelito')

        setProperty('late.visible', false)
        setCharacterX('boyfriend', 1850)
        setCharacterY('boyfriend', 1400)
        setProperty('defaultCamZoom', 0.4)

        curStage = "pilares3"
	end
end

function onUpdate()
    if curStage == 'pilares2' then
        setProperty('defaultCamZoom', mustHitSection and 0.6 or 0.4)
    end
end

function onUpdatePost(elapsed)
    if dadName == 'paranoiaAquino3' then 
        if getProperty('dad.animation.curAnim.name') == 'idle' then
            setProperty('pelito.x', getProperty('dad.x') - 750)
            setProperty('pelito.y', getProperty('dad.y') - 120)
        end
    end

    if getProperty('trans.animation.curAnim.finished') then
        if getProperty('trans.visible') == true then
            setProperty('trans.visible', false)
            setProperty('camGame.visible', true)
        end
    end
end

function onEvent(name, value1, value2)
    if name == "Change BG" then
        changeStage(value1)
    end

    if name == 'Add Camera Zoom' then
        tlBop()
    end

    if name == 'Change Character' then
        if value1 == 'dad' then
            if value2 == 'paranoiaAquino3' then
                setProperty('pelito.visible', true)
            else
                setProperty('pelito.visible', false)
            end
        end
    end

    if name == 'Trans Pilar' then
        playAnim('trans', 'idle', true)
        setProperty('trans.visible', true)
        setProperty('camGame.visible', false)
    end

    if name == 'BG Cuerpos' then
        for i,v in ipairs({'cuerpoAndreh', 'cuerpoAquino', 'cuerpoC3jo', 'cuerpoDuxo', 'cuerpoLoco', 'cuerpoMictia'}) do
            runHaxeCode([[
                var sprite:FlxSprite = game.getLuaObject(']]..v..[[');
                var funnyTween:FlxTween;

                if (sprite == null) return;
                if(funnyTween != null) funnyTween.cancel();

                sprite.y -= 200;
                funnyTween = FlxTween.tween(sprite, {y: sprite.y + 50, alpha: 1}, 0.6, {
                    ease: FlxEase.quadOut,
                    onComplete: function(twn2:FlxTween) {
                        funnyTween = null;
                    },
                    startDelay: ]]..(i-0.5)..[[
                });
            ]])
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if dadName == 'paranoiaAquino3' then 
        if noteData == 0 then
            setProperty('pelito.x', getProperty('dad.x') - 840)
            setProperty('pelito.y', getProperty('dad.y') - 90)
        elseif noteData == 1 then
            setProperty('pelito.x', getProperty('dad.x') - 750)
            setProperty('pelito.y', getProperty('dad.y') - 100)
        elseif noteData == 2 then
            setProperty('pelito.x', getProperty('dad.x') - 750)
            setProperty('pelito.y', getProperty('dad.y') - 250)
        elseif noteData == 3 then
            setProperty('pelito.x', getProperty('dad.x') - 620)
            setProperty('pelito.y', getProperty('dad.y') - 65)
        end
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