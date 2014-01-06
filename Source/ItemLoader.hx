package;

import haxe.Json;
import openfl.Assets;

class ItemLoader {

	public static function load(itemName:String) {

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