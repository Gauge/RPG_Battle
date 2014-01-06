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

	public var characterList:Array <CharacterSprite>;
	public var displayContainer:Sprite;
	public var spriteContainer:Array <Sprite>;
	public var GUIlist: Array <CharacterSprite>;

	public var screenWidth:Float;
	public var screenHeight:Float;
	public var gameStage:flash.display.Stage;

	var game:Game;
	var actionmenu:ActionMenu;
	
	function new(){

		super();

		game = new Game();

		init();
		gameStage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		gameStage.addEventListener ('select_character', sendCharSelect);
	}

	private function sendCharSelect(event:Event){
		game.selectCharacter(event.target.team, event.target.id);
		actionmenu.target = event.target;
		actionmenu.show = true;
	}

	public function init(){
		gameStage = Lib.current.stage;
		characterList = new Array();

		var spriteLoader = new LoadCharacterSprite();
		characterList = spriteLoader.loadSprites("assets/dataTest.xml");

		GUIlist = spriteLoader.loadSprites("assets/GUIdata.xml");

		loadBackdrop();
		loadContainers();

		actionmenu = new ActionMenu();
		gameStage.addChild(actionmenu);

		gameStage.addEventListener(Event.ENTER_FRAME, renderLoop);

	}

	private function loadBackdrop() : Void {
		var backdrop = new Graphic(Assets.getBitmapData('assets/background.png'), new Rectangle(0, 0, 800,600));
		drawGraphic(backdrop);
	}

	private function loadContainers() : Void {
		displayContainer = new Sprite();
		gameStage.addChild(displayContainer);

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

	public function drawGraphic( graphic : Graphic ) : Void {
		var container = graphic.graphicContainer;

		container = new Sprite();
		container.addChild(graphic.bitmapSource);
		resizeSprite(container, graphic.gameGeometry);
		gameStage.addChild(container);
		
	}

	private function resizeSprite( original:Sprite, targetDimentions:Rectangle ) : Void {
		original.width = targetDimentions.width;
		original.height = targetDimentions.height;
		original.x = targetDimentions.x;
		original.y = targetDimentions.y;
	}



	private function renderLoop( event:Event ) : Void {
		actionmenu.graphics.clear();
		if(actionmenu.show) drawActionMenu();

		for ( i in 0...characterList.length ){
			spriteContainer[i].graphics.clear();
			var animation = characterList[i].currentAnimation;
			var frameId = animation.currentFrameId;
			var frame = animation.frameList[frameId];
			
			if( frame.duration == animation.timer ) {
				if( frameId < animation.frameList.length - 1 ) {
					frame = animation.frameList[frameId + 1];
					characterList[i].currentAnimation.currentFrameId = frameId + 1;
				}
				else{
					frame = animation.frameList[0];
					characterList[i].currentAnimation.currentFrameId = 0;
				}
				characterList[i].currentAnimation.timer = 0;
			}
			else {
				characterList[i].currentAnimation.timer++;
			}
			var direction = characterList[i].direction * CHAR_SCALE;
			var characterX = 0;
			var characterY = 0;
			characterList[i].tilesheet.drawTiles(spriteContainer[i].graphics, [characterX, characterY, frameId, direction, 0, 0, CHAR_SCALE], Tilesheet.TILE_TRANS_2x2);
		}
	}

	private function drawActionMenu(){
		var target = actionmenu.target;
		actionmenu.x = target.x - 100;
		actionmenu.y = target.y;
		actionmenu.tilesheet.drawTiles(actionmenu.graphics, [0,0,0, 2.5], Tilesheet.TILE_SCALE);
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
}