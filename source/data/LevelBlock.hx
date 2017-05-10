package data;

class LevelBlock 
{
	public var blocked:Bool;
	public var decal:String;
	public var angle:Float;
	
	public function new(blocked:Bool, decal:String, angle:Float = 0) 
	{
		this.blocked = blocked;
		this.decal = decal;
		this.angle = angle;
	}	
}