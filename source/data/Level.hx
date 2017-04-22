package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tiles:Array<String>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tiles = new Array<String>();
	}
	
	public function fill(tile:String):Void
	{
		for (i in 0...((xDim + 1) * (yDim + 1)))
		{
			tiles.push(tile);
		}
	}
	
	public inline function getTile(x:Int, y:Int):String
	{
		return tiles[x + y * (xDim + 1)];
	}
	
	public inline function setTile(x:Int, y:Int, tile:String):Void
	{
		tiles[x + y * (xDim + 1)] = tile;
	}
	
	public function getTileAnimation(x:Int, y:Int):String
	{
		var t = getTile(x, y);
		var tx = getTile(x + 1, y);
		var txy = getTile(x + 1, y + 1);
		var ty = getTile(x, y + 1);
		
		return "t_" + t + tx + txy + ty;
	}
}