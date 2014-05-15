package graphics;

class Sequence {
	public function new(){}

	public var seqList:Array <Dynamic>;

	public function load( ?rawSequence : Array <Dynamic> ) :Void {
		seqList = new Array();
		if(rawSequence != null){
			for(action in rawSequence) {
				var character = action.selectedCharacter + (action.selectedPlayer * 4);
				var target = action.targetCharacter + (action.targetPlayer * 4);
				var anim = action.action;
				var damage = action.report.damage_dealt;

				seqList.push([character, target, anim, damage]);
			}
		}
		trace(seqList);
	}

	public function get(index : Int) : Array <Int> {
		return seqList[index];
	}

	public function shift() :Void {
		seqList.shift();
	}
}