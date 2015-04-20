package;

import Util;

class ControlStack {
  private var currentBase: Int = 0;
  private var basePlayables: Array<PlayableSprite> = [];
  private var stack: Array<PlayableSprite> = [];

  public function addBasePlayable(sprite: PlayableSprite) {
    basePlayables.push(sprite);
  }

  public function hasBasePlayable(sprite: PlayableSprite): Bool {
    return basePlayables.indexOf(sprite) != -1;
  }

  public function anyDeadBasePlayable(): PlayableSprite {
    for (bp in basePlayables)
      if (!bp.alive)
        return bp;
    return null;
  }

  public function push(sprite: PlayableSprite) {
    stack.push(sprite);
  }

  public function pop(): PlayableSprite {
    return stack.pop();
  }

  public function empty(): Bool {
    return stack.length < 1 && basePlayables.length < 1;
  }

  public function peek(): PlayableSprite {
    if (empty())
      throw "Control stack is empty";
    if (stack.length > 0)
      return stack[stack.length-1];
    return basePlayables[currentBase];
  }

  public function sendControlMove(dir: Direction) {
    if (empty())
      return;
    peek().controlMove(dir);
  }

  public function sendControlAim(at: Vec2) {
    if (empty())
      return;
    peek().controlAim(at);
  }

  public function sendControlSwitchCharacter() {
    if (empty())
      return;
    if (stack.length > 0) {
      // TODO make character suicide? It has been un-mind-controlled.
      peek().controlled = false;
      peek().possessed = false;
      pop();
    } else 
      currentBase = (currentBase+1) % basePlayables.length;
  }

  public function sendControlFire() {
    if (empty())
      return;
    peek().controlFire();
  }

  public function update() {
    while (stack.length > 0 && !peek().alive)
      pop();

    if (empty())
      return;

    for (sp in basePlayables)
      sp.controlled = false;
    for (sp in stack) {
      sp.controlled = false;
      sp.possessed = true;
    }
    peek().controlled = true;
  }
}
