package graphics;

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

class LockinButton extends Sprite {

	private var tilesheet:Tilesheet;

	public function new() {
		super();
		this.x = 700;
		this.y = 30;

		tilesheet = new Tilesheet(Assets.getBitmapData('assets/lockin_btn.png'));
		tilesheet.addTileRect(new Rectangle(0, 0, 30, 20));
		tilesheet.addTileRect(new Rectangle(30, 0, 30, 20));
		tilesheet.drawTiles(this.graphics, [0,0,0,3], Tilesheet.TILE_SCALE);

		this.addEventListener(MouseEvent.MOUSE_OVER, lockinHover);
	}

	private function lockinHover(event:MouseEvent) :Void {
		this.graphics.clear();
		tilesheet.drawTiles(this.graphics, [0,0,1,3], Tilesheet.TILE_SCALE);
		this.addEventListener(MouseEvent.MOUSE_OUT, lockinOut);
	}

	private function lockinOut(event:MouseEvent) :Void {
		this.graphics.clear();
		tilesheet.drawTiles(this.graphics, [0,0,0,3], Tilesheet.TILE_SCALE);
		this.removeEventListener(MouseEvent.MOUSE_OUT, lockinOut);
	}
}