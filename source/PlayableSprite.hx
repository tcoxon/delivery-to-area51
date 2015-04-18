package;

import flixel.*;
import flixel.util.*;
import flixel.animation.*;
import Util;

class PlayableSprite extends NiceSprite {

  private var aim: Vec2 = new Vec2(0,0);
  private var direction: Direction = South;
  private var moving: Bool = false;
  private var config: Dynamic;

  public var speed: Float;

  public function new(?sprite: String=null) {
    super();
    speed = 2;
    if (sprite != null)
      setSprite(sprite);
  }

  public function setSprite(sprite: Dynamic) {
    config = Util.loadJson("assets/sprites/"+sprite+".json");
    var width = Std.int(config.width);
    var height = Std.int(config.height);

    loadGraphic("assets/sprites/"+sprite+".png", true, width, height);

    animation = new FlxAnimationController(this);
    var animations = Util.jsonMap(config.animations);
    for (key in animations.keys()) {
      animation.add(key, animations.get(key), Globals.AnimationFrameRate, true);
    }
    centerOrigin();

    if (Util.hasField(config, "hitbox")) {
      var hitbox = config.hitbox;
      offset.set(hitbox.offset[0], hitbox.offset[1]);
      this.width = hitbox.size[0];
      this.height = hitbox.size[1];
    }
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
