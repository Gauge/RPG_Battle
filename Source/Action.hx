package;

class Action {

	private var selectedPlayer:Int;
	private var selectedCharacter:Int;
	private var action:Int;
	private var targetPlayer:Int;
	private var targetCharacter:Int;
	public var report:Report;
	
	public function new (selPlayer:Int, selCharacter:Int, act:Int, targPlayer:Int, targCharacter:Int) {
		selectedPlayer = selPlayer;
		selectedCharacter = selCharacter;
		action = act;
		targetPlayer = targPlayer;
		targetCharacter = targCharacter;
		report = new Report();
	}

	public function getSelectedPlayer():Int {
		return selectedPlayer;
	}

	public function getSelectedCharacter():Int {
		return selectedCharacter;
	}

	public function getAction():Int {
		return action;
	}

	public function getTargetPlayer():Int {
		return targetPlayer;
	}

	public function getTargetCharacter():Int {
		return targetCharacter;
	}
}