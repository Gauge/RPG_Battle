package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.system.System;


class Main extends Sprite {

	var game:Game;
	var gamegraphics:GameGraphics;

	public function new () {
		super();
		// start a new game
		game = new Game();
		stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		gamegraphics = new GameGraphics();
	}

	private function keyDown(event:KeyboardEvent):Void {

		switch (event.keyCode) {
			case Keyboard.NUMBER_1:
				game.lockin(Globals.PLAYER_ONE);

			case Keyboard.NUMBER_2:
				game.lockin(Globals.PLAYER_TWO);

			case Keyboard.ESCAPE:
				trace("quiting program");
				System.exit(0);

		}
	}
}