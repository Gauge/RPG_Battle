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
	var _selectedCharacter:Int;
	var _sequenceCount:Int;
	
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
		_selectedCharacter = -1;
		_sequenceCount = 0;

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
		addEventListener("attack", onAttack);
		addEventListener("defend", onDefend);
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
			var char = Loader.loadSprite("bc_waiting", Globals.LEFT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_ONE);
			var max = player.team[i].getMaxVitality();
			var vit = player.team[i].getVitality();
			char._init_(max, vit);
			char.recalculateSize();
			team1.push(char);
		}

		for (i in 0...4) {
			var char = Loader.loadSprite("bc_waiting", Globals.RIGHT, i);
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
		actionMenu.recalculateSize();
		for (char in team1) { 
			char.recalculateSize();
		}

		for (char in team2) {
			char.recalculateSize();
		}
	}

	private function onCharacterSelect(e:Event) {
		if (e.target.getDirection() == Globals.LEFT){
			_selectedCharacter = Math.round(e.target.getCharacterNumber()-1);
			
			game.selectCharacter(Globals.PLAYER_ONE, _selectedCharacter);
			actionMenu.showActionMenu();
		}
	}

	private function onCharacterActionSelect(e:Event){
		// attack the selected character
		var player = (e.target.getDirection() == Globals.LEFT) ? Globals.PLAYER_ONE : Globals.PLAYER_TWO;
		var character = Math.round(e.target.getCharacterNumber()-1);
		game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, player, character);
		team1[_selectedCharacter].setAnimation("pre_attack");

		this.removeEventListener("character_select", onCharacterActionSelect);
		this.addEventListener("character_select", onCharacterSelect);
	}

	private function onAttack(e:Event) {
		this.removeEventListener("character_select", onCharacterSelect);
		this.addEventListener("character_select", onCharacterActionSelect);
	}

	private function onDefend(e:Event) {
		team1[_selectedCharacter].setAnimation("defend");
		game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_DEFEND, -1, -1);
		actionMenu.hideActionMenu();
	}

	private function onLockinClick(e:Event) {
		game.lockin(Globals.PLAYER_ONE);
		game.lockin(Globals.PLAYER_TWO);
		while(game.gamestate != Globals.GAME_DISPLAY_ROUND){}
		sequence();
	}

	private function sequence() {
		var action_list = game.getSortedActions();
		if (_sequenceCount < action_list.length){
			var action = action_list[_sequenceCount];
			var character = (action.getSelectedPlayer() == Globals.PLAYER_ONE) ? team1[action.getSelectedCharacter()] : team2[action.getSelectedCharacter()];
			if (action.getAction() == Globals.ACTION_ATTACK) {
				character.setAnimationWithCallBack("attack", "action"+_sequenceCount);
				addEventListener("action"+_sequenceCount, nextSequence);
			
			} else if (action.getAction() == Globals.ACTION_DEFEND) {
				_sequenceCount++;
				sequence();
			}
		} else{
			for (char in team1){
				if (char.getCurrentAnimation() != "spin") char.setAnimation("spin");
			}
			for(char in team2){
				if (char.getCurrentAnimation() != "spin") char.setAnimation("spin");	
			}
			game.newTurn();
		}
	}

	private function nextSequence(e:Event) {
		e.target.setAnimation("spin");
		removeEventListener("action"+_sequenceCount, nextSequence);
		_sequenceCount++;
		sequence();
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