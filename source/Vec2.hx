package;

import flixel.util.*;
import Util;

class Vec2 {
  // Like a less nasty, immutable FlxPoint

  public var x(default, null): Float;
  public var y(default, null): Float;

  public function new(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function add(v: Vec2): Vec2 {
    return new Vec2(x + v.x, y + v.y);
  }

  public function subtract(v: Vec2): Vec2 {
    return new Vec2(x - v.x, y - v.y);
  }

  public function magnitude(): Float {
    return Math.sqrt(x*x + y*y);
  }

  public function unit(): Vec2 {
    var mag = magnitude();
    return new Vec2(x/mag, y/mag);
  }

  public function toFlxPoint(): FlxPoint {
    return new FlxPoint(x, y);
  }

  public static function fromFlxPoint(pt: FlxPoint): Vec2 {
    return new Vec2(pt.x, pt.y);
  }

  public function nearestDirection(): Direction {
    if (Math.abs(x) > Math.abs(y)) {
      if (x < 0)
        return West;
      return East;
    } else {
      if (y < 0)
        return North;
      return South;
    }
  }
}