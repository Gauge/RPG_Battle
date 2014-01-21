package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.Event;

import flash.geom.Rectangle;
import flash.geom.Point;

import flash.ui.Keyboard;
import flash.system.System;

import flash.Lib;

import openfl.Assets;
import openfl.display.Tilesheet;

import Animations;
import FileLoader;



class  GameGraphics extends Sprite {

	static var LEFT = 0;
	static var RIGHT = 1;

	static var POS_L_1 = new Point(175, 325);
	static var POS_L_2 = new Point(150, 400);
	static var POS_L_3 = new Point(125, 475);
	static var POS_L_4 = new Point(100, 550);

	static var POS_R_1 = new Point(600, 325);
	static var POS_R_2 = new Point(625, 400);
	static var POS_R_3 = new Point(650, 475);
	static var POS_R_4 = new Point(675, 550);

	static var TEAM_POSITIONS = [POS_L_1, POS_L_2, POS_L_3, POS_L_4, POS_R_1, POS_R_2, POS_R_3, POS_R_4];

	static var CHAR_SCALE = 2.5;

	public var characterList:Array <AnimationSprite>;
	public var displayContainer:Sprite;
	public var spriteContainer:Array <Sprite>;
	public var GUIlist: Array <AnimationSprite>;
	public var renderList: Array <Dynamic>;

	public var screenWidth:Float;
	public var screenHeight:Float;

	var game:Game;
	var actionmenu:ActionMenu;
	var hpBars:Array <HpBar>;
	var textBoxes: Array <TextAnimation>;
	var cursor:Cursor;
	var cursorVisible:Bool;

	var selectingTarget:Bool;

	var battleSequence:Sequence;
	
	function new(){

		super();

		game = new Game();

		init();
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);

		loadListeners();
	}

	private function loadListeners() :Void {
		addEventListener ('select_character', sendCharSelect);
		addEventListener ('menu_select', menuSelect);
	}

	public function init(){
		characterList = new Array();
		var spriteLoader = new LoadAnimationSprite();
		characterList = spriteLoader.loadSprites('basicCharacter', 8);
		GUIlist = spriteLoader.loadSprites("GUI", 1);

		loadBackdrop();
		loadContainers();
		loadHpBars();
		selectingTarget = false;

		cursorVisible = false;
		actionmenu = new ActionMenu();
		actionmenu.addEventListener(MouseEvent.MOUSE_DOWN, actionmenu.on_click);
		addChild(actionmenu);

		enemyTeamActions(); //Stand in for now...

		addEventListener(Event.ENTER_FRAME, renderLoop);
	}

	private function menuSelect(event : Event) {
		var target = event.target;
		var selection = target.selection;
		switch (selection) {
			case "exit" :
				actionmenu.show = false;
			case "item":
				actionmenu.show = false;
			case "magic":
				selectingTarget = true;
				showCursor();
				trace('please select target');
			case "defend":
				game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_DEFEND, -1, -1);
				actionmenu.show = false;
			case "attack":
				selectingTarget = true;
				showCursor();
				trace('please select target');
			}
	}

	private function sendCharSelect(event:Event){
		if(event.target.team == 2 && selectingTarget == false){
			game.selectCharacter(event.target.team, event.target.id);
			trace(event.target.team);
			actionmenu.target = event.target;
			actionmenu.show = true;
		}
		else if(event.target.team == 1 && selectingTarget == true) {

			game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_ATTACK, Globals.PLAYER_ONE, event.target.id);
			selectingTarget = false;
			actionmenu.show = false;
		}
	}

	private function showCursor() :Void{
		cursorVisible = true;
		if(cursor == null) cursor = new Cursor(Assets.getBitmapData('assets/cursor.png'));
		cursor.direction = 1;
	}

	private function updateCursor() :Void {

	}

	// // // // // LOADERS // // // // // 

	private function loadBackdrop() : Void {
		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, 800,600));
		drawGraphic(backdrop);
	}

	private function loadContainers() : Void {
		displayContainer = new Sprite();
		addChild(displayContainer);

		spriteContainer = new Array();

		for(c in 0...TEAM_POSITIONS.length){
			var sprite = characterList[c];
			sprite.x = TEAM_POSITIONS[c].x;
			sprite.y = TEAM_POSITIONS[c].y;

			sprite.addEventListener(MouseEvent.MOUSE_DOWN, characterList[c].on_click);

			spriteContainer.push(sprite);
			displayContainer.addChild(sprite);
		}
	}

	private function loadHpBars() :Void {
		hpBars = new Array();
		var charId = 0;
		for(p in 0...2) {
			var player = game.getPlayerById(p);
			for(character in player.team) {
				var hpBar = new HpBar();
				var team = (p == 0) ? -1 : 1;
				
				hpBar.x = characterList[charId].x + (80 * team);
				hpBar.y = characterList[charId].y;

				
				hpBar.vitMax = character.getMaxVitality();
				hpBar.vit = character.getVitality();

				hpBars.push(hpBar);
				addChild(hpBar);
				charId++;
			}
		}
	}

	// // // // // DRAWING & RENDERING // // // // //

	public function drawGraphic( graphic : Graphic ) : Void {
		var container = graphic.graphicContainer;

		container = new Sprite();
		container.addChild(graphic.bitmapSource);
		resizeSprite(container, graphic.gameGeometry);
		addChild(container);
		
	}

	private function resizeSprite( original:Sprite, targetDimentions:Rectangle ) : Void {
		original.width = targetDimentions.width;
		original.height = targetDimentions.height;
		original.x = targetDimentions.x;
		original.y = targetDimentions.y;
	}



	private function renderLoop( event:Event ) : Void {
		if(game.gamestate == Globals.GAME_TURN){	
			actionmenu.graphics.clear();
			if(actionmenu.show) drawActionMenu();
			if(cursorVisible) drawCursor();
		}
		else if(game.gamestate == Globals.GAME_UPDATE){
			if(battleSequence == null) startBattle();

		}

		drawHpBars();

		for ( char in 0...characterList.length ){
			spriteContainer[char].graphics.clear();
			var animation = characterList[char].currentAnimation;
			var frameId = animation.currentFrameId;
			var frame = animation.frameList[frameId];

			if( frame.duration == animation.timer ) {
				if( frameId < animation.frameList.length - 1 ) {
					frame = animation.frameList[frameId + 1];
					characterList[char].currentAnimation.currentFrameId = frameId + 1;
				}
				else if(!animation.loop) {
					characterList[char].currentAnimation.currentFrameId = 0;
					continueBattle();
					
				}
				else {
					frame = animation.frameList[0];
					characterList[char].currentAnimation.currentFrameId = 0;
				}

				characterList[char].currentAnimation.timer = 0;

				if(frame.trigger != null) battleTrigger(frame.trigger);
			}
			else {
				characterList[char].currentAnimation.timer++;
			}
			var direction = characterList[char].direction * CHAR_SCALE;
			characterList[char].tilesheet.drawTiles(spriteContainer[char].graphics, [0,0, frameId, direction, 0, 0, CHAR_SCALE], Tilesheet.TILE_TRANS_2x2);
		}
		if(textBoxes != null){
			for(box in textBoxes) {
				addChild(box);
				if(box.timer < box.timerMax) {
					box.timer++;
					box.y -= 3;
				}
				else {
					textBoxes.remove(box);
					removeChild(box);
				}
			}
		}
	}

	private function drawActionMenu(){
		var target = actionmenu.target;
		actionmenu.x = target.x - 100;
		actionmenu.y = target.y;
		actionmenu.tilesheet.drawTiles(actionmenu.graphics, [0,0,0, 2.5], Tilesheet.TILE_SCALE);
	}

	private function drawCursor(){
		cursor.drawTiles(this.graphics, [cursor.x, cursor.y, 0, 2.5*cursor.direction, 0, 0, 2.5], Tilesheet.TILE_TRANS_2x2);
	}

	private function drawHpBars() :Void {
		var charId = 0;
		for(p in 0...2) {
			var player = game.getPlayerById(p);
			for(character in player.team) {

				var hp = (hpBars[charId].vit / hpBars[charId].vitMax);

				var color = (hp < .5) ? 0xFF3300 : 0x008CFF;

				hpBars[charId].graphics.clear();
				hpBars[charId].graphics.beginFill(color);
				hpBars[charId].graphics.drawRect(-7,0,16,-(hp * 84));

				var hpTile = new Tilesheet(Assets.getBitmapData('assets/healthBar.png'));
				hpTile.addTileRect(new Rectangle(0,0,10,35), new Point(5, 35));
				hpTile.drawTiles(hpBars[charId].graphics, [1,1, 0, CHAR_SCALE], Tilesheet.TILE_SCALE);

				charId++;
			}
		}
	}



	// // // // // BATTLE // // // // //

	private function startBattle(){
		battleSequence = new Sequence();
		battleSequence.load( game.getSortedActions() );

		removeEventListener ('select_character', sendCharSelect);
		removeEventListener ('menu_select', menuSelect);

		battleAnimationCycle();
	}

	private function battleAnimationCycle() :Void {
		var action = battleSequence.get(0);
		characterList[action[0]].currentAnimation = characterList[action[0]].animationList[1];
	}

	private function continueBattle() :Void {
		var action = battleSequence.get(0);
		characterList[action[0]].currentAnimation = characterList[action[0]].animationList[0];

		battleSequence.shift();
		if(battleSequence.seqList[0] != null) battleAnimationCycle();
		else{
			loadListeners();
			game.newTurn();
			battleSequence = null;
		}
	}

	private function battleTrigger(trigger : String) :Void {
		var action = battleSequence.get(0);
		var char = characterList[action[0]];
		var hpBar = hpBars[action[1]];
		var target = characterList[action[1]];
		var damage = action[3];

		switch (trigger) {
			case "hitsplat" :
				hpBar.update(damage);
				if(textBoxes == null) textBoxes = new Array();
				var newBox = new TextAnimation("" + damage, 0xFF0000, 15, target);
				textBoxes.push(newBox);
				addChild(newBox);

		}

	}

	private function keyDown(event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.NUMBER_1:
			game.lockin(Globals.PLAYER_ONE);

			case Keyboard.NUMBER_2:
			game.lockin(Globals.PLAYER_TWO);

			case Keyboard.Q:
			game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_1);

			case Keyboard.W:
			game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_2);

			case Keyboard.E:
			game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_3);

			case Keyboard.R:
			game.selectCharacter(Globals.PLAYER_ONE, Globals.CHARACTER_4);

			case Keyboard.T:
			game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_1);

			case Keyboard.Y:
			game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_2);

			case Keyboard.U:
			game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_3);

			case Keyboard.I:
			game.selectCharacter(Globals.PLAYER_TWO, Globals.CHARACTER_4);

			case Keyboard.O:
			game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_ATTACK, Globals.PLAYER_TWO, Globals.CHARACTER_3);

			case Keyboard.P:
			game.selectAction(Globals.PLAYER_ONE, Globals.ACTION_DEFEND, Globals.PLAYER_ONE, Globals.CHARACTER_1);

			case Keyboard.A:
			game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_ATTACK, Globals.PLAYER_ONE, Globals.CHARACTER_3);

			case Keyboard.S:
			game.selectAction(Globals.PLAYER_TWO, Globals.ACTION_DEFEND, Globals.PLAYER_ONE, Globals.CHARACTER_1);

			case Keyboard.ESCAPE:
			trace("quiting program");
			System.exit(0);

		}
	}

	private function enemyTeamActions(){
		for(c in 0...4){
			game.selectCharacter(0, c);
			game.selectAction(0, 0, 1, c);
		}
	}
}