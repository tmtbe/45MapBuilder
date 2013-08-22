package base 
{
	import feathers.controls.ImageLoader;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author °无量
	 */
	public class MovieLoader extends ImageLoader implements IAnimatable 
	{
		private var _fps:int = 60;
		private var mCurrentFrame:int = 0;
		private var mCurrentTime:Number;
		private var mStartTimes:Vector.<Number>;
		private var mDefaultFrameDuration:Number;
		public function MovieLoader() 
		{
			
		}
		public function get totalTime():Number 
        {
			if (mStartTimes == null) initFps();
            var numFrames:int = _source.length;
			if(mStartTimes.length!=numFrames) initFps();
            return mStartTimes[int(numFrames - 1)];
        }
		private function initFps():void
		{
			if (!(_source as Vector.<Texture>)) 
			{
				return;
			}
			var numFrames:int = _source.length;            
            mDefaultFrameDuration = 1.0 / fps;
            mCurrentTime = 0.0;
            mCurrentFrame = 0;
            mStartTimes = new Vector.<Number>(numFrames);        
            for (var i:int=0; i<numFrames; ++i)
            {
                mStartTimes[i] = i * mDefaultFrameDuration;
            }
		}
		public function advanceTime(passedTime:Number):void
        {
			if (passedTime <= 0.0) return;
            var finalFrame:int;
            var previousFrame:int = mCurrentFrame;
            var restTime:Number = 0.0;
            var totalTime:Number = this.totalTime;
            
            if (mCurrentTime >= totalTime)
            { 
                mCurrentTime = 0.0; 
                mCurrentFrame = 0; 
            }
            
            if (mCurrentTime < totalTime)
            {
                mCurrentTime += passedTime;
                finalFrame = _source.length - 1;
                
                while (mCurrentTime > mStartTimes[mCurrentFrame])
                {
                    if (mCurrentFrame == finalFrame)
                    {
                        mCurrentTime -= totalTime;
                        mCurrentFrame = 0;
                    }
                    else
                    {
                        mCurrentFrame++;
                    }
                }
            }
            
            if (mCurrentFrame != previousFrame)
			{
                _texture = _source[mCurrentFrame];
				this.commitTexture();
			}
            if (restTime > 0.0)
                advanceTime(restTime);
		}
		override protected function commitData():void 
		{
			if(this._source is Vector.<Texture>)
			{
				if (_source.length > 0)
				{
					this._lastURL = null;
					mCurrentFrame = 0;
					this._texture = Texture(_source[mCurrentFrame]);
					this.commitTexture();
					this._isLoaded = true;
					initFps();
					Starling.juggler.add(this);
				}else
				{
					Starling.juggler.remove(this);
					_source = "";
					initFps();
					return;
				}
			}else
			{
				Starling.juggler.remove(this);
				super.commitData();
			}
		}
		override public function dispose():void 
		{
			Starling.juggler.remove(this);
			super.dispose();
		}
		
		public function get fps():int 
		{
			return _fps;
		}
		
		public function set fps(value:int):void 
		{
			_fps = value;
			initFps();
		}
	}

}