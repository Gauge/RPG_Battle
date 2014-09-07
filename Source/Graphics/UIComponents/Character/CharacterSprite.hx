package graphics.uicomponents.character;
import openfl.display.Tilesheet;
import openfl.Assets;
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.Lib;
import graphics.util.DarkFunctionTileSheet;
import flash.events.MouseEvent;
import flash.events.Event;

class CharacterSprite extends Sprite {

	var _tilesheet:DarkFunctionTileSheet;
	var _characterNumber:Int;
	var _direction:Int;
	var _hpBar:HpBar;
	var _callback:String;

	public function new(direction:Int, characterNumber:Int, tile:Dynamic, style:Dynamic) {
		super();
		
		_tilesheet = new DarkFunctionTileSheet(tile, style);
		_characterNumber = characterNumber+1;
		_direction = direction;
		_callback = "";

		this.addEventListener(MouseEvent.CLICK, onClick);
	}

	public function _init_(maxVit:Int, vit:Int):Void {
		_hpBar = new HpBar(maxVit, vit);
		this.addChild(_hpBar);
		this.update(0); // this initializes the color for the hp bar
		this.recalculateSize();
		this.setAnimation("idle");
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
		render();
		// get character number
		var charnum = ((_direction == Globals.LEFT) ? _characterNumber : (Math.abs(_characterNumber-4)+1));

		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		var startingHeight = stageHeight/3;
		var groundHeight = (stageHeight-startingHeight);

		// set padding
		var widthPadding = stageWidth/14;
		var heightPadding = groundHeight/6;

		var characterHeight = groundHeight/6;
		var characterWidth = characterHeight*22/37;

		this.x = (_direction == Globals.LEFT) ? ((stageWidth-characterWidth)-widthPadding)-((charnum*characterWidth)/3) : 
												(widthPadding+Globals.BASE_SCREEN_OFFSET) + ((charnum*characterWidth)/3);
		
		this.y = (_direction == Globals.LEFT) ? (startingHeight+(heightPadding*(Math.abs(_characterNumber-4)+1) )) : 
												(startingHeight+(heightPadding*_characterNumber));
		this.height = characterHeight;
		this.width = characterWidth;

		var hpBarWidth = characterWidth/4;
		var hpBarHeight = characterHeight/2;

		// calculate health position and size
		_hpBar.x = (((_direction == Globals.LEFT)? 0: -hpBarWidth));
		_hpBar.y = 0;
		_hpBar.width = hpBarWidth;
		_hpBar.height = hpBarHeight;
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
		//                                                 v--- this can be removed if the character sheet gets fliped
		_tilesheet.drawTiles(this.graphics, [((_direction*-1)*frame.xOffset), frame.yOffset, frame.index, _direction, 0, 0, 1], Tilesheet.TILE_TRANS_2x2); 
		_hpBar.render();
	}

	private function onClick(e:MouseEvent) {
		this.dispatchEvent(new Event("character_select", true));
	}
}