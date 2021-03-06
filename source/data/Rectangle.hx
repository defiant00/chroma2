package data;

class Rectangle 
{
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	
	public function new(x:Int, y:Int, width:Int, height:Int) 
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	public inline function contains(x:Int, y:Int):Bool
	{
		return x >= this.x && x <= (this.x + width) && y >= this.y && y <= (this.y + height);
	}
}