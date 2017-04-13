package data;

class Animation 
{
	public var name:String;
	public var indices:Array<Int>;
	public var frameRate:Int;
	public var looped:Bool;
	public var flipX:Bool;
	public var flipY:Bool;
	
	public function new(name:String, indices:Array<Int>, frameRate:Int, looped:Bool, flipX:Bool, flipY:Bool) 
	{
		this.name = name;
		this.indices = indices;
		this.frameRate = frameRate;
		this.looped = looped;
		this.flipX = flipX;
		this.flipY = flipY;
	}
}