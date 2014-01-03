package;

import flash.Lib;
import openfl.Assets;

class FileLoader {
	private static var DATAFOLDER = "assets/";
	public static function loadXmlFile( fileSource : String , fileType : Filetype ) : Array {
		var file = Assets.getText(fileSource);
		var xml = Xml.parse(file);
		

		trace(file);
	}
}

class Filetype {

	public var name:String;
	public var dataStructure:Array <Dynamic>;

}