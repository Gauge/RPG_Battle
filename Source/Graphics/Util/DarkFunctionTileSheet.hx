package graphics.util;

import openfl.Assets;
import openfl.display.Tilesheet;
import flash.Lib;
import flash.geom.Rectangle;

class DarkFunctionTileSheet extends Tilesheet {

	private var _animations:Map<String,Array<AnimationFrame>>;
	private var _currentAnimation:String;
	private var _animationQueue:Array<String>;
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
		_animationQueue = new Array<String>();
		_currentFrame = 0;
	}

	public function getAnimations():Array<String> {
		var array = new Array<String>();
		for (key in _animations.keys()){
			array.push(key);
		}
		return array;
	}

	public function getCurrentAnimation():String {
		return _currentAnimation;
	}

	public function getFrameNumber():Int {
		return _currentFrame;
	}
	
	public function setAnimation(name:String) {
		_animationQueue.push(name);
	}

	public function hardSetAnimation(name:String){
		_currentAnimation = name;
		_currentFrame = 0;
	}

	public function getQueueCount():Int {
		return _animationQueue.length;
	}

	public function nextFrame(): AnimationFrame {
		var list = _animations.get(_currentAnimation); // get the animation frame list
		var a = list[_currentFrame]; // get the current frame
		// update the current frame for the next round
		if ((_currentFrame+1) == list.length) { // if we have come to the end of the animation
			if (_animationQueue.length > 0) { // if there is are animations in the queue
				_currentAnimation = _animationQueue.shift(); // set the next one as the current animation
			}
			_currentFrame = 0; // if there are no animations in the queue repeate the last animation

		} else { // if this is not the last frame
			_currentFrame = _currentFrame+1; // increment the process by 1
		}
		return a; // return the current frame
	}

	public static function loadTileSheet (filename:String) {
		var json = Loader.getParsedJSON("assets/Layouts/" + filename + ".src");
		var json2 = Loader.getParsedJSON("assets/Layouts/" + filename + ".ass");

		if (json != null && json2 != null) {
			return new DarkFunctionTileSheet(json, json2);
		}
		return null;

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