package;

import haxe.Json;
import openfl.Assets;
import logic.Player;
import logic.Item;
import logic.Character;
import flash.utils.ByteArray;

import graphics.uicomponents.character.CharacterSprite;

class Loader {

	public static function loadPlayer(id:Int, playerName:String) {
		var json = getParsedJSON("assets/Players/" + playerName + ".ps");
		return (json != null) ? new Player(id, json.characters) : null;
	}

	public static function loadCharacter(characterName:String):Character {
		var json = getParsedJSON("assets/Characters/" + characterName + ".chd");
		return (json != null) ? new Character(json.name, json.equipment) : null;
	}

	public static function loadItem(itemName:String):Item {
		var json = getParsedJSON("assets/Items/" + itemName + ".tm");
		return (json != null) ? 
			new Item(json.name, json.type, json.vitality, json.attackPower, json.magicPower, 
						json.physicalRes, json.magicRes, json.attackSpeed) : null;
		
	}

	public static function loadSprite(spriteName:String, direction:Int, charNumber:Int) : CharacterSprite {
		var json = getParsedJSON('assets/Layouts/' + spriteName + '.src');
		var json2 = getParsedJSON("assets/Layouts/" + spriteName + ".ass");

		if (json != null && json2 != null) {
			return new CharacterSprite(direction, charNumber, json, json2);
		}
		return null;
	}

	public static function getParsedJSON(filename:String):Dynamic {
		try {
			// get string from file
			var bytedata:ByteArray = Assets.getBytes(filename);
			var stringdata:String = bytedata.readUTFBytes(bytedata.length);
			// parse jason from string
			return Json.parse(stringdata);
		} catch(msg:String) {
			trace("error loading file: " + filename);
			return null;
		}
	}
}
