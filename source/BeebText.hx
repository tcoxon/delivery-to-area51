package;

import flixel.text.*;

class BeebText extends FlxText {
  //private var color: UInt = 0xffffffff;
  //private var size: Float = 8;

  public function new(text: String, ?width: Float=0, ?pos: Vec2=null) {
    if (pos == null) {
      super(0, 0, width, text);
    } else {
      super(pos.x, pos.y, width, text);
    }
    font = "assets/Beeb.ttf";
  }

  //public function setColor(color: UInt) {
  //  this.color = color;
  //  setFormat(font, size, color);
  //}

  //public function setSize(size: Float) {
  //  this.size = size;
  //  setFormat(font, size, color);
  //}

}
