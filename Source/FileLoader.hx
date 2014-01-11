package;

import flash.Lib;
import openfl.Assets;

class FileLoader {

	public static function loadData( fileSource : String ) : Array <Dynamic> {
		var file = Assets.getText( fileSource );
		var xml = Xml.parse( file.toLowerCase() );
		var characters = xml.elementsNamed("character");
		var dataArray:Array <Dynamic> = new Array();

		var c = 0;

		for( character in characters ) {

			dataArray[c] = new Array();
			dataArray[c].push(character.get("name") );
			dataArray[c].push(character.get("bitmap") );

			var animations = character.elementsNamed("animation");
			var a = 0;

			for( animation in animations ) {

				var animationData = new Array();
				animationData.push( animation.get('name') );
				animationData.push( animation.get('loop') );

				dataArray[c][2 + a] = animationData;

				var frames = animation.elementsNamed('frame');
				var f = 0;

				for( frame in frames ) {
					var frameData:Array <Dynamic> = new Array();
					frameData.push( Std.parseInt( frame.get('duration') ) );
					frameData.push( Std.parseInt( frame.get('x') ) );
					frameData.push( Std.parseInt( frame.get('y') ) );

					frameData.push( Std.parseInt( frame.get('width') ) );
					frameData.push( Std.parseInt( frame.get('height') ) );

					frameData.push( Std.parseInt( frame.get('ref-x') ) );
					frameData.push( Std.parseInt( frame.get('ref-y') ) );
					frameData.push( Std.parseInt( frame.get('id') ) );
					frameData.push( frame.get('trigger') );

					dataArray[c][2 + a][2 + f] = frameData;
					f++;
				}
				a++;
			}
			c++;
		}
		return dataArray;
	}
}
