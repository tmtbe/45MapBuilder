package shell 
{
	import base.Isometric;
	import base.MapInfo;
	import extend.draw.display.Shape;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.textures.RenderTexture;
	/**
	 * ...
	 * @author °无量
	 */
	public class CreatGird extends Shape
	{
		private var cols:int;
		private var rows:int;
		private var mapInfo:MapInfo;
		private var blockGird:BlockGird;
		public function CreatGird(mapInfo:MapInfo) 
		{			
			reset(mapInfo);
		}
		
		public function reset(mapInfo:MapInfo):void 
		{			
			this.mapInfo = mapInfo;
			this.graphics.clear();
			removeEventListener(EnterFrameEvent.ENTER_FRAME, updata);
			cols = rows = mapInfo.mapLength / mapInfo.tileLength;
			for (var i:int = 0; i <= cols; i++)
			{
				drawLine(i,i);
			}
			blockGird = new BlockGird();
			addChild(blockGird);
			addEventListener(EnterFrameEvent.ENTER_FRAME, updata);
		}
		public function set showBlock(value:Boolean):void
		{
			blockGird.enable = value;
		}
		private function updata(e:EnterFrameEvent):void 
		{
			blockGird.update(mapInfo);
		}
		private function drawLine(row:int,col:int):void
		{
			var _x:Number;
			var _y:Number;
			
			graphics.lineStyle(1, 0xC0C0C0, 1);
			
			_x = mapInfo.rootPointX - mapInfo.tileLength / Math.sqrt(5) * row * 2;
			_y = mapInfo.rootPointY + mapInfo.tileLength / 2 / Math.sqrt(5) * row * 2;		
			graphics.moveTo(_x, _y);
			graphics.lineTo(_x + mapInfo.mapLength / Math.sqrt(5) * 2, _y + mapInfo.mapLength / Math.sqrt(5));
			
			_x = mapInfo.rootPointX + mapInfo.tileLength / Math.sqrt(5) * col * 2;
			_y = mapInfo.rootPointY + mapInfo.tileLength / 2 / Math.sqrt(5) * col * 2;
			graphics.moveTo(_x, _y);
			graphics.lineTo(_x - mapInfo.mapLength / Math.sqrt(5) * 2, _y + mapInfo.mapLength / Math.sqrt(5));
		}
	}

}