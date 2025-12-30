package states;

import flixel.addons.display.FlxBackdrop;

class CreditsState extends MusicBeatState
{
	var coffeSprite:FlxSprite;
	var islandSprite:FlxSprite;

	var tv:FlxSprite;
	var devChannel:FlxSprite;
	var trofeoGOAT:FlxSprite;
	var insignia1:FlxSprite;
	var insignia2:FlxSprite;
	var insignia3:FlxSprite;

	var insigniasAnims:Map<String, String> = [
		'animador' => 'start insignia animador0', 'artista' => 'start insignia artista0',
		'charters' => 'start insignia charters 0', 'coders' => 'start insignia coders0',
		'director' => 'start insignia director0', 'mc spriter' => 'start insignia mc spriter0',
		'musico' => 'start insignia musico0'
	];

	var devsArrary:Array<String> = [
		'akira', 'anxiouskitty', 'bayestso', 'bus_mixta', 'chintws', 'dta',
		'eikoz', 'elcami', 'elsebas1231', 'erick', 'garonm', 'garret', 'gonn',
		'gtx', 'jackflowers', 'jisuz', 'lolinmalo', 'lui', 'mrbeeps', 'nexo28', 'notwingow'
	];

	override function create()
	{
		#if DISCORD_ALLOWED
		//DiscordClient.changePresence("In the Menus", null);
		#end

		var formattedDevs:Array<String> = devsArrary.map(function(dev:String):String {
			return 'ui/menus/credits/devs/tvs/' + dev;
		});

		var bgColor:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(bgColor);

		islandSprite = new FlxSprite().loadGraphic(Paths.image('ui/menus/credits/isla-creditos'));
		islandSprite.screenCenter();
		islandSprite.antialiasing = ClientPrefs.data.antialiasing;
		islandSprite.x = 1400;
		islandSprite.y = 273;
		add(islandSprite);

		devChannel = new FlxSprite(0, 0);
		devChannel.x = 520;
		devChannel.y = 159;
		devChannel.antialiasing = ClientPrefs.data.antialiasing;
		devChannel.frames = Paths.getMultiAtlas(formattedDevs); // This will carry the fucking thing
		for (i in 0...devsArrary.length) {
			devChannel.animation.addByPrefix(devsArrary[i], devsArrary[i], 24, true);
		}
		devChannel.scale.set(0.95, 0.95);
		devChannel.visible = false;
		add(devChannel);

		tv = new FlxSprite(0, 0);
		tv.frames = Paths.getSparrowAtlas('ui/menus/credits/tv');
		tv.antialiasing = ClientPrefs.data.antialiasing;
		tv.animation.addByPrefix('intro', 'TV  enters0', 24, false);
        tv.animation.addByPrefix('idle', 'TV IDLE0', 24, true);
        tv.animation.addByPrefix('change', 'TV change channel0', 24, false);
        tv.animation.addByPrefix('trans change', 'TV change channel with transition0', 24, false);
		tv.x = 462;
		tv.y = -356;
		tv.scale.set(0.95, 0.95);
		tv.updateHitbox();
		tv.visible = false;
		add(tv);
		
		trofeoGOAT = new FlxSprite(0, 0);
		trofeoGOAT.frames = Paths.getSparrowAtlas('ui/menus/credits/trofeocarreador');
		trofeoGOAT.antialiasing = ClientPrefs.data.antialiasing;
		trofeoGOAT.animation.addByPrefix('intro', 'start trofeoGOAT0', 24, false);
		trofeoGOAT.animation.addByPrefix('left', 'left trofeoGOAT0', 24, false);
		trofeoGOAT.animation.addByPrefix('idle', 'idle trofeoGOAT0', 24, true);
		trofeoGOAT.scale.set(0.9, 0.9);
		trofeoGOAT.updateHitbox();
		trofeoGOAT.x = 380;
		trofeoGOAT.y = 290;
		trofeoGOAT.visible = false;
		add(trofeoGOAT);
		
		insignia1 = new FlxSprite(0, 0);
		insignia1.frames = Paths.getSparrowAtlas('ui/menus/credits/insignias');
		insignia1.antialiasing = ClientPrefs.data.antialiasing;
		insignia1.scale.set(0.65, 0.65);
		insignia1.updateHitbox();
		for (key in insigniasAnims.keys()) {
			insignia1.animation.addByPrefix(key, insigniasAnims[key], 24, false);
		}
		insignia1.x = 780;
		insignia1.y = 90;
		insignia1.visible = false;
		add(insignia1);

		insignia2 = new FlxSprite(0, 0);
		insignia2.frames = Paths.getSparrowAtlas('ui/menus/credits/insignias');
		insignia2.antialiasing = ClientPrefs.data.antialiasing;
		insignia2.scale.set(0.65, 0.65);
		insignia2.updateHitbox();
		for (key in insigniasAnims.keys()) {
			insignia2.animation.addByPrefix(key, insigniasAnims[key], 24, false);
		}
		insignia2.x = insignia1.x;
		insignia2.y = insignia1.y + 120;
		insignia2.visible = false;
		add(insignia2);

		insignia3 = new FlxSprite(0, 0);
		insignia3.frames = Paths.getSparrowAtlas('ui/menus/credits/insignias');
		insignia3.antialiasing = ClientPrefs.data.antialiasing;
		insignia3.scale.set(0.65, 0.65);
		insignia3.updateHitbox();
		for (key in insigniasAnims.keys()) {
			insignia3.animation.addByPrefix(key, insigniasAnims[key], 24, false);
		}
		insignia3.x = insignia2.x;
		insignia3.y = insignia2.y + 120;
		insignia3.visible = false;
		add(insignia3);

        coffeSprite = new FlxSprite();
        coffeSprite.frames = Paths.getSparrowAtlas('ui/menus/intro/coffe_team_logo');
        coffeSprite.animation.addByPrefix('intro', 'logo intro', 24, false);
        coffeSprite.animation.addByPrefix('idle', 'idle logo', 24, true);
        coffeSprite.animation.play('intro');
        FlxG.sound.play(Paths.sound('tea_sound'));
        coffeSprite.animation.finishCallback = function(name:String) {
            if (name == 'intro') {
				coffeSprite.x = 375;
				coffeSprite.y = 50;
				coffeSprite.animation.play('idle');
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					FlxTween.tween(coffeSprite, {x: -180, y: -220, "scale.x": 0.3, "scale.y": 0.3}, 0.8, {ease: FlxEase.smoothStepInOut});
					FlxTween.tween(islandSprite, {x: 333}, 0.8, {
						ease: FlxEase.smoothStepInOut, 
						onComplete: function(twn:FlxTween) {
							tv.visible = true;
							tv.animation.play('intro');
							tv.animation.finishCallback = function(n:String) {
							if (n == 'intro') {
								tv.x = 500;
								tv.y = 50;
								tv.animation.play('idle');
								devChannel.visible = true;

								insignia1.visible = true;
								insignia1.animation.play(insigniasAnims['director']);
								
								insignia2.visible = true;
								insignia2.animation.play(insigniasAnims['musico']);
								
								insignia3.visible = true;
								insignia3.animation.play(insigniasAnims['musico']);
								trofeoGOAT.visible = true;
							}
						}
					}});
				});
			}
        }
        coffeSprite.scale.set(0.75, 0.75);
        coffeSprite.screenCenter();
        coffeSprite.antialiasing = ClientPrefs.data.antialiasing;
        add(coffeSprite);
		
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (coffeSprite != null) {
			if (coffeSprite.animation.curAnim.name == 'intro') { 
				coffeSprite.screenCenter(); 
				coffeSprite.setPosition((coffeSprite.x - 170) * coffeSprite.scale.x + 94, (coffeSprite.y - 284) * coffeSprite.scale.y + 13); 
			}
		}

		if(!quitting) {
			if (controls.BACK) {
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		super.update(elapsed);
	}
}
