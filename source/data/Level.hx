package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tiles:Array<Tile>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tiles = new Array<Tile>();
	}
	
	public inline function getTile(x:Int, y:Int):Tile
	{
		return tiles[x + y * xDim];
	}
}