package graphics.uicomponents;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import openfl.Assets;

class Splash extends Sprite {
	
	public function new(bitmapName : String) {
		super();
		
		var bitmapData = Assets.getBitmapData('assets/Images/' + bitmapName);
		var bitmap = new Bitmap(bitmapData); 
		addChild(bitmap);
		bitmap.width = Lib.current.stage.stageWidth;
		bitmap.height = Lib.current.stage.stageHeight;

	}
}