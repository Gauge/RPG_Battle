package graphics.screens;

import openfl.Assets;

import logic.Game;
import logic.actions.Action;

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
	var _sequencing:Bool;
	var _sequenceList:Array<CharacterSprite>;
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
		_sequencing = false;
		_sequenceList = new Array<CharacterSprite>();

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
			var max = player.team[i].getMaxVit();
			var vit = player.team[i].getVit();
			char._init_(max, vit);
			team1.push(char);
		}

		for (i in 0...4) {

			var char = Loader.loadSprite('Characters/test', Globals.RIGHT, i);
			this.addChild(char);
			var player = game.getPlayerById(Globals.PLAYER_TWO);
			var max = player.team[i].getMaxVit();
			var vit = player.team[i].getVit();
			char._init_(max, vit);
			team2.push(char);
		}
	}

	private function initActionMenu(): Void {
		trace("creating action menu");
		actionMenu = new ActionMenu();
		addChild(actionMenu);
	}

	private function startGlow() {
		for (char in team2) {
			char.setGlow(0xffff00);
		}
	}

	private function stopGlow() {
		for (char in team2) {
			char.removeGlow();
		}
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
		team1[_selectedCharacter].hardSetAnimation("pre_attack");
		this.stopGlow();

		this.removeEventListener("character_select", onCharacterActionSelect);
		this.addEventListener("character_select", onCharacterSelect);
	}

	private function onAttack(e:Event) {
		this.startGlow();
		this.removeEventListener("character_select", onCharacterSelect);
		this.addEventListener("character_select", onCharacterActionSelect);
	}

	private function onDefend(e:Event) {
		team1[_selectedCharacter].hardSetAnimation("defend");
		game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_DEFEND, -1, -1);
		actionMenu.hideActionMenu();
	}

	private function onLockinClick(e:Event) {
		game.lockin(Globals.PLAYER_ONE);
		game.lockin(Globals.PLAYER_TWO);
		while(game.gamestate != Globals.GAME_DISPLAY_ROUND){}
		_action_list = game.getSortedActions();
		_sequencing = true;
	}

	private function sequence() {
		if (_sequenceCount < _action_list.length){ // while there are still actions to execute

			var action = _action_list[_sequenceCount]; // get the current action
			var character = (action.getSelectedPlayer() == Globals.PLAYER_ONE) ? team1[action.getSelectedCharacter()] : team2[action.getSelectedCharacter()];
			var target_character = (action.getTargetPlayer() == Globals.PLAYER_ONE) ? team1[action.getTargetCharacter()] : team2[action.getTargetCharacter()];

			if (action.getAction() == Globals.ACTION_ATTACK) {
				character.hardSetAnimation("attack");
				character.setAnimation("idle");

				target_character.hardSetAnimation("take_damage");
				if (action.report.died_this_turn) {
					target_character.setAnimation("pre_dead");
					target_character.setAnimation("dead");
				} else {
					target_character.setAnimation("idle");
				}
				_sequenceList.push(character);
				_sequenceList.push(target_character);
				target_character.update(action.report.damage_dealt);
			
			} else if (action.getAction() == Globals.ACTION_DEFEND) {}

			_sequenceCount++;
		
		} else{
			// reset everything and start the new round
			for (char in team1){
				if (char.getCurrentAnimation() != "dead"){
					char.setAnimation("idle");
				}
			}
			for(char in team2){
				if (char.getCurrentAnimation() != "dead"){
					char.setAnimation("idle");
				}
			}
			_sequenceCount = 0;
			_sequencing = false;
			game.newTurn();
		}
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

		// this runs at the end of each turn. it displayes the actions of each player seprately
		if (_sequencing) {
			var list = new Array<Int>();
			for (i in 0..._sequenceList.length){
				if (_sequenceList[i].getQueueCount() == 0){
					list.push(i);
				}
			}

			list.reverse(); // getting an error with this. I would like to fix later.
			for (pos in list) {
				_sequenceList.remove(_sequenceList[pos]);
			}

			if (_sequenceList.length == 0) sequence();
		}
	}
}