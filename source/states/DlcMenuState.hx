package states;

import sys.FileSystem;
import sys.io.File;

import states.freeplay.FreeplaySections;
import flixel.ui.FlxButton;

import backend.online.mods.OnlineMods;

class DlcMenuState extends MusicBeatState
{
    var bg:FlxSprite;
    var button:FlxButton;
    var dlcsInstalled:Array<String> = [];
    var dlcsDataMap = new Map<String, Dynamic>();
    var programPath = openfl.filesystem.File.applicationDirectory.nativePath; // very useful ngl

    override function create() {
        super.create();

        Cursor.show();

        bg = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/bgMisc'));
        add(bg);

        initDlcs();

        trace(dlcsDataMap);
        trace(dlcsInstalled);

        for (i in 0...dlcsInstalled.length) {
            var dlcInfo = dlcsDataMap.get(dlcsInstalled[i]);

            if (FileSystem.exists('$programPath/dlcs/${dlcInfo.name}/dlcData.json')) {
                if (ClientPrefs.data.fpSectionsUnlocked.contains(dlcInfo.name)) ClientPrefs.data.fpSectionsUnlocked.remove(dlcInfo.name);
                ClientPrefs.data.fpSectionsUnlocked.push(dlcInfo.name);
                
                if (FreeplaySections.freeplaySections.contains(dlcInfo.name)) FreeplaySections.freeplaySections.remove(dlcInfo.name);
                FreeplaySections.freeplaySections.push(dlcInfo.name);

                FlxG.save.data.fpSectionsUnlocked = ClientPrefs.data.fpSectionsUnlocked;
                FlxG.save.flush();
            }

            var buttonDLC:FlxButton = new FlxButton(110, 50 * i+1, dlcInfo.name, function() {
                if (!FileSystem.exists('$programPath/dlcs/${dlcInfo.name}')){
                    OnlineMods.downloadMod(dlcInfo.link, function(_result:String) {
                        if (ClientPrefs.data.fpSectionsUnlocked.contains(dlcInfo.name)) ClientPrefs.data.fpSectionsUnlocked.remove(dlcInfo.name);
                        ClientPrefs.data.fpSectionsUnlocked.push(dlcInfo.name);
                        
                        if (FreeplaySections.freeplaySections.contains(dlcInfo.name)) FreeplaySections.freeplaySections.remove(dlcInfo.name);
                        FreeplaySections.freeplaySections.push(dlcInfo.name);

                        FlxG.save.data.fpSectionsUnlocked = ClientPrefs.data.fpSectionsUnlocked;
                        FlxG.save.flush();
                    });
                } else {
                    trace('Already installed ${dlcInfo.name}');
                }
            });
            add(buttonDLC);

            var buttonToggle:FlxButton;
            buttonToggle = new FlxButton(buttonDLC.x + 100, buttonDLC.y, dlcInfo.name, function() {
                updateDlcButton(dlcInfo.name, buttonToggle);
            });
            if (ClientPrefs.data.fpSectionsUnlocked.contains(dlcInfo.name)) {
                buttonToggle.label.text = 'ON';
                buttonToggle.color = FlxColor.GREEN;
            } else {
                buttonToggle.label.text = 'OFF';
                buttonToggle.color = FlxColor.RED;
            }
            add(buttonToggle);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    function updateDlcButton(name:String, btn:FlxButton) {
        var isActive = ClientPrefs.data.fpSectionsUnlocked.contains(name);

        if (isActive) {
            ClientPrefs.data.fpSectionsUnlocked.remove(name);
            FreeplaySections.freeplaySections.remove(name);
            
            btn.label.text = 'OFF';
            btn.color = FlxColor.RED;
        } else {
            if (!ClientPrefs.data.fpSectionsUnlocked.contains(name)) {
                ClientPrefs.data.fpSectionsUnlocked.push(name);

                if (!FreeplaySections.freeplaySections.contains(name)) FreeplaySections.freeplaySections.push(name);

                btn.label.text = 'ON';
                btn.color = FlxColor.GREEN;
            }
        }

        trace(ClientPrefs.data.fpSectionsUnlocked);

        FlxG.save.data.fpSectionsUnlocked = ClientPrefs.data.fpSectionsUnlocked;
        FlxG.save.flush();
    }

    function initDlcs(fetched:Bool = false) {
        if (!fetched) {
            var dlcsLength:Int = Std.parseInt(File.getContent('$programPath/dlc_data/total.txt'));

            for (i in 0...dlcsLength) {
                var path = '$programPath/dlc_data';  
                if (FileSystem.exists(path)) {
                    var jsonString = File.getContent('$path/dlc${i+1}.json');
                    var jsonData = tjson.TJSON.parse(jsonString);

                    dlcsInstalled.push(jsonData.name);
                    dlcsDataMap.set(jsonData.name, jsonData);
                }
            }
        } else {
            // Unprivate the repo to use this lmao
            var dlcsRequestLength:Http = new Http('https://raw.githubusercontent.com/ElSebas1231/WBNS-x-FNF-Develop/refs/heads/develop/dlc_data/total.txt');
            dlcsRequestLength.onData = function(data:String) {
                var dlcsLength:Int = Std.parseInt(data);

                for (i in 0...dlcsLength) {
                    var dlcRequest:Http = new Http('https://raw.githubusercontent.com/ElSebas1231/WBNS-x-FNF-Develop/refs/heads/develop/dlc_data/dlc${i+1}.json');
                    dlcRequest.onData = function(data:String) {
                        var jsonData = tjson.TJSON.parse(data);

                        dlcsInstalled.push(jsonData.name);
                        dlcsDataMap.set(jsonData.name, jsonData);
                    }

                    dlcRequest.onError = function(error:String) { trace('Error while fetching dlc ${i}: $error'); }
                    dlcRequest.request();
                }
            };

            dlcsRequestLength.onError = function(error:String) { trace('Error while fetching dlcs length: $error'); }
            dlcsRequestLength.request();
        }
    }
}