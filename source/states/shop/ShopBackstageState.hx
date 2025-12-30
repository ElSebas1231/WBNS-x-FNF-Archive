package states.shop;

import flixel.input.mouse.FlxMouseEventManager;

class ShopBackstageState extends MusicBeatState {
    var bg:FlxSprite;
    var estante:FlxSprite;
    var armario:FlxSprite;
    var cajas:FlxSprite;
    var repisa:FlxSprite;
    var mostrador:FlxSprite;
    var capiHucha:FlxSprite;
    var lampara:FlxSprite;
    var cortina:FlxSprite;
    var title:FlxSprite;

    var espejo:ShopItem;
    var grpShopItems:FlxTypedGroup<ShopItem>;

    var shopItemsSection1:Array<{image:String, x:Float, y:Float, scale:Float, fpsIdle:Int, fpsSelected:Int, fpsSold:Int}> = [
        {image: 'celeste song', x: -24, y: -98, scale: 0.65, fpsIdle: 12, fpsSelected: 12, fpsSold: 12},
        {image: 'miku vs meica', x: 0, y: 0, scale: 0.65, fpsIdle: 2, fpsSelected: 12, fpsSold: 12}
    ];

    var shopItemsSection2:Array<{image:String, x:Float, y:Float, scale:Float, fpsIdle:Int, fpsSelected:Int, fpsSold:Int}> = [
        {image: 'animalcrosed', x: 296.1, y: 376.6 , scale: 0.7, fpsIdle: 2, fpsSelected: 2, fpsSold: 2},
    ];

    var shopItemsSection3:Array<{image:String, x:Float, y:Float, scale:Float, fpsIdle:Int, fpsSelected:Int, fpsSold:Int}> = [
        {image: 'boss fight', x: 0, y: 0, scale: 0.65, fpsIdle: 2, fpsSelected: 2, fpsSold: 2},
    ];

    var canLeave:Bool = false;
    var mouseManager:FlxMouseEventManager;

    override function create():Void {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('ui/shop/misc/bg3'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.screenCenter();
        add(bg);

        /*
        espejo = new ShopItem(64, 36, 'esquizofrenia', 0.6);
        espejo.scale.set(0.65, 0.65);
        add(espejo);
        */

        /*
        for (item => item in shopItemsSection1) {
            var shopItem:ShopItem = new ShopItem(item.x, item.y, item.image, item.scale, item.fpsIdle, item.fpsSelected, item.fpsSold);
            grpShopItems.add(shopItem);

            mouseManager.add(shopItem, shopItem.onClick, shopItem.onOut, shopItem.onOver, shopItem.onOut);
        }
        */

        estante = new FlxSprite(-151, 10).loadGraphic(Paths.image('ui/shop/misc/estante'));
        estante.antialiasing = ClientPrefs.data.antialiasing;
        estante.scale.set(0.66, 0.66);
        add(estante);

        armario = new FlxSprite(555, 77).loadGraphic(Paths.image('ui/shop/misc/armario'));
        armario.antialiasing = ClientPrefs.data.antialiasing;
        armario.scale.set(0.66, 0.66);
        add(armario);

        repisa = new FlxSprite(634.5, 287.5).loadGraphic(Paths.image('ui/shop/misc/repisa'));
        repisa.antialiasing = ClientPrefs.data.antialiasing;
        repisa.scale.set(0.66, 0.66);
        add(repisa);

        cajas = new FlxSprite(607, 385).loadGraphic(Paths.image('ui/shop/misc/cajas'));
        cajas.antialiasing = ClientPrefs.data.antialiasing;
        cajas.scale.set(0.66, 0.66);
        add(cajas);

        grpShopItems = new FlxTypedGroup<ShopItem>();
		add(grpShopItems);
        
        mouseManager = new FlxMouseEventManager();
        add(mouseManager);

        // mouseManager.add(espejo, espejo.onClick, espejo.onOut, espejo.onOver, espejo.onOut);

        // for (item => item in shopItems) {
        //     var shopItem:ShopItem = new ShopItem(item.x, item.y, item.image, item.scale, item.fpsIdle, item.fpsSelected, item.fpsSold);
        //     grpShopItems.add(shopItem);

        //     mouseManager.add(shopItem, shopItem.onClick, shopItem.onOut, shopItem.onOver, shopItem.onOut);
        // }

        lampara = new FlxSprite(-320, -170).loadGraphic(Paths.image('ui/shop/misc/bombilla1'));
        lampara.antialiasing = ClientPrefs.data.antialiasing;
        lampara.scale.set(0.7, 0.7);
        add(lampara);

        mostrador = new FlxSprite().loadGraphic(Paths.image('ui/shop/misc/mostrador'));
        mostrador.antialiasing = ClientPrefs.data.antialiasing;
        mostrador.scale.set(0.68, 0.68);
        mostrador.screenCenter();
        add(mostrador);

        capiHucha = new FlxSprite(-290, -165);
        capiHucha.frames = Paths.getSparrowAtlas('ui/shop/misc/capihucha');
        capiHucha.antialiasing = ClientPrefs.data.antialiasing;
        capiHucha.animation.addByPrefix('empty', 'empty', 24, false);
        capiHucha.animation.addByPrefix('mid', 'mid', 24, false);
        capiHucha.animation.addByPrefix('full', 'full', 24, false);
        capiHucha.animation.play('empty');
        capiHucha.scale.set(0.65, 0.65);
        add(capiHucha);

        cortina = new FlxSprite(-320, -190).loadGraphic(Paths.image('ui/shop/misc/cortina'));
        cortina.antialiasing = ClientPrefs.data.antialiasing;
        cortina.scale.set(0.68, 0.68);
        cortina.screenCenter();
        add(cortina);

        title = new FlxSprite(0, -25).loadGraphic(Paths.image('ui/shop/hud/title'));
        title.antialiasing = ClientPrefs.data.antialiasing;
        title.scrollFactor.set(0, 0);
        title.scale.set(0.75, 0.75);
        title.screenCenter(X);
        add(title);

        Cursor.show();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (canLeave) {
            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new ShopState());
            }
        }
    }
}

class ShopItem extends FlxSprite {
    var isSelected:Bool = true;
    var alreadyBuyed:Bool = true;

    public function new(x:Float, y:Float, image:String, ?scale:Float = 1, ?fpsIdle:Int = 2, ?fpsSelected:Int = 2, ?fpsSold:Int = 2) {
        super(x, y);

        frames = Paths.getSparrowAtlas('ui/shop/items/$image');
        this.animation.addByPrefix('idle', 'idle0', fpsIdle, true);
        this.animation.addByPrefix('press', 'press0', fpsIdle, true);
        this.animation.addByPrefix('sold', 'sold0', fpsIdle, true);
        if (scale > 1 || scale < 1) {
            this.scale.set(scale, scale);
            this.updateHitbox();
        }
        this.animation.play('idle', true);
    }

    public function onOver(target:ShopItem) {
        if (target == this) {
           if (this.animation.name != 'press') this.animation.play('press', true);
        }
    }

    public function onClick(target:ShopItem) {
        if (target == this) {
            if (this.animation.name != 'idle') this.animation.play('idle', true);
        }
    }

    public function onOut(target:ShopItem) {
        if (target == this) {
            if (this.animation.name != 'idle') this.animation.play('idle', true);
        }
    }
}