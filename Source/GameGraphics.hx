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
import FileLoader;
import openfl.display.Tilesheet;


class  GameGraphics extends Sprite {

	static var LEFT = 0;
	static var RIGHT = 1;

	public var characterList:Array <CharacterSprite>;
	public var characterData:Array <Dynamic>;
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
		var spriteLoader = new LoadCharacterSprite();
		characterList = spriteLoader.loadSprites();

		//FileLoader.loadXmlFile('assets/dataTest.xml');

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

	private function resizeSprite( original:Sprite, targetDimentions:Rectangle ) : Void {
		original.width = targetDimentions.width;
		original.height = targetDimentions.height;
		original.x = targetDimentions.x;
		original.y = targetDimentions.y;
	}



	private function renderLoop( event:Event ) : Void {
		displayContainer.graphics.clear();
		for ( i in 0...characterList.length ){
			var animation = characterList[i].currentAnimation; // this method is for testing purposes only
			var frameId = animation.currentFrameId;
			var frame = animation.frameList[frameId];

			if( frame.duration == animation.timer ) {
				if( frameId < animation.frameList.length - 1 ) {
					frame = animation.frameList[frameId + 1];
					characterList[i].currentAnimation.currentFrameId = frameId + 1;
				}
				else{
					frame = animation.frameList[0];
					characterList[i].currentAnimation.currentFrameId = 0;
				}
				characterList[i].currentAnimation.timer = 0;
			}
			else {
				characterList[i].currentAnimation.timer++;
			}
			characterList[i].tilesheet.drawTiles(displayContainer.graphics, [650, 300, frameId, 3], Tilesheet.TILE_SCALE);
		}
	}

}