package;

import flixel.*;

class NiceSprite extends FlxSprite {

  public var damageable: Bool = false;
  public var damage: Float = 0;
  public var destroyOnCollide: Bool = false;
  public var groups: Array<String> = [];
  public var team: String = null;
  public var possessed: Bool = false;

  private var pointSet = false;

  public function hasGroup(name: String): Bool {
    return groups.indexOf(name) != -1;
  }

  public function opposes(other: NiceSprite): Bool {
    if (team == null || other.team == null)
      return false;
    if (other.possessed)
      return false;
    return possessed || team != other.team;
  }

  public function getPoint(): Vec2 {
    return new Vec2(x+origin.x-offset.x, y+origin.x-offset.y);
  }

  public function setPoint(point: Vec2) {
    this.x = point.x-origin.x+offset.x;
    this.y = point.y-origin.x+offset.y;
    if (!pointSet) {
      // Stupid collision system collides us with everything between 0,0
      // and here if last is not set.
      last = getPoint().toFlxPoint();
      pointSet = true;
    }
  }

  public function addToPoint(vec: Vec2) {
    this.x += vec.x;
    this.y += vec.y;
  }

}
