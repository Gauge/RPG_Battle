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
			player1.selected = characterID;
			trace("player 1 selected character " + (characterID+1));
		}

		else if (player == Globals.PLAYER_TWO) { 
			player2.selected = characterID; 
			trace("player 2 selected character " + (characterID+1));
		}
	}

	public function selectAction(selectedPlayer:Int, action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (gamestate != Globals.GAME_TURN){
			return;
		}

		if (selectedPlayer == Globals.PLAYER_ONE) {
			player1.setAction(action, targetPlayer, targetCharacter);
			trace(player1.actions);
		}

		else if (selectedPlayer == Globals.PLAYER_TWO){
			player2.setAction(action, targetPlayer, targetCharacter);
			trace(player2.actions);
		}
	}


	// this is where all the calculations for battle will happen
	// and all the after math will be updated
	private function updateGame() {
		gamestate = Globals.GAME_UPDATE;

		
		newTurn();
	}

	// sets everything up for the next turn
	private function newTurn() {
		player1.newTurn();
		player2.newTurn();
		turn++;
		gamestate = Globals.GAME_TURN;
		trace("Turn: " + turn);
	}
}