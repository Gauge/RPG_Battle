package;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import graphics.GameGraphics;
import graphics.MainMenu;

class Main extends Sprite {

	var gamegraphics:GameGraphics;

	public function new () {
		super();
		var main_menu = new MainMenu();
		addChild(main_menu);
		addEventListener("quit", quit);
		addEventListener("new_game", new_game);
	}

	private function quit(e : Event) 		{ System.exit(0); }

	private function new_game(e : Event) 	{ gamegraphics = new GameGraphics(); addChild(gamegraphics); }
	
}