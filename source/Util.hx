package;

import haxe.Json;
import openfl.Assets;
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

  public static function loadJson(path: String): Dynamic {
    return Json.parse(Assets.getText(path));
  }

  public static function jsonMap(json: Dynamic): Map<String, Dynamic> {
    var result: Map<String, Dynamic> = new Map<String,Dynamic>();
    for (field in Reflect.fields(json)) {
      result.set(field, Reflect.field(json, field));
    }
    return result;
  }

  public static function lerp(origin: Float, target: Float, weight: Float): Float {
    return origin + (target - origin) * weight;
  }
}
