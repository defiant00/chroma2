package states;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class LevelState extends FlxState
{
	public var state:State;
	
	var _level:Level;
	var _tiles:FlxTypedGroup<FlxSprite>;
	var _baseTile:FlxSprite;
	
	override public function create():Void
	{
		_level = new Level(20, 20);
		for (i in 0...400)
		{
			_level.tiles.push(new Tile("_t0", false));
		}
		
		_baseTile = TileLoader.GetBaseTileSprite(state.staticData);
		
		add(_tiles = new FlxTypedGroup<FlxSprite>());
		
		createTiles();
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	function createTiles():Void
	{
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				var s = new FlxSprite(x * 32, y * 32);
				s.loadGraphicFromSprite(_baseTile);
				s.animation.play(_level.getTile(x, y).name, -1);
				_tiles.add(s);
			}
		}
	}
}