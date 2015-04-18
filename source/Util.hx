package;

import flixel.util.*;

enum Direction {
  North;
  East;
  South;
  West;
}

class Util {
  public static var vecNorth: FlxPoint = new FlxPoint(0,-1);
  public static var vecEast: FlxPoint = new FlxPoint(1,0);
  public static var vecSouth: FlxPoint = new FlxPoint(0,1);
  public static var vecWest: FlxPoint = new FlxPoint(-1,0);

  public static function toVec(dir: Direction): FlxPoint {
    switch (dir) {
      case North: return vecNorth;
      case East: return vecEast;
      case South: return vecSouth;
      case West: return vecWest;
    }
  }

  public static function toString(dir: Direction): String {
    switch (dir) {
      case North: return "North";
      case East: return "East";
      case South: return "South";
      case West: return "West";
    }
  }

}
