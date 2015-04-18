package;

import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.group.*;

import Util;

enum Mode {
  Normal;
  Scrolling(target: Vec2);
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

    var scrollSize = new Vec2(config.scrollArea.size[0], config.scrollArea.size[1]);

    var target = controlStack.peek().getPoint();
    var targetScrollArea = target.pieceMultiply(scrollSize.pieceInvert()).floor().pieceMultiply(scrollSize);
    FlxG.camera.scroll.set(targetScrollArea.x, targetScrollArea.y);
  }

  override public function update():Void {
    super.update();
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
