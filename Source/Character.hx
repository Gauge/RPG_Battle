package;

class Character {

	private var vitality:Int;
	private var isdead:Bool;
	
	//private lvl_mele:Int;
	//private lvl_ranged:Int;
	//private lvl_magic:Int;
	//private lvl_support:Int;
	//private statusEffects:Array;

	private var head:Item;
	private var body:Item;
	private var arms:Item;
	private var legs:Item;
	private var onhand:Item;
	private var offhand:Item;

	private var action:Action;
	
	// set up a new character
	// NOTE: later we will create an over loaded method that can
	// 		 load a new character based on the data provided 
	public function new():Void {
		equipItem(new Item(Globals.ITEM_ONHAND, 10, 200, 0, 0, 0, Math.round(Math.random()*500)));
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
		var items = [head, body, arms, legs, onhand, offhand];
		var vit = 1;

		for (i in 0...items.length) {
			vit += (items[i] != null) ? items[i].getVitality() : 0;
		}
		return vit;
	}

	// looks through all the items the character has equipped and returns the accumulated attack power from all the items.
	public function getAttackPower():Int {
		var items = [head, body, arms, legs, onhand, offhand];
		var attack_power = 0;

		for (i in 0...items.length){
			attack_power += (items[i] != null) ? items[i].getAttackPower() : 0;
		}
		return attack_power;
	}

	// looks through all the items the character has equipped and returns the accumulated magic power.
	public function getMagicPower():Int {
		var items = [head, body, arms, legs, onhand, offhand];
		var magic_power = 0;

		for (i in 0...items.length){
			magic_power += (items[i] != null) ? items[i].getMagicPower() : 0;
		}
		return magic_power;
	}

	// looks through all the items the character has equipped and returns the accumulated Physical Resist.
	public function getPhysicalRes():Int {
		var items = [head, body, arms, legs, onhand, offhand];
		var physical_res = 0;

		for (i in 0...items.length){
			physical_res += (items[i] != null) ? items[i].getPhysicalRes() : 0;
		}
		return physical_res;
	}

	// looks through all the items the character has equipped and returns the accumulated Magic Resist.
	public function getMagicRes():Int {
		var items = [head, body, arms, legs, onhand, offhand];
		var magic_res = 0;

		for (i in 0...items.length){
			magic_res += (items[i] != null) ? items[i].getMagicRes() : 0;
		}
		return magic_res;
	}

	public function getAttackSpeed():Int {
		var items = [head, body, arms, legs, onhand, offhand];
		var attack_speed = 0;

		for (i in 0...items.length){
			attack_speed += (items[i] != null) ? items[i].getAttackSpeed() : 0;
		}
		return attack_speed;	
	}


	public function getHead():Item {
		return head;
	}

	public function getBody():Item {
		return body;
	}

	public function getArms():Item {
		return arms;
	}

	public function getLegs():Item {
		return legs;
	}

	public function getOnhand():Item {
		return onhand;
	}

	public function getOffhand():Item {
		return offhand;
	}

	//take in the Item “i”
	//look at item i’s type
	//place item i in appropriate slot
	// if there is an item already in that slot replace return the old item otherwise return null
	public function equipItem(i:Item):Item {
		var oldItem = null;

		switch (i.getType()) {
			case Globals.ITEM_HEAD:
				oldItem = head;
				head = i;

			case Globals.ITEM_BODY:
				oldItem = body;
				body = i;

			case Globals.ITEM_ARMS:
				oldItem = arms;
				arms = i;

			case Globals.ITEM_LEGS:
				oldItem = legs;
				legs = i;

			case Globals.ITEM_ONHAND:
				oldItem = onhand;
				onhand = i;

			case Globals.ITEM_OFFHAND:
				oldItem = offhand;
				offhand = i;
		}

		return oldItem;
	}

	// requires the item type and replaces it with nothing
	public function unequipItem(type:Int):Void {

		switch (type) {
			case Globals.ITEM_HEAD:
				head = null;

			case Globals.ITEM_BODY:
				body = null;

			case Globals.ITEM_ARMS:
				arms = null;

			case Globals.ITEM_LEGS:
				legs = null;

			case Globals.ITEM_ONHAND:
				onhand = null;

			case Globals.ITEM_OFFHAND:
				offhand = null;
		}
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

	// applies damage to this character and returns
	// total damage dealt
	public function takeDamage(physicalDamage:Int) {
		var damageDealt = physicalDamage-getPhysicalRes();
		vitality -= damageDealt;
		return damageDealt;
	}
}