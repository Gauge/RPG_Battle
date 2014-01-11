package;

import haxe.Json;
import openfl.Assets;

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
}