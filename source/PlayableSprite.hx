package;

import flixel.*;
import flixel.util.*;
import Util;

class PlayableSprite extends FlxSprite {

  public function new(?sprite: Dynamic=null, ?width: Int=0, ?height: Int=0) {
    super();
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

  public function setPoint(point: FlxPoint) {
    this.x = point.x;
    this.y = point.y;
  }

  public function addToPoint(vec: FlxPoint) {
    this.x += vec.x;
    this.y += vec.y;
  }

  public function controlMove(dir: Direction) {
    addToPoint(Util.toVec(dir));
    animation.play(Util.toString(dir).toLowerCase());
  }

}
