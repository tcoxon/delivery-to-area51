package;

import flixel.*;
import flixel.group.*;
import flixel.text.*;

class TextWindow extends FlxGroup {
  
  private var textObj: FlxText;
  private var background: FlxSprite;
  private var clickIndicator: SimpleAnimation;
  private var mouseWasPressed: Bool = false;
  private var offset: Vec2;
  private var size: Vec2;

  public function new(text: String, ?color: UInt=0xff000000) {
    super();
    offset = new Vec2(8,8);
    var width = FlxG.width - offset.x*2;

    textObj = new FlxText(0, 0, width, text);
    textObj.font = "assets/Beeb.ttf";

    size = new Vec2(width, textObj.height);

    background = new FlxSprite(0, 0);
    background.makeGraphic(Std.int(size.x), Std.int(size.y), color);

    clickIndicator = new SimpleAnimation("click-indicator");

    add(background);
    add(textObj);
    add(clickIndicator);
  }

  private function setPosition(x: Float, y: Float) {
    x += offset.x;
    y += offset.y;
    textObj.setPosition(x, y);
    background.setPosition(x, y);
    clickIndicator.setPosition(x + size.x - clickIndicator.width - 1, y + size.y - clickIndicator.height - 1);
  }

  override public function update() {
    super.update();
    setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);

    if (mouseWasPressed && FlxG.mouse.justReleased)
      destroy();

    if (FlxG.mouse.justPressed)
      mouseWasPressed = true;
  }

}
