package;

import flixel.*;

class NiceSprite extends FlxSprite {

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
