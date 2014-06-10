package graphics.uicomponents;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.display.Bitmap;
import flash.display.BitmapData;

class Background extends Sprite {

	public function new (bitmapSource:BitmapData, ?geometry:Rectangle) {
		super();
		this.addChild(new Bitmap(bitmapSource));
		if (geometry != null) setSize(geometry);
	}

	public function setSize(geometry:Rectangle) {
		this.x = geometry.x;
		this.y = geometry.y;
		this.width = geometry.width;
		this.height = geometry.height;
	}
}