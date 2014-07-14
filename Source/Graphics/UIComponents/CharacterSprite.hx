package graphics.uicomponents;
import openfl.display.Tilesheet;
import openfl.Assets;
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.Lib;
import flash.filters.GlowFilter;
import flash.filters.BitmapFilterQuality;
import graphics.util.DarkFunctionTileSheet;
import flash.events.MouseEvent;
import flash.events.Event;
import motion.Actuate;

class CharacterSprite extends Sprite {

	var _tilesheet:DarkFunctionTileSheet;
	var _direction:Int;
	var _characterNumber:Int;
	var _characterScale:Float;
	var _hpBar:HpBar;
	var _callback:String;


	public function new(direction:Int, characterNumber:Int, tile:Dynamic, style:Dynamic) {
		super();
		_tilesheet = new DarkFunctionTileSheet(tile, style);
		_direction = direction;
		_characterNumber = characterNumber+1;
		_characterScale = 1;
		_callback = "";
		this.addEventListener(MouseEvent.CLICK, onClick);
		this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
	}

	public function _init_(maxVit:Int, vit:Int):Void {
		_hpBar = new HpBar(maxVit, vit);
		this.addChild(_hpBar);
	}

	public function getDirection():Int {
		return _direction;
	}

	public function getCharacterNumber():Int {
		return _characterNumber;
	}

	public function getAnimations():Array<String>{
		return _tilesheet.getAnimations();
	}

	public function getCurrentAnimation():String {
		return _tilesheet.getCurrentAnimation();
	}

	public function setAnimation(name:String) {
		_tilesheet.setAnimation(name);
	}

	public function setAnimationWithCallBack(name:String, callback:String){
		_tilesheet.setAnimation(name);
		_callback = callback;
	}

	public function recalculateSize():Void {
		var tile = _tilesheet.getTileRect(0);
		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		var startingHeight = stageHeight/3;
		var groundHeight = (stageHeight-startingHeight);

		// set scale
		var charnum = ((_direction == Globals.LEFT) ? _characterNumber : (Math.abs(_characterNumber-4)+1));
		_characterScale = ((groundHeight)/(tile.height*4)) - (charnum*0.05); // TODO

		// set padding
		var widthPadding = stageWidth/14;
		var hightPadding = groundHeight/6;



		this.x = (_direction == Globals.LEFT) ? ((stageWidth-tile.width)-widthPadding)-((charnum*50)/3) : 
												(widthPadding+Globals.BASE_SCREEN_OFFSET) + ((charnum*50)/3);
		
		this.y = (_direction == Globals.LEFT) ? (startingHeight+(hightPadding*(Math.abs(_characterNumber-4)+1) )) : 
												(startingHeight+(hightPadding*_characterNumber));

		// calculate health position and size
		_hpBar.x = (((_direction == Globals.LEFT)? 50 : -65)*_characterScale);
		_hpBar.y = 0;
		_hpBar.width = (12*_characterScale);
		_hpBar.height = (35*_characterScale);
	}

	public function update(damage:Int):Void {
		_hpBar.update(damage);
	}

	public function render():Void {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		if (_tilesheet.isEndOfAnimation() && _callback != "") { 
			this.dispatchEvent(new Event(_callback, true));
			_callback = "";
		}
		_tilesheet.drawTiles(this.graphics, [((_direction*-1)*frame.xOffset), frame.yOffset, frame.index, _direction*_characterScale, 0, 0, _characterScale], Tilesheet.TILE_TRANS_2x2); 
		_hpBar.render();
		// var bounds = getRect(this);
		// graphics.lineStyle(1, 0xFF0000, .3);
		// graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		// graphics.endFill();
	}

	private function onMouseOver(e:MouseEvent) {
		// add some cool effect
	}

	private function onMouseOut(e:MouseEvent) {
		// kill the cool effect
	}

	private function onClick(e:MouseEvent) {
		this.dispatchEvent(new Event("character_select", true));
	}
}