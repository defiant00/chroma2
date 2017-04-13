package states;

import flixel.FlxG;
import flixel.FlxState;

class SplashState extends FlxState
{
	override public function create():Void
	{
		FlxG.mouse.useSystemCursor = true;

		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		FlxG.switchState(new LevelState());

		super.update(elapsed);
	}
}