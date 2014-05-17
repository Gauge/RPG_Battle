package graphics.uicomponents;

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

	private var tilesheet:Tilesheet;

	public function new() {
		super();

		tilesheet = new Tilesheet(Assets.getBitmapData('assets/lockin_btn.png'));
		tilesheet.addTileRect(new Rectangle(0, 0, 30, 20));
		tilesheet.addTileRect(new Rectangle(30, 0, 30, 20));
		tilesheet.drawTiles(this.graphics, [0,0,0]);
		recalculateSize();

		this.addEventListener(MouseEvent.MOUSE_OVER, lockinHover);
	}

	private function lockinHover(event:MouseEvent) :Void {
		this.graphics.clear();
		tilesheet.drawTiles(this.graphics, [0,0,1]);
		this.addEventListener(MouseEvent.MOUSE_OUT, lockinOut);
	}

	private function lockinOut(event:MouseEvent) :Void {
		this.graphics.clear();
		tilesheet.drawTiles(this.graphics, [0,0,0]);
		this.removeEventListener(MouseEvent.MOUSE_OUT, lockinOut);
	}

	public function recalculateSize() {
		var stageWidth = Lib.current.stage.stageWidth;
		var stageHeight = Lib.current.stage.stageHeight;
		var padding = (stageWidth+stageHeight)/80;

		// maintian button shape
		this.height = stageHeight/10;
		this.width = (this.height*30)/20;

		this.x = stageWidth - (this.width+padding);
		this.y = padding;
	}
}