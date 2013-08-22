package base 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	/**
	 * ...
	 * @author °无量
	 */
	public class ItemPosInfo 
	{
		private var _mapInfo:MapInfo;
		public var col:int;
		public var row:int;
		public var id:String;
		private var _itemDesInfo:ItemInfo;
		public function ItemPosInfo() 
		{
		}
		public function reset(mapInfo:MapInfo,col:int,row:int,id:String):void
		{
			this.id = id;
			this.row = row;
			this.col = col;
			this.mapInfo = mapInfo;
			this.itemDesInfo = mapInfo.getItemInfo(id);
		}
		public function startChangePos():void
		{
			Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, onClick);			
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);		
		}
		
		public function remove():void 
		{
			mapInfo.removeItemPosInfo(this);
			onClick(null);
		}
		private function onMove(e:MouseEvent):void 
		{
			col = mapInfo.mouseGirdCoord.x;
			row = mapInfo.mouseGirdCoord.y;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.CLICK, onClick);			
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);	
		}
		
		public function get mapInfo():MapInfo 
		{
			return _mapInfo;
		}
		
		public function set mapInfo(value:MapInfo):void 
		{
			_mapInfo = value;
		}
		
		public function get itemDesInfo():ItemInfo 
		{
			return _itemDesInfo;
		}
		
		public function set itemDesInfo(value:ItemInfo):void 
		{
			_itemDesInfo = value;
		}
	}

}