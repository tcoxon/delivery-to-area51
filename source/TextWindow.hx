package;

import flixel.*;
import flixel.group.*;
import flixel.text.*;

class TextWindow extends FlxGroup {
  
  private var textObj: FlxText;
  private var background: FlxSprite;
  private var clickIndicator: SimpleAnimation;
  private var mouseWasPressed: Bool = false;
  private var spaceWasPressed: Bool = false;
  private var inset: Vec2;
  private var textInset: Vec2;
  private var size: Vec2;
  private var color: UInt;
  private var afterwards: Array<Void -> Void> = [];
  private var text: String;
  private var textPos: UInt = 0;

  public function new(text: String, ?color: UInt=0xff000000) {
    super();
    this.text = text;
    inset = new Vec2(8,8);
    textInset = new Vec2(4,4);
    this.color = color;
    var width = FlxG.width - inset.x*2;

    textObj = new BeebText(text, width - textInset.x*2);
    textObj.color = color;

    background = new FlxSprite(0, 0);

    clickIndicator = new SimpleAnimation("click-indicator");

    add(background);
    add(textObj);
    add(clickIndicator);
  }

  public function then(func: Void -> Void): TextWindow {
    afterwards.push(func);
    return this;
  }

  override public function draw() {
    super.draw();
    if (size == null) {
      var width = FlxG.width - inset.x*2;
      size = new Vec2(width, textObj.region.height + textInset.y*2);
      background.makeGraphic(Std.int(size.x), Std.int(size.y), color);
    }
  }

  private function setPosition(x: Float, y: Float) {
    if (size == null)
      return;
    x += inset.x;
    y += inset.y;
    textObj.setPosition(x + textInset.x, y + textInset.y);
    background.setPosition(x, y);
    clickIndicator.setPosition(x + size.x - clickIndicator.width - 1, y + size.y - clickIndicator.height - 1);
  }

  override public function update() {
    super.update();
    setPosition(FlxG.camera.scroll.x, FlxG.camera.scroll.y);

    if (textPos < text.length) {
      textPos += 1;
      if (textPos > 1) {
        textObj.color = 0xffffffff;

        if (mouseWasPressed && FlxG.mouse.justReleased)
          textPos = text.length;
        if (spaceWasPressed && FlxG.keys.justReleased.SPACE)
          textPos = text.length;

        textObj.text = text.substring(0, textPos);
      }

    } else {
      if (mouseWasPressed && FlxG.mouse.justReleased)
        kill();
      if (spaceWasPressed && FlxG.keys.justReleased.SPACE)
        kill();
    }

    if (FlxG.mouse.justPressed)
      mouseWasPressed = true;
    if (FlxG.keys.justPressed.SPACE)
      spaceWasPressed = true;
  }

  override public function kill() {
    super.kill();
    for (func in afterwards) func();
  }

}
