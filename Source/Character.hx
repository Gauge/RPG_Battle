package;

import actions.Action;

class Character {

	private var vitality:Int;
	private var isdead:Bool;

	private var equippment:Array <Item>;

	private var action:Action;
	
	// set up a new character
	public function new():Void {
		equippment = [null, null, null, null, null, null];
		equipItem(ItemLoader.load("ShortSword"));
		equipItem(ItemLoader.load("SteelArms"));
		equipItem(ItemLoader.load("SteelBuckler"));
		equipItem(ItemLoader.load("SteelHelm"));
		equipItem(ItemLoader.load("SteelLegs"));
		equipItem(ItemLoader.load("SteelPlate"));
		vitality = getMaxVitality();
		action = null;
		isdead = false;
	}

	public function isDead():Bool {
		return isdead;
	}

	public function getVitality():Int {
		return vitality;
	}

	// looks through all the items the character has equipped and returns the accumulated vitality number
	public function getMaxVitality():Int {
		var vit = 1;

		for (i in 0...equippment.length) {
			vit += (equippment[i] != null) ? equippment[i].getVitality() : 0;
		}
		return vit;
	}

	// looks through all the items the character has equipped and returns the accumulated attack power from all the items.
	public function getAttackPower():Int {
		var attack_power = 0;

		for (i in 0...equippment.length){
			attack_power += (equippment[i] != null) ? equippment[i].getAttackPower() : 0;
		}
		return attack_power;
	}

	// looks through all the items the character has equipped and returns the accumulated magic power.
	public function getMagicPower():Int {
		var magic_power = 0;

		for (i in 0...equippment.length){
			magic_power += (equippment[i] != null) ? equippment[i].getMagicPower() : 0;
		}
		return magic_power;
	}

	// looks through all the items the character has equipped and returns the accumulated Physical Resist.
	public function getPhysicalRes():Int {
		var physical_res = 0;

		for (i in 0...equippment.length){
			physical_res += (equippment[i] != null) ? equippment[i].getPhysicalRes() : 0;
		}
		return physical_res;
	}

	// looks through all the items the character has equipped and returns the accumulated Magic Resist.
	public function getMagicRes():Int {
		var magic_res = 0;

		for (i in 0...equippment.length){
			magic_res += (equippment[i] != null) ? equippment[i].getMagicRes() : 0;
		}
		return magic_res;
	}

	public function getAttackSpeed():Int {
		var attack_speed = 0;

		for (i in 0...equippment.length){
			attack_speed += (equippment[i] != null) ? equippment[i].getAttackSpeed() : 0;
		}
		return attack_speed;	
	}


	public function getHead():Item {
		return equippment[Globals.ITEM_HEAD];
	}

	public function getBody():Item {
		return equippment[Globals.ITEM_BODY];
	}

	public function getArms():Item {
		return equippment[Globals.ITEM_ARMS];
	}

	public function getLegs():Item {
		return equippment[Globals.ITEM_LEGS];
	}

	public function getOnhand():Item {
		return equippment[Globals.ITEM_ONHAND];
	}

	public function getOffhand():Item {
		return equippment[Globals.ITEM_OFFHAND];
	}

	//take in the Item “i”
	//look at item i’s type
	//place item i in appropriate slot
	// if there is an item already in that slot replace return the old item otherwise return null
	public function equipItem(i:Item):Item {
		var oldItem = equippment[i.getType()];
		equippment[i.getType()] = i;

		return oldItem;
	}

	// requires the item type and replaces it with nothing
	public function unequipItem(type:Int):Void {
		var oldItem = equippment[type];
		equippment[type] == null;
	}

	// this is used when a new turn happens
	public function resetAction():Void {
		action = null;
	}

	// sets the new action and calculates the 
	// pre attack variables
	public function setAction(a:Action):Void {
		action = a;

		action.report.attack_speed = getAttackSpeed();
	}

	public function getAction():Action {
		return action;
	}

	public function attack():Int {
		var damageToDo = getAttackPower();
		damageToDo = action.attack(damageToDo);
		return damageToDo;
	} 

	// applies damage to this character and returns
	public function defend(physicalDamage:Int):Int {
		
		var damageDealt = (physicalDamage-getPhysicalRes() < 0) ? 0 : physicalDamage-getPhysicalRes();
		if (action != null){
			damageDealt = action.defend(damageDealt);
		}
		
		if (vitality <= damageDealt){
			vitality = 0;
			isdead = true;
			
		} else {
			vitality -= damageDealt;
		}

		return damageDealt;
	}
}