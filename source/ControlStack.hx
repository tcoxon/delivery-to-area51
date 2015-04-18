package;

import Util;

class ControlStack {
  private var stack: Array<PlayableSprite> = [];

  public function push(sprite: PlayableSprite) {
    stack.push(sprite);
  }

  public function pop(): PlayableSprite {
    return stack.pop();
  }

  public function empty(): Bool {
    return stack.length < 1;
  }

  public function peek(): PlayableSprite {
    if (empty())
      throw "Control stack is empty";
    return stack[stack.length-1];
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
}
