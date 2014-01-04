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

class LoadCharacterSprite {

	static var LEFT = -1;
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

	public function new(){}

	public function loadSprites() : Array <CharacterSprite> {
		var characterList:Array <CharacterSprite> = new Array();
		var characterData = FileLoader.loadData('assets/dataTest.xml');
		for( c in 0...characterData.length ) {
			var character = new CharacterSprite(); 

			character.direction = (c < 4) ? LEFT : RIGHT;
			character.tilesheet = loadTilesheet(Assets.getBitmapData(characterData[c][CHAR_BITMAP_LOC]), characterData[c]);
			character.animationList = loadAnimations( characterData[c] );
			character.currentAnimation = character.animationList[0];

			characterList.push(character);
		}

		return characterList;
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

}