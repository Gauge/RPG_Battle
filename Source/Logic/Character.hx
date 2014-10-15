package logic;

import logic.actions.Action;
import logic.statuseffects.StatusEffect;

class Character {

	private var vit:Int;
	private var isdead:Bool;
	private var name:String;

	private var equipment:Array <Item>;
	private var statusEffects:Array <StatusEffect>;

	private var action:Action;
	
	// set up a new character
	public function new(?name:String, ?equipment:Array <String>):Void {
		this.name = (name != null) ? name : "I DONT HAVE A NAME!!!";
		this.equipment = [null, null, null, null, null, null];
		this.statusEffects = [];
		if (equipment != null) {
			for (e in equipment){
				equipItem(Loader.loadItem(e));
			}
		}
		vit = getMaxVit();
		action = null;
		isdead = false;
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

	// looks through all the items the character has equipped and returns the accumulated vitality number
	public function getMaxVit():Int {
		var vit = 1;

		for (i in 0...equipment.length) {
			vit += (equipment[i] != null) ? equipment[i].getVit() : 0;
		}
		return vit;
	}

	// looks through all the items the character has equipped and returns the accumulated attack power from all the items.
	public function getAttack():Int {
		var attack = 0;

		for (i in 0...equipment.length){
			attack += (equipment[i] != null) ? equipment[i].getAttack() : 0;
		}
		return attack;
	}

	// looks through all the items the character has equipped and returns the accumulated magic power.
	public function getMagic():Int {
		var magic = 0;

		for (i in 0...equipment.length){
			magic += (equipment[i] != null) ? equipment[i].getMagic() : 0;
		}
		return magic;
	}

	// looks through all the items the character has equipped and returns the accumulated Physical Resist.
	public function getArmor():Int {
		var armor = 0;

		for (i in 0...equipment.length){
			armor += (equipment[i] != null) ? equipment[i].getArmor() : 0;
		}
		return armor;
	}

	// looks through all the items the character has equipped and returns the accumulated Magic Resist.
	public function getResist():Int {
		var resist = 0;

		for (i in 0...equipment.length){
			resist += (equipment[i] != null) ? equipment[i].getResist() : 0;
		}
		return resist;
	}

	public function getSpeed():Int {
		var speed = 0;

		for (i in 0...equipment.length){
			speed += (equipment[i] != null) ? equipment[i].getSpeed() : 0;
		}
		return speed;
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

	//take in the Item “i”
	//look at item i’s type
	//place item i in appropriate slot
	// if there is an item already in that slot replace return the old item otherwise return null
	public function equipItem(i:Item):Item {
		var oldItem = equipment[i.getType()];
		equipment[i.getType()] = i;

		return oldItem;
	}

	// requires the item type and replaces it with nothing
	public function unequipItem(type:Int):Void {
		var oldItem = equipment[type];
		equipment[type] == null;
	}

	public function getStatusEffects(): Array <StatusEffect> {
		return statusEffects;
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

	public function getAction():Action {
		return action;
	}

	public function attack():Int {
		var damageToDo = getAttack();
		damageToDo = action.attack(damageToDo);
		return damageToDo;
	} 

	// applies damage to this character and returns
	public function defend(physicalDamage:Int):Int {
		
		var damageDealt = (physicalDamage-getArmor() < 0) ? 0 : physicalDamage-getArmor();
		if (action != null){
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

	public function ability(id:Int) {
		var sf = StatusEffect.create(id);
		statusEffects.push(sf);
	}
}