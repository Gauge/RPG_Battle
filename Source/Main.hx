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
		gamegraphics = new GameGraphics();
		stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
	}

	private function keyDown(event:KeyboardEvent):Void {
		trace(event.keyCode);
		switch (event.keyCode) {
			case Keyboard.NUMBER_1:
				game.lockin(Globals.PLAYER_ONE);

			case Keyboard.NUMBER_2:
				game.lockin(Globals.PLAYER_TWO);

			case 65:
				game.selectCharacter(Globals.PLAYER_ONE, 0);

			case 66:
				game.selectCharacter(Globals.PLAYER_ONE, 1);

			case 67:
				game.selectCharacter(Globals.PLAYER_ONE, 2);

			case 68:
				game.selectCharacter(Globals.PLAYER_ONE, 3);

			case 69:
				game.selectCharacter(Globals.PLAYER_TWO, 0);

			case 70:
				game.selectCharacter(Globals.PLAYER_TWO, 1);

			case 71:
				game.selectCharacter(Globals.PLAYER_TWO, 2);

			case 72:
				game.selectCharacter(Globals.PLAYER_TWO, 3);

			case Keyboard.ESCAPE:
				trace("quiting program");
				System.exit(0);

		}
	}
}