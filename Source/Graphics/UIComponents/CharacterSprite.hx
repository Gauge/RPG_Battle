package graphics.uicomponents;
import openfl.display.Tilesheet;
import openfl.Assets;
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Sprite;
import flash.Lib;

class CharacterSprite extends Sprite {

	var _tilesheet:Tilesheet;
	var _animations:Map<String,Point>;
	var _currentAnimation:String;
	var _currentPosition:Int;
	var _direction:Int;
	var _characterNumber:Int;

	public function new(direction:Int, characterNumber:Int) {
		super();
		_direction = direction;
		_characterNumber = characterNumber;
		_currentAnimation = "Idle";
		_currentPosition = 0;
		_animations = new Map<String, Point>();
	}

	public function setTilesheet(tilesheet:Tilesheet) {
		_tilesheet = tilesheet;
	}

	public function setAnimation(name:String) {
		_currentAnimation = name;
	}

	public function addAnimation(name:String, point:Point):Void {
		_animations.set(name, point);
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
		var range = _animations.get(_currentAnimation);
		_tilesheet.drawTiles(this.graphics, [0, 0,_currentPosition, _direction*Globals.SCALE, 0, 0, Globals.SCALE], Tilesheet.TILE_TRANS_2x2);

		_currentPosition = ((_currentPosition+1) == Std.int(range.y)) ? Std.int(range.x) : _currentPosition+1; 
	}

}