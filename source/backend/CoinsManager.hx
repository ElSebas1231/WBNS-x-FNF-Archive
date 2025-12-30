package backend;

class CoinsManager
{
    public static function addCoins(value:Int)
    {
        FlxG.save.data.coins += value;
    }

    public static function removeCoins(value:Int)
    {
        FlxG.save.data.coins -= value;
    }

    public static function getCoins():Int
    {
        return FlxG.save.data.coins;
    }

    public static function saveCoins()
    {
        FlxG.save.flush();
    }
}