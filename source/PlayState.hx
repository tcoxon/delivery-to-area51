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
  private var playables: FlxGroup = new FlxGroup();
  private var map: Tilemap;
  private var mode: Mode = Normal;
  private var windows: FlxGroup = new FlxGroup();
  private var config: Dynamic;

  private var currentScrollArea: Vec2 = null;

  override public function new() {
    super();
  }

  /**
   * Function that is called up when to state is created to set it up. 
   */
  override public function create():Void {
    super.create();

    config = Util.loadJson("assets/config.json");

    map = new Tilemap("assets/maps/labs.tmx");
    FlxG.worldBounds.width = map.width;
    FlxG.worldBounds.height = map.height;
    add(map);

    var player = new PlayableSprite("santa");
    player.setPosition(map.playerStart.x, map.playerStart.y);
    playables.add(player);
    controlStack.push(player);

    add(playables);

    windows.add(new TextWindow("Christmas is coming, bitches!"));
    add(windows);
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

    controlStack.sendControlAim(Vec2.fromFlxPoint(FlxG.mouse));

    FlxG.collide(map, playables);
  }

}
