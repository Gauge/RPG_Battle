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
		
		if (textual) runTextual();
		else runSplashes();
		
	}

	private function runTextual() {
		Sys.command("cls");
		var message = "Welcome to RPG_Battle's textual interface v" + version + 
						"\n\nType \"help\" for the full list of commands" +
						"\nNOTE: this must be ran by a system that can supply input";
		Sys.println(message);
		
		var stdin = Sys.stdin();
 		while (true) {
 			Sys.print("RPG_Battle> ");
 			doCommand(stdin.readLine().toLowerCase());
 		}

	}

	private function doCommand(command:String) {
		var args = command.split(" ");
		switch(args[0]) {
			case "help":
				printHelp();

			case "exit":
				Sys.exit(0);

			case "clear":
				Sys.command("cls");
			
			// game variables
			case "new", "start":
				startGame();

			case "end", "quit", "terminate":
				endGame();

			case "lockin":
				lockin();

			case "attack":
				attack(args);

			case "defend":
				defend(args);

			case "ability":
				ability(args);

			case "status":
				printStatus(args);

			case "test":
				testStuff();

			default:
				Sys.println("Error: Unrecognized Command");
		}
	}

	private function testStuff():Void {
	}

	private function isActiveGame():Bool{
		if (game == null) {
			Sys.println("Error: no active game");
		}
		return (game != null);
	}

	private function formatStatusTableText(text:String):String {
		var max = 12; // this is the max size of characters to fit in one table cell
		var textlength = 0;
		var side1 = 0;
		var side2 = 0;
		var r_str = text; // return string
 
		r_str = (r_str.length > max) ? r_str.substr(0, max) : r_str;
		textlength = r_str.length;
		// calculate white space on both sides of the text
		if ((max-textlength) > 1 && (max-textlength) % 2 == 0) {
			side1 = side2 = Std.int((max-textlength)/2);
		
		} else if ((max-textlength) > 1) {
			side1 = side2 = Std.int(((max-textlength)-1)/2);
			side2++;

		} else {
			side2 = (max-textlength);
		}

		// add spaceing
		for (i in 0...side1)
			r_str = " " + r_str;
		for (i in 0...side2)
			r_str = r_str + " ";

		return r_str;
	}

	private function startGame():Void {
		game = new Game();
	}

	private function endGame(): Void { 
		if (game == null){
			Sys.println("No game to terminate");
		} else {
			Sys.println("Game terminated");
			game = null;
		}
	}

	private function lockin() { 
		if (isActiveGame()) {
			game.lockin(Globals.PLAYER_ONE);
			game.lockin(Globals.PLAYER_TWO);
			game.newTurn();
		}
	}

	private function attack(args:Array<String>):Void {
		if (isActiveGame() && args.length >= 4 && Globals.isCharacterId_S(args[1]) 
			&& Globals.isPlayerId_S(args[2]) && Globals.isCharacterId_S(args[3])) {
			var id = Std.parseInt(args[1])-1; // adjust the number by one to account for 0 index
			var t_player = Std.parseInt(args[2])-1;
			var t_character = Std.parseInt(args[3])-1;

			game.selectCharacter(Globals.PLAYER_ONE, id);
			game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, t_player, t_character);
		}
	}

	private function defend(args:Array<String>):Void {
		if (isActiveGame() && args.length >= 2 && Globals.isCharacterId_S(args[1])) {
			var id = Std.parseInt(args[1])-1;

			game.selectCharacter(Globals.PLAYER_ONE, id);
			game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_DEFEND, null, null);

		} else {
			Sys.println("Error: Missing or invalid character ID");
		}
	}

	private function ability(args:Array<String>):Void {

	}

	// prints a characters total stats
	private function printStatus(args:Array<String>) {
		var table_splitter = "----------------------------------------------------------------------------------------------------------\n";
		if (isActiveGame() && args.length >= 3 && Globals.isPlayerId_S(args[1]) && Globals.isCharacterId_S(args[2])) {
			var playerId = Std.parseInt(args[1])-1;
			var characterId = Std.parseInt(args[2])-1;
			var player = game.getPlayerById(playerId);
			var character = player.team[characterId];
						
			var actionName:String;
			if (character.getAction() == null){
				actionName = "None";
			} else { 
				switch(character.getAction().getAction()){
					case Globals.ACTION_ATTACK:
						actionName = "Attack";
					case Globals.ACTION_DEFEND:
						actionName = "Defend";
					case Globals.ACTION_ABILITY:
						actionName = "Ability";
					case Globals.ACTION_ITEM:
						actionName = "Use Item";
					default:
						actionName = "None";
				}
			}

			var message:String = 
			"\n------- Character Status -------" +
			"\nName:\t\t\t" + character.getName() +
			"\nAction Selected:\t" + actionName +
			"\nVitality:\t\t" + character.getVit() + " of " + character.getMaxVit() +
			"\nAttack Speed:\t\t" + character.getSpeed() +
			"\nAttack Damage:\t\t" + character.getDamage() +
			"\nAbility Power:\t\t" + character.getMagic() +
			"\nArmor:\t\t\t" + character.getArmor() +
			"\nMagic Resist:\t\t" + character.getResist() + "\n" +
			table_splitter + 
			"|    NAME    |    TYPE    |    VIT     |     AD     |     AP     |   ARMOR    |   RESIST   |   SPEED    |\n" + 
			table_splitter;
			var name, type, vit, ad, ap, armor, resist, speed, items;
			
			items = [character.getOnhand(), character.getOffhand(), character.getHead(), character.getBody(), character.getArms(), character.getLegs()];
			
			for(item in items){
				if (item != null) {
					name = formatStatusTableText(item.getName());
					switch(item.getType()) {
						case Globals.ITEM_ARMS:
							type = formatStatusTableText("Arms");
						case Globals.ITEM_BODY:
							type = formatStatusTableText("Body");
						case Globals.ITEM_HEAD:
							type = formatStatusTableText("Head");
						case Globals.ITEM_LEGS:
							type = formatStatusTableText("Legs");
						case Globals.ITEM_ONHAND:
							type = formatStatusTableText("On-Hand");
						case Globals.ITEM_OFFHAND:
							type = formatStatusTableText("Off-Hand");
						default:
							type = ""; // this should never happen. i do it cause its fun
					}
					vit = formatStatusTableText(""+item.getVit());
					ad = formatStatusTableText(""+item.getDamage());
					ap = formatStatusTableText(""+item.getMagic());
					armor = formatStatusTableText(""+item.getArmor());
					resist = formatStatusTableText(""+item.getMagic());
					speed = formatStatusTableText(""+item.getSpeed());

					message += "|" + name + "|" + type + "|" + vit + "|" + ad + 
						"|" + ap + "|" + armor + "|" + resist + "|" + speed + "|\n" +
						table_splitter;
				}
			}

			message += "\n| Status Effects |";
			for (effect in character.getStatusEffects()) {
				message += "\nType: " + effect.getType();
				message += "\nTicks: " + effect.getTicks();
				message += "\nMagic Damage: " + effect.getMagic();
			}

			Sys.println(message);
		} else {
			Sys.println("Error: Missing or invalid player and character ID's");
		}
	}

	private function printHelp(){
		var message = 
		"\nGeneral Commands:" +
		"\n\texit\t\t- Terminates RPG_Battle" +
		"\n\thelp\t\t- Displays a list of command" +
		"\n\tnew\t\t- Creates a new game" +
		"\n\tend\t\t- Terminates the active game" +
		"\n\tclear\t\t- Clear the screen" +
		"\n\nGame Commands:" +
		"\n\tlockin\t\t- Processes moves and starts the new turn" +
		"\n\tstatus\t\t- Prints the status of a character.\n\t\t\t    Format: status [playerId] [characterId]" +
		"\n\tattack\t\t- Character attacks a given target\n\t\t\t    Format: attack [characterId] [targetPlayerId] [targetCharacterId]" +
		"\n\tdefend\t\t- Character defends taking less damage\n\t\t\t    Format: defend [characterId]\n";
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