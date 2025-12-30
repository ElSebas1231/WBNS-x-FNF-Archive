package shaders;

import flixel.addons.display.FlxRuntimeShader;

/**
 * Note... not actually gaussian!
*/
class GaussianBlurShader extends FlxRuntimeShader
{
  public var amount:Float;

  public function new(amount:Float = 1.0)
  {
    super(openfl.utils.Assets.getText(Paths.shaderFragment("gaussianBlur")));
    setAmount(amount);
  }

  public function setAmount(value:Float):Void
  {
    this.amount = value;
    this.setFloat("_amount", amount);
  }
}
