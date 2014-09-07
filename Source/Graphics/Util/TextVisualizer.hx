package graphics.util;

/*
package graphics;

import flash.display.Sprite;

import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextField;

import flash.filters.GlowFilter;

import flash.events.MouseEvent;

import openfl.Assets;

class TextAnimation extends Sprite {
	public var text:String;
	public var textbox:TextField;
	public var color:Int;
	public var timer:Int;
	public var timerMax:Int;

	public function new (newtext : String, newcolor : Int, delay : Int, target : AnimationSprite) {
		super();
		timer = 0;
		timerMax = delay;
		text = newtext;
		color = newcolor;
		this.x = (target.team == 1) ? target.x - 35 : target.x;
		this.y = target.y - 50;
		textbox = new TextField();

		var font = Assets.getFont('assets/pixelated.ttf');
		var format = new TextFormat(font.fontName, 20, color, true);
		format.align = TextFormatAlign.LEFT;

		textbox.embedFonts = true;
		textbox.defaultTextFormat = format;
		textbox.text = text;
		
		textbox.filters = [new GlowFilter(0x000000, .8, 5, 5)];
		textbox.selectable = false;


		addChild(textbox);

	}
}
*/