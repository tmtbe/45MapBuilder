package shell 
{
	import base.Coordinate;
	import base.EasyMovie;
	import base.ItemImage;
	import base.ItemInfo;
	import base.ItemPosInfo;
	import base.MapInfo;
	import base.MovieLoader;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author °无量
	 */
	public class ItemRender extends Sprite
	{
		private var mapInfo:MapInfo;
		private var assetManager:AssetManager;
		private var girdCoord:Coordinate;
		private var screenCoord:Coordinate;
		private var imageDic:Dictionary;
		private var touchPoint:Point;
		private var sortArrary:Vector.<ItemPosInfo>;
		public function ItemRender(mapInfo:MapInfo,assetManager:AssetManager) 
		{
			this.assetManager = assetManager;
			this.mapInfo = mapInfo;
			girdCoord = new Coordinate();
			screenCoord = new Coordinate();
			imageDic = new Dictionary();
			sortArrary = new Vector.<ItemPosInfo>;
			addEventListener(EnterFrameEvent.ENTER_FRAME, onUpdate);
		}
		
		private function onUpdate(e:EnterFrameEvent):void 
		{
			var itemPosInfo:ItemPosInfo;
			var image:EasyMovie;
			clearChild();
			dataSort();
			for (var i:int; i < sortArrary.length; i++)
			{
				itemPosInfo = sortArrary[i];
				image = imageDic[itemPosInfo];
				addQuiackChild(image);
			}
		}
		private function dataSort():void
		{
			var itemPosInfo:ItemPosInfo;
			var image:EasyMovie;
			var i:int;
			var list:Array = new Array();
			for (i = 0; i < mapInfo.itemPosInfo.length; i++)
			{
				itemPosInfo = mapInfo.itemPosInfo[i];
				image = imageDic[itemPosInfo];
				if (image == null)
				{
					image = new EasyMovie();
					if (itemPosInfo.itemDesInfo.ifCarton)
					{
						image.source = assetManager.getTextures(itemPosInfo.itemDesInfo.cartonID);
						image.fps = itemPosInfo.itemDesInfo.fps;
					}else
					{
						image.source = assetManager.getTexture(itemPosInfo.itemDesInfo.id);
					}			
					image.pivotX = image.width/2;
					image.pivotY = image.height/2;
					imageDic[itemPosInfo] = image;					
				}
				girdCoord.x = itemPosInfo.col;
				girdCoord.y = itemPosInfo.row;
				screenCoord = mapInfo.getScreenPointFromGird(girdCoord, screenCoord);
				if (itemPosInfo.itemDesInfo == null)
				{
					itemPosInfo.itemDesInfo = mapInfo.getItemInfo(itemPosInfo.id);
				}
				image.x = screenCoord.x + itemPosInfo.itemDesInfo.xoffset;
				image.y = screenCoord.y + itemPosInfo.itemDesInfo.yoffset;
				if ((image.x + image.width / 2) >= Camera.loacalLeftTopPoint.x && (image.x - image.width / 2) <= Camera.loacalRightBomPoint.x &&
					(image.y + image.height / 2) >= Camera.loacalLeftTopPoint.y && (image.y - image.height / 2) <= Camera.loacalRightBomPoint.y)
					{
						list.push(itemPosInfo);
					}
			}
			
			sortArrary.length = 0;
			var listLength:int = list.length;
			for (i = 0; i < listLength;++i)
			{
				var nsi:ItemPosInfo = list[i];
				var added:Boolean = false;
				var sortArrayLength:int = sortArrary.length;
				for (var j:int = 0; j < sortArrayLength;++j)
				{
					var si:ItemPosInfo = sortArrary[j];
					if (nsi.col > si.col+si.itemDesInfo.cols)
					{
						if (nsi.col <= si.col+si.itemDesInfo.cols && nsi.row+nsi.itemDesInfo.rows  <= si.row)
						{
							sortArrary.splice(j, 0, nsi);//nsi放在下面
							added = true;
							break;
						}
					}else
					{
						if (nsi.col < si.col+si.itemDesInfo.cols && nsi.row  < si.row+si.itemDesInfo.rows)
						{
							sortArrary.splice(j, 0, nsi);//nsi放在下面
							added = true;
							break;
						}
					}
					
				}
				if (!added)
				{
					sortArrary.push(nsi);
				}
			}
		}
		
		public function reset(mapInfo:MapInfo):void 
		{
			this.mapInfo = mapInfo;
		}		
	}

}
