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
import openfl.Assets;
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

class ActionMenu extends Sprite {
	public var show:Bool;
	public var target:CharacterSprite;
	public var tilesheet:Tilesheet;
	public var selection:String;

	public function new(){
		super();
		tilesheet = new Tilesheet(Assets.getBitmapData("assets/menusprite.png"));
		tilesheet.addTileRect(new Rectangle(0,0,50,100), new Point(25,100));
	}

	public function on_click(event : MouseEvent){
		var y = Math.abs(event.localY);
		var x = event.localX / Math.abs(event.localX); //30, 100, 160

		var call_menu_select = new Event("menu_select", true);
		if(y < 30){
			selection = (x > 0) ? "item" : "exit";
			event.target.dispatchEvent(call_menu_select);
		}
		else if(y < 100) {
			selection = "magic";
			event.target.dispatchEvent(call_menu_select);
		}
		else if(y < 160) {
			selection = "defend";
			event.target.dispatchEvent(call_menu_select);
		}
		else{
			selection = "attack";
			event.target.dispatchEvent(call_menu_select);
		}

	}

}

class Cursor extends Tilesheet {
	public var direction:Int;
	public var x:Float;
	public var y:Float;

	public function new(image:BitmapData){
		super(image);
		addTileRect(new Rectangle(0,0,10,10), new Point(0,5));
	}
}