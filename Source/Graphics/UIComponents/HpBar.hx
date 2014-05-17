package graphics;

import flash.display.Sprite;

class HpBar extends Sprite {
	public var vitMax:Int;
	public var vit:Int;

	public function new () {
		super();
		vitMax = 100;
		vit = 100;
	}

	public function update(damage : Int) {
		vit -= damage;
		if(vit < 0) vit = 0;
	}
}