package data;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxRect;

class SpriteLoader 
{
	public static function GetBaseSprite(stat:StaticData):FlxSprite
	{		
		var baseSprite = new FlxSprite("assets/images/sprites.png");
		var f = new FlxFramesCollection(baseSprite.graphic);
		
		for (i in 0...stat.areas.length)
		{
			f.addSpriteSheetFrame(new FlxRect(stat.areas[i].x, stat.areas[i].y, stat.areas[i].width, stat.areas[i].height));
		}
		
		baseSprite.setFrames(f);
		
		for (sprite in stat.sprites)
		{
			baseSprite.animation.add(sprite.name, sprite.indices, sprite.frameRate, sprite.looped, sprite.flipX, sprite.flipY);
		}
		
		return baseSprite;
	}
}