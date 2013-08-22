package base {
	
	/**
	 * ...
	 * @author Jobe Makar - jobe@electrotank.com
	 */
	public class Coordinate {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Coordinate(x:Number = 0, y:Number = 0, z:Number = 0):void {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		public function reset(x:Number = 0, y:Number = 0, z:Number = 0):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		public function toString():String
		{
			return "x:" + x + " y:" + y + " z:" + z;
		}
		public function clone():Coordinate 
		{
			return new Coordinate(x, y, z);
		}
	}
	
}