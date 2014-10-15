package logic.statuseffects;

class Ageianate extends StatusEffect {
	
	public function new() {
		super(StatusEffect.AGEIANATE);
	}

	public override function getMaxVitality(charMaxVit:Int):Int {
		return  Std.int(charMaxVit/2);
	}
}