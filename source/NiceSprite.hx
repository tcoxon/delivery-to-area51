package;

import flixel.*;

class NiceSprite extends FlxSprite {

  public var damageable: Bool = false;
  public var damage: Float = 0;
  public var team: String = null;
  public var destroyOnCollide: Bool = false;

  public function opposes(other: NiceSprite): Bool {
    return team != null && other.team != null && team != other.team;
  }

  public function getPoint(): Vec2 {
    return new Vec2(x+origin.x-offset.x, y+origin.x-offset.y);
  }

  public function setPoint(point: Vec2) {
    this.x = point.x-origin.x+offset.x;
    this.y = point.y-origin.x+offset.y;
  }

  public function addToPoint(vec: Vec2) {
    this.x += vec.x;
    this.y += vec.y;
  }

}
