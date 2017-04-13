package states;

//import data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class LevelState extends FlxState
{
	override public function create():Void
	{
		add(new FlxButton(120, 200, "Button", null));
		add(new FlxInputText(10, 10));
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}