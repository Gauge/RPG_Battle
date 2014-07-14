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
import graphics.uicomponents.ActionMenu;

import motion.Actuate;
import motion.easing.Quad;

class ActiveGame extends Sprite {
	// holds the game instance
	var game:Game;

	// graphic components
	var background:Background;
	var lockinButton:LockinButton;
	var actionMenu:ActionMenu;
	var team1:Array<CharacterSprite>;
	var team2:Array<CharacterSprite>;
	
	// render data
	var delta:Float;
	var lastTick:Float;

	public function new() {
		super();
		alpha = 0;
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
		initActionMenu();

		trace("Initializing render loop");
		// adjusts the screen if orientation changes
		addEventListener("lockin", onLockinClick);
		addEventListener("character_select", onCharacterSelect);
		Lib.current.stage.addEventListener(Event.RESIZE, onScreenResize);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, enterFrame);

		Actuate.tween(this, 2, {alpha:1});
	}

	private function initBackground(): Void {
		trace("creating background");
		background = new Background(Assets.getBitmapData('assets/Images/terregenBackground.png'), new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		this.addChild(background);
	}

	private function initCharacters(): Void {
		trace("creating characters");
		// create team 1
		for (i in 0...4) {
			var char = Loader.loadSprite("box", Globals.LEFT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_ONE);
			var max = player.team[i].getMaxVitality();
			var vit = player.team[i].getVitality();
			char._init_(max, vit);
			char.recalculateSize();
			team1.push(char);
		}

		for (i in 0...4) {
			var char = Loader.loadSprite("box", Globals.RIGHT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_TWO);
			var max = player.team[i].getMaxVitality();
			var vit = player.team[i].getVitality();
			char._init_(max, vit);
			char.recalculateSize();
			team2.push(char);
		}
	}

	private function initLockinButton(): Void {
		trace("creating lock-in button");
		lockinButton = new LockinButton();
		this.addChild(lockinButton);
	}

	private function initActionMenu(): Void {
		trace("creating action menu");
		actionMenu = new ActionMenu();
		addChild(actionMenu);
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

	private function onCharacterSelect(e:Event) {
		var player = ((e.target.getDirection() == Globals.LEFT) ? Globals.PLAYER_ONE : Globals.PLAYER_TWO);
		var character = e.target.getCharacterNumber();
		game.selectCharacter(player, character);
		actionMenu.showActionMenu();
	}

	private function onLockinClick(e:Event) {
		game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_1); // Sample data
		game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, Globals.PLAYER_TWO, Globals.CHARACTER_3); // Sample data
		game.lockin(Globals.PLAYER_ONE);
		game.lockin(Globals.PLAYER_TWO);
		

	}

	private function initSequence() {

	}

	private function updateSequence() {

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
		lockinButton.render();
		actionMenu.render();
		for (char in team1) { 
			char.render();
			char.update(1);
		}

		for (char in team2) {
			char.update(1);
			char.render();
		}
	}
}