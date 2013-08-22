package shell 
{
	import base.Coordinate;
	import base.MapInfo;
	import extend.draw.display.Shape;
	/**
	 * ...
	 * @author °无量
	 */
	public class BlockGird extends Shape
	{
		private var _enable:Boolean;
		private var screenCoord:Coordinate;
		
		public function BlockGird() 
		{
			
		}
		
		public function update(mapInfo:MapInfo):void 
		{
			if (!enable) return;
			this.graphics.clear();
			var a:Coordinate;
			var _x:Number;
			var _y:Number;
			for each(a in mapInfo.blockInfo)
			{
				screenCoord = mapInfo.getScreenPointFromGird(a, screenCoord);
				
				graphics.moveTo(screenCoord.x, screenCoord.y);
				graphics.beginFill(0x008080);
				
				_x = screenCoord.x + mapInfo.tileLength / Math.sqrt(5) * 2;
				_y = screenCoord.y + mapInfo.tileLength / 2 / Math.sqrt(5) * 2;		
				graphics.lineTo(_x, _y);
				
				_x = screenCoord.x;
				_y = screenCoord.y + mapInfo.girdWidth / 2;
				graphics.lineTo(_x, _y);
				
				_x = screenCoord.x - mapInfo.tileLength / Math.sqrt(5) * 2;;
				_y = screenCoord.y + mapInfo.tileLength / 2 / Math.sqrt(5) * 2;		
				graphics.lineTo(_x, _y);
				graphics.lineTo(screenCoord.x, screenCoord.y);
				graphics.endFill();
			}
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;
			if (!_enable)
			{
				this.graphics.clear();
			}
		}
		
		
		
	}

}