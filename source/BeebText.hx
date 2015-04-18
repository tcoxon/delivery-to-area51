package;

import flixel.text.*;

class BeebText extends FlxText {

  public function new(text: String, ?width: Float=0, ?pos: Vec2=null) {
    if (pos == null) {
      super(0, 0, width, text);
    } else {
      super(pos.x, pos.y, width, text);
    }
    font = "assets/Beeb.ttf";
  }

}
