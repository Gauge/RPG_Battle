package graphics.screens;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import flash.text.Font;
import flash.events.Event;
import flash.events.MouseEvent;
import openfl.Assets;
import flash.Lib;

class MainMenu extends Sprite
{
	private var blackout :Bitmap;
	private var play_button:Sprite;
	private var exit_button:Sprite;

	function new () {
		super();
		blackout_background();
		build_buttons();

		addEventListener(Event.RESIZE, onScreenResize);
	}

	private function blackout_background () {
		blackout = new Bitmap();
		blackout.graphics.beginFill(0x000000);
		blackout.graphics.drawRect(0,0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(blackout);
	}

	private function build_buttons () {

		play_button = create_button("Play", 100);
		exit_button = create_button("Quit", 300);

		addChild(play_button);
		addChild(exit_button);

		play_button.addEventListener(MouseEvent.MOUSE_UP, play_game);
		exit_button.addEventListener(MouseEvent.MOUSE_UP, quit_game);

	}

	private function create_button (_text, _y) : Sprite {
		var btn = new Sprite();
		btn.graphics.beginFill(0x555555);
		btn.graphics.drawRect(0,0,200,70);
		btn.y = _y;
		btn.x = Lib.stage.stageWidth/2 - (btn.width / 2);

		var btn_text = build_text(_text, 60);
		btn_text.x = btn_text.width / 2;
		btn.addChild(btn_text);

		return btn;

	}

	private function build_text(_text:String, _size) : TextField {
		var txt = new TextField();
		var font = Assets.getFont('assets/Fonts/pixelated.ttf');
		var format = new TextFormat(font.fontName, _size, 0x000000);

		format.align = TextFormatAlign.CENTER;
		txt.defaultTextFormat = format;
		
		txt.text = _text;
		txt.autoSize = TextFieldAutoSize.CENTER;

		return txt;
	}

	private function play_game( e : Event ) {
		trace("Menu Clicked! Starting game");
		var new_game = new Event("new_game", true);
		e.currentTarget.dispatchEvent(new_game);
	}

	private function quit_game( e : Event ) {
		trace("Menu Clicked! Exiting game");
		var quit_game = new Event("quit", true);
		e.currentTarget.dispatchEvent(quit_game);

	}

	private function onScreenResize(e:Event) {
		blackout.graphics.drawRect(0,0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		play_button.x = Lib.stage.stageWidth/2 - (play_button.width / 2);
		exit_button.x = Lib.stage.stageWidth/2 - (exit_button.width / 2);
	}
}