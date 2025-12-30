package states.freeplay;

import openfl.utils.Assets;
import states.freeplay.FreeplaySections;
import objects.freeplay.FreeplayCapsule;
import haxe.Json;

class FreeplayUtil {
	public var freeplayMeta:FreeplayMetadata;

    public static function getSongDifficulties(song:String):Array<String> {
		var songDifficulties:Array<String> = [];
		var chartFiles:Array<String> = [];
		var fileSongName = Paths.formatToSongPath(song);
		var songDataPath:String = '';

		if (FreeplaySections.sectionSelected.contains('dlc'))
			songDataPath = Paths.modFolders('data/$fileSongName');
		else 
			songDataPath = Paths.getSharedPath('data/${FreeplaySections.sectionSelected}/$fileSongName');

		if(songDifficulties.length == 0){
			var assetsPath = 'assets/shared/data/${FreeplaySections.sectionSelected}/$fileSongName';
			chartFiles = Assets.list()
			.filter(s -> s.indexOf(assetsPath) == 0 && s.endsWith(".json"));
			chartFiles = chartFiles.map(s -> s.substr(s.lastIndexOf('/') + 1));

			if (chartFiles.length == 0 && FileSystem.exists(songDataPath)) {
				chartFiles = FileSystem.readDirectory(songDataPath)
				.filter(s -> s.toLowerCase().startsWith(fileSongName) && s.endsWith(".json"));
			}

			var diffNames = chartFiles.map(s -> s.substring(fileSongName.length+1,s.length-5));
			if (diffNames.contains("hard") && diffNames.remove("hard")) diffNames.insert(0,"hard");
			songDifficulties = diffNames;
		}

		return songDifficulties;
	}

	public static function getMeta(songId:String):FreeplayMetadata {
		var metaFilePath:String;
		var formattedSongId = Paths.formatToSongPath(songId);

		if (FreeplaySections.sectionSelected.contains('dlc')) 
			metaFilePath = Paths.modFolders('data/${formattedSongId}/metadata.json');
		else
			metaFilePath = Paths.getSharedPath('data/${FreeplaySections.sectionSelected}/${formattedSongId}/metadata.json');

		var metaFileContent:String = null;

		if (FileSystem.exists(metaFilePath)) {
			try {
				metaFileContent = sys.io.File.getContent(metaFilePath);
			} catch (e:Dynamic) {
				trace('Error leyendo metadata.json desde FS para la canción ${songId}: $e');
			}
		} else {
			var assetsPath = 'assets/shared/data/${FreeplaySections.sectionSelected}/${formattedSongId}/metadata.json';
			if (Assets.exists(assetsPath)) {
				try {
					metaFileContent = Assets.getText(assetsPath);
				} catch (e:Dynamic) {
					trace('Error leyendo metadata.json desde assets para la canción ${songId}: $e');
				}
			}
		}

		if (metaFileContent != null) {
			try {
				var metaData:Dynamic = Json.parse(metaFileContent);
				return new FreeplayMetadata(
					metaData.freeplayPrevStart,
					metaData.freeplayPrevEnd,
					metaData.startingBPM,
					metaData.songCredits,
					metaData.songContext
				);
			} catch (e:Dynamic) {
				trace('Error parseando metadata.json para la canción ${songId}: $e');
			}
		}

		return new FreeplayMetadata(0, 20, 100);
	}

    public static function toggleFavorite(capsule:FreeplayCapsule):Bool {
		var songName:String = capsule.songText.text;
		var songLowercase:String = songName.toLowerCase();

		if (ClientPrefs.isSongFavorited(songLowercase)) {
			ClientPrefs.unfavoriteSong(songLowercase);
			return false;
		} else {
			ClientPrefs.favoriteSong(songLowercase);
			return true;
		}
	}
}

class FreeplayMetadata {
    public var freeplayPrevStart:Float = 0; // those are in seconds btw
	public var freeplayPrevEnd:Float = 15.0;// and this too
	public var startingBPM:Float = 100; // starting bpm
	public var songCredits:String = ""; // Text display on Pause Menu
	public var songContext:String = ""; // Text display on Pause Menu

    public function new(previewStart:Float, previewEnd:Float, initialBPM:Float = 0, creditsText:String = "", contextText:String = "") {
		this.freeplayPrevStart = previewStart;
		this.freeplayPrevEnd = previewEnd;
		this.startingBPM = initialBPM;
		this.songCredits = creditsText;
		this.songContext = contextText;
	}
}