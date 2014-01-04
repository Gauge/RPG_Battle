package;

class Game {

	var turn:Int;
	var gamestate:Int;

	var player1:Player;
	var player2:Player;

	public function new() {
		gamestate = Globals.GAME_INIT;
		trace("Initalizing game...");
		
		turn = 0;
		player1 = new Player(Globals.PLAYER_ONE);
		player2 = new Player(Globals.PLAYER_TWO);

		newTurn();
	}

	// toggles the locked in state of the player that calls it
	// it also proforms the check to move to the next turn
	public function lockin(p:Int) {
		if (gamestate != Globals.GAME_TURN) {
			return;
		}

		var player = getPlayerById(p);
		player.toggleLockedIn();
		trace(player.isLockedIn() ? "player " + p + " locked in" : "player " + p + " unlocked");

		if (player1.isLockedIn() && player2.isLockedIn()) {
			updateGame();
		}
	}

	// highlights a character to apply an action to
	public function selectCharacter(p:Int, characterID:Int) {
		if (gamestate != Globals.GAME_TURN){
			return; 
		}

		var player = getPlayerById(p);
		player.setSelected(characterID);
		trace("player " + p + " selected character " + (player.getSelected()+1));
	}

	public function selectAction(selectedPlayer:Int, action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (gamestate != Globals.GAME_TURN){
			return;
		}

		var player = getPlayerById(selectedPlayer);
		player.setAction(action, targetPlayer, targetCharacter);
		trace("player " + selectedPlayer + " selected: " + (action == Globals.ACTION_ATTACK ? "ATTACK" : (action == Globals.ACTION_DEFEND ? "DEFEND" : "OTHER")) + 
			" for Character " + (player.getSelected() == -1 ? "UNSELECTED" : (player.getSelected()+1)+""));
	}


	// this is where all the calculations for battle will happen
	// and all the after math will be updated
	private function updateGame() {
		gamestate = Globals.GAME_UPDATE;

		var actions = getSortedActions();

		for (i in 0...actions.length){
			var action = actions[i];
			var splayer = getPlayerById(action.getSelectedPlayer());
			var tplayer = getPlayerById(action.getTargetPlayer());
			
			var schar = splayer.team[action.getSelectedCharacter()];
			var tchar = tplayer.team[action.getTargetCharacter()];
			
			if (tchar.isDead()) {
				for(newTarget in 0...tplayer.team.length) {
					if (!tplayer.team[newTarget].isDead()){
						tchar = tplayer.team[newTarget];
					}
				}
			}
			
			if (action.getAction() != Globals.ACTION_DEFEND){
				schar.getAction().report.damage_dealt = tchar.defend(schar.attack());
			}
		}

		// after log
		var actions = getSortedActions();
		for (i in 0...actions.length){
			trace("player " + actions[i].getSelectedPlayer() + " character " + (actions[i].getSelectedCharacter()+1) + 
				"\'s attack did " + actions[i].report.damage_dealt + " damage to player " + actions[i].getTargetPlayer() + 
				" character " + (actions[i].getTargetPlayer()+1));
		}
		
		newTurn();
	}

	private function getPlayerById(id:Int) {
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

		// adds the first list item to the sorted list if one exists
		if (list.length > 0) actions.push(list[0]);

		for (i in 1...list.length) {
			var flag = false;
			for (i2 in 0...actions.length) {
				
				if (list[i].report.attack_speed < actions[i2].report.attack_speed){
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

	// sets everything up for the next turn
	private function newTurn() {
		player1.newTurn();
		player2.newTurn();
		turn++;
		gamestate = Globals.GAME_TURN;
		trace("\n-------------------------------Turn " + turn +"--------------------------------------");
		// list players
		trace("player 1");
		for(i in 0...player1.team.length){
			trace("Character " + (i+1) + " Vitality " + player1.team[i].getVitality() + (player1.team[i].isDead() ? " DEAD" : " ALIVE"));
		}

		trace("player 2");
		for(i in 0...player2.team.length){
			trace("Character " + (i+1) + " Vitality " + player2.team[i].getVitality() + (player2.team[i].isDead() ? " DEAD" : " ALIVE"));
		}
	}
}