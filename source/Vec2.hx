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

  public function multiply(m: Float): Vec2 {
    return new Vec2(x * m, y * m);
  }

  public function pieceMultiply(v: Vec2): Vec2 {
    return new Vec2(x * v.x, y * v.y);
  }

  public function pieceInvert(): Vec2 {
    return new Vec2(1/x, 1/y);
  }

  public function magnitude(): Float {
    return Math.sqrt(x*x + y*y);
  }

  public function unit(): Vec2 {
    var mag = magnitude();
    return new Vec2(x/mag, y/mag);
  }

  public function floor(): Vec2 {
    return new Vec2(Math.floor(x), Math.floor(y));
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

  public function lerp(target: Vec2, weight: Float): Vec2 {
    return new Vec2(Util.lerp(x, target.x, weight), Util.lerp(y, target.y, weight));
  }

  public function equals(v: Vec2, ?epsilon: Float=0): Bool {
    if (v == null)
      return false;
    return Math.abs(x - v.x) <= epsilon && Math.abs(y - v.y) <= epsilon;
  }
}
