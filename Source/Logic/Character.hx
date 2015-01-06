package logic;

import logic.actions.Action;
import logic.StatusEffect;

class Character {

	private var vit:Int;
	private var maxVit:Int;
	private var damage:Int;
	private var magic:Int;
	private var armor:Int;
	private var resist:Int;
	private var speed:Int;
	private var isdead:Bool;
	private var name:String;

	private var action:Action;
	private var equipment:Array <Item>;
	private var statusEffects:Array <StatusEffect>;
	
	// set up a new character
	public function new(?name:String, ?equipment:Array <String>):Void {
		action = null;
		isdead = false;
		this.name = (name != null) ? name : "I DONT HAVE A NAME!!!";
		this.equipment = [null, null, null, null, null, null];
		statusEffects = [new StatusEffect(StatusEffect.BURNING)];
		if (equipment != null) {
			for (e in equipment){
				equipItem(Loader.loadItem(e));
			}
		}
		calculateStats();
		vit = getMaxVit(); // sets vitality to max
	}

	public function getName():String {
		return name;
	}

	public function isDead():Bool {
		return isdead;
	}

	public function getVit():Int {
		return vit;
	}

	public function getMaxVit():Int {
		return maxVit;
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

	public function getAction():Action {
		return action;
	}

	public function getHead():Item {
		return equipment[Globals.ITEM_HEAD];
	}

	public function getBody():Item {
		return equipment[Globals.ITEM_BODY];
	}

	public function getArms():Item {
		return equipment[Globals.ITEM_ARMS];
	}

	public function getLegs():Item {
		return equipment[Globals.ITEM_LEGS];
	}

	public function getOnhand():Item {
		return equipment[Globals.ITEM_ONHAND];
	}

	public function getOffhand():Item {
		return equipment[Globals.ITEM_OFFHAND];
	}

	public function getStatusEffects(): Array <StatusEffect> {
		return statusEffects;
	}

	private function calculateStats():Void {
		maxVit = 0;
		for (i in 0...equipment.length) {
			maxVit += (equipment[i] != null) ? equipment[i].getVit() : 0;
		}

		maxVit = (maxVit == 0)? 1 : maxVit; // must have at least one hit point

		damage = 0;
		for (i in 0...equipment.length){
			damage += (equipment[i] != null) ? equipment[i].getDamage() : 0;
		}

		magic = 0;
		for (i in 0...equipment.length){
			magic += (equipment[i] != null) ? equipment[i].getMagic() : 0;
		}

		armor = 0;
		for (i in 0...equipment.length){
			armor += (equipment[i] != null) ? equipment[i].getArmor() : 0;
		}

		resist = 0;
		for (i in 0...equipment.length){
			resist += (equipment[i] != null) ? equipment[i].getResist() : 0;
		}

		speed = 0;
		for (i in 0...equipment.length){
			speed += (equipment[i] != null) ? equipment[i].getSpeed() : 0;
		}
	}

	// take in the Item “i”
	// look at item i’s type
	// place item i in appropriate slot
	// update character stats
	// if there is an item already in that slot replace return the old item otherwise return null
	public function equipItem(i:Item):Item {
		var oldItem = equipment[i.getType()];
		equipment[i.getType()] = i;
		calculateStats();

		return oldItem;
	}

	// requires the item type and replaces it with nothing
	public function unequipItem(type:Int):Item {
		var oldItem = equipment[type];
		equipment[type] == null;
		calculateStats();

		return oldItem;
	}

	// this is used when a new turn happens
	public function resetAction():Void {
		action = null;
	}

	// sets the new action and calculates the 
	// pre attack variables
	public function setAction(a:Action):Void {
		action = a;
		action.report.speed = getSpeed();
	}

	public function attack():Int {
		//TODO: status effect modifiers
		var damageToDo = getDamage();
		damageToDo = action.attack(damageToDo);
		return damageToDo;
	} 

	// applies damage to this character and returns
	public function defend(physicalDamage:Int, magicDamage:Int):Int {
		
		var damageDealt = 0;
		damageDealt += (physicalDamage-getArmor() < 0) ? 0 : physicalDamage-getArmor();
		damageDealt += (magicDamage-getResist() < 0) ? 0 : magicDamage-getResist();

		if (action != null) {
			damageDealt = action.defend(damageDealt);
		}
		
		if (vit <= damageDealt){
			vit = 0;
			isdead = true;
			
		} else {
			vit -= damageDealt;
		}

		return damageDealt;
	}
}