package actions;

class Defend extends Action {

	public function new (selPlayer:Int, selCharacter:Int, targPlayer:Int, targCharacter:Int) {
		super(selPlayer, selCharacter, Globals.ACTION_DEFEND, targPlayer, targCharacter);
	}

	// defence stance does not do damage
	public override function attack(physicalDamage:Int):Int {
		return 0;
	}

	// cuts attack damage in half
	public override function defend(physicalDamage:Int):Int {
		return Math.round(physicalDamage/2);
	}

}