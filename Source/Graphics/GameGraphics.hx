package graphics;

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

import graphics.Animations;
import graphics.HpBar;
import logic.Game;


class  GameGraphics extends Sprite {

	static var LEFT = 0;
	static var RIGHT = 1;

	static var CHAR_SCALE = 2.5;

	public var characterList:Array <AnimationSprite>;
	public var displayContainer:Sprite;
	public var spriteContainer:Array <Sprite>;
	public var GUIlist: Array <AnimationSprite>;
	public var renderList: Array <Dynamic>;

	public var screenWidth:Float;
	public var screenHeight:Float;

	var syncTimer:Int;
	var syncTimerMax:Int;

	var game:Game;
	var actionmenu:ActionMenu;
	var lockinButton:Sprite;
	var hpBars:Array <HpBar>;
	var textBoxes: Array <TextAnimation>;
	var cursor:Cursor;
	var cursorVisible:Bool;

	var selectingTarget:Bool;

	var battleSequence:Sequence;
	

	public function new() {
		super();

		game = new Game();
		characterList = new Array();
		var spriteLoader = new LoadAnimationSprite();
		characterList = spriteLoader.loadSprites('basicCharacter', 8);
		GUIlist = spriteLoader.loadSprites("GUI", 1);

		loadBackdrop();
		loadContainers();
		loadHpBars();
		selectingTarget = false;

		syncTimer = 0;
		syncTimerMax = 15;

		cursorVisible = false;
		actionmenu = new ActionMenu();
		addChild(actionmenu);
		
		lockinButton = new LockinButton();
		addChild(lockinButton);

		enemyTeamActions(); //Stand in for now...
		initListeners();
	}

	private function lockin(event:MouseEvent) :Void {
		game.lockin(Globals.PLAYER_ONE);
		game.lockin(Globals.PLAYER_TWO);
	}
		
	private function initListeners() {
		actionmenu.addEventListener(MouseEvent.MOUSE_DOWN, actionmenu.on_click);
		lockinButton.addEventListener(MouseEvent.MOUSE_DOWN, lockin);

		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		// begins animation render loop
		addEventListener(Event.ENTER_FRAME, renderLoop);
	}

	private function loadListeners() {
		addEventListener ('select_character', sendCharSelect);
		addEventListener ('menu_select', menuSelect);
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
			actionmenu.show = false;
			hideCursor();
		}
	}

	private function showCursor() :Void{
		cursorVisible = true;
		if(cursor == null) cursor = new Cursor(Assets.getBitmapData('assets/cursor.png'), characterList[0]);
		cursor.direction = 1;
		addChild(cursor);
		this.addEventListener(MouseEvent.MOUSE_MOVE, updateCursor);
	}

	private function updateCursor(event:MouseEvent) :Void {
		for(char in 0...4) {
			if(event.target == characterList[char]) {
				cursor.x = characterList[char].x + 30;
				cursor.y = characterList[char].y - 40;
			}
		}	
	}

	private function hideCursor() :Void {
		selectingTarget = false;
		this.removeEventListener(MouseEvent.MOUSE_MOVE, updateCursor);
		removeChild(cursor);

	}

	// // // // // LOADERS // // // // // 

	private function loadBackdrop() : Void {
		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight));
		drawGraphic(backdrop);
	}

	private function loadContainers() : Void {
		displayContainer = new Sprite();
		spriteContainer = new Array();
		addChild(displayContainer);

		// this is half the window hight divided by 6 for the location the characters stand
		var CHAR_POSITIONING_Y = (Lib.current.stage.stageHeight / 12);
		var x = 20;
		var y = Lib.current.stage.stageHeight - CHAR_POSITIONING_Y;

		for(c in 0...4){
			var sprite = characterList[c];
			sprite.x = x;
			sprite.y = y;

			sprite.addEventListener(MouseEvent.MOUSE_DOWN, characterList[c].on_click);

			spriteContainer.push(sprite);
			displayContainer.addChild(sprite);
			y -= CHAR_POSITIONING_Y;
		}

		x = Lib.current.stage.stageWidth-100;
		y = Lib.current.stage.stageHeight - CHAR_POSITIONING_Y;
		for (c in 4...8) {
			var sprite = characterList[c];
			sprite.x = x;
			sprite.y = y;

			sprite.addEventListener(MouseEvent.MOUSE_DOWN, characterList[c].on_click);

			spriteContainer.push(sprite);
			displayContainer.addChild(sprite);
			y -= CHAR_POSITIONING_Y;
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

				characterList[char].currentAnimation.timer = (characterList[char].currentAnimation.name == "waiting") ? syncTimer : characterList[char].currentAnimation.timer + 1 ;
			}
			var direction = characterList[char].direction * CHAR_SCALE;
			characterList[char].tilesheet.drawTiles(spriteContainer[char].graphics, [0,0, frameId, direction, 0, 0, CHAR_SCALE], Tilesheet.TILE_TRANS_2x2);
		}

		if(syncTimer < syncTimerMax) syncTimer++;
		else syncTimer = 0;

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
			
	}

	private function drawHpBars() :Void {
		var charId = 0;
		for(p in 0...2) {
			var player = game.getPlayerById(p);
			for(character in player.team) {

				var hp = (hpBars[charId].vit <= 0) ? 0 : (hpBars[charId].vit / hpBars[charId].vitMax);
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

		if (battleSequence.seqList.length != 0){
			battleAnimationCycle();
		}
		else {
			loadListeners();
			game.newTurn();
			battleSequence = null;
		}
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
				var newBox = new TextAnimation("-" + damage, 0xFF0000, 15, target);
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