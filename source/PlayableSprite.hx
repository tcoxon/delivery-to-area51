package;

import flixel.*;
import flixel.util.*;
import Util;

class PlayableSprite extends FlxSprite {

  private var aim: Vec2 = new Vec2(0,0);
  private var direction: Direction = South;
  private var moving: Bool = false;

  public var speed: Float;

  public function new(?sprite: Dynamic=null, ?width: Int=0, ?height: Int=0) {
    super();
    speed = 2;
    if (sprite != null)
      setSprite(sprite, width, height);
  }

  public function setSprite(sprite: Dynamic, width: Int, height: Int) {
    loadGraphic(sprite, true, width, height);
    animation.add("north", [0, 1, 2, 3], 8, true);
    animation.add("east", [4, 5, 6, 7], 8, true);
    animation.add("south", [8, 9, 10, 11], 8, true);
    animation.add("west", [12, 13, 14, 15], 8, true);
    animation.add("northStopped", [0], 8, true);
    animation.add("eastStopped", [4], 8, true);
    animation.add("southStopped", [8], 8, true);
    animation.add("westStopped", [12], 8, true);
  }

  public function getPoint(): Vec2 {
    return new Vec2(x, y);
  }

  public function setPoint(point: Vec2) {
    this.x = point.x;
    this.y = point.y;
  }

  public function addToPoint(vec: Vec2) {
    this.x += vec.x;
    this.y += vec.y;
  }

  public function controlMove(dir: Direction) {
    addToPoint(Util.dirToVec(dir).multiply(speed));
    moving = true;
  }

  public function setDirection(dir: Direction) {
    this.direction = dir;
  }

  public function controlAim(at: Vec2) {
    this.aim = at;
    setDirection(at.subtract(getPoint()).nearestDirection());
  }

  override public function draw() {
    if (moving) {
      animation.play(Util.dirToString(direction).toLowerCase());
    } else {
      animation.play(Util.dirToString(direction).toLowerCase() + "Stopped");
    }
    super.draw();
  }

  override public function update() {
    super.update();
    moving = false;
  }

}
