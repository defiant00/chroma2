package data;
import flixel.tile.FlxTileblock;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tileXDim:Int;
	public var tileYDim:Int;
	var tiles:Array<String>;
	var blocks:Array<LevelBlock>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tileXDim = xDim + 1;
		this.tileYDim = yDim + 1;
		this.tiles = new Array<String>();
		this.blocks = new Array<LevelBlock>();
	}
	
	public function deserialize(obj:Dynamic)
	{
		tiles = obj.tiles;
		
		var blArr:Array<Dynamic> = obj.blocks;
		for (bl in blArr)
		{
			blocks.push(new LevelBlock(bl.blocked, bl.decal));
		}
	}
	
	public function fill(tile:String):Void
	{
		for (i in 0...(tileXDim * tileYDim))
		{
			tiles.push(tile);
		}
		for (i in 0...(xDim * yDim))
		{
			blocks.push(new LevelBlock(false, ""));
		}
	}
	
	public inline function getTile(x:Int, y:Int):String
	{
		return tiles[x + y * tileXDim];
	}
	
	public inline function setTile(x:Int, y:Int, tile:String):Void
	{
		tiles[x + y * tileXDim] = tile;
	}
	
	public inline function getBlock(x:Int, y:Int):LevelBlock
	{
		return blocks[x + y * xDim];
	}
}