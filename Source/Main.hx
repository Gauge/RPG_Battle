package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.system.System;


class Main extends Sprite {

	public var game:Game;
	var gamegraphics:GameGraphics;

	public function new () {
		super();
		// start a new game
		game = new Game();
		gamegraphics = new GameGraphics(this);
		stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
	}

	private function keyDown(event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.NUMBER_1:
				game.lockin(Globals.PLAYER_ONE);

			case Keyboard.NUMBER_2:
				game.lockin(Globals.PLAYER_TWO);

			case Keyboard.Q:
				game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_1);

			case Keyboard.W:
				game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_2);

			case Keyboard.E:
				game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_3);

			case Keyboard.R:
				game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_4);

			case Keyboard.T:
				game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_1);

			case Keyboard.Y:
				game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_2);

			case Keyboard.U:
				game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_3);

			case Keyboard.I:
				game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_4);

			case Keyboard.O:
				game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, Globals.PLAYER_TWO, Globals.CHARACTER_3);

			case Keyboard.P:
				game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_DEFEND, -1, -1);

			case Keyboard.A:
				game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_ATTACK, Globals.PLAYER_ONE, Globals.CHARACTER_3);

			case Keyboard.S:
				game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_DEFEND, -1, -1);

			case Keyboard.ESCAPE:
				trace("quiting program");
				System.exit(0);

		}
	}
}