package;

class Character {
<<<<<<< HEAD

	var vitality:Int; 
	
	//private lvl_mele:Int;
	//private lvl_ranged:Int;
	//private lvl_magic:Int;
	//private lvl_support:Int;

	var head:Item;
	var body:Item;
	var arms:Item;
	var legs:Item;
	var onhand:Item;
	var offhand:Item;

	//private statusEffects:Array;

	
	// set up a new character
	// NOTE: later we will create an over loaded method that can
	// 		 load a new character based on the data provided 
=======
	public var level:Int;
	public var currentXp:Int;
	public var health:Int;
	public var healthMax:Int;
	public var physicalPower:Int;
	public var armor:Int;
	public var statusEffects:Array <Dynamic>;
	
>>>>>>> 5629c916324a3eb74159bf4a585f0a650293a686
	function new() {}

	// looks through all the items the character has equipped and returns the accumulated vitality number
	function getMaxVitality() {}

	// looks through all the items the character has equipped and returns the accumulated attack power from all the items.
	function getAttackPower() {}

	// looks through all the items the character has equipped and returns the accumulated magic power.
	function getMagicPower() {}

	// looks through all the items the character has equipped and returns the accumulated Physical Resist.
	function getPysicalRes() {}

	// looks through all the items the character has equipped and returns the accumulated Magic Resist.
	function getMagicRes() {}

	//take in the Item “i”
	//look at item i’s type
	//place item i in appropriate slot
	// if there is an item already in that slot replace return the old item otherwise return null
	function equipItem(i:Item) {}

}