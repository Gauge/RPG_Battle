package;

class Action {

	private var selectedPlayer:Int;
	private var selectedCharacter:Int;
	private var action:Int;
	private var targetPlayer:Int;
	private var targetCharacter:Int;
	
	public function new (selPlayer:Int, selCharacter:Int, act:Int, targPlayer:Int, targCharacter:Int) {
		selectedPlayer = selPlayer;
		selectedCharacter = selCharacter;
		action = act;
		targetPlayer = targPlayer;
		targetCharacter = targCharacter;
	}

	public function getSelectedPlayer() {
		return selectedPlayer;
	}

	public function getSelectedCharacter() {
		return selectedCharacter;
	}

	public function getAction() {
		return action;
	}

	public function getTargetPlayer() {
		return targetPlayer;
	}

	public function getTargetCharacter() {
		return targetCharacter;
	}
}