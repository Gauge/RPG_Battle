package;

class Player {

	private var playerID:Int;
	private var islockedin:Bool;
	// this is the index of the currently selected character
	// nagative one stands for nothing selected
	public var selected:Int;
	// this is the four character under the players command
	public var team:Array <Character>;


	public function new(id:Int) {
		playerID = id;
		team = [new Character(), new Character(), new Character(), new Character()];
		newTurn();
	}

	public function newTurn() {
		selected = -1;
		islockedin = false;
		for (i in 0...team.length) {
			team[i].resetAction();
		}
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

	public function setAction(action:Int, targetPlayer:Int, targetCharacter:Int) {
		if (selected == -1){
			return;
		}

		team[selected].setAction(new Action(playerID, selected, action, targetPlayer, targetCharacter));
	}

	public function getActionList():Array <Action> {
		var actions = [];
		for (i in 0...team.length) {
			var a = team[i].getAction();
			if (a != null){
				actions.push(a);
			}
		}
		return actions;
	}
}