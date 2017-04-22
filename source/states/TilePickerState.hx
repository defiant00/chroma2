package states;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TilePickerState extends FlxSubState 
{
	public var state:State;
	public var selectedTile:String;
	
	var _baseSprite:FlxSprite;
	var _tiles:Array<String>;
	
	override public function create():Void 
	{
		super.create();
		
		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
		
		_tiles = new Array<String>();
		
		_baseSprite = TileLoader.GetBaseTileSprite(state.staticData);
		
		createTileGrid();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justReleased)
		{
			var x = Std.int(FlxG.mouse.x / 34);
			var y = Std.int(FlxG.mouse.y / 34);
			var i = x + y * 37;
			if (i > -1 && i < _tiles.length)
			{
				selectedTile = _tiles[i];
				close();
			}
		}
	}
	
	function createTileGrid():Void
	{
		var count = 0;
		for (a in state.staticData.animations)
		{
			if (a.name.indexOf("t_") == 0)
			{
				var x = (count % 37) * 34;
				var y = Std.int(count / 37) * 34;
				
				var s = new FlxSprite(x, y);
				s.loadGraphicFromSprite(_baseSprite);
				s.animation.play(a.name);
				add(s);
				_tiles.push(a.name);
				count++;
			}
		}
	}
}