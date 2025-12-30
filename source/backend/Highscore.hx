package backend;

import backend.Scoring.ScoringRank;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var weekRating:Map<String, Float> = new Map<String, Float>();
	public static var weekCompletition:Map<String, Int> = new Map<String, Int>();

	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songCompletition:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setRating(daSong, 0);
		setCompletition(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
		setWeekRating(daWeek, 0);
		setCompletition(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, ?completition:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
			{
				setScore(daSong, score);
				setCompletition(daSong, completition);
				if (rating >= 0)
					setRating(daSong, rating);
			}
		}
		else
		{
			setScore(daSong, score);
			setCompletition(daSong, completition);
			if (rating >= 0)
				setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, ?completition:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score){
				setWeekScore(daWeek, score);
				setWeekRating(daWeek,rating);
				setCompletitionRating(daWeek, completition);
			}
		}
		else{
			setWeekScore(daWeek, score);
			setWeekRating(daWeek,rating);
			setCompletitionRating(daWeek, completition);
		}
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setWeekRating(week:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekRating.set(week, rating);
		FlxG.save.data.weekRating = weekRating;
		FlxG.save.flush();
	}

	static function setCompletitionRating(week:String, completitionPercent:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekCompletition.set(week, completitionPercent);
		FlxG.save.data.weekCompletition = weekCompletition;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	static function setCompletition(song:String, completitionPercent:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songCompletition.set(song, completitionPercent);
		FlxG.save.data.songCompletition = songCompletition;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getCompletition(song:String, diff:Int):Float
		{
			var daSong:String = formatSong(song, diff);
			if (!songCompletition.exists(daSong))
				setCompletition(daSong, 0);
	
			return songCompletition.get(daSong);
		}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function getWeekAccuracy(week:String, diff:Int):Float
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekRating.exists(daWeek))
			setWeekRating(daWeek, 0);

		return weekRating.get(daWeek);
	}

	public static function isSongBeated(song:String, diff:Int):Bool
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong) <= 0;
	}

	public static function getSongRank(song:String, diff:Int):ScoringRank
	{
		var score:Int = getScore(song, diff);
		var accuracy:Float = getRating(song, diff);

		return Scoring.calculateRankFromData(score, accuracy);
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.weekRating != null)
		{
			weekRating = FlxG.save.data.weekRating;
		}
		if (FlxG.save.data.weekCompletition != null)
		{
			weekCompletition = FlxG.save.data.weekCompletition;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songCompletition != null)
		{
			songCompletition = FlxG.save.data.songCompletition;
		}
	}
}