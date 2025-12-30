package backend.downloads;

import farfadox.utils.net.downloads.GoogleDriveDownloader;
import farfadox.utils.net.downloads.MediafireDownloader;

typedef Configs = 
{
    extension:String,
    autoUnzip:Bool,
    customOutputPath:String,
    unZipCustomPath:String,
    onSuccess:Void->Void,
    onCancel:Void->Void,
    onZipSuccess:Void->Void
}

class DownloadManager
{
    public static var isGDrive:Bool;
    public static var _configs:Configs;
    public function new(url:String, fileName:String, configs:Configs)
    {
        if(StringTools.contains(url, 'drive.google.com'))
        {
            // gdrive
            trace('GoogleDrive downloader');
            GoogleDriveDownloader.extension = configs.extension;
            GoogleDriveDownloader.autoUnzip = configs.autoUnzip;
            GoogleDriveDownloader.customOutputPath = configs.customOutputPath;
            GoogleDriveDownloader.unZipCustomPath = configs.unZipCustomPath;
            GoogleDriveDownloader.onSuccess = configs.onSuccess;
            GoogleDriveDownloader.onCancel = configs.onCancel;
            GoogleDriveDownloader.onZipSuccess = configs.onZipSuccess;
            _configs = configs;
            new GoogleDriveDownloader(url, fileName);

            isGDrive = true;
        }
        else
        {
            // mediafire
            trace('Mediafire downloader');
            MediafireDownloader.autoUnzip = configs.autoUnzip;
            MediafireDownloader.customOutputPath = configs.customOutputPath;
            MediafireDownloader.unZipCustomPath = configs.unZipCustomPath;
            MediafireDownloader.onSuccess = configs.onSuccess;
            MediafireDownloader.onCancel = configs.onCancel;
            MediafireDownloader.onZipSuccess = configs.onZipSuccess;
            _configs = configs;
            new MediafireDownloader(url, fileName);

            isGDrive = false;
        }
    }
}