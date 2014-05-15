package graphics;

import flash.display.Sprite;

class Animation {
	public function new(){}

	public var index : Int;
	public var name : String;
	public var frameList : Array <Frame>;
	public var currentFrameId : Int;
	public var loop : Bool;
	public var nextAnimation : Int;
	public var timer : Int;
}