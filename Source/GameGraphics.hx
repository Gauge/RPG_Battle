package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.events.MouseEvent;
import flash.events.Event;

import flash.geom.Rectangle;
import flash.geom.Point;

import flash.Lib;

import openfl.Assets;
import openfl.display.Tilesheet;

import Animations;
import FileLoader;



class  GameGraphics extends Sprite {

	static var LEFT = 0;
	static var RIGHT = 1;

	static var POS_L_1 = new Point(175, 325);
	static var POS_L_2 = new Point(150, 400);
	static var POS_L_3 = new Point(125, 475);
	static var POS_L_4 = new Point(100, 550);

	static var POS_R_1 = new Point(600, 325);
	static var POS_R_2 = new Point(625, 400);
	static var POS_R_3 = new Point(650, 475);
	static var POS_R_4 = new Point(675, 550);

	static var TEAM_POSITIONS = [POS_L_1, POS_L_2, POS_L_3, POS_L_4, POS_R_1, POS_R_2, POS_R_3, POS_R_4];

	static var CHAR_SCALE = 2.5;

	public var characterList:Array <CharacterSprite>;
	public var displayContainer:Sprite;
	public var spriteContainer:Array <Sprite>;

	public var screenWidth:Float;
	public var screenHeight:Float;
	public var gameStage:flash.display.Stage;

	private var mainclass:Main;

	
	function new(parent : Main){
		mainclass = parent;
		super();
		init();

	}

	public function init(){
		gameStage = Lib.current.stage;
		characterList = new Array();

		var spriteLoader = new LoadCharacterSprite(mainclass);
		characterList = spriteLoader.loadSprites();

		loadBackdrop();
		loadContainers();


		gameStage.addEventListener(Event.ENTER_FRAME, renderLoop);

	}

	private function loadBackdrop() : Void {
		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, 800,600));
		drawGraphic(backdrop);
	}

	private function loadContainers() : Void {
		displayContainer = new Sprite();
		gameStage.addChild(displayContainer);

		spriteContainer = new Array();

		for(c in 0...TEAM_POSITIONS.length){
			var sprite = new Sprite();
			sprite.x = TEAM_POSITIONS[c].x;
			sprite.y = TEAM_POSITIONS[c].y;

			sprite.addEventListener(MouseEvent.MOUSE_DOWN, characterList[c].on_click);

			spriteContainer.push(sprite);
			displayContainer.addChild(sprite);
		}
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
		for ( i in 0...characterList.length ){
			spriteContainer[i].graphics.clear();
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
			var direction = characterList[i].direction * CHAR_SCALE;
			var characterX = 0;
			var characterY = 0;
			characterList[i].tilesheet.drawTiles(spriteContainer[i].graphics, [characterX, characterY, frameId, direction, 0, 0, CHAR_SCALE], Tilesheet.TILE_TRANS_2x2);
		}
	}

}