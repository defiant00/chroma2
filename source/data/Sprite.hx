package data;

class Sprite 
{
	public var name:String;
	public var indices:Array<Int>;
	public var frameRate:Int;
	public var looped:Bool;
	public var flipX:Bool;
	public var flipY:Bool;
	public var boundingRect:Rectangle;
	
	public function new(name:String, indices:Array<Int>, frameRate:Int, looped:Bool, flipX:Bool, flipY:Bool, state:State) 
	{
		this.name = name;
		this.indices = indices;
		this.frameRate = frameRate;
		this.looped = looped;
		this.flipX = flipX;
		this.flipY = flipY;
		
		boundingRect = new Rectangle(0, 0, 0, 0);
		for (ind in indices)
		{
			var area = state.staticData.areas[ind];
			if (boundingRect.width < area.width)
			{
				boundingRect.width = area.width;
			}
			if (boundingRect.height < area.height)
			{
				boundingRect.height = area.height;
			}
		}
	}
}