package graphics.util;

import flash.display.Sprite;

import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextField;

import flash.filters.GlowFilter;

import flash.events.MouseEvent;

import openfl.Assets;
import motion.Actuate;

class TextAnimation extends Sprite {
	public var text:String;
	public var textbox:TextField;
	public var color:Int;

	public function new (_text:String, _width:Int, _height:Int, _x:Int = 0, _y:Int = 0, _color:Int = 0x000000, _font:String = 'assets/Fonts/pixelated.ttf') {
		super();
		this.x = x;		this.width = _width;
		this.y = y;		this.height = _height;
		textbox = new TextField();

		var font = Assets.getFont(_font);
		var format = new TextFormat(font.fontName, 20, color, true);
		format.align = TextFormatAlign.LEFT;

		textbox.embedFonts = true;
		textbox.defaultTextFormat = format;
		textbox.text = _text;
		textbox.selectable = false;


		addChild(textbox);

	}

	public function fadeOut(_interval:Float = 1, _delay:Float = 0) Actuate.tween(this, _interval, {alpha: 0}).delay(_delay);

	public function fadeIn(_interval:Float = 1, _delay:Float = 0) Actuate.tween(this, _interval, {alpha: 1}).delay(_delay);

	public function move(_deltaX, _deltaY, _interval = 1, _delay = 0) Actuate.tween(this, _interval, {x: this.x + _deltaX, y: this.y + _deltaY}).delay(_delay);
}