package shell 
{
	import base.Coordinate;
	import base.MapInfo;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author °无量
	 */
	public class Camera 
	{
		private static var globalLeftTopPoint:Point = new Point(0, 0);
		public static var loacalLeftTopPoint:Point = new Point(0, 0);
		static private var gridCoord:Coordinate;
		private static var globalRightBomPoint:Point = new Point(960, 640);
		public static var loacalRightBomPoint:Point = new Point(0, 0);

		public function Camera() 
		{
			
		}
		public static function updateView(target:DisplayObject,mapInfo:MapInfo):void
		{
			loacalLeftTopPoint = target.globalToLocal(globalLeftTopPoint, loacalLeftTopPoint);
			loacalRightBomPoint = target.globalToLocal(globalRightBomPoint, loacalRightBomPoint);
		}
	}

}