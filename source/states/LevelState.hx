package states;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class LevelState extends FlxState
{
	public var state:State;
	
	var _level:Level;
	var _tiles:FlxTypedGroup<FlxSprite>;
	var _editControls:FlxTypedGroup<FlxSprite>;
	var _tileArray:Array<FlxSprite>;
	var _baseSprite:FlxSprite;
	var _editTile:FlxSprite;
	var _tilePicker:TilePickerState;
	
	override public function create():Void
	{
		super.create();
		
		destroySubStates = false;
		
		_tilePicker = new TilePickerState();
		_tilePicker.state = state;
		_tilePicker.closeCallback = tilePickerClosed;
		
		_tileArray = new Array<FlxSprite>();
		_level = new Level(20, 20);
		_level.fill("t_gggg");
		
		_baseSprite = TileLoader.GetBaseTileSprite(state.staticData);
		
		add(_tiles = new FlxTypedGroup<FlxSprite>());
		
		createTiles();
		
		createEditControls();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		doInput();
	}
	
	function tilePickerClosed():Void
	{
		_editTile.animation.play(_tilePicker.selectedTile);
	}
	
	function doInput():Void
	{
		if (FlxG.mouse.pressed)
		{
			var x = FlxG.mouse.x >> 5;
			var y = FlxG.mouse.y >> 5;
			
			if (x > -1 && x < _level.tileXDim && y > -1 && y < _level.tileYDim)
			{
				if (_level.getTile(x, y) != _editTile.animation.name)
				{
					_level.setTile(x, y, _editTile.animation.name);
					setTiles();
				}
			}
			else if (x == 0 && y == -1)
			{
				openSubState(_tilePicker);
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
		add(_editControls = new FlxTypedGroup<FlxSprite>());
		_editTile = new FlxSprite();
		_editTile.loadGraphicFromSprite(_baseSprite);
		_editTile.animation.play("t_gggg");
		_editTile.scrollFactor.x = 0;
		_editTile.scrollFactor.y = 0;
		_editControls.add(_editTile);
	}
	
	function createTiles():Void
	{
		for (x in 0..._level.tileXDim)
		{
			for (y in 0..._level.tileYDim)
			{
				var s = new FlxSprite(x * 32, y * 32);
				s.loadGraphicFromSprite(_baseSprite);
				s.animation.play(_level.getTile(x, y), -1);
				_tiles.add(s);
				_tileArray.push(s);
			}
		}
	}
	
	function setTiles():Void
	{
		var counter = 0;
		for (x in 0..._level.tileXDim)
		{
			for (y in 0..._level.tileYDim)
			{
				_tileArray[counter++].animation.play(_level.getTile(x, y), -1);
			}
		}
	}
}