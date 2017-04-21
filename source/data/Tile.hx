package data;

class Tile 
{
	public var type:String;
	public var block:Bool;
	
	public function new(type:String, block:Bool)
	{
		this.type = type;
		this.block = block;
	}
}