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
		this.x = x;	this.width = _width;
		this.y = y;	this.height = _height;
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
}