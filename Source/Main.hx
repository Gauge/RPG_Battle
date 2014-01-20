package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.system.System;
import graphics.GameGraphics;

class Main extends Sprite {

	var gamegraphics:GameGraphics;

	public function new () {
		super();
		gamegraphics = new GameGraphics();
		addChild(gamegraphics);
	}
	
}