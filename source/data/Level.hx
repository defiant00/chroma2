package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tileXDim:Int;
	public var tileYDim:Int;
	public var tiles:Array<String>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tileXDim = xDim + 1;
		this.tileYDim = yDim + 1;
		this.tiles = new Array<String>();
	}
	
	public function fill(tile:String):Void
	{
		for (i in 0...(tileXDim * tileYDim))
		{
			tiles.push(tile);
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
}