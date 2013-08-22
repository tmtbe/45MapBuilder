package panel 
{
	import base.MapInfo;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.events.Event;
	/**
	 * ...
	 * @author °无量
	 */
	public class CreatNewMapPanel extends PanelScreen
	{
		private var tileLabel:Label;
		private var tileNum:NumericStepper;
		private var choseMapback:Button;
		private var closeBtn:Button;
		private var readyBtn:Button;
		private var list:List;
		private var readyCallBack:Function;
		private var clipHNum:NumericStepper;
		private var clipWNum:NumericStepper;
		
		public function CreatNewMapPanel(readyCallBack:Function) 
		{
			this.readyCallBack = readyCallBack;
			
		}
		override protected function initialize():void 
		{
			super.initialize();
			_minWidth = 400;
			
			headerProperties.title = "新建地图";
			
			closeBtn = new Button;
			closeBtn.label = "返回";
			closeBtn.addEventListener(starling.events.Event.TRIGGERED, onClose);
			
			headerProperties.leftItems = new <DisplayObject>[closeBtn];
			
			choseMapback = new Button();
			choseMapback.maxWidth = 200;
			choseMapback.label = "选择";
			choseMapback.addEventListener(starling.events.Event.TRIGGERED, onChoseMap);
			
			readyBtn = new Button();
			readyBtn.label = "等待就绪";
			readyBtn.addEventListener(starling.events.Event.TRIGGERED, onReady);
			readyBtn.isEnabled = false;
			
			tileNum = new NumericStepper();
			tileNum.maximum = 256;
			tileNum.value = 128;
			tileNum.step = 32;
			
			clipWNum = new NumericStepper();
			clipWNum.maximum = 512;
			clipWNum.value = 256;
			clipWNum.step = 32;
			
			clipHNum = new NumericStepper();
			clipHNum.maximum = 512;
			clipHNum.value = 256;
			clipHNum.step = 32;
			
			list = new List();
			list.width = 400;
			list.isSelectable = false;
			list.dataProvider = new ListCollection(
			[
				{ label: "选择一张背景", accessory: this.choseMapback },
				{ label: "Tile的宽度", accessory: this.tileNum },
				{ label: "切片的宽度", accessory: this.clipWNum },
				{ label: "切片的高度", accessory: this.clipHNum },
				{ label: "确认保存", accessory: this.readyBtn },
			]);
			list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			addChild(list);
		}
		
		private function onReady(e:starling.events.Event):void 
		{
			readyCallBack(choseMapback.label, tileNum.value, clipWNum.value, clipHNum.value);
			onClose(null);
		}
		
		private function onChoseMap(e:starling.events.Event):void 
		{
			var file:File = new File();
			var fileFilter:FileFilter = new FileFilter("图片", "*.jpg;*.png");
			file.browseForOpen("",[fileFilter]);       
			file.addEventListener(flash.events.Event.SELECT, fileSelectpd);
		}
		private function fileSelectpd(e:flash.events.Event):void { 
			choseMapback.label = e.target.nativePath;    //绝对路径
			readyBtn.isEnabled = true;
			readyBtn.label = "保存";
		}
		private function onClose(e:starling.events.Event):void 
		{
			PopUpManager.removePopUp(this, true);
		}
		override protected function draw():void 
		{
			super.draw();
		}
	}

}