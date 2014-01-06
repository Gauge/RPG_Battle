package;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.Lib;
import openfl.display.Tilesheet;
import Game;

class CharacterSprite extends Sprite {
	public var id : Int;
	public var team : Int;
	public var position : Int;
	public var direction : Int;
	public var tilesheet : Tilesheet;
	public var animationList : Array <Animation>;
	public var currentAnimation : Animation;

	public function new (){
		super();
	}

	public function on_click(event : Event) :Void {
		event.target.dispatchEvent(new Event('select_character', true));		
	}

}

class Animation {
	public var name : String;
	public var frameList : Array <Frame>;
	public var currentFrameId : Int;
	public var loop : Bool;
	public var nextAnimation : Int;
	public var timer : Int;
	public function new () {};	
}

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

class Frame {
	public var tileId : Int;
	public var duration : Int;
	public var offset : Point;
	public function new(){};
	}