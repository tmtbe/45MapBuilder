package
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import lzm.starling.STLStarup;
	import shell.MapEditor;
	import starling.core.Starling;
	/**
	 * ...
	 * @author °无量
	 */
	[SWF(width="960", height="640", frameRate="30", backgroundColor="#FFFFFF")]
	public class MapBuilder extends STLStarup
	{		
		public function MapBuilder() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddStageHandler);			
		}		
		private function onAddStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddStageHandler);
			initStarlingWithWH(MapEditor, 960, 640, true, true, true);
			initCc();
		}
		private function initCc():void
		{
			Cc.startOnStage(this, "`"); // "`" - change for password. This will start hidden
			Cc.width = Starling.current.stage.stageWidth;
			Cc.commandLine = true; // enable command line
			Cc.config.commandLineAllowed = true;
		}
	}

}