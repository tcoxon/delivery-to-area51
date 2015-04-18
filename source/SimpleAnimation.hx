package;

import flixel.*;

class SimpleAnimation extends FlxSprite {
  private var config: Dynamic;

  public function new(asset: Dynamic, ?pos: Vec2=null) {
    if (pos == null)
      super();
    else
      super(pos.x, pos.y);

    config = Util.loadJson("assets/sprites/"+asset+".json");
    var width = Std.int(config.width);
    var height = Std.int(config.height);
    loadGraphic("assets/sprites/"+asset+".png", true, width, height);

    var frames: Array<Int> = [];
    for (i in 0...animation.frames) {
      frames.push(i);
    }

    animation.add("default", frames, Globals.AnimationFrameRate, true);
    animation.play("default");
  }
}
