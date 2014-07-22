package graphics.uicomponents.actionmenu;

import flash.display.Sprite;
import openfl.display.Tilesheet;
import graphics.util.DarkFunctionTileSheet;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.Lib;

import motion.Actuate;
import motion.easing.Quad;

class ActionMenu extends Sprite {

	private static var UNSELECTED:Int = -1;
	private static var ATTACK:Int = 0;
	private static var DEFEND:Int = 1;
	private static var ABILITY:Int= 2;
	private static var NOTHING:Int= 3;
	private static var LOCKIN:Int = 4;

	var _selected:Int;
	var _abilityPanelToggle:Bool;
	var _tilesheet:DarkFunctionTileSheet;

	public function new() {
		super();
		_selected = UNSELECTED;
		_abilityPanelToggle = false;
		_tilesheet = DarkFunctionTileSheet.loadTileSheet("ActionMenu/action_menu");
		_tilesheet.setAnimation("Inactive");

		this.addEventListener(MouseEvent.MOUSE_DOWN, setActive);
		this.addEventListener(MouseEvent.MOUSE_UP, onClick);
		recalculateSize();
	}


	private function setActive(e:MouseEvent) {
		// Set animation to lockin if the lockin button is pressed
		if (e.localX >= 94 && e.localX <= 147 && e.localY >= 0 && e.localY <= 22) {
			_selected = LOCKIN;
			_tilesheet.setAnimation("Lockin");

		// set the one of the action menu buttons to active
		} else if (e.localX >= 65 && e.localX <= 90){
			if (e.localY >= 3 && e.localY <= 25){
				_selected = ATTACK;
				_tilesheet.setAnimation("Attack");
			} else if (e.localY >= 26 && e.localY <= 48){
				_selected = DEFEND;
				_tilesheet.setAnimation("Defend");
			} else if (e.localY >= 49 && e.localY <= 71) {
				_selected = ABILITY;
				_tilesheet.setAnimation("Ability");
			} else if (e.localY >= 72 && e.localY <= 94) {
				_selected = NOTHING;
				_tilesheet.setAnimation("Nothing");
			}
		}

		// set one of the ability buttons 
		// NOTE: currently not implemented
	}

	private function onClick(e:Event) {
		if (_selected == LOCKIN){
			this.dispatchEvent(new Event("lockin", true));

		} else if (_selected == ATTACK) {
			this.dispatchEvent(new Event("attack", true));

		} else if (_selected == DEFEND) {
			this.dispatchEvent(new Event("defend", true));
		
		} else if (_selected == ABILITY) {
			if (_abilityPanelToggle){
				hideAbilityPanel();
				_abilityPanelToggle = false;
			} else { 
				showAbilityPanel();
				_abilityPanelToggle = true;
			}
		
		} else if (_selected == NOTHING) {
			hideActionMenu();
		}

		_selected = UNSELECTED;
		_tilesheet.setAnimation("Inactive");
	}

	public function showActionMenu():Void {
		Actuate.tween(this, .25, {x:-(this.width/150*63)}).ease(Quad.easeOut);
	}

	public function hideActionMenu():Void {
		_tilesheet.setAnimation("Inactive");
		Actuate.tween(this, .25, {x:-this.width}).ease(Quad.easeIn);
	}

	private function showAbilityPanel():Void {
		Actuate.tween(this, .25, {x:0}).ease(Quad.easeOut);
	}

	private function hideAbilityPanel():Void {
		_tilesheet.setAnimation("Inactive");
		Actuate.tween(this, .25, {x:-(this.width/150*63)}).ease(Quad.easeIn);
	}

	public function recalculateSize() {
		trace("this is passing "+ Lib.current.stage.stageHeight);
		// make sure the tile has already been drawn
		this.render();

		// set height to a third of the screen
		this.height = (Lib.current.stage.stageHeight/3);
		// 150x102 is the menus dimentions
		this.width = (this.height*150/102);
		this.x = -this.width;

	}

	public function render() {
		this.graphics.clear();
		var frame = _tilesheet.nextFrame();
		_tilesheet.drawTiles(this.graphics, [frame.xOffset, frame.yOffset, frame.index, 1, 0, 0, 1], Tilesheet.TILE_TRANS_2x2);
	}

}