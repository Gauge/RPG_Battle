package;

class Game {

	var turn:Int;
	var gamestate:Int;

	var player1:Player;
	var player2:Player;

	public function new() {
		gamestate = Globals.GAME_INIT;
		trace("Initalizing game...");
		
		turn = 1;
		player1 = new Player(Globals.PLAYER_ONE);
		player2 = new Player(Globals.PLAYER_TWO);

		gamestate = Globals.GAME_TURN;
		trace("started game, turn 1");
	}

	// toggles the locked in state of the player that calls it
	// it also proforms the check to move to the next turn
	public function lockin(player:Int) {
		if (gamestate != Globals.GAME_TURN) {
			return;
		}
		
		if (player == Globals.PLAYER_ONE){
			player1.toggleLockedIn();
			trace((player1.isLockedIn()) ? "player one locked in" : "player one unlocked");
		} 

		else if (player == Globals.PLAYER_TWO) {
			player2.toggleLockedIn();
			trace((player2.isLockedIn()) ? "player two locked in" : "player two unlocked");
		}

		if (player1.isLockedIn() && player2.isLockedIn()) {
			updateGame();
		}
	}

	// highlights a character to apply an action to
	public function selectCharacter(player:Int, characterID:Int) {
		if (gamestate != Globals.GAME_TURN){
			return; 
		}

		if (player == Globals.PLAYER_ONE) { 
			player1.setSelected(characterID);
			trace("player 1 selected character " + (player1.getSelected()+1));
			trace("plaer 1 locked in: " + player1.isLockedIn());
		}

		else if (player == Globals.PLAYER_TWO) { 
			player2.setSelected(characterID);
			trace("player 2 selected character " + (player2.getSelected()+1));
			trace("plaer 2 locked in: " + player2.isLockedIn());
		}
	}

	public function selectAction(selectedPlayer:Int, action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (gamestate != Globals.GAME_TURN){
			return;
		}

		if (selectedPlayer == Globals.PLAYER_ONE) {
			player1.setAction(action, targetPlayer, targetCharacter);
		}

		else if (selectedPlayer == Globals.PLAYER_TWO){
			player2.setAction(action, targetPlayer, targetCharacter);
		}
	}


	// this is where all the calculations for battle will happen
	// and all the after math will be updated
	private function updateGame() {
		gamestate = Globals.GAME_UPDATE;

		var actions = getSortedActions();

		for (i in 0...actions.length){
			var action = actions[i];
			var splayer = getPlayerOffId(action.getSelectedPlayer());
			var tplayer = getPlayerOffId(action.getTargetPlayer());
			var schar = splayer.team[action.getSelectedCharacter()];
			var tchar = tplayer.team[action.getTargetCharacter()];

			if (action.getAction() == Globals.ACTION_ATTACK) {
				schar.getAction().report.damage_dealt = tchar.takeDamage(schar.getAttackPower());
			}
		}

		// after log
		actions = getSortedActions();
		for (i in 0...actions.length){
			trace("player " + actions[i].getSelectedPlayer() + " character " + (actions[i].getSelectedCharacter()+1) + 
				"\'s attack did " + actions[i].report.damage_dealt + " damage to player " + actions[i].getTargetPlayer() + 
				" character " + (actions[i].getTargetPlayer()+1));
		}
		
		newTurn();
	}

	private function getPlayerOffId(id:Int) {
		if (id == Globals.PLAYER_ONE) {
			return player1;
		} else {
			return player2;
		}
	}

	public function getSortedActions() {
				// sort actions by attack speed
		var actions = [];

		// connect lists into one
		var list = player1.getActionList();
		var temp = player2.getActionList();
		for (i in 0...temp.length) {
			list.push(temp[i]);
		}

		actions.push(list[0]);

		for (i in 1...list.length) {
			for (i2 in 0...actions.length) {
				
				if (list[i].report.attack_speed < actions[i2].report.attack_speed){
					actions.insert(i2, list[i]);
					break;
				} 

				else if (i2 == list.length-1) {
					actions.push(list[i]);
				}
			}
		}

		return actions;
	}

	// sets everything up for the next turn
	private function newTurn() {
		player1.newTurn();
		player2.newTurn();
		turn++;
		gamestate = Globals.GAME_TURN;
		trace("Turn: " + turn);
		// list players
		trace("player 1");
		for(i in 0...player1.team.length){
			trace("Character " + (i+1) + " Vitality " + player1.team[i].getVitality());
		}

		trace("player 2");
		for(i in 0...player2.team.length){
			trace("Character " + (i+1) + " Vitality " + player2.team[i].getVitality());
		}
	}
}