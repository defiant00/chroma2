package states.level_editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class NewLevelState extends FlxSubState
{
	public var x:Int;
	public var y:Int;
	public var ok:Bool;
	
	var _txtX:FlxInputText;
	var _txtY:FlxInputText;
	
	override public function create():Void 
	{
		super.create();
		
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		x = 20;
		y = 20;
		
		add(_txtX = new FlxInputText(8, 8, 80, Std.string(x)));
		_txtX.scrollFactor.set(0, 0);
		add(_txtY = new FlxInputText(96, 8, 80, Std.string(y)));
		_txtY.scrollFactor.set(0, 0);
		var b:FlxButton;
		add(b = new FlxButton(192, 8, "OK", okClicked));
		b.scrollFactor.set(0, 0);
		add(b = new FlxButton(192, 40, "Cancel", cancelClicked));
		b.scrollFactor.set(0, 0);
	}
	
	function okClicked()
	{
		ok = true;
		x = Std.parseInt(_txtX.text);
		y = Std.parseInt(_txtY.text);
		close();
	}
	
	function cancelClicked()
	{
		ok = false;
		close();
	}
}