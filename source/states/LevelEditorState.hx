package states;

import data.*;
import haxe.Json;
import states.level_editor.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sys.io.File;

class LevelEditorState extends FlxState
{
	public var state:State;
	
	var _level:Level;
	var _tiles:FlxTypedGroup<FlxSprite>;
	var _decals:FlxTypedGroup<FlxSprite>;
	var _blocks:FlxTypedGroup<FlxSprite>;
	var _tileHover:FlxSprite;
	var _blockHover:FlxSprite;
	var _editControls:FlxTypedGroup<FlxSprite>;
	var _tileArray:Array<FlxSprite>;
	var _decalArray:Array<FlxSprite>;
	var _blockArray:Array<FlxSprite>;
	var _baseSprite:FlxSprite;
	var _selectedTile:FlxSprite;
	var _tileAngle:Float;
	var _tileAngleText:FlxText;
	var _selectedDecal:FlxSprite;
	var _decalAngle:Float;
	var _decalAngleText:FlxText;
	var _tilePicker:SpritePickerState;
	var _decalPicker:SpritePickerState;
	var _showBlocks:Bool;
	var _showDecals:Bool;
	var _statusText:FlxText;
	
	var _newState:NewLevelState;
	var _saveState:SaveLevelState;
	var _loadState:LoadLevelState;
	
	override public function create():Void
	{
		super.create();
		
		destroySubStates = false;
		
		_showBlocks = true;
		_showDecals = true;
		
		_tileAngle = 0;
		_decalAngle = 0;
		
		_tilePicker = new SpritePickerState();
		_tilePicker.state = state;
		_tilePicker.prefix = "t_";
		_tilePicker.closeCallback = tilePickerClosed;
		
		_decalPicker = new SpritePickerState();
		_decalPicker.state = state;
		_decalPicker.prefix = "d_";
		_decalPicker.closeCallback = decalPickerClosed;
		
		_newState = new NewLevelState();
		_newState.closeCallback = newClosed;
		_newState.x = 20;
		_newState.y = 20;
		_newState.ok = true;
		
		_saveState = new SaveLevelState();
		_saveState.closeCallback = saveClosed;
		
		_loadState = new LoadLevelState();
		_loadState.closeCallback = loadClosed;
		
		_baseSprite = SpriteLoader.GetBaseSprite(state.staticData);
		
		add(_tiles = new FlxTypedGroup<FlxSprite>());
		add(_decals = new FlxTypedGroup<FlxSprite>());
		add(_blocks = new FlxTypedGroup<FlxSprite>());
		
		createEditControls();
		
		newClosed();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		doInput();
	}
	
	function tilePickerClosed():Void
	{
		_selectedTile.animation.play(_tilePicker.selectedSprite);
	}
	
	function decalPickerClosed():Void
	{
		setSelectedDecal(_decalPicker.selectedSprite);
	}
	
	function newClosed():Void
	{
		if (_newState.ok)
		{
			_level = new Level(_newState.x, _newState.y);
			_level.fill("t_gggg");
			
			updateSprites();
		}
	}
	
	function saveClosed():Void
	{
		if (_saveState.ok)
		{
			File.saveContent("C:\\git\\chroma2\\assets\\data\\" + _saveState.file + ".json", Json.stringify(_level, "\t"));
		}
	}
	
	function loadClosed():Void
	{
		if (_loadState.ok)
		{
			var lvl = Json.parse(File.getContent("C:\\git\\chroma2\\assets\\data\\" + _loadState.file + ".json"));
			
			_level = new Level(lvl.xDim, lvl.yDim);
			_level.deserialize(lvl);
			
			updateSprites();
		}
	}
	
	function updateSprites():Void
	{
		_tileArray = new Array<FlxSprite>();
		_decalArray = new Array<FlxSprite>();
		_blockArray = new Array<FlxSprite>();
		
		_tiles.clear();
		_decals.clear();
		_blocks.clear();
		
		createTiles();
		createDecals();
		createBlocks();
	}
	
	function doInput():Void
	{
		var x = FlxG.mouse.x >> 5;
		var y = FlxG.mouse.y >> 5;
		var bx = (FlxG.mouse.x - 16) >> 5;
		var by = (FlxG.mouse.y - 16) >> 5;
		var sx = FlxG.mouse.screenX;
		var sy = FlxG.mouse.screenY;
		
		_tileHover.setPosition(x * 32, y * 32);
		_blockHover.setPosition(bx * 32 + 16, by * 32 + 16);
		
		if (FlxG.mouse.pressed || FlxG.mouse.justPressedRight)
		{
			if (sy > -1 && sy < 35)
			{
				if (sx > -1 && sx < 35)
				{
					if (FlxG.mouse.pressed)
					{
						openSubState(_tilePicker);
					}
					else
					{
						_tileAngle = (_tileAngle + 90) % 360;
						_selectedTile.angle = _tileAngle;
						_tileAngleText.text = Std.string(_tileAngle);
					}
				}
				else if (sx > 34 && sx < 69)
				{
					if (FlxG.mouse.pressed)
					{
						openSubState(_decalPicker);
					}
					else
					{
						_decalAngle = (_decalAngle + 90) % 360;
						_selectedDecal.angle = _decalAngle;
						_decalAngleText.text = Std.string(_decalAngle);
					}
				}
			}
			else if (FlxG.mouse.pressed && x > -1 && x < _level.tileXDim && y > -1 && y < _level.tileYDim)
			{
				var t = _level.getTile(x, y);
				if (t.name != _selectedTile.animation.name || t.angle != _selectedTile.angle)
				{
					t.name = _selectedTile.animation.name;
					t.angle = _tileAngle;
					setTiles();
				}
			}
			else if (FlxG.mouse.justPressedRight && bx > -1 && bx < _level.xDim && by > -1 && by < _level.yDim)
			{
				var block = _level.getBlock(bx, by);
						
				if (FlxG.keys.pressed.SHIFT)
				{
					block.blocked = !block.blocked;
					setBlocks();
				}
				else
				{
					block.decal = block.decal == "" ? _selectedDecal.animation.name : "";
					block.angle = _decalAngle;
					setDecals();
				}
			}
		}
		
		if (FlxG.keys.justPressed.B)
		{
			_showBlocks = !_showBlocks;
			setStatusText();
			setBlocks();
		}
		
		if (FlxG.keys.justPressed.C)
		{
			_showDecals = !_showDecals;
			setStatusText();
			setDecals();
		}
		
		if (FlxG.keys.pressed.CONTROL)
		{
			if (FlxG.keys.justPressed.N)
			{
				openSubState(_newState);
			}
			if (FlxG.keys.justPressed.S)
			{
				openSubState(_saveState);
			}
			if (FlxG.keys.justPressed.L)
			{
				openSubState(_loadState);
			}
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
		add(_tileHover = new FlxSprite(0, 0));
		_tileHover.loadGraphicFromSprite(_baseSprite);
		_tileHover.animation.play("corners");
		
		add(_blockHover = new FlxSprite(16, 16));
		_blockHover.loadGraphicFromSprite(_baseSprite);
		_blockHover.animation.play("corners");
		_blockHover.color = FlxColor.RED;
		
		add(_editControls = new FlxTypedGroup<FlxSprite>());
		var bg = new FlxSprite().makeGraphic(FlxG.width, 34, 0x80000000);
		bg.scrollFactor.set(0, 0);
		_editControls.add(bg);
		
		_editControls.add(_selectedTile = new FlxSprite(1, 1));
		_selectedTile.loadGraphicFromSprite(_baseSprite);
		_selectedTile.animation.play("t_gggg");
		_selectedTile.scrollFactor.set(0, 0);
		
		_editControls.add(_selectedDecal = new FlxSprite());
		_selectedDecal.loadGraphicFromSprite(_baseSprite);
		setSelectedDecal("d_flower1");
		_selectedDecal.scrollFactor.set(0, 0);
		
		_editControls.add(_tileAngleText = new FlxText(2, 2));
		_tileAngleText.scrollFactor.set(0, 0);
		_tileAngleText.text = "0";
		
		_editControls.add(_decalAngleText = new FlxText(36, 2));
		_decalAngleText.scrollFactor.set(0, 0);
		_decalAngleText.text = "0";
		
		_editControls.add(_statusText = new FlxText(120, 4));
		_statusText.scrollFactor.set(0, 0);
		setStatusText();
	}
	
	function setSelectedDecal(decal: String):Void
	{
		_selectedDecal.animation.play(decal, -1);
		_selectedDecal.setPosition(35 + ((32 - _selectedDecal.frameWidth) >> 1), 1 + ((32 - _selectedDecal.frameHeight) >> 1));
	}
	
	function setDecal(spr: FlxSprite, decal: String, x:Int, y:Int):Void
	{
		spr.animation.play(decal, -1);
		spr.setPosition(x * 32 + 16 + ((32 - spr.frameWidth) >> 1), y * 32 + 16 + ((32 - spr.frameHeight) >> 1));
	}
	
	function setStatusText():Void
	{
		_statusText.text = (_showBlocks ? "(B)locks Displayed" : "(B)locks Hidden") + "\n" + (_showDecals ? "De(c)als Displayed" : "De(c)als Hidden");
	}
	
	function createTiles():Void
	{
		for (x in 0..._level.tileXDim)
		{
			for (y in 0..._level.tileYDim)
			{
				var s = new FlxSprite(x * 32, y * 32);
				s.loadGraphicFromSprite(_baseSprite);
				var t = _level.getTile(x, y);
				s.animation.play(t.name, -1);
				s.angle = t.angle;
				_tiles.add(s);
				_tileArray.push(s);
			}
		}
	}
	
	function createDecals():Void
	{
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				var s = new FlxSprite();
				s.loadGraphicFromSprite(_baseSprite);
				var block = _level.getBlock(x, y);
				if (block.decal != "" && _showDecals)
				{
					setDecal(s, block.decal, x, y);
					s.angle = block.angle;
					s.visible = true;
				}
				else
				{
					s.visible = false;
				}
				_decals.add(s);
				_decalArray.push(s);
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
				s.visible = _level.getBlock(x, y).blocked;
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
				var t = _level.getTile(x, y);
				_tileArray[counter].animation.play(t.name, -1);
				_tileArray[counter++].angle = t.angle;
			}
		}
	}
	
	function setDecals():Void
	{
		var counter = 0;
		for (x in 0..._level.xDim)
		{
			for (y in 0..._level.yDim)
			{
				var block = _level.getBlock(x, y);
				var s = _decalArray[counter++];
				if (block.decal != "" && _showDecals)
				{
					setDecal(s, block.decal, x, y);
					s.angle = block.angle;
					s.visible = true;
				}
				else
				{
					s.visible = false;
				}
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
				_blockArray[counter++].visible = _showBlocks && _level.getBlock(x, y).blocked;
			}
		}
	}
}