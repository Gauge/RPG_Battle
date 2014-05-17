package graphics.screens;

import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.events.Event;
import openfl.Assets;
import flash.Lib;

import graphics.uicomponents.Background;
import logic.Game;

class ActiveGame extends Sprite {

	// holds the game instance
	var game:Game;

	// graphic components
	var background:Background;

	public function new() {
		super();
		
		game = new Game();
		initBackground();

		Lib.current.stage.addEventListener(Event.RESIZE, onScreenResize);

	}

	private function initBackground(): Void {
		trace("creating background");
		background = new Background(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		this.addChild(background);
	}

	private function initCharacters(): Void {

	}

	// NOTE: i think i will include this in the init characters
	private function initHpBars(): Void {

	}

	private function initLockinButton(): Void {

	}

	private function initActionMenu(): Void {

	}


	private function onScreenResize(e:Event) {
		background.setSize(new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
	}
}