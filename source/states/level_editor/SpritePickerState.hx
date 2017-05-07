package states.level_editor;

import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class SpritePickerState extends FlxSubState 
{
	public var state:State;
	public var selectedSprite:String;
	public var prefix:String;
	
	var _baseSprite:FlxSprite;
	var _names:Array<String>;
	var _locations:Array<Rectangle>;
	
	override public function create():Void 
	{
		super.create();
		
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		_names = new Array<String>();
		_locations = new Array<Rectangle>();
		
		_baseSprite = SpriteLoader.GetBaseSprite(state.staticData);
		
		createGrid();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justReleased)
		{
			var x = FlxG.mouse.screenX;
			var y = FlxG.mouse.screenY;
			
			for (i in 0..._locations.length)
			{
				var l = _locations[i];
				if (l.contains(x, y))
				{
					selectedSprite = _names[i];
					close();
					return;
				}
			}
		}
	}
	
	function createGrid():Void
	{
		var areas = new Array<Rectangle>();
		var br:Rectangle;
		areas.push(new Rectangle(0, 0, FlxG.width, FlxG.height));
		for (spr in state.staticData.sprites)
		{
			if (spr.name.indexOf(prefix) == 0)
			{
				br = new Rectangle(spr.boundingRect.x, spr.boundingRect.y, spr.boundingRect.width + 2, spr.boundingRect.height + 2);
				for (i in 0...areas.length)
				{
					var area = areas[i];
					
					if (br.width <= area.width && br.height <= area.height)
					{
						var s = new FlxSprite(area.x + 1, area.y + 1);
						s.loadGraphicFromSprite(_baseSprite);
						s.animation.play(spr.name);
						s.scrollFactor.set(0, 0);
						add(s);
						_names.push(spr.name);
						_locations.push(new Rectangle(area.x, area.y, br.width, br.height));
						
						areas.splice(i, 1);
						if (br.height < area.height)
						{
							areas.insert(i, new Rectangle(area.x, area.y + br.height, area.width, area.height - br.height));
						}
						if (br.width < area.width)
						{
							areas.insert(i, new Rectangle(area.x + br.width, area.y, area.width - br.width, br.height));
						}
						
						break;
					}
				}
			}
		}
	}
}