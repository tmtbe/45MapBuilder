package base 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author °无量
	 */
	public class MapInfo 
	{
		public var assetInfo:Array;
		public var blockInfo:Object;
		public var cartonDesInfo:Object;
		public var itemDesInfo:Object;
		public var itemPosInfo:Array;
		public var girdWidth:Number = 0;
		public var mapWidth:Number = 0;
		public var mapHeight:Number = 0;
		public var rootPointX:Number = 0;
		public var rootPointY:Number = 0;	
		public var tileWidth3D:Number = 0;
		public var tileLength:Number = 0;
		public var mapLength:Number = 0;
		public var mapBackName:String;
		public var mapClipWidth:int;
		public var mapClipHeight:int;
		
		private var _mouseGirdCoord:Coordinate;
		private var _iso:Isometric ;
		private var _coord:Coordinate ;
		
		public function MapInfo() 
		{
			_iso = new Isometric();
			_coord = new Coordinate();
			_mouseGirdCoord = new Coordinate();
			blockInfo = new Object();
			itemDesInfo = new Object();
			cartonDesInfo = new Object();
			itemPosInfo = new Array();
			assetInfo = new Array();
		}
		public function reset():void 
		{			
			blockInfo = new Object();
			itemDesInfo = new Object();
			cartonDesInfo = new Object();
			itemPosInfo = new Array();
			assetInfo = new Array();
		}
		public function setClipWH(mapClipWidth:int,mapClipHeight:int):void
		{
			this.mapClipHeight = mapClipHeight;
			this.mapClipWidth = mapClipWidth;
		}
		public function setView(girdWidth:int,mapWidth:Number, mapHeight:Number):void
		{			
			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;
			this.girdWidth = girdWidth;
			this.rootPointX = mapWidth / 2;
			this.rootPointY = -mapWidth / 4;
			tileWidth3D = _iso.mapToIsoWorld(girdWidth, 0).x;
			mapLength = (mapWidth / 4 + mapHeight / 2) * Math.sqrt(5);
			tileLength = girdWidth / 4 * Math.sqrt(5);
			mapLength = Math.ceil(mapLength / tileLength) * tileLength;
		}
		public function checkPoint(screenCoord:*):void
		{
			screenCoord.x = screenCoord.x - rootPointX;
			screenCoord.y = screenCoord.y - rootPointY;
		}
		public function getGirdPointFromScreen(screenCoord:*,girdCoord:Coordinate):Coordinate
		{
			checkPoint(screenCoord);
			_coord = _iso.mapToIsoWorld(screenCoord.x, screenCoord.y, _coord);
			if (girdCoord == null) girdCoord = new Coordinate();
			girdCoord.x = int(_coord.x / tileWidth3D);
			girdCoord.y = int( -_coord.z / tileWidth3D);
			return girdCoord;
		}
		public function getScreenPointFromGird(girdCoord:Coordinate,screenCoord:Coordinate):Coordinate
		{			
			screenCoord = _iso.mapToScreen(girdCoord.x * tileWidth3D, 0, -girdCoord.y *tileWidth3D, screenCoord);
			screenCoord.x = int(screenCoord.x+rootPointX);
			screenCoord.y = int(screenCoord.y+rootPointY);
			return screenCoord;
		}
	
		public function set mouseGirdCoord(value:Coordinate):void 
		{
			_mouseGirdCoord.reset(value.x, value.y, value.z);
		}
		
		public function get mouseGirdCoord():Coordinate 
		{
			return _mouseGirdCoord;
		}
		
		public function pushAssetInfo(value:String):void 
		{
			assetInfo.push(value);
		}
		public function pushItemPosInfo($itemPosInfo:ItemPosInfo):void 
		{
			itemPosInfo.push($itemPosInfo);
		}
		public function removeItemPosInfo($itemPosInfo:ItemPosInfo):void
		{
			var index:int = itemPosInfo.indexOf($itemPosInfo);
			if (index >= 0)itemPosInfo.splice(index, 1);
		}
		public function setIfBlock(gridCoord:Coordinate,isBlock:Boolean):void
		{			
			var infoName:String = gridCoord.x.toString() + "_" + gridCoord.y.toString();
			if (!isBlock)
			{
				delete blockInfo[infoName];
			}else
			{
				blockInfo[infoName] = gridCoord.clone();
			}
		}
		public function getItemInfo(id:String):ItemInfo
		{
			if (cartonDesInfo[id] != null) return cartonDesInfo[id];
			return itemDesInfo[id];
		}
		public function ifBlock(gridPoint:Point):Boolean
		{
			var infoName:String = gridPoint.x.toString() + "_" + gridPoint.y.toString();
			if (blockInfo[infoName] == null) return false;
			else return true;
		}
		
		public function clearAllBlock():void 
		{
			blockInfo = null;
			blockInfo = new Object();
		}
		
		public function setItemInfo(itemInfo:ItemInfo):void 
		{
			if (!itemInfo.ifCarton)
			{
				if (itemDesInfo[itemInfo.id] == null)
				{
					itemDesInfo[itemInfo.id] = itemInfo;
				}else
				{
					itemDesInfo[itemInfo.id].copy(itemInfo);
				}
			}else 
			{
				if (cartonDesInfo[itemInfo.cartonID] == null)
				{
					cartonDesInfo[itemInfo.cartonID] = itemInfo;
				}else
				{
					cartonDesInfo[itemInfo.cartonID].copy(itemInfo);
				}
			}
		}
		
		public function getMouseItem():ItemPosInfo
		{
			for (var i:int = 0; i < itemPosInfo.length; i++)
			{
				var oneItemPosInfo:ItemPosInfo = itemPosInfo[i];
				if (mouseGirdCoord.x >= oneItemPosInfo.col && mouseGirdCoord.x < oneItemPosInfo.col + oneItemPosInfo.itemDesInfo.cols && 
					mouseGirdCoord.y >= oneItemPosInfo.row && mouseGirdCoord.y < oneItemPosInfo.row + oneItemPosInfo.itemDesInfo.rows)
				{
					return oneItemPosInfo;
				}
			}
			return null;
		}
		
		
	}

}