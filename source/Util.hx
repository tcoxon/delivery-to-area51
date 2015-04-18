package;

import flixel.util.*;

enum Direction {
  North;
  East;
  South;
  West;
}

class Util {
  public static var vecNorth: Vec2 = new Vec2(0,-1);
  public static var vecEast: Vec2 = new Vec2(1,0);
  public static var vecSouth: Vec2 = new Vec2(0,1);
  public static var vecWest: Vec2 = new Vec2(-1,0);

  public static function dirToVec(dir: Direction): Vec2 {
    switch (dir) {
      case North: return vecNorth;
      case East: return vecEast;
      case South: return vecSouth;
      case West: return vecWest;
    }
  }

  public static function dirToString(dir: Direction): String {
    switch (dir) {
      case North: return "North";
      case East: return "East";
      case South: return "South";
      case West: return "West";
    }
  }

  public static function boolify(val: String): Bool {
    return val == "true";
  }

}
