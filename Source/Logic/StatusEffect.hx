package logic;

class StatusEffect {
	public static var BURNING = "burning";
	public static var NONE = "none";

	private var type:String;
	private var ticks:Int;
	private var magic:Int;

	public function new(type:String) {
		switch(type) {
			case "burning": createBurning();
			default: type = NONE;
		}
	}

	private function createBurning():Void {
		type = BURNING;
		ticks = 3;
		magic = 100;
	}

	public function getType() {
		return type;
	}

	public function getTicks() {
		return ticks;
	}

	public function getMagic() {
		return magic;
	}

	public function update() {
		switch(type) {
			case "burning": updateBurning();
		}
	}

	private function updateBurning() {
		if (ticks == 0) type = NONE; // if burning is complete mark this status effect to be removed
		ticks -= 1;
	}

}