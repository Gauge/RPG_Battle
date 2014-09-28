package logic;

import logic.actions.Action;

class Player {

	private var playerID:Int;
	private var islockedin:Bool;
	// this is the index of the currently selected character
	// nagative one stands for nothing selected
	private var selected:Int;
	// this is the four character under the players command
	public var team:Array <Character>;


	public function new(id:Int, team:Array <String>) {
		playerID = id;
		this.team = [null, null, null, null];
		for (i in 0...team.length) {
			this.team[i] = Loader.loadCharacter(team[i]);
		}

		newTurn();
	}

	public function newTurn():Void {
		selected = -1;
		islockedin = false;
		for (i in 0...team.length) {
			team[i].resetAction();
		}
	}

	public function getPlayerID():Int {
		return playerID;
	}

	public function toggleLockedIn():Void {
		islockedin = !islockedin;
		selected = (islockedin) ? -1 : selected;
	}

	public function isLockedIn():Bool {
		return islockedin;
	}

	public function setSelected(id:Int):Void {
		selected = id;
		islockedin = false;
	}

	public function getSelected():Int {
		return selected;
	}

	public function setAction(action:Int, targetPlayer:Int, targetCharacter:Int):Void {
		if (selected == -1){
			return;
		}

		team[selected].setAction(Action.createAction(action, playerID, selected, targetPlayer, targetCharacter));
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