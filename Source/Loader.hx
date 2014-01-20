package;

import haxe.Json;
import openfl.Assets;
import logic.Player;
import logic.Item;
import logic.Character;

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

	public static function loadSprite(spriteName:String) :Array <Dynamic> {

		var filename = "assets/Spritesheets/" + spriteName + ".ass";
		var string = Assets.getText(filename);
		var dataArray:Array <Dynamic> = new Array();
		try {
			var json = Json.parse(string);
			dataArray.push(json.bitmap);
	
			var animations:Array <Dynamic> = json.animationList;
			
			for(a in 0...animations.length){
				var animList:Array <Dynamic> = new Array();
				animList.push(animations[a].name);
				animList.push(animations[a].loop);
				var frames:Array <Dynamic> = animations[a].frameList;
				for(f in 0...frames.length) {
					var frame = [ frames[f].duration, frames[f].x, frames[f].y, frames[f].width, frames[f].height, frames[f].refx, frames[f].refy, frames[f].id];
					if(frames[f].trigger != null) frame.push( frames[f].trigger );
					animList.push(frame);
				}
				dataArray.push(animList);
			}
			
			return dataArray;
		
		} catch (msg: String){
			trace("error loading file: " + filename);
			return null;
		}
	}
}