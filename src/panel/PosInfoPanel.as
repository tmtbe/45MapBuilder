package panel 
{
	import base.Coordinate;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	/**
	 * ...
	 * @author °无量
	 */
	public class PosInfoPanel extends PanelScreen
	{
		private var list:List;
		private var tileColRow:Label;
		private var tilePos:Label;
		
		public function PosInfoPanel() 
		{
			alpha = 0.5;
			touchable = false;
			scaleX = scaleY = 0.8;
		}
		override protected function initialize():void 
		{
			super.initialize();
			_maxWidth = 200;
			headerProperties.title = "坐标信息";
			tileColRow = new Label();
			tilePos = new Label();
			
			list = new List();
			list.width = 200;
			list.isSelectable = false;
			list.dataProvider = new ListCollection(
			[
				{ label: "格子坐标", accessory: this.tileColRow },
				{ label: "位置坐标", accessory: this.tilePos }
			]);
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(list);
		}
		public function update(gridCoord:Coordinate,screenCoord:Coordinate):void
		{
			tileColRow.text = gridCoord.toString();
			tilePos.text = screenCoord.toString();
		}
		override protected function draw():void 
		{
			super.draw();
		}
	}

}