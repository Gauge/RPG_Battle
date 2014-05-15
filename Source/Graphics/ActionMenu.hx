package graphics;

import flash.display.Sprite;
import openfl.display.Tilesheet;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.events.Event;
import flash.events.MouseEvent;
import openfl.Assets;


class ActionMenu extends Sprite {
	public var show:Bool;
	public var target:AnimationSprite;
	public var tilesheet:Tilesheet;
	public var selection:String;

	public function new(){
		super();
		tilesheet = new Tilesheet(Assets.getBitmapData("assets/menusprite.png"));
		tilesheet.addTileRect(new Rectangle(0,0,50,100), new Point(25,100));
	}

	public function on_click(event : MouseEvent){
		var y = Math.abs(event.localY);
		var x = event.localX / Math.abs(event.localX); //30, 100, 160

		var call_menu_select = new Event("menu_select", true);
		if(y < 30){
			selection = (x > 0) ? "item" : "exit";
			event.target.dispatchEvent(call_menu_select);
		}
		else if(y < 100) {
			selection = "magic";
			event.target.dispatchEvent(call_menu_select);
		}
		else if(y < 160) {
			selection = "defend";
			event.target.dispatchEvent(call_menu_select);
		}
		else{
			selection = "attack";
			event.target.dispatchEvent(call_menu_select);
		}

	}

}