package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

import shaders.ChromaticAberration;
import shaders.BloomShader;

import openfl.filters.ShaderFilter;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var alredyPressed:Bool = false;

	var text1:FlxSprite;
	var text2:FlxSprite;
	var text3:FlxSprite;
	var text4:FlxSprite;

	var introSprite:FlxSprite;
	var whiteBg:FlxSprite;

	var initialTextsPos:Float = 100;
	var topBg:FlxSprite;

	var chromaticAberrationShader:ChromaticAberration;
	var bloomShader:BloomShader;

	var shaderFilter1:ShaderFilter;
	var shaderFilter2:ShaderFilter;

	override function create()
	{
		super.create();

		// shaders
		if(ClientPrefs.data.shaders)
		{
			chromaticAberrationShader = new ChromaticAberration();
			chromaticAberrationShader.rOffset.value = [0];
			chromaticAberrationShader.gOffset.value = [0];
			chromaticAberrationShader.bOffset.value = [0];

			shaderFilter1 = new ShaderFilter(chromaticAberrationShader);

			bloomShader = new BloomShader();

			bloomShader.dim.value = [2.0];
			bloomShader.Directions.value = [10.0];
			bloomShader.Quality.value = [8.0];
			bloomShader.Size.value = [0.0];
			
			shaderFilter2 = new ShaderFilter(bloomShader);

			FlxG.camera.filters = [shaderFilter1, shaderFilter2];
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		whiteBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		whiteBg.visible = false;
		add(whiteBg);

		text1 = new FlxSprite(0, initialTextsPos).loadGraphic(Paths.image('ui/menus/intro/TEXT 1'));
		text1.screenCenter(X);
		text1.antialiasing = ClientPrefs.data.antialiasing;
		text1.visible = false;
		add(text1);
		
		text2 = new FlxSprite(0, initialTextsPos + 100).loadGraphic(Paths.image('ui/menus/intro/TEXT 2'));
		text2.screenCenter(X);
		text2.antialiasing = ClientPrefs.data.antialiasing;
		text2.visible = false;
		add(text2);
		
		text3 = new FlxSprite(0, initialTextsPos + 240).loadGraphic(Paths.image('ui/menus/intro/TEXT 3'));
		text3.screenCenter(X);
		text3.antialiasing = ClientPrefs.data.antialiasing;
		text3.visible = false;
		add(text3);

		text4 = new FlxSprite(0, initialTextsPos + 130).loadGraphic(Paths.image('ui/menus/intro/TEXT 4 press ENTER'));
		text4.screenCenter(X);
		text4.antialiasing = ClientPrefs.data.antialiasing;
		text4.visible = false;
		add(text4);

		introSprite = new FlxSprite();
		introSprite.frames = Paths.getSparrowAtlas('ui/menus/intro/advertencia_intro');
		introSprite.animation.addByPrefix('idle', 'advertencia_intro lightsOFF', 12, true);
		introSprite.animation.addByPrefix('lightsOn', 'advertencia_intro lightsOn', 10, false);
		introSprite.animation.play('idle');
		introSprite.x = FlxG.width - introSprite.width - 15;
		introSprite.y = FlxG.height - introSprite.height - 15;
		introSprite.antialiasing = ClientPrefs.data.antialiasing;
		introSprite.visible = false;
		add(introSprite);

		// start thing
		new FlxTimer().start(0.4, function(t:FlxTimer)
		{
			text1.visible = true;
			FlxG.sound.play(Paths.sound('scrollMenu'));
			
			new FlxTimer().start(1.4, function(t:FlxTimer) 
			{
				text2.visible = true;
				introSprite.visible = true;

				FlxG.sound.play(Paths.sound('scrollMenu'));
				
				new FlxTimer().start(1.4, function(t:FlxTimer) 
				{
					text3.visible = true;
					
					FlxG.sound.play(Paths.sound('cancelMenu'));
				});
			});
		});
	}

	override function update(elapsed:Float)
	{
		if(!leftState) 
		{
			if(!text3.visible) return;
			
			if(controls.ACCEPT && !alredyPressed)
			{
				alredyPressed = true;
				FlxG.camera.flash(0xFFFFFFFF, 1, null, true);
				whiteBg.visible = true;
				introSprite.animation.play('lightsOn');
				text1.color = 0xFF000000;
				text4.visible = true;

				FlxG.sound.play(Paths.sound('confirm'));

				chromaticAberrationShader.rOffset.value[0] = 0.002;
				chromaticAberrationShader.gOffset.value[0] = 0;
				chromaticAberrationShader.bOffset.value[0] = -0.002;
				
				bloomShader.Directions.value = [4.0];

				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					trace('triggered!');
					
					FlxTween.tween(text1, {alpha: 0}, 1.3);
					FlxTween.tween(text4, {alpha: 0}, 1.3);
	
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						FlxTransitionableState.skipNextTransOut = true;
						FlxTransitionableState.skipNextTransIn = true;
	
						leftState = true;
						MusicBeatState.switchState(new TitleState());
					});
				});
			}
		}
		super.update(elapsed);
	}
}
