package states;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class LevelEditorState extends FlxState
{
	public var state:State;
	
	var _level:Level;
	var _tiles:FlxTypedGroup<FlxSprite>;
	var _blocks:FlxTypedGroup<FlxSprite>;
	var _editControls:FlxTypedGroup<FlxSprite>;
	var _tileArray:Array<FlxSprite>;
	var _blockArray:Array<FlxSprite>;
	var _baseSprite:FlxSprite;
	var _editTile:FlxSprite;
	var _tilePicker:TilePickerState;
	var _scrollX:Float;
	var _scrollY:Float;
	var _showBlocks:Bool;
	var _blockStatus:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		destroySubStates = false;
		
		_showBlocks = true;
		
		_tilePicker = new TilePickerState();
		_tilePicker.state = state;
		_tilePicker.closeCallback = tilePickerClosed;
		
		_tileArray = new Array<FlxSprite>();
		_blockArray = new Array<FlxSprite>();
		_level = new Level(20, 20);
		_level.fill("t_gggg");
		
		_baseSprite = SpriteLoader.GetBaseSprite(state.staticData);
		
		add(_tiles = new FlxTypedGroup<FlxSprite>());
		add(_blocks = new FlxTypedGroup<FlxSprite>());
		
		createTiles();
		createBlocks();
		
		createEditControls();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		doInput();
	}
	
	function tilePickerClosed():Void
	{
		loadScroll();
		_editTile.animation.play(_tilePicker.selectedTile);
	}
	
	function saveScroll():Void
	{
		_scrollX = FlxG.camera.scroll.x;
		_scrollY = FlxG.camera.scroll.y;
		FlxG.camera.scroll.set(0, 0);
	}
	
	function loadScroll():Void
	{
		FlxG.camera.scroll.set(_scrollX, _scrollY);
	}
	
	function doInput():Void
	{
		if (FlxG.mouse.pressed)
		{
			var sx = FlxG.mouse.screenX;
			var sy = FlxG.mouse.screenY;
			
			var x = FlxG.mouse.x >> 5;
			var y = FlxG.mouse.y >> 5;
			
			if (sx > -1 && sx < 35 && sy > -1 && sy < 35)
			{
				saveScroll();
				openSubState(_tilePicker);
			}
			else if (x > -1 && x < _level.tileXDim && y > -1 && y < _level.tileYDim)
			{
				if (_level.getTile(x, y) != _editTile.animation.name)
				{
					_level.setTile(x, y, _editTile.animation.name);
					setTiles();
				}
			}
		}
		
		if (FlxG.mouse.justPressedRight)
		{
			var x = (FlxG.mouse.x - 16) >> 5;
			var y = (FlxG.mouse.y - 16) >> 5;
			
			if (x > -1 && x < _level.xDim && y > -1 && y < _level.yDim)
			{
				_level.setBlock(x, y, !_level.getBlock(x, y));
				setBlocks();
			}
		}
		
		if (FlxG.keys.justPressed.B)
		{
			_showBlocks = !_showBlocks;
			_blockStatus.text = _showBlocks ? "Blocks Displayed" : "Blocks Hidden";
			setBlocks();
		}
		
		var scrollRate = 10;
		
		if (FlxG.keys.pressed.W)
		{
			FlxG.camera.scroll.y -= scrollRate;
		}
		if (FlxG.keys.pressed.S)
		{
			FlxG.camera.scroll.y += scrollRate;
		}
		if (FlxG.keys.pressed.A)
		{
			FlxG.camera.scroll.x -= scrollRate;
		}
		if (FlxG.keys.pressed.D)
		{
			FlxG.camera.scroll.x += scrollRate;
		}
	}
	
	function createEditControls():Void
	{
		add(_editControls = new FlxTypedGroup<FlxSprite>());
		var bg = new FlxSprite().makeGraphic(FlxG.width, 34, 0x80000000);
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		_editControls.add(bg);
		
		_editControls.add(_editTile = new FlxSprite(1, 1));
		_editTile.loadGraphicFromSprite(_baseSprite);
		_editTile.animation.play("t_gggg");
		_editTile.scrollFactor.x = 0;
		_editTile.scrollFactor.y = 0;
		
		_editControls.add(_blockStatus = new FlxText(36, 4));
		_blockStatus.scrollFactor.x = 0;
		_blockStatus.scrollFactor.y = 0;
		_blockStatus.text = "Blocks Displayed";
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
	
	function createBlocks():Void
	{
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				var s = new FlxSprite(x * 32 + 16, y * 32 + 16);
				s.loadGraphicFromSprite(_baseSprite);
				s.animation.play("indicator", -1);
				s.visible = _level.getBlock(x, y);
				s.color = FlxColor.RED;
				_blocks.add(s);
				_blockArray.push(s);
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
	
	function setBlocks():Void
	{
		var counter = 0;
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				_blockArray[counter++].visible = _showBlocks && _level.getBlock(x, y);
			}
		}
	}
}