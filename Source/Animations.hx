package;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import flash.geom.Point;

class CharacterSprite {
	public var slot:Int;
	public var Direction:Int;
	public var animationList:Array <Animation>;
	public var currentAnimation:Animation;

}

class Animation {
	public var name:String;
	public var bitmap:BitmapData;
	public var frameList:Array <Frame>;
	public var animationProgress:Int;
	
}

class Graphic {
	public var graphicContainer:Sprite;
	public var gameGeometry:Rectangle;
	public var bitmapSource:Bitmap;

	public function new (bitmap : BitmapData, ?geometry:Rectangle){
		if(geometry != null){
			gameGeometry = geometry;
		}
		bitmapSource = new Bitmap(bitmap);
	}


}

class Frame {
	public var geometry:Rectangle;
	public var duration:Int;
	public var offset:Point;

}