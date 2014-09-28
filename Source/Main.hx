package;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;

import graphics.screens.ActiveGame;
import graphics.screens.MainMenu;
import graphics.screens.SplashRunner;
import logic.Game;


class Main extends Sprite {

	// textual interface
	var textual:Bool = true;
	var version:String = "1.0";
	var game:Game = null;

	// visual interface
	var main_menu:MainMenu;
	var activeGame:ActiveGame;

	public function new () {
		super();
		if (textual){
			runTextual();
		} else {
			runSplashes();
		}
	}

	private function runTextual() {
		this.visible = false; // makes the blank display vanish :D
		var message = "Welcome to RPG_Battle's textual interface v" + version + 
						"\nType \"help\" for the full list of commands" +
						"\nNOTE: this must be ran by a system that can supply input";
		Sys.println(message);
		
		var stdin = Sys.stdin();
 		while (true) {
 			Sys.print("RPG_Battle> ");
 			doCommand(stdin.readLine().toLowerCase());
 		}

	}

	private function doCommand(command:String) {
		switch(command) {
			case "h", "help":
				printHelp();

			case "exit":
				Sys.exit(0);
			
			case "new", "new game", "start", "start game":
				startGame();

			case "end", "end game", "quit", "quit game", "terminate", "terminate game":
				endGame();

			case "lockin":
				lockin();

			default:
				Sys.println("Error: Unrecognized Command");
		}
	}

	private function startGame() {
		game = new Game();
	}

	private function endGame() { 
		if (game == null){
			Sys.println("No game to terminate");
		} else {
			Sys.println("Game terminated");
			game = null;
		}
	}

	private function lockin() { 
		if (game != null) {
			game.lockin(Globals.PLAYER_ONE);
			game.lockin(Globals.PLAYER_TWO);
			game.newTurn();
		} else {
			Sys.println("Error: no active game");
		}
	}

	private function printHelp(){
		var message = 
		"\nGeneral Commands:" +
		"\n\texit\t- Terminates RPG_Battle" +
		"\n\thelp\t- Displays a list of command" +
		"\n\tnew\t- Creates a new game" +
		"\n\tend\t- Terminates the active game" +
		"\n\nGame Commands:" +
		"\n\tlockin\t- Processes moves and starts the new turn\n";
		Sys.println(message);
	}


// ############## VISUAL INTERFACE ##############

	private function runSplashes() {
		var splashes = new SplashRunner(['GGsplash.png','ABsplash.png','RPGsplash.png']); // add any splashscreen filenames to this list to auto add them to the splashscreen loop
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
	}	
}