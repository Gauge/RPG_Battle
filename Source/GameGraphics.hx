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

	static var CHAR_NAME = 0;
	static var CHAR_BITMAP_LOC = 1;
	static var ANIM_LIST_START = 2;

	static var ANIM_NAME = 0;
	static var ANIM_LOOP = 1;
	static var FRAME_LIST_START = 2;

	static var FRAME_DURATION = 0;
	static var FRAME_X = 1;
	static var FRAME_Y = 2;

	static var FRAME_WIDTH = 3;
	static var FRAME_HEIGHT = 4;
	static var FRAME_REF_X = 5;
	static var FRAME_REF_Y = 6;
	static var FRAME_ID = 7;

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
		characterData = FileLoader.loadData('assets/dataTest.xml');
		getScreenDimentions();
		loadBackdrop();

		loadCharacterData();

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

	public function drawFrame() : Void {

	}

	private function resizeSprite( original:Sprite, targetDimentions:Rectangle ) : Void {
		original.width = targetDimentions.width;
		original.height = targetDimentions.height;
		original.x = targetDimentions.x;
		original.y = targetDimentions.y;
	}

	private function loadCharacterData() : Void {
		for( c in 0...characterData.length ) {
			var character = new CharacterSprite(); 

			character.direction = LEFT;
			character.tilesheet = loadTilesheet(Assets.getBitmapData(characterData[c][CHAR_BITMAP_LOC]), characterData[c]);
			character.animationList = loadAnimations( characterData[c] );
			character.currentAnimation = character.animationList[0];

			characterList.push(character);
		}
	}

	private function loadTilesheet( bitmap : BitmapData, characterData : Array <Dynamic> ) : Tilesheet {
		var tilesheet = new Tilesheet(bitmap);

		for( animations in ANIM_LIST_START...characterData.length ) {
			for( frames in FRAME_LIST_START...characterData[animations].length ) {

				var frame = characterData[animations][frames];
				var geometry = new Rectangle(frame[FRAME_X], frame[FRAME_Y], frame[FRAME_WIDTH], frame[FRAME_HEIGHT]);
				var reference = new Point(frame[FRAME_REF_X], frame[FRAME_REF_Y]);

				tilesheet.addTileRect(geometry, reference);
			}
		}
		
		return tilesheet;
	}

	private function loadAnimations( data : Array <Dynamic> ) : Array <Animation> {
  		var animationlist = new Array(); 

		for(a in ANIM_LIST_START...data.length){
			var animation = new Animation();
			animation.name = data[a][ANIM_NAME];
			animation.loop = data[a][ANIM_LOOP];
			animation.frameList = loadFrameData(data[a]);

			animation.currentFrameId = 0;
			animation.timer = 0;
			
			animationlist.push(animation);
		}

		return animationlist;
	}

	private function loadFrameData( data : Array <Dynamic> ) : Array <Frame> {
		var framelist = new Array();

		for (f in FRAME_LIST_START...data.length) {
			var frame = new Frame();
			frame.tileId = data[f][FRAME_ID];
			frame.duration = data[f][FRAME_DURATION];

			framelist.push(frame);
		}


		return framelist;
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