package;

import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.group.*;

import Util;

enum Mode {
  Normal;
  Scrolling(origin: Vec2, target: Vec2, elapsed: Float);
}

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {

  private var controlStack: ControlStack = new ControlStack();
  private var mode: Mode = Normal;
  private var windows: FlxGroup = new FlxGroup();
  private var config: Dynamic;
  private var levelConfig: Dynamic;
  private var level: UInt;

  private var map: Tilemap;
  private var groups: Multigroup;
  private var currentScrollArea: Vec2 = null;

  override public function new(?level: UInt=0) {
    super();
    this.level = level;
  }

  /**
   * Function that is called up when to state is created to set it up. 
   */
  override public function create():Void {
    super.create();
    setCursor();

    config = Util.loadJson("assets/config.json");
    levelConfig = config.levels[level];

    map = new Tilemap(levelConfig.map);
    FlxG.worldBounds.width = map.width;
    FlxG.worldBounds.height = map.height;
    add(map);

    groups = map.multigroup;
    add(groups.getGroup("display"));

    groups.getGroup("basePlayable").forEachOfType(PlayableSprite, function(sp) {
      controlStack.addBasePlayable(sp);
    });

    if (Util.hasField(levelConfig, "entryText")) {
      var entryText = levelConfig.entryText;
      windows.add(new TextWindow(entryText.text, Util.intify(entryText.color)));
    }
    add(windows);
  }

  private function setCursor() {
    var sprite = new SimpleAnimation("cursor");
    var zoom = FlxG.camera.zoom;
    FlxG.mouse.load(sprite.pixels, zoom, -Std.int(zoom*sprite.width/2), -Std.int(zoom*sprite.height/2));
  }

  /**
   * Function that is called when this state is destroyed - you might want to 
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void {
    super.destroy();
  }

  private function updateCamera() {
    if (controlStack.empty())
      return;

    var scrollSize = new Vec2(config.scrolling.size[0], config.scrolling.size[1]);

    var target = controlStack.peek().getPoint();
    var targetScrollArea = target.pieceMultiply(scrollSize.pieceInvert()).floor().pieceMultiply(scrollSize);

    if (currentScrollArea == null) {
      FlxG.camera.scroll.set(targetScrollArea.x, targetScrollArea.y);
      currentScrollArea = targetScrollArea;
      return;
    } else if (currentScrollArea.equals(targetScrollArea)) {
      return;
    }

    mode = Scrolling(currentScrollArea, targetScrollArea, 0);
    currentScrollArea = targetScrollArea;
  }

  override public function update():Void {
    groups.forEachGroupMemberOfType(PlayableSprite, function(playable) {
      playable.setMap(map);
    });
    controlStack.update();

    super.update();

    switch (mode) {
      case Normal: updateNormal();
      case Scrolling(origin,target,elapsed): mode = updateScrolling(origin,target,elapsed);
    }
  }

  private function updateScrolling(origin: Vec2, target: Vec2, elapsed: Float): Mode {
    var timeLength: Float = config.scrolling.duration;
    elapsed += FlxG.elapsed;
    if (elapsed > timeLength) {
      FlxG.camera.scroll.set(target.x, target.y);
      return Normal;
    }

    var newScroll = origin.lerp(target, elapsed/timeLength);
    FlxG.camera.scroll.set(newScroll.x, newScroll.y);
    return Scrolling(origin, target, elapsed);
  }

  private function updateNormal() {
    updateCamera();

    if (windows.countLiving() > 0) {
      return;
    }

    if (FlxG.keys.anyPressed(["W"]))
      controlStack.sendControlMove(North);
    if (FlxG.keys.anyPressed(["D"]))
      controlStack.sendControlMove(East);
    if (FlxG.keys.anyPressed(["S"]))
      controlStack.sendControlMove(South);
    if (FlxG.keys.anyPressed(["A"]))
      controlStack.sendControlMove(West);

    if (FlxG.keys.justPressed.TAB)
      controlStack.sendControlSwitchCharacter();

    var cursor = Vec2.fromFlxPoint(FlxG.mouse);
    controlStack.sendControlAim(cursor);

    if (FlxG.mouse.justReleased)
      controlStack.sendControlFire();

    FlxG.collide(map, groups.getGroup("colliding"));
    // Custom collision to avoid colliding playables with playables:
    FlxG.overlap(groups.getGroup("colliding"), groups.getGroup("colliding"), null, customSeparate);
  }

  private function customSeparate(obj1: Dynamic, obj2: Dynamic): Bool {
    if (Std.is(obj1, NiceSprite) && Std.is(obj2, NiceSprite)) {
      var result: Null<Bool> = null;
      for (pair in [[obj1,obj2],[obj2,obj1]]) {
        var a: NiceSprite = pair[0];
        var b: NiceSprite = pair[1];
        if (a.opposes(b) && a.damage > 0 && b.damageable) {
          b.hurt(a.damage);
          if (a.destroyOnCollide) {
            a.destroy();
            result = true;
          }
        }
      }
      if (result != null)
        return result;
    }

    if (Std.is(obj1, PlayableSprite) && Std.is(obj2, PlayableSprite)) {
      // Don't let playables collide with playables. That's weird
      return false;
    }

    // Bullet vs TileObject
    for (obj in [obj1,obj2]) {
      if (Std.is(obj, PlayableSprite) && obj.destroyOnCollide) {
        obj.destroy();
        return false;
      }
    }

    return FlxObject.separate(obj1, obj2);
  }

}
