package;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.Lib;
import openfl.display.Tilesheet;

import Game;

class CharacterSprite {
	public var id : Int;
	public var team : Int;
	public var position : Int;
	public var direction : Int;
	public var tilesheet : Tilesheet;
	public var animationList : Array <Animation>;
	public var currentAnimation : Animation;
	public var mainclass : Main;
	public function new (parent : Main){
		mainclass = parent;
	};

	public function on_click(event : Event) :Void {
		mainclass.game.selectCharacter(team, id);
		
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