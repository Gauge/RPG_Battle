package;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import graphics.GameGraphics;
import MainMenu;

class Main extends Sprite {

	var gamegraphics:GameGraphics;

	public function new () {
		super();
		var main_menu = new MainMenu();
		addChild(main_menu);
		addEventListener("quit", quit);
		addEventListener("new_game", new_game);
		addEventListener("game_over", game_over);
	}

	private function quit(e : Event) 		{ System.exit(0); }

	private function new_game(e : Event) 	{ gamegraphics = new GameGraphics(); addChild(gamegraphics); }


	private function game_over(e : Event)	{trace('caught game_over call');}
	
}