package graphics.uicomponents;
import openfl.display.Tilesheet;
import openfl.Assets;
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Sprite;
import flash.Lib;
import graphics.util.DarkFunctionTileSheet;

class CharacterSprite extends Sprite {

	var _tilesheet:DarkFunctionTileSheet;
	var _direction:Int;
	var _characterNumber:Int;
	var _characterScale:Float;


	public function new(direction:Int, characterNumber:Int, tile:Dynamic, style:Dynamic) {
		super();
		_tilesheet = new DarkFunctionTileSheet(tile, style);
		_direction = direction;
		_characterNumber = characterNumber+1;
		_characterScale = 1;
	}

	public function getAnimations():Array<String>{
		return _tilesheet.getAnimations();
	}

	public function setAnimation(name:String) {
		_tilesheet.setAnimation(name);
	}

	public function recalculateSize():Void {
		var stageWidth = Lib.current.stage.stageWidth;
		var startingHeight = Lib.current.stage.stageHeight/2;
		var hightPadding = (startingHeight/6);
		var widthPadding = stageWidth/15;
		var tile = _tilesheet.getTileRect(0);

		// set scale
		//trace("Character Scale: " + (startingHeight)/(tile.height*4) / (Math.abs(_characterNumber-4)+1));
		var charnum = ((_direction == Globals.LEFT) ? _characterNumber : (Math.abs(_characterNumber-4)+1));
		_characterScale = ((startingHeight)/(tile.height*4)) - (charnum*0.05); // TODO

		this.x = (_direction == Globals.LEFT) ? ((stageWidth-tile.width)-widthPadding)-((charnum*50)/3) : 
												(widthPadding+Globals.BASE_SCREEN_OFFSET) + ((charnum*50)/3);
		
		this.y = (_direction == Globals.LEFT) ? (startingHeight+(hightPadding*(Math.abs(_characterNumber-4)+1))) : 
												(startingHeight+(hightPadding*_characterNumber)); 
	}

	public function render():Void {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [((_direction*-1)*frame.xOffset), frame.yOffset, frame.index, _direction*_characterScale, 0, 0, _characterScale], Tilesheet.TILE_TRANS_2x2); 
	}

}