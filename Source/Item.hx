package;

class Item {
	
	private var type:Int;
	private var vitality:Int;
	private var attackPower:Int;
	private var magicPower:Int;
	private var physicalRes:Int;
	private var magicRes:Int;
	private var attackSpeed:Int;

	//var statusEffects:Array <StatusEffect>;


	public function new(t:Int, vit:Int, attpow:Int, magpow:Int, phyres:Int, magres:Int, attspd:Int) {
		type = t;
		vitality = vit;
		attackPower = attpow;
		magicPower = magpow;
		physicalRes = phyres;
		magicRes = magres;
		attackSpeed = attspd;
	}

	public function getType():Int {
		return type;
	}

	public function getVitality():Int {
		return vitality;
	}

	public function getAttackPower():Int {
		return attackPower;
	}

	public function getMagicPower():Int {
		return magicPower;
	}

	public function getPhysicalRes():Int {
		return physicalRes;
	}

	public function getMagicRes():Int {
		return magicRes;
	}

	public function getAttackSpeed():Int {
		return attackSpeed;
	}
}