package graphics.uicomponents;

import flash.display.Sprite;
import openfl.display.Tilesheet;
import graphics.util.DarkFunctionTileSheet;
import flash.events.MouseEvent;
import flash.events.Event;

import motion.Actuate;
import motion.easing.Quad;

class ActionMenu extends Sprite {

	private static var UNSELECTED:Int = -1;
	private static var ATTACK:Int = 0;
	private static var DEFEND:Int = 1;
	private static var ABILITY:Int= 2;
	private static var NOTHING:Int= 3;

	var _selected:Int;
	var _tilesheet:DarkFunctionTileSheet;
	var _abilityPanel:DarkFunctionTileSheet;

	public function new() {
		super();
		this.x = -70;
		_selected = UNSELECTED;
		_tilesheet = DarkFunctionTileSheet.loadTileSheet("ActionMenu/action_menu");
		_abilityPanel = DarkFunctionTileSheet.loadTileSheet("ActionMenu/ability_panel");
		_tilesheet.setAnimation("Inactive");
		this.addEventListener(MouseEvent.MOUSE_MOVE, setActive);
		this.addEventListener(MouseEvent.MOUSE_DOWN, setInactive);
		this.addEventListener(MouseEvent.MOUSE_UP, onClick);
	}


	private function setActive(e:MouseEvent) {
		if (e.localX >= 5 && e.localX <= 45 && e.buttonDown == false){
			if (e.localY >= 5 && e.localY <= 45){
				_selected = ATTACK;
				_tilesheet.setAnimation("Attack");
			} else if (e.localY >= 49 && e.localY <= 89){
				_selected = DEFEND;
				_tilesheet.setAnimation("Defend");
			} else if (e.localY >= 94 && e.localY <= 134) {
				_selected = ABILITY;
				_tilesheet.setAnimation("Ability");
			} else if (e.localY >= 138 && e.localY <= 178) {
				_selected = NOTHING;
				_tilesheet.setAnimation("Nothing");
			} else {
				_selected = UNSELECTED;
				_tilesheet.setAnimation("Inactive");
			}
		} else {
			_selected = UNSELECTED;
			_tilesheet.setAnimation("Inactive");
		}
	}

	private function setInactive(e:Event) {
		_tilesheet.setAnimation("Inactive");
	}

	private function onClick(e:Event) {
		if (_selected == ATTACK) {
			_tilesheet.setAnimation("Attack");
			this.dispatchEvent(new Event("attack", true));
			
		} else if (_selected == DEFEND) {
			_tilesheet.setAnimation("Defend");
			this.dispatchEvent(new Event("defend", true));
		
		} else if (_selected == ABILITY) {
			_tilesheet.setAnimation("Ability");
			showAbilityPanel();
		
		} else if (_selected == NOTHING) {
			_tilesheet.setAnimation("Inactive");
			hideActionMenu();
		} 
	}

	public function showActionMenu():Void {
		Actuate.tween(this, .25, {x:0}).ease(Quad.easeOut);
	}

	public function hideActionMenu():Void {
		Actuate.tween(this, .25, {x:-70}).ease(Quad.easeIn);
	}

	private function showAbilityPanel():Void {
		Actuate.tween(this, .35, {x:122}).ease(Quad.easeOut);
	}

	private function hideAbilityPanel():Void {
		Actuate.tween(this, .35, {x:0}).ease(Quad.easeIn);
	}

	public function render() {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [frame.xOffset, frame.yOffset, frame.index, 1, 0, 0, 1], Tilesheet.TILE_TRANS_2x2);

		frame = _abilityPanel.nextFrame();
		_abilityPanel.drawTiles(this.graphics, [-122+frame.xOffset, frame.yOffset, frame.index, 1, 0, 0, 1], Tilesheet.TILE_TRANS_2x2);
	}

}