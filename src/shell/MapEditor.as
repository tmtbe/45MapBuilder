package shell 
{
	import adobe.serialization.json.MYJSON;
	import base.Coordinate;
	import base.Isometric;
	import base.ItemImage;
	import base.ItemInfo;
	import base.ItemPosInfo;
	import base.MapInfo;
	import extend.draw.display.Shape;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.core.PopUpManager;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.registerClassAlias;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import lzm.starling.STLMainClass;
	import panel.CreatNewMapPanel;
	import panel.ItemLibPanel;
	import panel.PosInfoPanel;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author °无量
	 */
	public class MapEditor extends PanelScreen
	{
		private var mapInfo:MapInfo;
		private var coord:Coordinate=new Coordinate();
		private var creatGird:CreatGird;
		private var mouseLocationPoint:Point;
		private var gridCoord:Coordinate;
		private var screenCoord:Coordinate;
		private var assetManager:AssetManager;
		private var theme:MetalWorksMobileTheme;
		private var creatNewBtn:Button;
		private var saveBtn:Button;
		private var mapBack:MapBack;
		private var tileWidth:int;
		private var screenContain:Sprite;
		private var uiContain:Sprite;
		private var posPanel:PosInfoPanel;
		private var blockBtn:Check;
		private var buildBtn:Check;
		private var rightMouseDown:Boolean;
		public static var ctrlDown:Boolean;
		private var itemLibPanel:ItemLibPanel;
		private var itemRender:ItemRender;
		private var mousePoint:Point;
		private var openBtn:Button;
		private var outBtn:Button;
		public function MapEditor() 
		{
			theme = new MetalWorksMobileTheme(this.stage);
			mousePoint = new Point();
			mapInfo = new MapInfo();
			assetManager = new AssetManager();
			assetManager.map = mapInfo;
			registerClassAlias("tmtbe.MapInfo", MapInfo);
			registerClassAlias("tmtbe.ItemPosInfo", ItemPosInfo);
			registerClassAlias("tmtbe.ItemInfo", ItemInfo);
			registerClassAlias("tmtbe.Isometric", Isometric);
			registerClassAlias("tmtbe.Coordinate", Coordinate);
		}
		override protected function initialize():void 
		{
			super.initialize();
			setSize(stage.stageWidth, stage.height);
			screenContain = new Sprite();
			addChild(screenContain);
			uiContain = new Sprite();
			addChild(uiContain);
			creatPanle();
		}
		private function creatPanle():void
		{
			headerProperties.width = stage.stageWidth;
			creatNewBtn = new Button();
			creatNewBtn.label = "新建";		
			creatNewBtn.addEventListener(Event.TRIGGERED, onCreatNew);
			
			openBtn = new Button();
			openBtn.label = "打开";
			openBtn.addEventListener(Event.TRIGGERED, onOpen);
			
			outBtn = new Button();
			outBtn.label = "导出JSON";
			outBtn.addEventListener(Event.TRIGGERED, onOut);
			
			saveBtn = new Button();
			saveBtn.label = "保存";
			saveBtn.addEventListener(Event.TRIGGERED, onSave);
			
			blockBtn = new Check();
			blockBtn.label = "刷通断";
			blockBtn.addEventListener(Event.CHANGE, onBlockChange);
			
			buildBtn = new Check();
			buildBtn.label = "调整位置";
			buildBtn.addEventListener(Event.CHANGE, onBuildChange);
			
			headerProperties.leftItems = new <DisplayObject>[creatNewBtn,openBtn,saveBtn,outBtn,blockBtn,buildBtn];		
			
			posPanel = new PosInfoPanel();
			
			uiContain.addChild(posPanel);
		}
		
		private function onOut(e:Event):void 
		{
			var file:File = new File();
			file.browseForSave("");
			file.addEventListener("select", onSelectedOut);
		}
		private function onSelectedOut(e:*):void 
		{
			if (mapInfo == null) return;
			var newFile:File = e.target as File;
			
			newFile.nativePath += ".json";
			var save:ByteArray = new ByteArray();
			save.writeUTFBytes(MYJSON.encode(mapInfo));
			if(!newFile.exists){
				var stream:FileStream = new FileStream();
				stream.open(newFile, FileMode.WRITE);
				stream.writeBytes(save);
				stream.close();
			}
		}
		private function onSave(e:Event):void 
		{
			var file:File = new File();
			file.browseForSave("");
			file.addEventListener("select", onSelectedSave);
		}
		
		private function onSelectedSave(e:*):void 
		{
			if (mapInfo == null) return;
			var newFile:File = e.target as File;
			
			newFile.nativePath += ".map";
			var save:ByteArray = new ByteArray();
			save.writeObject(mapInfo); 
			if(!newFile.exists){
				var stream:FileStream = new FileStream();
				stream.open(newFile, FileMode.WRITE);
				stream.writeBytes(save);
				stream.close();
			}
		}
		
		private function onOpen(e:Event):void 
		{
			var file:File = new File();
			var fileFilter:FileFilter = new FileFilter("Open","*.map");
			file.browseForOpen("",[fileFilter]);      
			file.addEventListener("select", fileSelectpd);			
		}
		
		private function fileSelectpd(e:*):void 
		{			
			reset();
			var souce:String = e.target.nativePath;    //绝对路径			
			assetManager.enqueue(souce);
			assetManager.loadQueue(loadMapInfoOK);
		}
		private function reset():void
		{
			removeChildren(0, -1, true);
			mapBack = null;
			itemRender = null;
			creatGird = null;
			assetManager.dispose();	
			screenContain = new Sprite();
			addChild(screenContain);
			uiContain = new Sprite();
			addChild(uiContain);
			creatPanle();
			screenContain.x = 400;
			screenContain.pivotX = 400;
			screenContain.y = 320;
			screenContain.pivotY = 320;
		}
		private function loadMapInfoOK(radio:Number):void 
		{
			if (radio == 1)
			{
				mapInfo = assetManager.map;
				tileWidth = mapInfo.girdWidth;
				loadAsset();
			}
		}
		
		private function onBuildChange(e:Event):void 
		{
			if (buildBtn.isSelected)
			{
				screenContain.addChild(creatGird);
				itemRender.alpha = 0.5;
				blockBtn.isSelected = false;
			}else
			{
				screenContain.addChild(itemRender);
				itemRender.alpha = 1;
			}
		}
		override protected function draw():void 
		{
			super.draw();
		}
		
		private function onBlockChange(e:Event):void 
		{
			if (creatGird != null)
			{
				creatGird.showBlock = blockBtn.isSelected;
			}
			if (blockBtn.isSelected) buildBtn.isSelected = false;
		}
		
		private function onCreatNew(e:Event):void 
		{
			PopUpManager.addPopUp(new CreatNewMapPanel(readyCallBack));
		}
		
		private function readyCallBack(souce:String, tileWidth:int,clipWidth:int,clipHeight:int):void 
		{
			reset();
			this.tileWidth = tileWidth;
			mapInfo.reset();
			mapInfo.mapBackName = assetManager.getName(souce);
			mapInfo.setClipWH(clipWidth, clipHeight);
			mapInfo.pushAssetInfo(souce);
			loadAsset();
		}		
		private function loadAsset():void
		{
			assetManager.enqueue(mapInfo.assetInfo);
			assetManager.loadQueue(loadAssetOK);
		}
		
		private function loadAssetOK(radio:Number):void 
		{
			if (radio == 1)
			{
				if (mapBack == null)
				{
					mapBack = new MapBack(assetManager,mapInfo);
				}
				mapBack.reset(mapInfo);
				screenContain.addChild(mapBack);
				mapInfo.setView(tileWidth, mapBack.mapWidth, mapBack.mapHeight);
				
				if (creatGird == null)
				{
					creatGird = new CreatGird(mapInfo);
				}else
				{
					creatGird.reset(mapInfo);
				}
				screenContain.addChild(creatGird);
				
				if (itemRender == null)
				{
					itemRender = new ItemRender(mapInfo, assetManager);
				}else
				{
					itemRender.reset(mapInfo);
				}
				screenContain.addChild(itemRender);				
				
				addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				addEventListener(TouchEvent.TOUCH, onTouchHandler);
				Starling.current.nativeStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
				Starling.current.nativeStage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
				Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				
				itemLibPanel = new ItemLibPanel(assetManager,mapInfo);
				uiContain.addChild(itemLibPanel);
				itemLibPanel.x = width - itemLibPanel.width;
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (!ctrlDown) return;
			if (e.delta > 0)
			{
				screenContain.scaleY = screenContain.scaleX = screenContain.scaleX + 0.1;
			}else
			{
				screenContain.scaleY = screenContain.scaleX = screenContain.scaleX - 0.1;
			}
			if (screenContain.scaleX < 0.1) screenContain.scaleY = screenContain.scaleX = 0.1;
			if (screenContain.scaleX > 1.5) screenContain.scaleY = screenContain.scaleX = 1.5;
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.CONTROL)
			{
				ctrlDown = false;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.CONTROL)
			{
				ctrlDown = true;
			}
		}
		
		private function onRightMouseUp(e:MouseEvent):void 
		{
			rightMouseDown = false;
		}
		
		private function onRightMouseDown(e:MouseEvent):void 
		{
			rightMouseDown = true;
		}
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (creatGird == null) return;
			mousePoint.x = Starling.current.nativeStage.mouseX;
			mousePoint.y = Starling.current.nativeStage.mouseY;
			mouseLocationPoint = creatGird.globalToLocal(mousePoint, mouseLocationPoint);
			gridCoord = mapInfo.getGirdPointFromScreen(mouseLocationPoint, gridCoord);
			screenCoord = mapInfo.getScreenPointFromGird(gridCoord, screenCoord);
			mapInfo.mouseGirdCoord = gridCoord;
			posPanel.update(gridCoord, screenCoord);
		}
		
		private function onTouchHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.touches[0];
			if (touch == null) return;
			if (touch.phase == TouchPhase.MOVED)
			{
				if (blockBtn.isSelected)
				{
					if (!ctrlDown)
					{
						mapInfo.setIfBlock(gridCoord, true);
					}else
					{
						mapInfo.setIfBlock(gridCoord, false);
					}
				}
			}else if (touch.phase == TouchPhase.BEGAN)
			{
				if (buildBtn.isSelected)
				{
					var pointItem:ItemPosInfo = mapInfo.getMouseItem();
					if (pointItem != null)
					{
						pointItem.startChangePos();
					}					
				}
			}
			if (rightMouseDown)
			{
				screenContain.pivotX += touch.previousGlobalX - touch.globalX;
				screenContain.pivotY += touch.previousGlobalY - touch.globalY;
			}
		}
		
	}

}