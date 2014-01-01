package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import openfl.Assets;
import flash.Lib;
import Animations;
import openfl.display.Tilesheet;


class  GameGraphics extends Sprite {

	static var LEFT = 0;
	static var RIGHT = 1;

	public var characterList:Array <CharacterSprite>;
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
		characterList = new Array();

		getScreenDimentions();
		loadBackdrop();

		loadCharacterData();

		gameStage.addEventListener(Event.ENTER_FRAME, renderLoop);

	}

	private function getScreenDimentions() : Void {
		screenWidth = gameStage.width;
		screenHeight = gameStage.height; 
	} 

	private function loadBackdrop() : Void {
		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, 800,600));
		drawGraphic(backdrop);
		displayContainer = new Sprite();
		gameStage.addChild(displayContainer);

	}

	public function drawGraphic( graphic : Graphic ) : Void {
		var container = graphic.graphicContainer;

		container = new Sprite();
		container.addChild(graphic.bitmapSource);
		resizeSprite(container, graphic.gameGeometry);
		gameStage.addChild(container);
		
	}

	public function drawFrame() : Void {

	}

	private function resizeSprite( original:Sprite, targetDimentions:Rectangle ) : Void {
		original.width = targetDimentions.width;
		original.height = targetDimentions.height;
		original.x = targetDimentions.x;
		original.y = targetDimentions.y;
	}

	private function loadCharacterData() : Void {

		characterList[0] = new CharacterSprite(); // this method is for testing purposes only
		
		characterList[0].Direction = LEFT;

		characterList[0].animationList = loadAnimationData();
		characterList[0].currentAnimation = characterList[0].animationList[0];

	}

	private function loadAnimationData() : Array <Animation> {

		var animationlist = new Array(); // this method is for testing purposes only

		animationlist[0] = new Animation();
		animationlist[0].name = "waiting";
		animationlist[0].bitmap = Assets.getBitmapData('assets/basicCharacter.png');
		animationlist[0].frameList = loadFrameData();
		animationlist[0].currentFrame = animationlist[0].frameList[0];
		return animationlist;

	}

	private function loadFrameData() : Array <Frame> {

		var framelist = new Array(); // this method is for testing purposes only

		framelist[0] = new Frame();
		framelist[0].geometry = new Rectangle(0,0,30,31);

		return framelist;
	}

	private function loadAnimations(){

	}

	private function renderLoop( event:Event ) : Void {

		for (i in 0...characterList.length){
			var animation = characterList[i].currentAnimation; // this method is for testing purposes only
			var frame = animation.currentFrame;
			var tilesheet = new Tilesheet(animation.bitmap);
			var tile = tilesheet.addTileRect(frame.geometry, new Point(0,0));
			tilesheet.drawTiles(displayContainer.graphics, [650, 300, tile, 3], Tilesheet.TILE_SCALE);
		}

	}
}