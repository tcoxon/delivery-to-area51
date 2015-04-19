package;

import flixel.*;
import flixel.util.*;
import flixel.animation.*;
import Util;

class PlayableSprite extends NiceSprite {

  private var aim: Vec2 = null;
  private var direction: Direction = South;
  private var moving: Bool = false;
  private var name: String;

  public var prettyName: String;
  public var config: Dynamic;
  public var speed: Float;
  public var controlled: Bool;
  public var weapon: Weapon;
  public var state: String;
  public var stateData: Dynamic;

  private var map: Tilemap;
  private var elapsed: Float = 0;
  private var childSprites: Array<PlayableSprite> = [];

  public function new(?sprite: String=null, ?parameters: Dynamic=null) {
    super();
    if (sprite != null)
      setSprite(sprite, parameters);
  }

  public function setSprite(sprite: String, ?parameters: Dynamic=null) {
    name = sprite;
    config = Util.loadJson("assets/sprites/"+sprite+".json");
    Util.merge(config, parameters);
    prettyName = config.prettyName;
    groups = config.groups;
    var width = Std.int(config.width);
    var height = Std.int(config.height);

    if (Util.hasField(config, "speed"))
      speed = config.speed;
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

    if (Util.hasField(config, "weapon"))
      this.weapon = new Weapon(config.weapon);

    if (Util.hasField(config, "direction"))
      this.direction = Util.stringToDir(config.direction);

    if (Util.hasField(config, "state"))
      setState(config.state);

    if (Util.hasField(config, "stateData"))
      this.stateData = config.stateData;

    destroyOnCollide = false;
    if (Util.hasField(config, "destroyOnCollide"))
      destroyOnCollide = config.destroyOnCollide;
  }

  private function addChild(sprite: PlayableSprite) {
    childSprites.push(sprite);
    sprite.setPoint(getPoint());
  }

  public function setState(state: String, ?stateData: Dynamic=null) {
    this.state = state;
    this.stateData = stateData;
    for (sp in childSprites)
      sp.destroy();
    childSprites = [];
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
    if (aim == null)
      return;
    setDirection(aim.subtract(getPoint()).nearestDirection());
  }

  public function getAim(): Vec2 {
    return aim;
  }

  public function controlFire() {
    if (weapon != null) {
      lookAtAim();
      weapon.fire(this, map);
    }
  }

  override public function draw() {
    if (!moving)
      lookAtAim();

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

    if (controlled || map == null)
      return;

    // AI here
    if (state == "following") {
      updateFollowing();

    } else if (state == "moveForwards") {
      updateMoveForwards();

    } else if (state == "guarding") {
      updateGuarding();

    } else if (state == "bomb") {
      updateBomb();

    }

    if (Util.hasField(config, "lifeSpan") && elapsed > config.lifeSpan)
      kill();
  }

  private function updateMoveForwards() {
    controlMove(direction);
  }

  private function updateFollowing() {
    var followGroup = map.multigroup.getGroup(stateData.target);
    var target: NiceSprite = cast followGroup.getFirstAlive();
    if (target == null)
      return;
    var displ = target.getPoint().subtract(getPoint());
    if (displ.magnitude() <= stateData.distance)
      return;
    var dir = displ.unit();
    setPoint(target.getPoint().subtract(dir.multiply(stateData.distance)));
    controlAim(target.getPoint());
    moving = true;
    immovable = true;
  }

  private function updateGuarding() {
    if (childSprites.length < 1) {
      var torch = new PlayableSprite("guardtorch");
      addChild(torch);
      map.backgroundGroup.add(torch);
    }
    var torch = childSprites[0];
    torch.setDirection(getDirection());

    for (sp in map.multigroup.getGroup("playable")) {
      var playable: PlayableSprite = cast sp;
      if (!this.opposes(playable))
        continue;
      var displ = playable.getPoint().subtract(getPoint());
      if (displ.magnitude() < config.visionDistance && displ.nearestDirection() == direction) {
        playable.kill();
      }
    }
  }

  private function updateBomb() {
    if (elapsed > config.lifeSpan) {
      var expl = new PlayableSprite("explosion");
      expl.setPoint(getPoint());
      for (group in expl.groups) {
        map.multigroup.insert(group, expl);
      }
    }
  }

  override public function toString() {
    return "PlayableSprite:"+Std.string(name)+super.toString();
  }

  override public function kill() {
    super.kill();
    for (child in childSprites) {
      child.kill();
    }
  }

  override public function destroy() {
    super.destroy();
    for (child in childSprites) {
      child.destroy();
    }
  }
}
