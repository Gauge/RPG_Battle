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
import graphics.uicomponents.MainMenuBtn;
import motion.Actuate;
import motion.easing.Quad;
import haxe.Timer;

class MainMenu extends Sprite
{
	private var blackout :Bitmap;
	private var play_button:Sprite;
	private var exit_button:Sprite;
	private var cancel_btn:MainMenuButton;
	private var loadout_btn:MainMenuButton;
	private var online_btn:MainMenuButton;
	private var training_btn:MainMenuButton;	
	private var options_btn:MainMenuButton;
	private var buttonList:Array<MainMenuButton>;

	function new () {
		super();
		blackout_background();
		this.alpha = 0;
		build_buttons();
		Lib.current.stage.addEventListener(Event.RESIZE, onScreenResize);
	}

	private function blackout_background () {
		blackout = new Bitmap();
		blackout.graphics.beginFill(0x000000);
		blackout.graphics.drawRect(0,0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(blackout);
	}

	private function build_buttons () {

		cancel_btn = new MainMenuButton('quit', 'mm_cancel', 80, 20);
		loadout_btn = new MainMenuButton('loadout', 'mm_loadout', 80, 3);
		online_btn = new MainMenuButton('online', 'mm_online', 10, 3);
		training_btn = new MainMenuButton('new_game', 'mm_training', 5, 3);
		options_btn = new MainMenuButton('options', 'mm_options', 3, 3);

		buttonList = [cancel_btn, loadout_btn, online_btn, training_btn, options_btn];
		for(i in 0...buttonList.length) addChild(buttonList[i]);
		Actuate.tween(this, 2, {alpha:1});
	}

	private function onScreenResize(e:Event) {
		for(btn in 0...buttonList.length) buttonList[btn].recalculateSize();
		blackout.graphics.drawRect(0,0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
	}

	public function slide_up() {
		Actuate.tween(this, 1, {y:-Lib.current.stage.stageHeight}).ease(Quad.easeIn);
	}

	private function render() {
		for (btn in buttonList){
			btn.render();
		}
	}
}