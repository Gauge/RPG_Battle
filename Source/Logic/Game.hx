package logic;

import logic.actions.Action;
import flash.Lib;
import flash.events.Event;
import flash.events.EventDispatcher;

class Game {

	private var turn:Int;
	public var gamestate:Int;

	private var player1:Player;
	private var player2:Player;

	public function new() {
		gamestate = Globals.GAME_INIT;
		Sys.println("Initalizing game...");
		
		turn = 0;
		player1 = Loader.loadPlayer(Globals.PLAYER_ONE, "player1");
		player2 = Loader.loadPlayer(Globals.PLAYER_TWO, "player2");

		newTurn();
	}

	// toggles the locked in state of the player that calls it
	// it also proforms the check to move to the next turn
	public function lockin(p:Int):Void {
		if (gamestate != Globals.GAME_TURN) return;

		var player = getPlayerById(p);
		player.toggleLockedIn();
		Sys.println(player.isLockedIn() ? "player " + p + " locked in" : "player " + p + " unlocked");

		if (player1.isLockedIn() && player2.isLockedIn()) {
			updateGame();
		}
	}

	// highlights a character to apply an action to
	public function selectCharacter(p:Int, characterID:Int):Void {
		if (gamestate != Globals.GAME_TURN) return; 

		var player = getPlayerById(p);
		player.setSelected(characterID);
		Sys.println("player " + (p+1) + " selected character " + (player.getSelected()+1));
	}

	// sets an action for the currently selected character
	public function selectAction(selectedPlayer:Int, action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (gamestate != Globals.GAME_TURN) return;

		var player = getPlayerById(selectedPlayer);
		player.setAction(action, targetPlayer, targetCharacter);
		Sys.println("player " + (selectedPlayer+1) + " selected: " + (action == Globals.ACTION_ATTACK ? "ATTACK" : (action == Globals.ACTION_DEFEND ? "DEFEND" : "OTHER")) + 
			" for Character " + (player.getSelected() == -1 ? "UNSELECTED" : (player.getSelected()+1)+""));
	}


	// this is where all the calculations for battle will happen
	// and all the after math will be updated
	private function updateGame():Void {
		gamestate = Globals.GAME_UPDATE;
		Sys.println("Processing unit actions...");
		var actions = getSortedActions();
		for (i in 0...actions.length){
			var action = actions[i];
			if (action.getAction() != Globals.ACTION_DEFEND){
				var splayer = getPlayerById(action.getSelectedPlayer());
				var tplayer = getPlayerById(action.getTargetPlayer());

				var schar = splayer.team[action.getSelectedCharacter()];
				var tchar = tplayer.team[action.getTargetCharacter()];
				
				if (tchar.isDead()) {
					for(newTarget in 0...tplayer.team.length) {
						if (!tplayer.team[newTarget].isDead()){
							tchar = tplayer.team[newTarget];
							var newAction = Action.createAction(action.getAction(), action.getSelectedPlayer(), action.getSelectedCharacter(), action.getTargetPlayer(), newTarget);
							schar.setAction(newAction);
						}
					}
				}
				
				if (schar.isDead() == false){
					schar.getAction().report.damage_dealt = tchar.defend(schar.attack(), 0);
					schar.getAction().report.died_this_turn = tchar.isDead();
				} else {
					schar.resetAction();
				}
			}
		}

		// after log
		var actions = getSortedActions();

		for (i in 0...actions.length){
			if (actions[i].getAction() != Globals.ACTION_DEFEND){
				Sys.println("player " + (actions[i].getSelectedPlayer()+1) + " character " + (actions[i].getSelectedCharacter()+1) + 
					"\'s attack did " + actions[i].report.damage_dealt + " damage to player " + (actions[i].getTargetPlayer()+1)+ 
					" character " + (actions[i].getTargetCharacter()+1));
			}
		}

		// process status effects
		for (i in 0...player1.team.length) {
			var c = player1.team[i];
			for (effect in c.getStatusEffects()){
				var damage = c.defend(0, effect.getMagic());
				Sys.println("player 1 character" + (i+1) + " took "+ damage + " from " + effect.getType());
				effect.update();
			}
		}

		for (i in 0...player2.team.length) {
			var c = player2.team[i];
			for (effect in c.getStatusEffects()){
				var damage = c.defend(0, effect.getMagic());
				Sys.println("player 2 character" + (i+1) + " took "+ damage + " from " + effect.getType());
				effect.update();
			}
		}

		Sys.println("Finished processing actions");
		gamestate = Globals.GAME_DISPLAY_ROUND;
	}

	public function getPlayerById(id:Int):Player {
		if (id == Globals.PLAYER_ONE) {
			return player1;
		} else {
			return player2;
		}
	}

	public function getSortedActions():Array<Action> {
		// sort actions by attack speed
		var actions = [];

		// connect lists into one
		var list = player1.getActionList();
		var temp = player2.getActionList();
		for (i in 0...temp.length) {
			list.push(temp[i]);
		}

		// adds the first list item to the sorted list if one exists
		if (list.length > 0) actions.push(list[0]);

		for (i in 1...list.length) {
			var flag = false;
			for (i2 in 0...actions.length) {
				
				if (list[i].report.speed < actions[i2].report.speed){
					actions.insert(i2, list[i]);
					flag = true;
					break;
				}
			}
			if (!flag) {
				actions.push(list[i]);
			}
		}
		return actions;
	}

	private function isGameover():Bool {
		var team1 = true;
		var team2 = true;
		for (c in player1.team){
			if (c.isDead() == false){
				team1 = false;
				break;
			}	
		}
		for (c in player2.team){
			if (c.isDead() == false){
				team2 = false;
				break;
			}		
		}
		return (team1 || team2);
	}

	// sets everything up for the next turn
	public function newTurn() {
		player1.newTurn();
		player2.newTurn();
		turn++;
		if (!isGameover()) {
			gamestate = Globals.GAME_TURN;
			Sys.println("\n------------------ Turn " + turn +" ------------------");
			// list players
			Sys.println("Player 1");
			for(i in 0...player1.team.length){
				Sys.println("\tCharacter " + (i+1) + " Vitality " + player1.team[i].getVit() + (player1.team[i].isDead() ? " DEAD" : " ALIVE"));
			}

			Sys.println("Player 2");
			for(i in 0...player2.team.length){
				Sys.println("\tCharacter " + (i+1) + " Vitality " + player2.team[i].getVit() + (player2.team[i].isDead() ? " DEAD" : " ALIVE"));
			}
		} else {
			gamestate = Globals.GAME_OVER;
			var dispatch = new EventDispatcher();
			dispatch.dispatchEvent(new Event("game_over", true));
			Sys.println("Game over on turn: " + turn + "|" + dispatch);
		}
		Sys.println("");
	}
}