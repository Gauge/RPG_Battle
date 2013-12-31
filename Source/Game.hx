package;

class Game {

	// four character per team
	var team1:Array <Character>;
	var team2:Array <Character>;

	// counts the number of turns the game has been going on for
	var turn:Int;
	var gamestate:Int;

	var player1LockedIn:Bool;
	var player2LockedIn:Bool;

	public function new() {
		gamestate = Globals.GAME_INIT;
		trace("Initalizing game...");
		// create a new team of characters
		team1 = [new Character(), new Character(), new Character(), new Character()];
		team2 = [new Character(), new Character(), new Character(), new Character()];

		turn = 1;
		player1LockedIn = false;
		player2LockedIn = false;

		gamestate = Globals.GAME_TURN;
		trace("started game, turn 1");
	}

	// toggles the locked in state of the player that calls it
	// it also proforms the check to move to the next turn
	public function lockin(player:Int) {
		if (player == Globals.PLAYER_ONE){
			player1LockedIn = !player1LockedIn;
			trace((player1LockedIn) ? "player one locked in" : "player one unlocked");
		
		} else if (player == Globals.PLAYER_TWO) {
			player2LockedIn = !player2LockedIn;
			trace((player2LockedIn) ? "player two locked in" : "player two unlocked");
		}

		if (player1LockedIn && player2LockedIn) {
			updateGame();
		}
	}

	// this is where all the calculations for battle will happen
	// and all the after math will be updated
	private function updateGame() {
		gamestate = Globals.GAME_UPDATE;

		
		newTurn();
	}

	private function newTurn() {
		player1LockedIn = false;
		player2LockedIn = false;
		turn++;
		trace("Turn: " + turn);
	}
}