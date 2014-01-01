package;

import flash.Lib;
import openfl.Assets;

class FileLoader {
	public function loadXmlFile( fileSource : String) : Void {
		var file = Assets.getText(fileSource);
		trace(file); 
	}
}