package backend.build;

import haxe.Http;

class Blocker
{
    public static var isBlocked:Bool = false;

    public static function fetchInfo() {
        var http = new Http('https://raw.githubusercontent.com/ElSebas1231/mod-stuff/refs/heads/main/wbns-x-fnf.txt');
        http.onData = function(d:String) {
            if(StringTools.contains(d, 'true')) isBlocked = true;
            if(StringTools.contains(d, 'false')) isBlocked = false;
        }
        //trace('Fetched! | Block = $isBlocked');
        http.request();
    }
}