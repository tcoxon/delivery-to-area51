package;

import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.group.*;

import Tilemap;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {

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
    var player = new FlxObject(map.playerStart.x, map.playerStart.y);
    add(player);
    FlxG.camera.target = player;
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
  }

}
