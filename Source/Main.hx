package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.system.System;
import graphics.GameGraphics;
import MainMenu;

class Main extends Sprite {

	var gamegraphics:GameGraphics;

	public function new () {
		super();
		var main_menu = new MainMenu();
		addChild(main_menu);
		// gamegraphics = new GameGraphics();
		// addChild(gamegraphics);
	}
	
}