package states;

import data.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Json;
import sys.io.File;

class SplashState extends FlxState
{
	var _totalTime:Float;
	var _state:State;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.useSystemCursor = true;

		var t = new FlxText("Deffie Games Presents...");
		t.size = 32;
		t.screenCenter();
		add(t);

		_totalTime = 0;
		
		loadGameData();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_totalTime += elapsed;

		//
		// TODO - Change this to _totalTime > 3 or however many seconds the splash screen should wait before auto-advancing.
		//
		if (_totalTime > 0 || FlxG.mouse.justPressed || FlxG.keys.anyJustPressed([ESCAPE, SPACE, ENTER]))
		{
			var ls = new LevelState();
			ls.state = _state;
			FlxG.switchState(ls);
		}
	}
	
	function loadGameData():Void
	{
		_state = new State();
		_state.staticData = new StaticData();
		
		// Animations
		var aArr:Array<Dynamic> = Json.parse(File.getContent("assets/data/animations.json"));
		for (animation in aArr)
		{
			var a = new Animation(animation.name, animation.indices, animation.frameRate, animation.looped, animation.flipX, animation.flipY);
			_state.staticData.animations.push(a);
		}
	}
}