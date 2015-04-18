package;

import openfl.Assets;
import flixel.*;

class SimpleAnimation extends FlxSprite {
  private var config: Dynamic;

  public function new(asset: Dynamic, ?pos: Vec2=null) {
    if (pos == null)
      super();
    else
      super(pos.x, pos.y);

    var jsonPath = "assets/sprites/"+asset+".json";
    width = 0;
    height = 0;
    if (Assets.exists(jsonPath)) {
      config = Util.loadJson(jsonPath);
      width = Std.int(config.width);
      height = Std.int(config.height);
    }
    loadGraphic("assets/sprites/"+asset+".png", true, Std.int(width), Std.int(height));

    var frames: Array<Int> = [];
    for (i in 0...animation.frames) {
      frames.push(i);
    }

    animation.add("default", frames, Globals.AnimationFrameRate, true);
    animation.play("default");
  }
}
