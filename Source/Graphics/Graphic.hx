package graphics;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.display.Bitmap;
import flash.display.BitmapData;

class Graphic {
	public var graphicContainer : Sprite;
	public var gameGeometry : Rectangle;
	public var bitmapSource : Bitmap;

	public function new (bitmap : BitmapData, ?geometry:Rectangle){
		if(geometry != null){
			gameGeometry = geometry;
		}
		bitmapSource = new Bitmap(bitmap);
	}
}