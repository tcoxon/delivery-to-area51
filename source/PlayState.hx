package;

import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.group.*;

import Util;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {

  private var controlStack: ControlStack = new ControlStack();

  override public function new() {
    super();
  }

  /**
   * Function that is called up when to state is created to set it up. 
   */
  override public function create():Void {
    super.create();

    var map = new Tilemap("assets/maps/labs.tmx");
    add(map);

    var player = new PlayableSprite("assets/images/santa.png", 16, 16);
    player.setPosition(map.playerStart.x, map.playerStart.y);
    add(player);
    controlStack.push(player);
  }

  /**
   * Function that is called when this state is destroyed - you might want to 
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void {
    super.destroy();
  }

  static var clickedOnce = false;
  override public function update():Void {
    #if flash
    if (!clickedOnce) {

      // Pause the game until the player clicks to give it focus
      if (FlxG.mouse.justReleased)
        clickedOnce = true;
      else
        return;

    }
    #end

    super.update();
    if (!controlStack.empty())
      FlxG.camera.target = controlStack.peek();

    if (FlxG.keys.anyPressed(["W"]))
      controlStack.sendControlMove(North);
    if (FlxG.keys.anyPressed(["D"]))
      controlStack.sendControlMove(East);
    if (FlxG.keys.anyPressed(["S"]))
      controlStack.sendControlMove(South);
    if (FlxG.keys.anyPressed(["A"]))
      controlStack.sendControlMove(West);

    controlStack.sendControlAim(Vec2.fromFlxPoint(FlxG.mouse));
  }

}
