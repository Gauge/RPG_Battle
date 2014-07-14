package graphics.screens;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;

import graphics.uicomponents.Splash;

import motion.Actuate;
import motion.easing.Quad;

class SplashRunner extends Sprite {

	private var blackout:Bitmap;
	private var splashList:Array<String>;
	private var splashCounter:Int = 0;
	private var splash:Splash;
	
	public function new(_splashList) {
		super();
		splashList = _splashList;
		blackout_background();
		runSplashes();
		Lib.current.stage.addEventListener(Event.RESIZE, resizeSplash);
		addEventListener(MouseEvent.MOUSE_DOWN, skip);
	}

	private function blackout_background () {
		blackout = new Bitmap();
		blackout.graphics.beginFill(0x141414);
		blackout.graphics.drawRect(0,0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		addChild(blackout);
	}

	private function runSplashes() {
		if(splashCounter < splashList.length) {
			splash = new Splash(splashList[splashCounter]);
			addChild(splash);
			splash.alpha = 0;
			Actuate.tween(splash, 2, {alpha: 1}).delay(.4).ease(Quad.easeIn).onComplete(
			function() {
				Actuate.tween(splash, 2, {alpha: 0}).delay(.8).ease(Quad.easeOut).onComplete(function(){splashCounter++;runSplashes();});
			});
		}
		else {
			removeEventListener(MouseEvent.MOUSE_DOWN, skip);
			var event = new Event('splash_complete', true);
			dispatchEvent(event);
		}
	}

	public function resizeSplash(e : Event) {
		Actuate.pauseAll();
		var stageW = Lib.current.stage.stageWidth;
		var stageH = Lib.current.stage.stageHeight;
		blackout.width = stageW;
		blackout.height = stageH;
		splash.width = stageW;
		splash.height = stageH;
		Actuate.resumeAll();
	}

	private function skip( e : MouseEvent) {
		Actuate.reset();
		splash.alpha = 0;
		splashCounter++;
		runSplashes();
	}
}