package;

class Action {

	private var preformer:Int;
	private var action:Int;
	private var player:Int;
	private var recipiant:Int;
	
	public function new (p:Int, a:Int, p:Int, r:Int) {
		preformer = p;
		action = a;
		player = p;
		recipiant = r;
	}

	public function getPreformer() {
		return preformer;
	}

	public function getAction() {
		return action;
	}

	public function getPlayer() {
		return player;
	}

	public function getRecipiant() {
		return recipiant;
	}
}