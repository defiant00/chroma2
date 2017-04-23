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
			var ls = new LevelEditorState();
			ls.state = _state;
			FlxG.switchState(ls);
		}
	}
	
	function loadGameData():Void
	{
		_state = new State();
		_state.staticData = new StaticData();
		
		var spr = Json.parse(File.getContent("assets/data/sprites.json"));
		
		// Areas
		var areas:Array<Dynamic> = spr.areas;
		for (area in areas)
		{
			var a = new Area(area.x, area.y, area.width, area.height);
			_state.staticData.areas.push(a);
		}
		
		// Sprites
		var sprites:Array<Dynamic> = spr.sprites;
		for (sprite in sprites)
		{
			var s = new Sprite(sprite.name, sprite.indices, sprite.frameRate, sprite.looped, sprite.flipX, sprite.flipY);
			_state.staticData.sprites.push(s);
		}
	}
}