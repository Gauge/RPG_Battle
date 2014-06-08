package graphics.screens;


import openfl.Assets;

import logic.Game;

import flash.Lib;
import flash.events.Event;

import flash.display.Sprite;
import flash.geom.Rectangle;

import graphics.uicomponents.Background;
import graphics.uicomponents.LockinButton;
import graphics.uicomponents.CharacterSprite;

class ActiveGame extends Sprite {
	// holds the game instance
	var game:Game;

	// graphic components
	var background:Background;
	var lockinButton:LockinButton;
	var team1:Array<CharacterSprite>;
	var team2:Array<CharacterSprite>;
	
	// render data
	var delta:Float;
	var lastTick:Float;

	public function new() {
		super();
		delta = 0;
		lastTick = 0;

		team1 = new Array<CharacterSprite>();
		team2 = new Array<CharacterSprite>();

		game = new Game();
		trace("Starting GUI");
		trace("Initializing components");
		initBackground();
		initLockinButton();
		initCharacters();

		trace("Initializing render loop");
		// adjusts the screen if orientation changes
		addEventListener("lockin", onLockinClick);
		Lib.current.stage.addEventListener(Event.RESIZE, onScreenResize);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
	}

	private function initBackground(): Void {
		trace("creating background");
		background = new Background(Assets.getBitmapData('assets/Images/background.png'), new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		this.addChild(background);
	}

	private function initCharacters(): Void {
		trace("creating characters");
		// create team 1
		for (i in 0...4) {
			var char = Loader.loadSprite("character", Globals.LEFT, i);
			this.addChild(char);
			char.recalculateSize();
			team1.push(char);
		}

		for (i in 0...4) {
			var char = Loader.loadSprite("character", Globals.RIGHT, i);
			this.addChild(char);
			char.recalculateSize();
			team2.push(char);
		}
	}

	// NOTE: i think i will include this in the init characters
	private function initHpBars(): Void {
		trace("creating hp bars");
	}

	private function initLockinButton(): Void {
		trace("creating lock-in button");
		lockinButton = new LockinButton();
		this.addChild(lockinButton);
	}

	private function initActionMenu(): Void {
		trace("creating action menu");
	}

	private function onScreenResize(e:Event) {
		background.setSize(new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		lockinButton.recalculateSize();
		for (char in team1) { 
			char.recalculateSize();
		}

		for (char in team2) {
			char.recalculateSize();
		}
	}

	private function onLockinClick(e:Event) {
		game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_1);
		game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, Globals.PLAYER_TWO, Globals.CHARACTER_3);
		game.lockin(Globals.PLAYER_ONE);
		game.lockin(Globals.PLAYER_TWO);
	}

	private function enterFrame(e:Event){
		// controls the number of updates are ran every second
		delta = delta + (Lib.getTimer() - lastTick);
		if (delta >= Globals.FRAME_RATE) {
			delta = delta - Globals.FRAME_RATE;
			render();
		}
		lastTick = Lib.getTimer();
	}

	private function render() {
		for (char in team1) { 
			char.render();
		}

		for (char in team2) {
			char.render();
		}
	}
}