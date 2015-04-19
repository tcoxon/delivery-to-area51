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
  private var name: String;

  public var speed: Float;
  public var groups: Array<String>;
  public var controlled: Bool;
  public var weapon: Weapon;

  private var map: Tilemap;
  private var elapsed: Float = 0;

  public function new(?sprite: String=null) {
    super();
    if (sprite != null)
      setSprite(sprite);
  }

  public function setSprite(sprite: String) {
    name = sprite;
    config = Util.loadJson("assets/sprites/"+sprite+".json");
    speed = config.speed;
    groups = config.groups;
    var width = Std.int(config.width);
    var height = Std.int(config.height);

    if (Util.hasField(config, "damage"))
      damage = config.damage;

    if (Util.hasField(config, "health")) {
      damageable = true;
      health = config.health;
    }

    if (Util.hasField(config, "team")) {
      team = config.team;
    }

    loadGraphic("assets/sprites/"+sprite+".png", true, width, height);

    animation = new FlxAnimationController(this);
    var animations = Util.jsonMap(config.animations);
    var animConfig = if (Util.hasField(config, "animationConfig")) Util.jsonMap(config.animationConfig) else null;
    for (key in animations.keys()) {
      var framerate = Globals.AnimationFrameRate;
      var loop = true;
      if (animConfig != null && animConfig.exists(key)) {
        framerate = animConfig.get(key).framerate;
        loop = animConfig.get(key).loop;
      }
      animation.add(key, animations.get(key), framerate, loop);
    }
    centerOrigin();

    if (Util.hasField(config, "hitbox")) {
      var hitbox = config.hitbox;
      offset.set(hitbox.offset[0], hitbox.offset[1]);
      this.width = hitbox.size[0];
      this.height = hitbox.size[1];
    }

    if (Util.hasField(config, "weapon")) {
      this.weapon = new Weapon(config.weapon);
    }

    destroyOnCollide = false;
    if (Util.hasField(config, "destroyOnCollide"))
      destroyOnCollide = config.destroyOnCollide;
  }

  public function controlMove(dir: Direction) {
    controlMoveVec(Util.dirToVec(dir));
  }

  public function controlMoveVec(vec: Vec2) {
    setDirection(vec.nearestDirection());
    addToPoint(vec.unit().multiply(speed));
    moving = true;
  }

  public function setDirection(dir: Direction) {
    this.direction = dir;
  }

  public function getDirection(): Direction {
    return direction;
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

  public function getAim(): Vec2 {
    return aim;
  }

  public function controlFire() {
    if (weapon != null)
      weapon.fire(this, map);
  }

  override public function draw() {
    var anim: String = if (moving) {
      Util.dirToString(direction).toLowerCase();
    } else {
      Util.dirToString(direction).toLowerCase() + "Stopped";
    }
    if (animation.get(anim) == null)
      anim = "default";
    animation.play(anim);
    super.draw();
  }

  public function setMap(map: Tilemap) {
    this.map = map;
  }

  override public function update() {
    super.update();
    elapsed += FlxG.elapsed;
    moving = false;
    immovable = false;

    if (Util.hasField(config, "lifeSpan") && elapsed > config.lifeSpan)
      kill();

    if (controlled || map == null)
      return;

    // AI here
    if (Util.hasField(config, "follows")) {
      updateFollowState(config.follows);

    } else if (Util.hasField(config, "projectile")) {
      updateProjectile();
    }
  }

  private function updateProjectile() {
    if (config.projectile == "straight") {
      controlMove(direction);
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

  override public function toString() {
    return "PlayableSprite:"+Std.string(name)+super.toString();
  }
}
