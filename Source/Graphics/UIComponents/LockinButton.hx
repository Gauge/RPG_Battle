package graphics.uicomponents;

import graphics.util.DarkFunctionTileSheet;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.Event;

import openfl.Assets;
import openfl.display.Tilesheet;

import flash.geom.Rectangle;
import flash.geom.Point;
import flash.Lib;

class LockinButton extends Sprite {

	private var _tilesheet:DarkFunctionTileSheet;

	public function new() {
		super();

		_tilesheet = DarkFunctionTileSheet.loadTileSheet("lockin");
		_tilesheet.setAnimation("Inactive");
		this.render();
		recalculateSize();

		this.addEventListener(MouseEvent.MOUSE_OVER, lockinHover);
		this.addEventListener(MouseEvent.MOUSE_OUT, lockinOut);
		this.addEventListener(MouseEvent.CLICK, onClick);
	}

	private function lockinHover(event:MouseEvent) :Void {
		this.graphics.clear();
		if (_tilesheet.getCurrentAnimation() == "Inactive"){
			_tilesheet.setAnimation("Transition_Over");
		}
	}

	private function lockinOut(event:MouseEvent) :Void {
		this.graphics.clear();
		if (_tilesheet.getCurrentAnimation() == "Active") {
			_tilesheet.setAnimation("Transition_Out");
		}
	}

	private function onClick(e:Event) {
		if (_tilesheet.getCurrentAnimation() == "Active"){
			_tilesheet.setAnimation("Inactive");
		}
		e.currentTarget.dispatchEvent(new Event("lockin", true));
	}

	public function recalculateSize() {
		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		var padding = (stageWidth+stageHeight)/80;

		// maintian button shape
		this.height = stageHeight/10;
		this.width = (this.height*4)/2;

		this.x = stageWidth - (this.width+padding);
		this.y = padding;
	}

	private function changeAnimation() {
		var current = _tilesheet.getCurrentAnimation();
		if (current == "Transition_Over"){ 
			_tilesheet.setAnimation("Active");
		} else if (current == "Transition_Out"){
			_tilesheet.setAnimation("Inactive");
		}
	}

	public function render():Void {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [frame.xOffset, frame.yOffset, frame.index, 1, 0, 0, 1], Tilesheet.TILE_TRANS_2x2);
		if (_tilesheet.isEndOfAnimation() == true) {
			changeAnimation();
		} 
	}
}