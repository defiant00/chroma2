package data;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxRect;

class TileLoader 
{
	public static function GetBaseTileSprite(stat:StaticData):FlxSprite
	{		
		var tileMapSize = 2048;
		var smallTileSize = 32;
		var largeTileSize = 64;
		var numSmallTileRows = 8;
		var numLargeTileRows = 28;
		var numSmallTilesPerRow = Std.int(tileMapSize / smallTileSize);
		var numLargeTilesPerRow = Std.int(tileMapSize / largeTileSize);
		var startingLargeRow = Std.int(numSmallTileRows / 2);
		
		var tiles = new FlxSprite("assets/images/tiles.png");
		var f = new FlxFramesCollection(tiles.graphic);
		
		for (r in 0...numSmallTileRows)
		{
			for (t in 0...numSmallTilesPerRow)
			{
				f.addSpriteSheetFrame(new FlxRect(t * smallTileSize, r * smallTileSize, smallTileSize, smallTileSize));
			}
		}
		for (r in startingLargeRow...numLargeTileRows)
		{
			for (t in 0...numLargeTilesPerRow)
			{
				f.addSpriteSheetFrame(new FlxRect(t * largeTileSize, r * largeTileSize, largeTileSize, largeTileSize));
			}
		}
		
		tiles.setFrames(f);
		
		for (anim in stat.animations)
		{
			tiles.animation.add(anim.name, anim.indices, anim.frameRate, anim.looped, anim.flipX, anim.flipY);
		}
		
		return tiles;
	}
}