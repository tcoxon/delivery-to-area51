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
  public var groups: Array<String>;
  public var controlled: Bool;

  private var map: Tilemap;

  public function new(?sprite: String=null) {
    super();
    if (sprite != null)
      setSprite(sprite);
  }

  public function setSprite(sprite: String) {
    config = Util.loadJson("assets/sprites/"+sprite+".json");
    speed = config.speed;
    groups = config.groups;
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
    setDirection(dir);
    addToPoint(Util.dirToVec(dir).multiply(speed));
    moving = true;
  }

  public function setDirection(dir: Direction) {
    this.direction = dir;
  }

  public function controlAim(at: Vec2) {
    if (!at.equals(this.aim)) {
      this.aim = at;
      lookAtAim();
    }
  }

  public function lookAtAim() {
    setDirection(aim.subtract(getPoint()).nearestDirection());
  }

  override public function draw() {
    if (moving) {
      animation.play(Util.dirToString(direction).toLowerCase());
    } else {
      animation.play(Util.dirToString(direction).toLowerCase() + "Stopped");
    }
    super.draw();
  }

  public function setMap(map: Tilemap) {
    this.map = map;
  }

  override public function update() {
    super.update();
    moving = false;
    immovable = false;

    if (controlled || map == null)
      return;

    // AI here
    if (Util.hasField(config, "follows")) {
      updateFollowState(config.follows);
    }
  }

  private function updateFollowState(follows: String) {
    var followGroup = map.multigroup.getGroup(config.follows);
    var target: NiceSprite = cast followGroup.getFirstAlive();
    if (target == null)
      return;
    var displ = target.getPoint().subtract(getPoint());
    if (displ.magnitude() <= config.followDistance)
      return;
    var dir = displ.unit();
    setPoint(target.getPoint().subtract(dir.multiply(config.followDistance)));
    controlAim(target.getPoint());
    moving = true;
    immovable = true;
  }
}
