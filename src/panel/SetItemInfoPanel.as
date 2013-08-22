package panel 
{
	import base.Coordinate;
	import base.ItemInfo;
	import base.MapInfo;
	import base.MovieLoader;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import shell.CreatGird;
	import shell.MapEditor;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author °无量
	 */
	public class SetItemInfoPanel extends Screen
	{
		private var mapInfo:MapInfo;
		private var itemId:String;
		private var closeBtn:Button;
		private var creatGird:CreatGird;
		private var tempMapInfo:MapInfo;
		private var assetManager:AssetManager;
		private var gridCoord:Coordinate = new Coordinate();
		private var screenCoord:Coordinate = new Coordinate();
		private var image:MovieLoader;
		private var contain:Sprite;
		private var header:Header;
		private var back:Quad;
		private var itemInfo:ItemInfo;
		private var list:List;
		private var colsNum:NumericStepper;
		private var rowsNum:NumericStepper;
		private var xoffsetNum:NumericStepper;
		private var yoffsetNum:NumericStepper;
		private var ifCarton:Check; 
		private var cartonName:TextInput;
		private var cartonFPS:NumericStepper;
		private var saveBtn:Button;
		public function SetItemInfoPanel(mapInfo:MapInfo,itemId:String,assetManager:AssetManager) 
		{
			this.assetManager = assetManager;
			this.itemId = itemId;
			this.mapInfo = mapInfo;	
			this.tempMapInfo = new MapInfo();
			tempMapInfo.setView(mapInfo.girdWidth, 256, 256);
			itemInfo = mapInfo.getItemInfo(itemId);
			if (itemInfo == null) 
			{
				itemInfo = new ItemInfo();
				itemInfo.id = itemId;
			}else
			{
				itemInfo = itemInfo.clone();
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			var gap:int = 1;
			if (MapEditor.ctrlDown)
			{
				gap = 5;
			}
			switch(e.keyCode)
			{
				case Keyboard.UP:
					itemInfo.yoffset-=gap;
					image.y -=gap;
					break;
				case Keyboard.DOWN:
					itemInfo.yoffset+=gap;
					image.y +=gap;
					break;
				case Keyboard.LEFT:
					itemInfo.xoffset-=gap;
					image.x -=gap;
					break;
				case Keyboard.RIGHT:
					itemInfo.xoffset+=gap;
					image.x +=gap;
					break;
			}
			xoffsetNum.value = itemInfo.xoffset;
			yoffsetNum.value = itemInfo.yoffset;
		}
		override protected function initialize():void 
		{
			super.initialize();
			setSize(800, 600);
			back = new Quad(800, 600, 0x2C251F);
			addChild(back);
			header = new Header();
			
			header.title = "基础坐标";
			header.width = 800;
			closeBtn = new Button();
			closeBtn.label = "返回";
			closeBtn.addEventListener(Event.TRIGGERED, onClose);		
			
			saveBtn = new Button();
			saveBtn.label = "保存";
			saveBtn.addEventListener(Event.TRIGGERED, onSave);	
			header.rightItems = new <DisplayObject>[closeBtn];
			header.leftItems = new <DisplayObject>[saveBtn];
			
			contain = new Sprite();
			addChild(contain);
			
			screenCoord = tempMapInfo.getScreenPointFromGird(gridCoord, screenCoord);
			image = new MovieLoader();
			image.source = assetManager.getTexture(itemInfo.id);			
			contain.addChild(image);
			image.validate();
			
			creatGird = new CreatGird(tempMapInfo);
			creatGird.showBlock = true;
			creatGird.alpha = 0.5;
			contain.addChild(creatGird);	
			
			image.x = screenCoord.x + itemInfo.xoffset;
			image.y = screenCoord.y + itemInfo.yoffset;
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			contain.x = -tempMapInfo.rootPointX + creatGird.width / 2 + 30;
			contain.y = -tempMapInfo.rootPointY + 250;
			
			colsNum = new NumericStepper();			
			colsNum.step = 1;
			colsNum.minimum = 1;
			colsNum.maximum = 100;
			colsNum.value  = itemInfo.cols;
			colsNum.addEventListener(Event.CHANGE, onRowColChange);
			
			rowsNum = new NumericStepper();
			rowsNum.step = 1;
			rowsNum.minimum = 1;
			rowsNum.maximum = 100;
			rowsNum.value  = itemInfo.rows;
			rowsNum.addEventListener(Event.CHANGE, onRowColChange);
			
			xoffsetNum = new NumericStepper();			
			xoffsetNum.step = 1;
			xoffsetNum.minimum = -999;
			xoffsetNum.maximum = 999;
			xoffsetNum.value  = itemInfo.xoffset;
			xoffsetNum.addEventListener(Event.CHANGE, onOffsetChange);
			
			yoffsetNum = new NumericStepper();			
			yoffsetNum.step = 1;
			yoffsetNum.minimum = -999;
			yoffsetNum.maximum = 999;
			yoffsetNum.value  = itemInfo.yoffset;
			yoffsetNum.addEventListener(Event.CHANGE, onOffsetChange);
			
			cartonName = new TextInput();
			if (itemInfo.ifCarton)
			{
				cartonName.text = itemInfo.cartonID;
			}else
			{
				cartonName.text = itemInfo.id;
			}
			cartonName.addEventListener(Event.CHANGE, onCartonNameChange);
			cartonName.isEnabled = false;
			
			cartonFPS = new NumericStepper();
			cartonFPS.minimum = 1;
			cartonFPS.maximum = 60;
			cartonFPS.step = 1;
			if (itemInfo.ifCarton)
			{
				cartonFPS.value = itemInfo.fps;
				image.fps = itemInfo.fps;
			}else
			{
				cartonFPS.value = 60;
			}
			cartonFPS.addEventListener(Event.CHANGE, onFPSChange);
			
			ifCarton = new Check();
			ifCarton.label = "";
			ifCarton.addEventListener(Event.CHANGE, onIfCartonChange);
			ifCarton.isSelected = itemInfo.ifCarton;
			
			list = new List();
			list.width = 250;
			list.isSelectable = false;
			list.dataProvider = new ListCollection(
			[
				{ label: "Cols:", accessory: this.colsNum },
				{ label: "Rows:", accessory: this.rowsNum },
				{ label: "Xoffset:", accessory: this.xoffsetNum },
				{ label: "Yoffset:", accessory: this.yoffsetNum },
				{ label: "是否是动画:", accessory: this.ifCarton },
				{ label: "动画索引:", accessory: this.cartonName },
				{ label: "FPS:", accessory: this.cartonFPS }
			]);
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(list);
			addChild(header);
			list.y = 50;
			onRowColChange(null);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onSave(e:Event):void 
		{
			if (itemInfo.ifCarton) itemInfo.id = "";
			itemInfo.fps = cartonFPS.value;
			mapInfo.setItemInfo(itemInfo);
			PopUpManager.removePopUp(this, true);
		}
		
		private function onFPSChange(e:Event):void 
		{
			image.fps = cartonFPS.value;
			itemInfo.fps = cartonFPS.value;
		}
		
		private function onCartonNameChange(e:Event):void 
		{
			itemInfo.cartonID = cartonName.text;
			image.source = assetManager.getTextures(itemInfo.cartonID);	
			image.validate();
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
		}
		
		private function onIfCartonChange(e:Event):void 
		{
			if (ifCarton.isSelected)
			{
				itemInfo.ifCarton = true;
				cartonName.isEnabled = true;
				itemInfo.cartonID = cartonName.text;
				image.source = assetManager.getTextures(itemInfo.cartonID);	
				image.validate();
				image.pivotX = image.width / 2;
				image.pivotY = image.height / 2;
			}else
			{
				itemInfo.ifCarton = false;
				itemInfo.cartonID = "";
				cartonName.isEnabled = false;
				image.source = assetManager.getTexture(itemInfo.id);
				image.validate();
				image.pivotX = image.width / 2;
				image.pivotY = image.height / 2;
			}
		}
		
		private function onOffsetChange(e:Event):void 
		{
			itemInfo.xoffset = xoffsetNum.value;
			itemInfo.yoffset = yoffsetNum.value;
			image.x = screenCoord.x + itemInfo.xoffset;
			image.y = screenCoord.y + itemInfo.yoffset;
		}
		
		private function onRowColChange(e:Event):void 
		{
			itemInfo.cols = colsNum.value;
			itemInfo.rows = rowsNum.value;
			tempMapInfo.clearAllBlock();
			var coord:Coordinate = new Coordinate();
			for (var col:int = 0; col < colsNum.value; col++)
			{
				for (var row:int = 0; row < rowsNum.value; row++)
				{
					coord.x = col;
					coord.y = row;
					tempMapInfo.setIfBlock(coord, true);
				}
			}
			
		}
		override public function dispose():void 
		{
			super.dispose();
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		private function onClose(e:Event):void 
		{
			PopUpManager.removePopUp(this, true);
		}
	}

}