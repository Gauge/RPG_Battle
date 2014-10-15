package;

class Globals {

	// item constants
	public static var ITEM_HEAD = 0;
	public static var ITEM_BODY = 1;
	public static var ITEM_ARMS = 2;
	public static var ITEM_LEGS = 3;
	public static var ITEM_ONHAND = 4;
	public static var ITEM_OFFHAND = 5;

	// class constants
	public static var CLASS_MELE = 0;
	public static var CLASS_RANGED = 1;
	public static var CLASS_MAGIC = 2;
	public static var CLASS_SUPPORT = 3;

	// actions
	public static var ACTION_ATTACK = 0;
	public static var ACTION_ABILITY = 1;
	public static var ACTION_ITEM = 2;
	public static var ACTION_DEFEND = 3;

	// players
	public static var PLAYER_ONE = 0;
	public static var PLAYER_TWO = 1;

	// gamestate
	public static var GAME_INIT = 0;
	public static var GAME_TURN = 1;
	public static var GAME_UPDATE = 2;
	public static var GAME_DISPLAY_ROUND = 3;
	public static var GAME_OVER = 4;

	// character number
	public static var CHARACTER_1 = 1;
	public static var CHARACTER_2 = 2;
	public static var CHARACTER_3 = 3;
	public static var CHARACTER_4 = 4;

	// game speed
	public static var FRAME_RATE = 1000/10; // 30 frames a second <- this is funny :D

	// character config 
	public static var BASE_SCREEN_OFFSET = 45;
	public static var LEFT = -1;
	public static var RIGHT = 1;

	public static function isPlayerId(id:Int):Bool {
		return (id >= 1 && id <= 2); // this is different because we desplay player 1 instead of player 0
	}

	public static function isPlayerId_S(id:String):Bool {
		try {
			return isPlayerId(Std.parseInt(id));
		} catch (m:String) {
			return false;
		}
	}

	public static function isCharacterId(id:Int):Bool {
		return (id >= 1 && id <= 4);
	}

	public static function isCharacterId_S(id:String):Bool {
		try {
			return isCharacterId(Std.parseInt(id));
		} catch (m:String) {
			return false;
		}
	}
}