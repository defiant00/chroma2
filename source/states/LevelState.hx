package states;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class LevelState extends FlxState
{
	public var state:State;
	
	var _level:Level;
	var _tiles:FlxTypedGroup<FlxSprite>;
	var _tileArray:Array<FlxSprite>;
	var _baseTile:FlxSprite;
	var _tileDropDown:FlxUIDropDownMenu;
	
	override public function create():Void
	{
		_tileArray = new Array<FlxSprite>();
		_level = new Level(20, 20);
		for (i in 0...400)
		{
			_level.tiles.push(new Tile("g", false));
		}
		
		_baseTile = TileLoader.GetBaseTileSprite(state.staticData);
		
		add(_tiles = new FlxTypedGroup<FlxSprite>());
		
		createTiles();
		
		createEditControls();
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		doInput();
		
		super.update(elapsed);
	}
	
	function doInput():Void
	{
		if (FlxG.mouse.pressed)
		{
			var x = FlxG.mouse.x >> 5;
			var y = FlxG.mouse.y >> 5;
			
			if (x > -1 && x < _level.xDim && y > -1 && y < _level.yDim)
			{
				var t = _level.getTile(x, y);
				if (t.type != _tileDropDown.selectedId)
				{
					_level.getTile(x, y).type = _tileDropDown.selectedId;
					setTiles();
				}
			}
		}
		
		//var scrollArea = 64;
		var scrollRate = 10;
		//var fixedX = FlxG.mouse.x + FlxG.camera.x;
		//var fixedY = FlxG.mouse.y + FlxG.camera.y;
		
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W)// || fixedY < scrollArea)
		{
			FlxG.camera.scroll.y -= scrollRate;
		}
		if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S)// || (fixedY > 720 - scrollArea))
		{
			FlxG.camera.scroll.y += scrollRate;
		}
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)// || fixedX < scrollArea)
		{
			FlxG.camera.scroll.x -= scrollRate;
		}
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)// || (fixedX > 1280 - scrollArea))
		{
			FlxG.camera.scroll.x += scrollRate;
		}
		
		if (FlxG.camera.scroll.x > 0)
		{
			FlxG.camera.scroll.x = 0;
		}
		
		if (FlxG.camera.scroll.y > -32)
		{
			FlxG.camera.scroll.y = -32;
		}
	}
	
	function createEditControls():Void
	{
		var tileTypes = new Array<StrNameLabel>();
		tileTypes.push(new StrNameLabel("g", "Grass"));
		tileTypes.push(new StrNameLabel("w", "Water"));
		
		_tileDropDown = new FlxUIDropDownMenu(0, 0, tileTypes);
		_tileDropDown.setScrollFactor(0, 0);
		add(_tileDropDown);
	}
	
	function createTiles():Void
	{
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				var s = new FlxSprite(x * 32, y * 32);
				s.loadGraphicFromSprite(_baseTile);
				s.animation.play(_level.getTileAnimation(x, y), -1);
				_tiles.add(s);
				_tileArray.push(s);
			}
		}
	}
	
	function setTiles():Void
	{
		var counter = 0;
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				_tileArray[counter++].animation.play(_level.getTileAnimation(x, y), -1);
			}
		}
	}
}