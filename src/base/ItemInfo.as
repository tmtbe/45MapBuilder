package base 
{
	/**
	 * ...
	 * @author °无量
	 */
	public class ItemInfo 
	{
		public var rows:int = 1;
		public var cols:int = 1;
		public var xoffset:int = 0;
		public var yoffset:int = 0;
		public var id:String;
		public var ifCarton:Boolean;
		public var cartonID:String;
		public var fps:int;
		public function ItemInfo() 
		{
			
		}
		
		public function clone():ItemInfo 
		{
			var a:ItemInfo = new ItemInfo();
			a.rows = rows;
			a.cols = cols;
			a.xoffset = xoffset;
			a.yoffset = yoffset;
			a.id = id;
			a.ifCarton = ifCarton;
			a.cartonID = cartonID;
			a.fps = fps;
			return a;
		}
		public function copy(source:ItemInfo):void
		{
			rows = source.rows;
			cols = source.cols;
			xoffset = source.xoffset;
			yoffset = source.yoffset;
			id = source.id;
			ifCarton = source.ifCarton;
			cartonID = source.cartonID;
			fps = source.fps;
		}
	}

}