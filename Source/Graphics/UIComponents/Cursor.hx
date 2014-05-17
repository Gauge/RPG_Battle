package graphics;

import graphics.Animation;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

class Cursor extends Sprite {
	public var direction:Int;

	public function new(image:BitmapData, sprite:AnimationSprite){
		super();
		x = sprite.x + 30;
		y = sprite.y - 40;
		addChild(new Bitmap(image));
		width *= 2.5;
		height *= 2.5;
	}
}