package;

import haxe.Json;
import openfl.Assets;
import logic.Player;
import logic.Item;
import logic.Character;
import flash.geom.Rectangle;
import openfl.display.Tilesheet;
import flash.geom.Point;

import graphics.uicomponents.CharacterSprite;

class Loader {

	public static function loadPlayer(id:Int, playerName:String) {
		var filename = "assets/Players/" + playerName + ".ps";
		var string = Assets.getText(filename);
		try {
			var json = Json.parse(string);
			trace(json.characters);
			return new Player(id, json.characters);
		
		} catch (msg: String){
			trace("error loading file: " + filename);
			return null;
		}
	}

	public static function loadCharacter(characterName:String):Character {

		var filename = "assets/Characters/" + characterName + ".chd";
		var string = Assets.getText(filename);
		try {
			var json = Json.parse(string);
			return new Character(json.name, json.equipment);
		
		} catch (msg: String){
			trace("error loading file: " + filename);
			return null;
		}
	}

	public static function loadItem(itemName:String):Item {

		var filename = "assets/Items/" + itemName + ".tm";
		var string = Assets.getText(filename);
		try {
			var json = Json.parse(string);
			return new Item(json.type, json.vitality, json.attackPower, json.magicPower, json.physicalRes, json.magicRes, json.attackSpeed);
		
		} catch (msg: String){
			trace("error loading file: " + filename);
			return null;
		}
	}

	public static function loadSprite(spriteName:String, direction:Int, charNumber:Int) : CharacterSprite {

		var filename = "assets/Layouts/" + spriteName + ".ass";
		try {
			var json = Json.parse(Assets.getText(filename));
			var char = new CharacterSprite(direction, charNumber);
			var tempsheet = new Tilesheet(Assets.getBitmapData("assets/Images/" + json.filename));
			var start = 0;
			
			json.actions[0]; // must have!!!
			for (i in 0...json.actions.length) { 
				json.actions[i].frames[0]; // must have!!!
				
				var end = 0;
				for (ii in 0...json.actions[i].frames.length) {
					var rec = json.actions[i].frames[ii];
					tempsheet.addTileRect(new Rectangle(rec.x, rec.y , rec.w , rec.h));
					end++;
				}
				char.addAnimation(json.actions[i].name, new Point(start, end));
				start = end;
			}

			char.setTilesheet(tempsheet);
			return char;

		} catch(msg: String) {
			trace("error loading file: " + filename);
			return null;
		}
	}
}