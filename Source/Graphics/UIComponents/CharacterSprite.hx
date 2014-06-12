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


	public function new(direction:Int, characterNumber:Int, tile:Dynamic, style:Dynamic) {
		super();
		_tilesheet = new DarkFunctionTileSheet(tile, style);
		_direction = direction;
		_characterNumber = characterNumber;
	}

	public function getAnimations():Array<String>{
		return _tilesheet.getAnimations();
	}

	public function setAnimation(name:String) {
		_tilesheet.setAnimation(name);
	}

	public function recalculateSize():Void {
		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		var widthPadding = stageWidth/15;
		var heightPadding = stageHeight/15;
		var tile = _tilesheet.getTileRect(0);

		// set scale
		Globals.SCALE = (stageHeight/8)/tile.height;

		this.x = (_direction == Globals.LEFT) ? (stageWidth-tile.width)-widthPadding : widthPadding+20;
		this.y = (stageHeight-((stageHeight/8)*_characterNumber))-(tile.height+heightPadding); 
	}

	public function render():Void {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [frame.xOffset, frame.yOffset, frame.index, _direction*Globals.SCALE, 0, 0, Globals.SCALE], Tilesheet.TILE_TRANS_2x2); 
	}

}