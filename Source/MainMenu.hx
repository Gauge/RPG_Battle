package ;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.Font;
import openfl.Assets;
import flash.Lib;

class MainMenu extends Sprite
{
	private var blackout 	:Bitmap;
	private var buttons 	:Sprite;

	function new () 
	{
		super();
		blackout_background();
		build_buttons();
	}

	private function blackout_background ()
	{
		blackout = new Bitmap();
		blackout.graphics.beginFill(0x000000);
		blackout.graphics.drawRect(0,0, 1000, 1000);
		addChild(blackout);
	}

	private function build_buttons ()
	{
		var play_button = create_button("Play", 100);
		var exit_button = create_button("Quit", 300);

		addChild(play_button);
		addChild(exit_button);

	}

	private function create_button (_text, _y) : Sprite
	{
		var btn 	= new Sprite();
		btn.graphics.beginFill(0x555555);
		btn.graphics.drawRect(0,0,200,70);
		btn.y 		= _y;
		btn.x		= Lib.stage.stageWidth/2 - (btn.width / 2);

		var btn_text 	= build_text(_text, 60);
		btn_text.x = btn_text.width / 2;
		trace(Lib.stage.stageWidth);
		btn.addChild(btn_text);

		return btn;

	}

	private function build_text(_text:String, _size) : TextField
	{
		var txt 	= new TextField();
		var font 	= Assets.getFont('assets/pixelated.ttf');
		var format 				= new TextFormat(font.fontName, _size, 0x000000);
		format.align 			= TextFormatAlign.CENTER;
		txt.defaultTextFormat 	= format;
		txt.text 		= _text;
		txt.autoSize 	= TextFieldAutoSize.CENTER;


		return txt;
	}
}