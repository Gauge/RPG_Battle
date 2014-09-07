package graphics.screens;

import openfl.Assets;

import logic.Game;
import actions.Action;

import flash.Lib;
import flash.events.Event;

import flash.display.Sprite;
import flash.geom.Rectangle;

import graphics.uicomponents.Background;
import graphics.uicomponents.character.CharacterSprite;
import graphics.uicomponents.actionmenu.ActionMenu;

import motion.Actuate;
import motion.easing.Quad;

class ActiveGame extends Sprite {
	// holds the game instance
	var game:Game;

	// graphic components
	var background:Background;
	var actionMenu:ActionMenu;
	var team1:Array<CharacterSprite>;
	var team2:Array<CharacterSprite>;
	var _selectedCharacter:Int;
	var _sequenceCount:Int;
	var _action_list:Array<Action>;
	
	// render data
	var delta:Float;
	var lastTick:Float;

	public function new() {
		super();
		alpha = 0;
		delta = 0;
		lastTick = -1;

		team1 = new Array<CharacterSprite>();
		team2 = new Array<CharacterSprite>();
		_selectedCharacter = -1;
		_sequenceCount = 0;

		game = new Game();
		trace("Starting GUI");
		trace("Initializing components");
		initBackground();
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

			var char = Loader.loadSprite('Characters/test', Globals.LEFT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_ONE);
			var max = player.team[i].getMaxVitality();
			var vit = player.team[i].getVitality();
			char._init_(max, vit);
			team1.push(char);
		}

		for (i in 0...4) {

			var char = Loader.loadSprite('Characters/test', Globals.RIGHT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_TWO);
			var max = player.team[i].getMaxVitality();
			var vit = player.team[i].getVitality();
			char._init_(max, vit);
			team2.push(char);
		}
	}

	private function initActionMenu(): Void {
		trace("creating action menu");
		actionMenu = new ActionMenu();
		addChild(actionMenu);
	}

	private function onScreenResize(e:Event) {
		background.setSize(new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
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
		_action_list = game.getSortedActions();
		sequence();
	}

	private function sequence() {
		if (_sequenceCount < _action_list.length){
			var action = _action_list[_sequenceCount];
			var character = (action.getSelectedPlayer() == Globals.PLAYER_ONE) ? team1[action.getSelectedCharacter()] : team2[action.getSelectedCharacter()];
			var target_character = (action.getTargetPlayer() == Globals.PLAYER_ONE) ? team1[action.getTargetCharacter()] : team2[action.getTargetCharacter()];

			if (action.getAction() == Globals.ACTION_ATTACK) {
				// attack animation
				character.setAnimationWithCallBack("attack", "action"+_sequenceCount);
				addEventListener("action"+_sequenceCount, nextSequence);
				// reaciton animation
				target_character.setAnimationWithCallBack("take_damage", "reaction"+_sequenceCount);
				addEventListener("reaction"+_sequenceCount, reactionSequence);
				target_character.update(action.report.damage_dealt);
			
			} else if (action.getAction() == Globals.ACTION_DEFEND) {
				_sequenceCount++;
				sequence();
			}
		} else{
			// reset everything and start the new round
			for (char in team1){
				char.setAnimation("idle");
			}
			for(char in team2){
				char.setAnimation("idle");	
			}
			game.newTurn();
		}
	}

	private function nextSequence(e:Event) {
		e.target.setAnimation("idle");
		removeEventListener("action"+_sequenceCount, nextSequence);
		_sequenceCount++;
		sequence();
	}

	// for events that dont increment the sequencer such as taking damage
	private function reactionSequence(e:Event){
		var player = game.getPlayerById((e.target.getDirection() == Globals.LEFT) ? Globals.PLAYER_ONE : Globals.PLAYER_TWO);
		e.target.setAnimation("idle");

		removeEventListener("reaction"+_sequenceCount, reactionSequence);
	}

	private function enterFrame(e:Event){
		// controls the number of updates are ran every second
		var time = Lib.getTimer();
		if (lastTick == -1) lastTick = time;
		delta = delta + (time - lastTick);
		if (delta >= Globals.FRAME_RATE) {
			delta = delta - Globals.FRAME_RATE;
			render();
		}
		lastTick = time;
	}

	private function render() {
		actionMenu.render();
		for (char in team1) { 
			char.render();
		}
		for (char in team2) {
			char.render();
		}
	}
}