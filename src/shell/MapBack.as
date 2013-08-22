package shell 
{
	import base.Coordinate;
	import base.MapInfo;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author °无量
	 */
	public class MapBack extends Sprite
	{
		public var mapWidth:int;
		public var mapHeight:int;
		private var assetManager:AssetManager;
		private var mapName:String;
		private var cols:int;
		private var rows:int;
		
		private var mapNames:Vector.<String>;
		private var mapInfo:MapInfo;
		
		private var cilpXa:int;
		private var cilpXb:int;
		private var cilpYa:int;
		private var cilpYb:int;
		private var dic:Object;
		public function MapBack(assetManager:AssetManager,mapInfo:MapInfo) 
		{
			this.assetManager = assetManager;
			reset(mapInfo);
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);
		}
		
		private function update(e:EnterFrameEvent):void 
		{
			Camera.updateView(this, mapInfo);
			cilpXa = int(Camera.loacalLeftTopPoint.x / mapInfo.mapClipWidth);
			cilpXb = Math.ceil(Camera.loacalRightBomPoint.x / mapInfo.mapClipWidth);
			cilpYa = int(Camera.loacalLeftTopPoint.y / mapInfo.mapClipHeight);
			cilpYb = Math.ceil(Camera.loacalRightBomPoint.y / mapInfo.mapClipHeight);
			if (dic != null)
			{
				this.clearChild();
				for (var col:int = cilpXa; col < cilpXb; col++)
				{
					for (var row:int = cilpYa; row < cilpYb; row++)
					{
						var image:Image = dic[col.toString() + "_" + row.toString()];
						if (image != null)	addQuiackChild(image);
					}
				}
			}
		}
		public function reset(mapInfo:MapInfo):void
		{
			this.removeChildren();
			dic = new Object();
			rows = 0;
			cols = 0;
			mapHeight = 0;
			mapWidth = 0;
			var col:int;
			var row:int;
			this.mapInfo = mapInfo;
			this.mapName = mapInfo.mapBackName;
			mapNames = assetManager.getTextureNames("&clip_"+mapName);
			for (var i:int = 0; i < mapNames.length; i++)
			{
				var name:String = mapNames[i];
				var namePA:Array = name.split("_");
				row = namePA[namePA.length - 1];
				col = namePA[namePA.length - 2];
				rows = Math.max(row, rows);
				cols = Math.max(col, cols);
			}
			for (col = 0; col <= cols; col++)
			{
				for (row = 0; row <= rows; row++)
				{
					var image:Image = new Image(assetManager.getTexture("&clip_"+mapName + "_" + col.toString() + "_" + row.toString()));
					image.x = col * mapInfo.mapClipWidth;
					image.y = row * mapInfo.mapClipHeight;
					dic[col.toString() + "_" + row.toString()] = image;
					mapWidth += image.width;
					mapHeight += image.height;
				}
			}
			mapWidth = mapWidth / (rows+1);
			mapHeight = mapHeight / (cols+1);
		}
	}

}