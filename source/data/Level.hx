package data;

class Level 
{
	public var xDim:Int;
	public var yDim:Int;
	public var tileXDim:Int;
	public var tileYDim:Int;
	var tiles:Array<LevelTile>;
	var blocks:Array<LevelBlock>;
	
	public function new(xDim:Int, yDim:Int)
	{
		this.xDim = xDim;
		this.yDim = yDim;
		this.tileXDim = xDim + 1;
		this.tileYDim = yDim + 1;
		this.tiles = new Array<LevelTile>();
		this.blocks = new Array<LevelBlock>();
	}
	
	public function deserialize(obj:Dynamic)
	{
		var tArr:Array<Dynamic> = obj.tiles;
		for (t in tArr)
		{
			tiles.push(new LevelTile(t.name, t.angle));
		}
		
		var bArr:Array<Dynamic> = obj.blocks;
		for (b in bArr)
		{
			blocks.push(new LevelBlock(b.blocked, b.decal, b.angle));
		}
	}
	
	public function fill(tile:String):Void
	{
		for (i in 0...(tileXDim * tileYDim))
		{
			tiles.push(new LevelTile(tile));
		}
		for (i in 0...(xDim * yDim))
		{
			blocks.push(new LevelBlock(false, ""));
		}
	}
	
	public inline function getTile(x:Int, y:Int):LevelTile
	{
		return tiles[x + y * tileXDim];
	}
	
	public inline function getBlock(x:Int, y:Int):LevelBlock
	{
		return blocks[x + y * xDim];
	}
}