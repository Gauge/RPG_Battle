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
		var json = getParsedJSON("assets/Players/" + playerName + ".ps");
		//trace(json);
		return (json != null) ? new Player(id, json.characters) : null;
	}

	public static function loadCharacter(characterName:String):Character {
		var json = getParsedJSON("assets/Characters/" + characterName + ".chd");
		//trace(json);
		return (json != null) ? new Character(json.name, json.equipment) : null;
	}

	public static function loadItem(itemName:String):Item {
		var json = getParsedJSON("assets/Items/" + itemName + ".tm");
		//trace(json);
		return (json != null) ? 
			new Item(json.type, json.vitality, json.attackPower, json.magicPower, json.physicalRes, json.magicRes, json.attackSpeed) : null;
		
	}

	public static function loadSprite(spriteName:String, direction:Int, charNumber:Int) : CharacterSprite {
		var json = getParsedJSON("assets/Layouts/" + spriteName + ".src");
		//trace(json);
		if (json != null) {
			var start = 0;
			var char = new CharacterSprite(direction, charNumber);
			var tempsheet = new Tilesheet(Assets.getBitmapData("assets/Images/" + json.name));
			
			json.dir[0]; // must have!!!
			for (i in 0...json.dir.length) { 
				json.dir[i].spr[0]; // must have!!!
				
				var end = 0;
				for (ii in 0...json.dir[i].spr.length) {
					var rec = json.dir[i].spr[ii];
					tempsheet.addTileRect(new Rectangle(rec.x, rec.y , rec.w , rec.h));
					end++;
				}
				char.addAnimation(json.dir[i].name, new Point(start, end));
				start = end;
			}

			char.setTilesheet(tempsheet);
			return char;
		}
		return null;
	}

	public static function getParsedJSON(filename:String):Dynamic {
		try {
			return Json.parse(Assets.getText(filename));
		} catch(msg:String) {
			trace("error loading file: " + filename);
			return null;
		}
	}
}
