package logic;

class Item {
	
	private var name:String;
	private var type:Int;
	private var vit:Int;
	private var damage:Int;
	private var magic:Int;
	private var armor:Int;
	private var resist:Int;
	private var speed:Int;

	//var statusEffects:Array <StatusEffect>;


	public function new(name:String, type:Int, vit:Int, damage:Int, magic:Int, armor:Int, resist:Int, speed:Int) {
		this.name = name;
		this.type = type;
		this.vit = vit;
		this.damage = damage;
		this.magic = magic;
		this.armor = armor;
		this.resist = resist;
		this.speed = speed;
	}

	public function getName():String {
		return name;
	}

	public function getType():Int {
		return type;
	}

	public function getVit():Int {
		return vit;
	}

	public function getDamage():Int {
		return damage;
	}

	public function getMagic():Int {
		return magic;
	}

	public function getArmor():Int {
		return armor;
	}

	public function getResist():Int {
		return resist;
	}

	public function getSpeed():Int {
		return speed;
	}
}