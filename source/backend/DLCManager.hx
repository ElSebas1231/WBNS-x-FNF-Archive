package backend;

import flixel.util.FlxSave;
import haxe.Http;

class DLCManager
{
	public static var dlcSaves:FlxSave = new FlxSave();
	public static var dlcInfoSave:FlxSave = new FlxSave();
    private static var mustUpdateDlcs:Bool = false;
    
    public static var dlcsInfo:Array<Dynamic> = 
    [
        'https://drive.google.com/file/d/1dNsQqAsr2oT6DfppA-8amXufWQQiHbJ3/view?usp=sharing'
    ];

    private static function fetchGithubData()
    {
        dlcInfoSave.bind('dlc_data', CoolUtil.getSavePath());
        if(dlcInfoSave.data.info == null) dlcInfoSave.data.info = dlcsInfo;

        trace('Current array: ${dlcInfoSave.data.info}');

        for(i in 0...dlcsInfo.length)
        {
            //while the repository is private, dlcs r fetched locally
            #if develop
                #if debug trace('getting versions locally'); #end
    
                var programPath = Sys.programPath();
                var lastIndex = programPath.lastIndexOf('\\');
                programPath = programPath.substr(0, lastIndex);
                programPath += '/dlcdata/dlc${i+1}_version.txt';
    
                var file = File.getContent(programPath);
                var arr = file.split(':::::');
                #if debug trace('ver: ${arr[0]}, href: ${arr[1]}'); #end
                if(dlcInfoSave.data.info[i].toString() != arr[1].toString())
                {
                    mustUpdateDlcs = true;
                    trace('dlcs must be updated!');
    
                    // TO DO: move this code to a function for when you ACCEPT the update
                    dlcInfoSave.data.info.splice(0, 1);
                    dlcInfoSave.data.info.insert(0, arr[1]);
                    #if debug trace('new link: ${dlcInfoSave.data.info}'); #end
                }
                else
                {
                    #if debug trace('dlcs are alredy updated!'); #end
                }
    
            #else
    
                #if debug trace('getting versions via github'); #end
                var http:Http = new Http('https://raw.githubusercontent.com/MrMadera/WBNS-x-FNF-Develop/refs/heads/dlcs-system/dlc_data/dlc${i+1}_version.txt');
                http.onData = function(data:String)
                {
                    var arr = data.split(':::::');
                    #if debug trace('ver: ${arr[0]}, href: ${arr[1]}'); #end
                    if(dlcInfoSave.data.info[0].toString() != arr[1].toString())
                    {
                        mustUpdateDlcs = true;
                        #if debug trace('dlcs must be updated!'); #end
        
                        // TO DO: move this code to a function for when you ACCEPT the update
                        dlcInfoSave.data.info.splice(0, 1);
                        dlcInfoSave.data.info.insert(0, arr[1]);
                        #if debug trace('new link: ${dlcInfoSave.data.info}'); #end
                    }
                    else
                    {
                        #if debug trace('dlcs are alredy updated!'); #end
                    }
                }
    
                http.onError = function(error:String)
                {
                    #if debug trace('Error while fetching: $error'); #end
                }
    
                http.request();
            #end
        }

        dlcInfoSave.flush();
    }

    public static function initDLCs()
    {
		dlcSaves.bind('dlcs', CoolUtil.getSavePath());

        #if develop
            restartDlcs();
        #end

		if(dlcSaves.data.dlcsActivated == null) dlcSaves.data.dlcsActivated = new Map<String, Bool>();

        for(i in 0...dlcsInfo.length) // initializing variables
        {
            trace('Initializing DLC ${i+1}');
            if(!dlcSaves.data.dlcsActivated.exists('dlc ${i+1}')) dlcSaves.data.dlcsActivated.set('dlc ${i+1}', false);
        }

        dlcSaves.flush();

        trace('DLC Map: ${dlcSaves.data.dlcsActivated}');

        // fetching before the amount of dlcs has been loaded
        fetchGithubData();
    }

    public static function enable_disable(dlcID:Int = 0)
    {
        // it's just set the oposite value of getting 'dlc $dlcID'
        dlcSaves.data.dlcsActivated.set('dlc $dlcID', !dlcSaves.data.dlcsActivated.get('dlc $dlcID'));
        dlcSaves.flush();

        trace('Updated Map?? ${dlcSaves.data.dlcsActivated}');
    }

    public static function isDlcEnabled(dlcID:Int = 0)
    {
        return dlcSaves.data.dlcsActivated.get('dlc $dlcID');
    }

    public static function restartDlcs()
    {
        dlcSaves.data.dlcsActivated = null;
    }
}