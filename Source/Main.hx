package;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import graphics.screens.ActiveGame;
import graphics.screens.MainMenu;
import graphics.util.DarkFunctionTileSheet;

class Main extends Sprite {

	var main_menu:MainMenu;
	var activeGame:ActiveGame;

	public function new () {
		super();

		var main_menu = new MainMenu();
		addChild(main_menu);
		addEventListener("quit", quit);
		addEventListener("new_game", new_game);
		addEventListener("game_over", game_over);
	}

	private function quit(e : Event) { 
		System.exit(0); 
	}
	private function game_over(e : Event)	{trace('caught game_over call');}

	
	private function new_game(e : Event) { 
		// remove old view
		removeChild(main_menu);
		// add current view
		activeGame = new ActiveGame(); 
		addChild(activeGame); 
	}
	
}