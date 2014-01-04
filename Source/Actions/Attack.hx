package actions;

class Attack extends Action {
	
	public function new (selPlayer:Int, selCharacter:Int, targPlayer:Int, targCharacter:Int) {
		super(selPlayer, selCharacter, Globals.ACTION_ATTACK, targPlayer, targCharacter);
	}

	// the ability doesn't add any attack power
	public override function attack(physicalDamage:Int):Int {
		return physicalDamage;
	}

	// this ability doesn't apply any defence
	public override function defend(physicalDamage:Int):Int {
		return physicalDamage;
	}

}