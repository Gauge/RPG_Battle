package graphics.util;

import openfl.Assets;
import openfl.display.Tilesheet;
import flash.geom.Rectangle;

class DarkFunctionTileSheet extends Tilesheet {

	private var _animations:Map<String,Array<AnimationFrame>>;
	private var _currentAnimation:String;
	private var _currentFrame:Int;

	// load the src and ass files
	public function new(tile:Dynamic, style:Dynamic) {
		super(Assets.getBitmapData("assets/Images/" + tile.name));

		_animations = new Map<String, Array<AnimationFrame>>();

		// load sprite sheet frames
		for (i in 0...tile.frames.length){
			var dim = tile.frames[i];
			addTileRect(new Rectangle(dim.x, dim.y , dim.w , dim.h));
		}

		// load animation layout
		for (i in 0...style.anims.length) {
			var anim = style.anims[i];
			var animationName = anim.name;
			var frames = new Array<AnimationFrame>();

			anim.frames[0];
			for(i2 in 0...anim.frames.length){
				var frame = anim.frames[i2];
				frames.push(new AnimationFrame(frame.index, frame.delay, frame.x, frame.y, frame.z));
			}
			_animations.set(animationName, frames);
		}

		// set starting animation
		_currentAnimation = getAnimations()[0];
		_currentFrame = 0;
	}

	public function getAnimations():Array<String> {
		var array = new Array<String>();
		for (key in _animations.keys()){
			array.push(key);
		}
		return array;
	}
	
	public function setAnimation(name:String) {
		_currentAnimation = name;
	}

	public function nextFrame(): AnimationFrame {
		var list = _animations.get(_currentAnimation);
		var a = list[_currentFrame];
		_currentFrame = ((_currentFrame+1) == list.length) ? 0 : _currentFrame+1;
		return a;
	}

}

class AnimationFrame {
	public var index:Int;
	public var delay:Int;
	public var xOffset:Int;
	public var yOffset:Int;
	public var zOffset:Int;

	public function new(i:Int, d:Int, x:Int, y:Int, z:Int){
		this.index = i;
		this.delay = d;
		xOffset = x;
		yOffset = y;
		zOffset = z;
	}
}