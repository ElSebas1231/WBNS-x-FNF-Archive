package states.shop;

import flixel.input.mouse.FlxMouseEventManager;

class ShopState extends MusicBeatState
{
    var title:FlxSprite;
    var dialogueBox:FlxSprite;
    var selectionBox:FlxSprite;
    var selector:FlxSprite;
    var curSelected:Int = 0;
    
    var bg:FlxSprite;
    var nexita:FlxSprite;
    var cajaRegistradora:FlxSprite;
    var lampara:FlxSprite;
    var capiHucha:FlxSprite;
    var weboCoinCounter:FlxSprite;

    var menuOptions:Array<{text:String, x:Float, y:Float}> = [
        {text: 'Comprar', x: -400, y: 174},
        {text: 'Charlar', x: -405, y: 229},
        {text: 'Salir',   x: -435, y: 284}
    ];
    private var grpOptions:FlxTypedGroup<FlxText>;

    var initialDialogue:String = "¡Bienvenido a la tienda!";
    var randomDialogues:Array<String> = [
        "¿Buscas algo especial?",
        "¡No olvides revisar las ofertas!",
        "Aceptamos WeboCoins.",
        "¡Gracias por visitarnos!",
        "¿Te gustaría una recomendación?",
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    ];

	var canSelectSomething = false;
    var showingInitial:Bool = true;
    var finishedText:Bool = false;
    var currentDialogue:String = "";
    var currentChar:Int = 0;
    var textSpeed:Float = 0.045;
    var textTimer:Float = 0;
    var dialogueText:FlxText;
    var dialogueChangeTimer:Float = 0;
    var dialogueInterval:Float = 6.0; // segundos entre diálogos aleatorios

    override function create() {
        super.create();
        Cursor.show();
        
        bg = new FlxSprite(-638, -333).loadGraphic(Paths.image('ui/shop/misc/bg'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.scale.set(0.5, 0.5);
        add(bg);

        nexita = new FlxSprite(500, -50).loadGraphic(Paths.image('ui/shop/misc/nexita'));
        nexita.antialiasing = ClientPrefs.data.antialiasing;
        nexita.scale.set(0.5, 0.5);
        add(nexita);

        cajaRegistradora = new FlxSprite(200, -40).loadGraphic(Paths.image('ui/shop/misc/cajaRegistradora'));
        cajaRegistradora.antialiasing = ClientPrefs.data.antialiasing;
        cajaRegistradora.scale.set(0.5, 0.5);
        add(cajaRegistradora);

        lampara = new FlxSprite(-640, -340).loadGraphic(Paths.image('ui/shop/misc/bombilla2'));
        lampara.antialiasing = ClientPrefs.data.antialiasing;
        lampara.scale.set(0.5, 0.5);
        add(lampara);
        
        capiHucha = new FlxSprite(-350, -170);
        capiHucha.antialiasing = ClientPrefs.data.antialiasing;
        capiHucha.frames = Paths.getSparrowAtlas('ui/shop/misc/capihucha');
        capiHucha.animation.addByPrefix('empty', 'empty', 24, false);
        capiHucha.animation.addByPrefix('mid', 'mid', 24, false);
        capiHucha.animation.addByPrefix('full', 'full', 24, false);
        capiHucha.animation.play('empty');
        capiHucha.scale.set(0.6, 0.6);
        add(capiHucha);

        dialogueBox = new FlxSprite(-310, 420).loadGraphic(Paths.image('ui/shop/hud/dialogueBox'));
        dialogueBox.antialiasing = ClientPrefs.data.antialiasing;
        dialogueBox.scale.set(0.45, 0.45);
        add(dialogueBox);

        dialogueText = new FlxText(500, 600, 750, "");
        dialogueText.antialiasing = ClientPrefs.data.antialiasing;
        dialogueText.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 27, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.fromString('#9b003b'));
        add(dialogueText);

        selectionBox = new FlxSprite(-230, -150).loadGraphic(Paths.image('ui/shop/hud/box'));
        selectionBox.antialiasing = ClientPrefs.data.antialiasing;
        selectionBox.scale.set(0.45, 0.45);
        add(selectionBox);

        grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

        for (num => option in menuOptions) {
            var optionText:FlxText = new FlxText(option.x, option.y, 1280, option.text);
            optionText.antialiasing = ClientPrefs.data.antialiasing;
            optionText.setFormat(Paths.font('Tardling-Regular.ttf'), 45, FlxColor.WHITE, CENTER);
            grpOptions.add(optionText);

            var mouseMenuItems = new FlxMouseEventManager();
			mouseMenuItems.add(optionText, onClick, null, onOver, null);
            add(mouseMenuItems);
        }
        
        selector = new FlxSprite(grpOptions.members[curSelected].x + 740, grpOptions.members[curSelected].y).loadGraphic(Paths.image('ui/shop/hud/selector'));
        selector.antialiasing = ClientPrefs.data.antialiasing;
        selector.scale.set(0.6, 0.6);
        add(selector);

        weboCoinCounter = new FlxSprite(-80, 550).loadGraphic(Paths.image('ui/shop/hud/webocoins'));
        weboCoinCounter.antialiasing = ClientPrefs.data.antialiasing;
        weboCoinCounter.scale.set(0.6, 0.6);
        add(weboCoinCounter);

        title = new FlxSprite(0, -25).loadGraphic(Paths.image('ui/shop/hud/title'));
        title.antialiasing = ClientPrefs.data.antialiasing;
        title.scrollFactor.set(0, 0);
        title.screenCenter(X);
        title.scale.set(0.75, 0.75);
        add(title);

        currentDialogue = initialDialogue;
        currentChar = 0;
        dialogueText.text = "";
        dialogueChangeTimer = 0;
        finishedText = false;
        canSelectSomething = true;
    }
    
    var canChangeDialogueText:Bool = true;
    var movedBack:Bool = false;
	var holdTime:Float = 0;
    var shiftMult:Int = 1;

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (canSelectSomething) {
            if (FlxG.keys.pressed.SHIFT) shiftMult = 3;

            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
                canSelectSomething = false;
            }

            if (FlxG.keys.justPressed.HOME) {
				curSelected = 0;
				changeSelection();
				holdTime = 0;	
			} else if(FlxG.keys.justPressed.END) {
				curSelected = menuOptions.length - 1;
				changeSelection();
				holdTime = 0;	
			}

			if (controls.UI_UP_P) {
				changeSelection(-shiftMult);
				holdTime = 0;
			}
	
			if (controls.UI_DOWN_P) {
				changeSelection(shiftMult);
				holdTime = 0;
			}
	
			if (controls.UI_DOWN || controls.UI_UP) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
	
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
	
			if (FlxG.mouse.wheel != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel);
			}

            if (controls.ACCEPT ) {
                switch (curSelected) {
                    case 0:
                        canSelectSomething = false;
                        MusicBeatState.switchState(new ShopBackstageState());

                    case 2:
                        canSelectSomething = false;
                        FlxG.sound.play(Paths.sound('cancelMenu'));
                        MusicBeatState.switchState(new MainMenuState());
                }
            }
        }

        if (canChangeDialogueText) {
            if (!finishedText) {
                textTimer += elapsed;
                if (currentChar < currentDialogue.length && textTimer >= textSpeed) {
                    dialogueText.text += currentDialogue.charAt(currentChar);
                    currentChar++;
                    textTimer = 0;
                    FlxG.sound.play(Paths.sound('dialogue'), 0.5);
                }

                if (currentChar >= currentDialogue.length) finishedText = true;
            }
    
            if (controls.ACCEPT && !finishedText) {
                dialogueText.text = currentDialogue;
                currentChar = currentDialogue.length;
                finishedText = true;
                FlxG.sound.play(Paths.sound('dialogue'), 0.5);
            }
    
            if (finishedText) {
                dialogueChangeTimer += elapsed;
                if (showingInitial && dialogueChangeTimer >= dialogueInterval) {
                    showingInitial = false;
                    pickRandomDialogue();
                } else if (!showingInitial && dialogueChangeTimer >= dialogueInterval) {
                    pickRandomDialogue();
                }
            }
        }
    }

    function onOver(target:FlxText) {
        if (canSelectSomething) {
            var idx = grpOptions.members.indexOf(target);
            if (idx != -1 && curSelected != idx) {
                curSelected = idx;
                changeSelection();
            }
        }
    }

    function onClick(target:FlxText) {
        if (canSelectSomething) {
            switch (curSelected) {
                case 0:
                    canSelectSomething = false;
                    MusicBeatState.switchState(new ShopBackstageState());

                case 2:
                    canSelectSomething = false;
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    MusicBeatState.switchState(new MainMenuState());
            }
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected += change;

        if (curSelected < 0) curSelected = menuOptions.length - 1;
		if (curSelected > menuOptions.length-1) curSelected = 0;

        switch (curSelected) {
            case 0:
                resetDialogue();
                canChangeDialogueText = false;
                currentDialogue = 'Claro, sigueme';
                new FlxTimer().start(0.3, _ -> { 
                    dialogueChangeTimer = 0.3;
                    canChangeDialogueText = true;
                });
                selector.setPosition(grpOptions.members[curSelected].x + 740, grpOptions.members[curSelected].y);
            case 1:
                resetDialogue();
                canChangeDialogueText = false;
                currentDialogue = 'No tengo mucho de que hablar';
                new FlxTimer().start(0.3, _ -> { 
                    dialogueChangeTimer = 0.3;
                    canChangeDialogueText = true;
                });
                selector.setPosition(grpOptions.members[curSelected].x + 740, grpOptions.members[curSelected].y);
            case 2:
                resetDialogue();
                canChangeDialogueText = false;
                currentDialogue = '¡Nos vemos!';
                new FlxTimer().start(0.3, _ -> { 
                    dialogueChangeTimer = 0.3;
                    canChangeDialogueText = true;
                });
                selector.setPosition(grpOptions.members[curSelected].x + 700, grpOptions.members[curSelected].y - 5);
        }
    }

    function resetDialogue() {
        currentChar = 0;
        dialogueText.text = "";
        finishedText = false;
        dialogueChangeTimer = 0;
    }

    function pickRandomDialogue() {
        currentDialogue = randomDialogues[FlxG.random.int(0, randomDialogues.length - 1)];
        currentChar = 0;
        dialogueText.text = "";
        finishedText = false;
        dialogueChangeTimer = 0;
    }
}