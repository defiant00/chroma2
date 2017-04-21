package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tiles:Array<Tile>;
	
	static var allowedTileTransitions:Map<String, String> = ["g" => "", "w" => "g"];
	
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
	
	public function getTileAnimation(x:Int, y:Int):String
	{
		var t = getTile(x, y);
		var allowed = allowedTileTransitions[t.type];
		trace(allowed);
		var up = t.type;
		if (y > 0)
		{
			var v = getTile(x, y - 1).type;
			if (allowed.indexOf(v) > -1)
			{
				up = v;
			}
		}
		var right = t.type;
		if (x + 2 < xDim)
		{
			var v = getTile(x + 1, y).type;
			if (allowed.indexOf(v) > -1)
			{
				right = v;
			}
		}
		var down = t.type;
		if (y + 2 < yDim)
		{
			var v = getTile(x, y + 1).type;
			if (allowed.indexOf(v) > -1)
			{
				down = v;
			}
		}
		var left = t.type;
		if (x > 0)
		{
			var v = getTile(x - 1, y).type;
			if (allowed.indexOf(v) > -1)
			{
				left = v;
			}
		}
		
		return "t_" + t.type + up + right + down + left;
	}
}