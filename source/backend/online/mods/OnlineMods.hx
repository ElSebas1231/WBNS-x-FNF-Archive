package backend.online.mods;

import haxe.CallStack;
import unrar.UnRAR;
import haxe.io.Path;
import backend.online.mods.GameBanana.GBMod;
import haxe.zip.Reader;
import haxe.zip.Entry;
import sys.io.File;
import sys.FileSystem;
import backend.online.http.URLScraper;

class OnlineMods {
	public static function downloadMod(url:String, ?onSuccess:String->Void) {
		if (url == null || url.trim() == "")
			return;

		if (StringTools.startsWith(url, "https://drive.google.com/file/d/")) {
			URLScraper.downloadFromGDrive(url, onSuccess);
			return;
		}

		if (StringTools.startsWith(url, "https://drive.google.com/drive/folders/")) {
			Alert.alert("Mod download failed!", "Can't download GDrive folders!");
			return;
		}

		if (StringTools.startsWith(url, "https://www.mediafire.com/file/")) {
			URLScraper.downloadFromMediaFire(url, onSuccess);
			return;
		}
	}

	public static function startDownloadMod(fileName:String, modURL:String, ?gbMod:GBMod, ?onSuccess:String->Void, ?headers:Map<String, String>, ?ogURL:String) {
		return new ModDownloader(fileName, modURL, gbMod, onSuccess, headers, ogURL);
	}

	//gbMod only works if the url is a mod page url not the direct download one
	public static function installMod(fileName:String, ?modURL:String, ?gbMod:GBMod, ?onSuccess:String->Void) {
		fileName = Path.normalize(fileName); // I HATE WINDOWS PATH FORMAT AAAAAAAAAAAAAA (C:/ is cool though, JUST INVERT THESE SLASHES PLEASE)
		var _fileNameSplit = fileName.split("/");
		var swagFileName = _fileNameSplit[_fileNameSplit.length - 1].split(".")[0];
		var beginFolder = null; // the folder inside the archive to extract
		var parentFolder = 'dlcs/'; // the destination mod path
		var modName:String = null;
		var ignoreRest = false;
		var isExecutable = false;
		var isRar = unrar.RARUtil.isRAR(fileName);
		var zipFiles:List<Entry> = null;

		function iterFunc(fileName:String) {
			if (fileName.endsWith(".exe"))
				isExecutable = true;

			if (!ignoreRest) {
				var pathSplit = fileName.split("/");

				var forFiles = [];
				for (file in pathSplit) {
					if (file == "shared" || file == "mods")
						return;

					if (file == "assets" || Mods.ignoreModFolders.contains(file)) {
						modName = forFiles[forFiles.length - 1] ?? null;
						if (modName == null || modName.trim() == "" || modName == "bin" || modName == "PsychEngine")
							modName = swagFileName;
						modName = FileUtils.formatFile(modName);

						parentFolder += modName + "/";
						beginFolder = forFiles.join("/") + "/";
						ignoreRest = true;
						trace(beginFolder + ' -> ' + parentFolder);
						return;
					}
					forFiles.push(file);
				}
			}
		}

		if (isRar) {
			var rarFailed = false;
			UnRAR.openArchive({
				openPath: fileName,
				mode: LIST,
				onError: (code, type) -> {
					Waiter.put(() -> {
						Alert.alert("Listing RAR failed!", '$code\n$type');
					});
					rarFailed = true;
				},
				onFile: (file, flags) -> {
					iterFunc(file);
					return file;
				}
			});

			if (rarFailed) {
				return;
			}
		}
		else {
			var file = File.read(fileName, true);
			try {
				zipFiles = Reader.readZip(file);
			}
			catch (exc) {
				trace(exc, CallStack.toString(exc.stack));
				file.close();
				Waiter.put(() -> {
					Alert.alert("Dlc data is corrupted or invalid!", exc + "\n" + CallStack.toString(exc.stack) + "\n\n" + fileName);
				});
				return;
			}
			file.close();

			var fileSize = 0.;
			var dataSize = 0.;
			for (entry in zipFiles) {
				fileSize += entry.fileSize;
				dataSize += entry.dataSize;

				iterFunc(entry.fileName);
			}
			if (Math.min(fileSize, dataSize) < 0 || Math.max(fileSize, dataSize) >= 3000000000) {
				Waiter.put(() -> {
					Alert.alert("Downloading Cancelled",
						'The dlc file is WAY too big!\n${FlxMath.roundDecimal(Math.max(fileSize, dataSize) / 1000000000, 4)}GB');
				});
				return;
			}
		}

		trace(modName, parentFolder);

		if (beginFolder == '/')
			beginFolder = '';

		if (beginFolder == null) {
			Waiter.put(() -> {
				Alert.alert("Mod data not found inside of the archive!");
			});
			return;
		}

		if (FileSystem.exists(Paths.dlcs(modName)) || FileSystem.exists(Paths.dlcsFolders(modName))) {
			try {
				FileUtils.removeFiles(parentFolder);
			}
			catch (exc) {
				Waiter.put(() -> {
					Alert.alert("Installation Error!", 'It seems this directory $modName\nis already being accessedby the game or another program!\n\nPlease try again by re-opening the game!');
				});
				return;
			}
		}

		if (isRar) {
			var rarFailed = false; 
			UnRAR.openArchive({
				openPath: fileName,
				mode: EXTRACT,
				onError: (code, type) -> {
					trace("RAR FAILED: " + code + " - " + type);
					Waiter.put(() -> {
						Alert.alert("Extracting RAR failed!", '$code\n$type');
					});
					rarFailed = true;
				},
				onFile: (file, flags) -> {
					if (!StringTools.startsWith(file, beginFolder) || flags.isDirectory) {
						return null;
					}

					var coolPath = Path.join([parentFolder, file.substring(beginFolder.length)]).split("/");
					for (i => file in coolPath) {
						// seems like unrar (c++ side) doesn't want to create files with invalid characters?
						coolPath[i] = FileUtils.formatFile(file, i == coolPath.length - 1);
					}
					return coolPath.join("/");
				}
			});

			if (rarFailed) {
				try {
					FileUtils.removeFiles(parentFolder);
				} catch (e:Dynamic) {
					trace('[Error] $e');
				}
				return;
			}
		} else {
			for (entry in zipFiles) {
				if (!StringTools.startsWith(entry.fileName, beginFolder) || entry.fileName.endsWith("/")) {
					continue;
				}

				if (!FileSystem.exists(Path.directory(Path.join([parentFolder, entry.fileName.substring(beginFolder.length)])))) {
					FileSystem.createDirectory(Path.join([parentFolder, Path.directory(entry.fileName).substring(beginFolder.length)]));
				}
				trace(FileSystem.exists(Path.directory(Path.join([parentFolder, entry.fileName.substring(beginFolder.length)]))));
				File.saveBytes(Path.join([parentFolder, entry.fileName.substring(beginFolder.length)]), Reader.unzip(entry));
			}
		}

		Waiter.put(() -> {
			Alert.alert("Mod Installation Successful!");
			if (onSuccess != null)
				onSuccess(modName);
		});
	}

	public static function formatSongName(song:String) {
		return song.trim().replace(" ", "-").toLowerCase();
	}
}