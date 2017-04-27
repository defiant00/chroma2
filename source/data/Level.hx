package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tileXDim:Int;
	public var tileYDim:Int;
	var tiles:Array<String>;
	var decals:Array<String>;
	var blocks:Array<Bool>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tileXDim = xDim + 1;
		this.tileYDim = yDim + 1;
		this.tiles = new Array<String>();
		this.decals = new Array<String>();
		this.blocks = new Array<Bool>();
	}
	
	public function fill(tile:String):Void
	{
		for (i in 0...(tileXDim * tileYDim))
		{
			tiles.push(tile);
		}
		for (i in 0...(xDim * yDim))
		{
			decals.push("");
			blocks.push(false);
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
	
	public inline function getDecal(x:Int, y:Int):String
	{
		return decals[x + y * xDim];
	}
	
	public inline function setDecal(x:Int, y:Int, decal:String):Void
	{
		decals[x + y * xDim] = decal;
	}
	
	public inline function getBlock(x:Int, y:Int):Bool
	{
		return blocks[x + y * xDim];
	}
	
	public inline function setBlock(x:Int, y:Int, block:Bool)
	{
		blocks[x + y * xDim] = block;
	}
}