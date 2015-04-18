package;

import flixel.*;

class SimpleAnimation extends FlxSprite {
  public function new(asset: Dynamic, pos: Vec2, size: Vec2) {
    super(pos.x, pos.y);
    loadGraphic(asset, true, Std.int(size.x), Std.int(size.y));

    var frames: Array<Int> = [];
    for (i in 0...animation.frames) {
      frames.push(i);
    }

    animation.add("default", frames, Globals.AnimationFrameRate, true);
    animation.play("default");
  }
}
