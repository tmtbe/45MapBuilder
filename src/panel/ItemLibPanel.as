package panel 
{
	import adobe.utils.CustomActions;
	import base.ItemInfo;
	import base.ItemPosInfo;
	import base.MapInfo;
	import base.MovieLoader;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author °无量
	 */
	public class ItemLibPanel extends PanelScreen
	{
		private var list:List;
		private var addToLibBtn:Button;
		private var assetManager:AssetManager;
		private var allTexture:Vector.<String>;
		private var view:MovieLoader;
		private var listArr:Array;
		private var setItemBtn:Button;
		private var putItemBtn:Button;
		private var mapInfo:MapInfo;
		private var itemPosInfo:ItemPosInfo;
		private var pickerList:PickerList;
		private var altes:Array;
		public function ItemLibPanel(assetManager:AssetManager,mapInfo:MapInfo) 
		{
			this.mapInfo = mapInfo;
			this.assetManager = assetManager;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			setSize(200, 580);
			
			headerProperties.title = "库";
			backgroundSkin = new Quad(1, 1, 0x2C251F);
			view = new MovieLoader();
			view.maxWidth = view.minWidth = 200;
			view.maxHeight = view.minHeight = 160;
			addChild(view);
			
			addToLibBtn = new Button();
			addToLibBtn.label = "+";
			addToLibBtn.addEventListener(Event.TRIGGERED, onAddToLib);
			addChild(addToLibBtn);
			
			altes = new Array();
			pickerList = new PickerList();
			pickerList.prompt = "选择图集";
			pickerList.dataProvider = new ListCollection(altes);
			pickerList.selectedIndex = -1;
			const listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.horizontalCenter = 0;
			listLayoutData.verticalCenter = 0;
			pickerList.layoutData = listLayoutData;
			pickerList.typicalItem = "选择图集";
			pickerList.addEventListener(Event.CHANGE, onPickListChange);
			function labelFunction(item:Object):String
			{
				return assetManager.getName(item);				
			}
			addChild(pickerList);
			
			list = new List();
			listArr = new Array();
			list.width = 200;
			list.height = 360;
			list.addEventListener(Event.CHANGE, onListChange);
			list.dataProvider = new ListCollection(listArr);
			addChild(list);
			
			setItemBtn = new Button();
			setItemBtn.label = "设置偏移";
			setItemBtn.addEventListener(Event.TRIGGERED, onSetItem);
			setItemBtn.isEnabled = false;
			addChild(setItemBtn);
			
			putItemBtn = new Button();
			putItemBtn.label = "放置物体";
			putItemBtn.addEventListener(Event.TRIGGERED, onPutItem);
			putItemBtn.isEnabled = false;
			addChild(putItemBtn);
			onLoadOK(1);
		}
	
		private function onPickListChange(e:Event):void 
		{
			var image:MovieLoader;
			allTexture.length = 0;
			if (pickerList.selectedIndex == 0)
			{
				allTexture = assetManager.getTextureNames("", allTexture);
			}else if (pickerList.selectedIndex == 1)
			{
				var carton:ItemInfo;
				listArr.length = 0;
				for each(carton in mapInfo.cartonDesInfo)
				{
					image = new MovieLoader();
					image.source = assetManager.getTextures(carton.cartonID);
					image.maxHeight = 40;
					image.maxWidth = 40;
					image.fps = carton.fps;
					listArr.push( { label: carton.cartonID, accessory:image } );
				}
				list.dataProvider = new ListCollection(listArr);
				return;
			}else
			{
				var tempAtals:TextureAtlas = assetManager.getTextureAtlas(pickerList.selectedItem as String);
				if (tempAtals != null)
				{
					allTexture = tempAtals.getNames("", allTexture);
				}else
				{
					allTexture = assetManager.getTextureNames(pickerList.selectedItem as String, allTexture);
				}
			}
			listArr.length = 0;
			for (var i:int = 0; i < allTexture.length; i++)
			{
				image = new MovieLoader();
				image.source = assetManager.getTexture(allTexture[i]);
				image.maxHeight = 40;
				image.maxWidth = 40;
				listArr.push( { label: allTexture[i], accessory:image } );
			}
			list.dataProvider = new ListCollection(listArr);
		}
		
		private function onPutItem(e:Event):void 
		{
			if (mapInfo.getItemInfo(list.selectedItem.label) == null)
			{
				onSetItem(null);
				return;
			}
			itemPosInfo = new ItemPosInfo();
			itemPosInfo.reset(mapInfo, 0, 0, list.selectedItem.label);
			itemPosInfo.startChangePos();
			mapInfo.pushItemPosInfo(itemPosInfo);			
		}
		
		
		private function onSetItem(e:Event):void 
		{
			PopUpManager.addPopUp(new SetItemInfoPanel(mapInfo, list.selectedItem.label , assetManager));
		}
		
		private function onListChange(e:Event):void 
		{
			if (list.selectedItem == null)
			{
				setItemBtn.isEnabled = false;
				putItemBtn.isEnabled = false;
				return;
			}
			if (list.selectedItem.accessory as ImageLoader)
			{
				view.source = list.selectedItem.accessory.source;
				view.fps = list.selectedItem.accessory.fps;
				setItemBtn.isEnabled = true;
				putItemBtn.isEnabled = true;
			}
			else
			{
				view.source = "";
				setItemBtn.isEnabled = false;
				putItemBtn.isEnabled = false;
			}
		}
		override protected function draw():void 
		{
			super.draw();
			addToLibBtn.y = 160;
			addToLibBtn.validate();
			pickerList.y = 160;
			pickerList.x = addToLibBtn.width;
			pickerList.validate();
			list.y = pickerList.y + pickerList.height;
			setItemBtn.x = 120;
		}
		private function onAddToLib(e:Event):void 
		{
			var file:File = new File();
			var fileFilter:FileFilter = new FileFilter("图片","*.png");
			file.browseForOpen("",[fileFilter]);      
			file.addEventListener("select", fileSelectpd);
		}
		private function fileSelectpd(e:*):void { 
			var souce:String = e.target.nativePath;    //绝对路径
			var path:String = souce.split(".")[0];
			mapInfo.pushAssetInfo(path + ".png");
			mapInfo.pushAssetInfo(path + ".xml");
			var loadArr:Array = new Array();
			loadArr.push(path + ".png");
			loadArr.push(path + ".xml");
			assetManager.enqueue(loadArr);
			assetManager.loadQueue(onLoadOK);
		}
		
		private function onLoadOK(radio:Number):void 
		{
			if (radio == 1)
			{
				allTexture = assetManager.getTextureNames("", allTexture);
				altes = new Array("全部","动画");
				for (var i:int; i < mapInfo.assetInfo.length; i++)
				{
					var value:String = assetManager.getName(mapInfo.assetInfo[i]);
					if (altes.indexOf(value) < 0)
					{
						altes.push(value);
					}
				}
				pickerList.dataProvider = new ListCollection(altes);
				if (pickerList.selectedIndex < 0) pickerList.selectedIndex = 0;
			}
		}
	}

}