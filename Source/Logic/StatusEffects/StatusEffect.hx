package logic.statuseffects;

class StatusEffect {

	// All status effect types
	public static var AGEIANATE = 0;

	private var type:Int;

	public function new(t:Int) {
		type = t;
	}

	public function getType():Int {
		return type;
	}

	public function revive():Bool {
		return false;
	}

	public function getMaxVitality(charMaxVit:Int):Int {
		return charMaxVit;
	}

	public function getAttackPower(charAttackPower:Int):Int {
		return charAttackPower;
	}

	public function getMagicPower(charMagicPower:Int):Int {
		return charMagicPower;
	}

	public function getPhysicalRes(charPhysicalRes:Int):Int {
		return charPhysicalRes;
	}

	public function getMagicRes(charMagicRes:Int):Int {
		return charMagicRes;
	}

	public function getAttackSpeed(charAttackSpeed:Int):Int {
		return charAttackSpeed;
	}

	public static function create(id:Int):StatusEffect {

		switch(id) {
			case StatusEffect.AGEIANATE:
				return new Ageianate();
		}
		return null;
	}
}