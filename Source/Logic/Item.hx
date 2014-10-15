package logic;

class Item {
	
	private var name:String;
	private var type:Int;
	private var vitality:Int;
	private var attackPower:Int;
	private var magicPower:Int;
	private var physicalRes:Int;
	private var magicRes:Int;
	private var attackSpeed:Int;

	//var statusEffects:Array <StatusEffect>;


	public function new(n:String, t:Int, vit:Int, attpow:Int, magpow:Int, phyres:Int, magres:Int, attspd:Int) {
		name = n;
		type = t;
		vitality = vit;
		attackPower = attpow;
		magicPower = magpow;
		physicalRes = phyres;
		magicRes = magres;
		attackSpeed = attspd;
	}

	public function getName():String {
		return name;
	}

	public function getType():Int {
		return type;
	}

	public function getVit():Int {
		return vitality;
	}

	public function getAttack():Int {
		return attackPower;
	}

	public function getMagic():Int {
		return magicPower;
	}

	public function getArmor():Int {
		return physicalRes;
	}

	public function getResist():Int {
		return magicRes;
	}

	public function getSpeed():Int {
		return attackSpeed;
	}
}