package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import openfl.Assets;
import flash.Lib;
import Animations;
import openfl.display.Tilesheet;


class  GameGraphics extends Sprite {

	public static var FRAME = 0;
	public static var GRAPHIC = 1;

	public var animationList:Array <Dynamic>;
	public var graphicList:Array <Graphic>;
	public var displayContainer:Sprite;

	public var screenWidth:Float;
	public var screenHeight:Float;
	public var gameStage:flash.display.Stage;
	
	function new(){
		super();
		init();

	}

	public function init(){
		gameStage = Lib.current.stage;

		getScreenDimentions();
		loadBackdrop();

	}

	private function getScreenDimentions() : Void {
		screenWidth = gameStage.width;
		screenHeight = gameStage.height; 
	} 

	private function loadBackdrop() : Void {

		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, 800,600));
		drawGraphic(backdrop);

	}

	public function drawGraphic( graphic : Graphic ) : Void {
		var container = graphic.graphicContainer;

		container = new Sprite();
		container.addChild(graphic.bitmapSource);
		resizeSprite(container, graphic.gameGeometry);
		gameStage.addChild(container);
		
	}

	private function resizeSprite( sprite:Sprite, dimentions:Rectangle ) : Void {
		sprite.width = dimentions.width;
		sprite.height = dimentions.height;
		sprite.x = dimentions.x;
		sprite.y = dimentions.y;
	}

	private function loadAnimations(){

	}
	private function loadGrapics(){

	}
}