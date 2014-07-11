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

		this.addEventListener(MouseEvent.ROLL_OVER, lockinHover);
		this.addEventListener(MouseEvent.ROLL_OUT, lockinOut);
		this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function lockinHover(event:MouseEvent) :Void {
		_tilesheet.setAnimation("Active");
	}

	private function lockinOut(event:MouseEvent): Void {
		_tilesheet.setAnimation("Inactive");
	}

	private function onMouseDown(e:MouseEvent): Void {
		_tilesheet.setAnimation("Inactive");
	}

	private function onMouseUp(e:MouseEvent): Void {
		_tilesheet.setAnimation("Active");
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

	public function render():Void {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [frame.xOffset, frame.yOffset, frame.index, 1, 0, 0, 1], Tilesheet.TILE_TRANS_2x2);

		if (_tilesheet.getCurrentAnimation() == "Clicked" && _tilesheet.isEndOfAnimation()) {
			_tilesheet.setAnimation("Active");
		}

	}
}