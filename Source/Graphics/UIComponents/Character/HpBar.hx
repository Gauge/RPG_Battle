package graphics.uicomponents.character;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import openfl.Assets;

class HpBar extends Sprite {
	private var _vitMax:Int;
	private var _vit:Int;
	private var _width:Float;
	private var _height:Float;
	private var _color:Int;


	public function new (max:Int, cur:Int) {
		super();
		_vitMax = max;
		_vit = cur;
		
		var data = Assets.getBitmapData('assets/Images/healthBar.png');
		_width = data.width;
		_height = data.height;
		this.addChild(new Bitmap(data));
	}

	public function update(damage : Int) {
		_vit -= damage;
		if(_vit < 0) _vit = 0;
		updateColor();
	}

	private function updateColor() {
		if (_vit/_vitMax < .2) {
			_color = 0x9A0000;
		
		} else if (_vit/_vitMax < .5) {
			_color = 0xA09000;
		
		} else {
			_color = 0x009A00;
		}
	}
	
	public function render():Void {
		this.graphics.clear();
		this.graphics.beginFill(_color);
		var h = (_vit/_vitMax)*(_height);
		var y = _height-h;
		this.graphics.drawRect(2, y, _width-4, h);
		this.graphics.endFill();
	}
}