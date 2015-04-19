package;

import flixel.*;
import flixel.group.*;

class StatusBar extends FlxGroup {
  private var controlStack: ControlStack;
  private var background: SimpleAnimation;

  private var currentWeapon: Weapon;
  private var currentCharacter: PlayableSprite;

  private var weaponName: BeebText;
  private var charName: BeebText;

  override public function new(controlStack: ControlStack) {
    super();

    this.controlStack = controlStack;
    add(background = new SimpleAnimation("statusbar"));
    background.origin.set(0,0);

    add(weaponName = new BeebText("?"));
    add(charName = new BeebText("?"));
  }

  override public function update() {
    super.update();

    background.setPoint(new Vec2(FlxG.camera.scroll.x, FlxG.camera.scroll.y + FlxG.height - background.height));

    if (controlStack.empty())
      return;

    charName.text = controlStack.peek().prettyName;
    var weapon = controlStack.peek().weapon;
    var weaponText = if (weapon != null) weapon.getPrettyName() else "No Weapon";
    weaponName.text = weaponText;

    charName.x = background.x + background.width - 16 - charName.width;
    charName.y = background.y;
    weaponName.x = background.x + 8;
    weaponName.y = background.y;
  }
}
