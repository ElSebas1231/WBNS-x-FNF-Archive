package states;

import backend.downloads.DownloadManager;

import flixel.ui.FlxBar;

/*
import farfadox.utils.ui.CustomButton;
import farfadox.utils.net.downloads.GoogleDriveDownloader;
import farfadox.utils.net.downloads.MediafireDownloader;
*/

class DlcMenuState extends MusicBeatState
{
    var bg:FlxSprite;
    /*
    var buttonDownloadGrp:FlxTypedGroup<CustomButton>;
    var buttonEnable_DisableGrp:FlxTypedGroup<CustomButton>;

    var blackLineBG:FlxSprite;
    var downloadTxt:FlxText;
    var downloadBytesTxt:FlxText;
    var downloadBar:FlxBar;
    var downloadPercent:Float;

    var isDownloading:Bool;
    */

    override function create()
    {
        super.create();

        Cursor.show();
        
		var text:FlxText = new FlxText(0, 0, FlxG.width - 300, 'Placeholder', 32);
		text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.borderSize = 2;
		text.screenCenter();
		add(text);

        /*
        var oldProgramPath = Sys.programPath();
        var index = oldProgramPath.lastIndexOf("\\");
        var programPath = oldProgramPath.substr(0, index);
        programPath += '/';
        trace('Unzipping path: $programPath');

        buttonDownloadGrp = new FlxTypedGroup<CustomButton>();
        add(buttonDownloadGrp);

        buttonEnable_DisableGrp = new FlxTypedGroup<CustomButton>();
        add(buttonEnable_DisableGrp);

        for(i in 0...DLCManager.dlcsInfo.length)
        {
            var btn = new CustomButton(10, 70 + (i * 80), 100, 33, 0xFF000000, 'DLC ${i+1}', 16, 0xFFFFFFFF, function()
            {
                new DownloadManager(
                    DLCManager.dlcsInfo[i], 
                    'assets',
                    {
                        extension: "zip",
                        autoUnzip: true,
                        customOutputPath: '',
                        unZipCustomPath: programPath,
                        onSuccess:
                            function()
                            {
                                trace('Download completed!');
                                isDownloading = false;
                            },
                        onCancel:
                            function()
                            {
                                trace('Download canceled!');
                                isDownloading = false;
    
                                new FlxTimer().start(1, function(t:FlxTimer)
                                {
                                    hideDownloadHUD();
                                });
                            },
                        onZipSuccess:
                            function()
                            {
                                trace('Unzipping process finished!');
                                
                                new FlxTimer().start(1, function(t:FlxTimer)
                                {
                                    hideDownloadHUD();
                                    DLCManager.dlcSaves.data.dlc1Activated = true;
                                    DLCManager.dlcSaves.flush();
                                });
                            }
                    }
                );
    
                isDownloading = true;
    
                showUpDownloadHUD();
            });
            btn.ID = i;
            buttonDownloadGrp.add(btn);

            var buttonEnable_Disable:CustomButton;
            buttonEnable_Disable = new CustomButton(btn.x + btn.width + 10, btn.y, 100, 33, 0xFF4B8B37, 'Enable/Disable', 16, 0xFFFFFFFF, function(){});
            buttonEnable_Disable.ID = i;
            buttonEnable_Disable.onPress = function()
            {
                DLCManager.enable_disable(buttonEnable_Disable.ID+1);
                reloadButtons(buttonEnable_Disable.ID);
            }
            buttonEnable_DisableGrp.add(buttonEnable_Disable);

            // reloading every button
            reloadButtons(buttonEnable_Disable.ID);
        }

        blackLineBG = new FlxSprite(0, 500).makeGraphic(925, 120, 0xFF000000);
        blackLineBG.screenCenter(X);
        blackLineBG.alpha = 0.55;
        blackLineBG.visible = false;
        add(blackLineBG);

        downloadTxt = new FlxText(blackLineBG.x, blackLineBG.y + 20, blackLineBG.width, 'Starting...', 30);
		downloadTxt.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        downloadTxt.visible = false;
        add(downloadTxt);

        downloadBytesTxt = new FlxText(blackLineBG.x, blackLineBG.y + 60, blackLineBG.width, '', 30);
		downloadBytesTxt.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        downloadBytesTxt.visible = false;
        add(downloadBytesTxt);

        downloadBar = new FlxBar(0, downloadBytesTxt.y + downloadBytesTxt.height + 10, LEFT_TO_RIGHT, 525, 10, this, 'downloadPercent', 0, 1);
        downloadBar.screenCenter(X);
        downloadBar.visible = false;
        add(downloadBar);
        */
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        /*
        downloadTxt.text = DownloadManager.isGDrive ? GoogleDriveDownloader.downloadStatus : MediafireDownloader.downloadStatus;

        if(DownloadManager.isGDrive)
        {
            if(GoogleDriveDownloader.downloadStatus == 'Downloading...')
            {
                downloadBar.visible = true;
                downloadBytesTxt.visible = true;
                downloadBytesTxt.text = '${GoogleDriveDownloader.loadedBytes(GoogleDriveDownloader.bytesDownloaded)}/${GoogleDriveDownloader.loadedBytes(GoogleDriveDownloader.totalBytes)}';
                downloadPercent = GoogleDriveDownloader.bytesDownloaded / GoogleDriveDownloader.totalBytes;
            }
            else
            {
                downloadBar.visible = false;
                downloadBytesTxt.visible = false;
            }
        }
        else
        {
            if(MediafireDownloader.downloadStatus == 'Downloading...')
            {
                downloadBar.visible = true;
                downloadBytesTxt.visible = true;
                downloadBytesTxt.text = '${MediafireDownloader.loadedBytes(MediafireDownloader.bytesDownloaded)}/${MediafireDownloader.loadedBytes(MediafireDownloader.totalBytes)}';
                downloadPercent = MediafireDownloader.bytesDownloaded / MediafireDownloader.totalBytes;
            }
            else
            {
                downloadBar.visible = false;
                downloadBytesTxt.visible = false;
            }
        }
        */
    }

    /*
    public function reloadButtons(btnObj:Int)
    {
        for(btn in buttonEnable_DisableGrp)
        {
            if(btn.ID == btnObj)
            {
                if(DLCManager.isDlcEnabled(btn.ID+1))
                {
                    btn.txt.text = 'Enabled';
                    btn.bgColor = 0xFF4B8B37;
                    btn.txt.y = btn.y + (btn.bg.height / 2) - (btn.txt.height / 2); // center
                }
                else
                {
                    btn.txt.text = 'Disabled';
                    btn.bgColor = 0xFF8B3D37;
                    btn.txt.y = btn.y + (btn.bg.height / 2) - (btn.txt.height / 2); // center
                }
            }
        }
    }

    public function showUpDownloadHUD()
    {
        blackLineBG.visible = true;
        downloadTxt.visible = true;
    }

    public function hideDownloadHUD()
    {
        blackLineBG.visible = false;
        downloadTxt.visible = false;
    }
    */
}