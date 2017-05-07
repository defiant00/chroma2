package states.level_editor;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxInputText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class LoadLevelState extends FlxSubState
{
	public var file:String;
	public var ok:Bool;
	
	var _txtFile:FlxInputText;
	
	override public function create():Void 
	{
		super.create();
		
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set(0, 0);
		add(bg);
		
		add(_txtFile = new FlxInputText(8, 8, 160));
		_txtFile.scrollFactor.set(0, 0);
		
		var b:FlxButton;
		add(b = new FlxButton(192, 8, "OK", okClicked));
		b.scrollFactor.set(0, 0);
		add(b = new FlxButton(192, 40, "Cancel", cancelClicked));
		b.scrollFactor.set(0, 0);
	}
	
	function okClicked()
	{
		ok = true;
		file = _txtFile.text;
		close();
	}
	
	function cancelClicked()
	{
		ok = false;
		close();
	}
}