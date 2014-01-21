package actions;

class Defend extends Action {

	public function new (selPlayer:Int, selCharacter:Int) {
		super(selPlayer, selCharacter, Globals.ACTION_DEFEND, 0, 0);
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