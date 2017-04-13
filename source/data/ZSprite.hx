package data;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxSort;

class ZSprite extends FlxSprite
{
	public var z:Float;
	
	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0, ?simpleGraphic:FlxGraphicAsset) 
	{
		this.z = z;
		super(x, y, simpleGraphic);
	}
	
	public static inline function sortByZ(order:Int, o1:ZSprite, o2:ZSprite):Int
	{
		return FlxSort.byValues(order, o1.z, o2.z);
	}
}