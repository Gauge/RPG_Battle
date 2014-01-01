package;

class Player {

	private var playerID:Int;
	private var islockedin:Bool;
	// this is the index of the currently selected character
	// nagative one stands for nothing selected
	public var selected:Int;
	// this is the four character under the players command
	public var team:Array <Character>;
	public var actions:Array <Action>;


	public function new(id:Int) {
		playerID = id;
		team = [new Character(), new Character(), new Character(), new Character()];
		newTurn();
	}

	public function getPlayerID() {
		return playerID;
	}

	public function toggleLockedIn() {
		islockedin = !islockedin;
	}

	public function isLockedIn() {
		return islockedin;
	}

	public function newTurn() {
		selected = -1;
		islockedin = false;
		actions = [null, null, null, null];
	}

	public function setAction(action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (selected == -1){
			return;
		}

		actions[selected] = new Action(playerID, selected, action, targetPlayer, targetCharacter);
	}
}