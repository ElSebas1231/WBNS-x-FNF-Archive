package states.freeplay;

import states.freeplay.FreeplaySections;
import objects.freeplay.FreeplayCapsule;
import haxe.Json;

class FreeplayUtil {
	public var freeplayMeta:FreeplayMetadata;

    public static function getSongDifficulties(song:String):Array<String> {
		var songDifficulties:Array<String> = [];
		var fileSongName = Paths.formatToSongPath(song);
		var songDataPath:String = '';

		if (FileSystem.exists(Paths.mods('${Mods.currentModDirectory}/data/${fileSongName}'))) {
			songDataPath = Paths.mods('${Mods.currentModDirectory}/data/${fileSongName}');
		} else {
			songDataPath = Paths.getSharedPath('data/${FreeplaySections.sectionSelected}/${fileSongName}');
		}

		if(songDifficulties.length == 0){
			if (FileSystem.exists(songDataPath)){
				var chartFiles = FileSystem.readDirectory(songDataPath)
				.filter(s -> s.toLowerCase().startsWith(fileSongName) && s.endsWith(".json"));

				var diffNames = chartFiles.map(s -> s.substring(fileSongName.length+1,s.length-5));
				// Regrouping difficulties
				if (diffNames.contains('soarinng') && diffNames.remove("soarinng")) diffNames.insert(0,"soarinng");

				if ((diffNames.contains(".") && !diffNames.contains('normal')) && diffNames.remove(".")) {
					diffNames.insert(1,"normal");
				} else if ((diffNames.contains("normal") && !diffNames.contains('.')) && diffNames.remove("normal")) {
					diffNames.insert(1,"normal");
				}

				if(diffNames.contains("hard") && diffNames.remove("hard")) diffNames.insert(2,"hard");
				songDifficulties = diffNames;
			}
		}

		return songDifficulties;
	}

	public static function getMeta(songId:String):FreeplayMetadata {
		var metaFilePath:String = Paths.getSharedPath('data/${FreeplaySections.sectionSelected}/${Paths.formatToSongPath(songId)}/metadata.json');
		
		if (FileSystem.exists(metaFilePath)) {
			try {
				var metaFileContent:String = sys.io.File.getContent(metaFilePath);
				var metaData:Dynamic = Json.parse(metaFileContent);
				return new FreeplayMetadata(
					metaData.freeplayPrevStart,
					metaData.freeplayPrevEnd,
					metaData.startingBPM
				);
			} catch (e:Dynamic) {
				trace('Error parsing metadata.json for song ${songId}: $e');
			}
		}
	
		// Return a default FreeplayMetadata object if the file doesn't exist or parsing fails
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

    public function new(previewStart:Float, previewEnd:Float, initialBPM:Float = 0) {
		this.freeplayPrevStart = previewStart;
		this.freeplayPrevEnd = previewEnd;
		this.startingBPM = initialBPM;
	}
}