package;

import flixel.*;
import flixel.system.*;

class Sounds {

  public static var soundExample: FlxSound;

  public static function init() {
    //soundExample = FlxG.sound.load("assets/sounds/example.wav");
  }

  private static var currentTrack = null;
  private static inline var MUSIC_EXT =
#if flash
    ".wav"
#elseif neko
    ".ogg"
#elseif linux
    ".ogg"
#else
    null
#end
    ;
  public static function playTrack(track: String) {
    if (MUSIC_EXT == null) return;
    if (track != currentTrack) {
      FlxG.sound.playMusic("assets/music/"+track+MUSIC_EXT);
      currentTrack = track;
    }
  }

  public static function playMainTrack() {
    //playTrack("TrackNameExample");
  }

}
