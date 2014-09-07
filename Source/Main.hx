package;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;

import graphics.screens.ActiveGame;
import graphics.screens.MainMenu;
import graphics.screens.SplashRunner;

import graphics.util.TextVisualizer;


class Main extends Sprite {

	var main_menu:MainMenu;
	var activeGame:ActiveGame;

	public function new () {
		super();
		runSplashes();
	}

	private function runSplashes() {
		// add any splashscreen filenames to this list to auto add them to the splashscreen loop
		var splashes = new SplashRunner(['GGsplash.png','ABsplash.png','RPGsplash.png']);
		addChild(splashes);
		addEventListener('splash_complete', build_main_menu);
	}

	private function build_main_menu(e : Event) {
		main_menu = new MainMenu();
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
		main_menu.stop_music();
		removeChild(main_menu);
		// add current view
		activeGame = new ActiveGame(); 
		addChildAt(activeGame, 1);
		//animate

		var thing = new TextAnimation("yayayaya", 100, 100);
		addChild(thing);
		thing.move(100, 100);
	}
	
}