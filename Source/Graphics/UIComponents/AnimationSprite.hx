package graphics;

import flash.display.Sprite;
import flash.events.Event;
import openfl.display.Tilesheet;
import graphics.Animation;

class AnimationSprite extends Sprite {
	public var id : Int;
	public var team : Int;
	public var position : Int;
	public var direction : Int;
	public var tilesheet : Tilesheet;
	public var animationList : Array <Animation>;
	public var currentAnimation : Animation;

	public function new (){
		super();
	}

	public function on_click(event : Event) :Void {
		event.target.dispatchEvent(new Event('select_character', true));		
	}
}