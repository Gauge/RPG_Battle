package actions;

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

	// this function will be overritten
	public function attack(physicalDamage:Int):Int {
		return 0;
	}

	// this function will be overritten
	public function defend(physicalDamage:Int):Int {
		return 0;
	}

	public static function createAction(a:Int, selectedPlayer:Int, selectedCharacter:Int, targetPlayer:Int, targetCharacter:Int):Action {
		if (a == Globals.ACTION_ATTACK) {
			return new Attack(selectedPlayer, selectedCharacter, targetPlayer, targetCharacter);
		}

		if (a == Globals.ACTION_DEFEND) { 
			return new Defend(selectedPlayer, selectedCharacter, targetPlayer, targetCharacter);
		}

		return new Action(selectedPlayer, selectedCharacter, a, targetPlayer, targetCharacter);
	}
}