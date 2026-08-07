package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import dragonBones.objects.FrameData;
   import dragonBones.objects.TimelineData;
   
   public class TimelineState extends BaseObject
   {
      
      internal var _playState:int;
      
      internal var _currentPlayTimes:uint;
      
      internal var _currentTime:Number;
      
      internal var _timelineData:TimelineData;
      
      protected var _frameRate:uint;
      
      protected var _keyFrameCount:uint;
      
      protected var _frameCount:uint;
      
      protected var _position:Number;
      
      protected var _duration:Number;
      
      protected var _animationDutation:Number;
      
      protected var _timeScale:Number;
      
      protected var _timeOffset:Number;
      
      protected var _currentFrame:FrameData;
      
      protected var _armature:Armature;
      
      protected var _animationState:AnimationState;
      
      protected var _mainTimeline:AnimationTimelineState;
      
      public function TimelineState(param1:TimelineState)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      override protected function _onClear() : void
      {
         this._playState = -1;
         this._currentPlayTimes = 0;
         this._currentTime = -1;
         this._timelineData = null;
         this._frameRate = 0;
         this._keyFrameCount = 0;
         this._frameCount = 0;
         this._position = 0;
         this._duration = 0;
         this._animationDutation = 0;
         this._timeScale = 1;
         this._timeOffset = 0;
         this._currentFrame = null;
         this._armature = null;
         this._animationState = null;
         this._mainTimeline = null;
      }
      
      protected function _onUpdateFrame() : void
      {
      }
      
      protected function _onArriveAtFrame() : void
      {
      }
      
      protected function _setCurrentTime(param1:Number) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc2_:int = this._playState;
         var _loc3_:uint = 0;
         var _loc4_:Number = 0;
         if(Boolean(this._mainTimeline) && this._keyFrameCount === 1)
         {
            this._playState = this._animationState._timeline._playState >= 0 ? 1 : -1;
            _loc3_ = 1;
            _loc4_ = Number(this._mainTimeline._currentTime);
         }
         else if(!this._mainTimeline || this._timeScale !== 1 || this._timeOffset !== 0)
         {
            _loc5_ = this._animationState.playTimes;
            _loc6_ = _loc5_ * this._duration;
            param1 *= this._timeScale;
            if(this._timeOffset !== 0)
            {
               param1 += this._timeOffset * this._animationDutation;
            }
            if(_loc5_ > 0 && (param1 >= _loc6_ || param1 <= -_loc6_))
            {
               if(this._playState <= 0 && this._animationState._playheadState === 3)
               {
                  this._playState = 1;
               }
               _loc3_ = _loc5_;
               if(param1 < 0)
               {
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_ = this._duration;
               }
            }
            else
            {
               if(this._playState !== 0 && this._animationState._playheadState === 3)
               {
                  this._playState = 0;
               }
               if(param1 < 0)
               {
                  param1 = -param1;
                  _loc3_ = Math.floor(param1 / this._duration);
                  _loc4_ = this._duration - param1 % this._duration;
               }
               else
               {
                  _loc3_ = Math.floor(param1 / this._duration);
                  _loc4_ = param1 % this._duration;
               }
            }
         }
         else
         {
            this._playState = this._animationState._timeline._playState;
            _loc3_ = uint(this._animationState._timeline._currentPlayTimes);
            _loc4_ = Number(this._mainTimeline._currentTime);
         }
         _loc4_ += this._position;
         if(this._currentPlayTimes === _loc3_ && this._currentTime === _loc4_)
         {
            return false;
         }
         if(_loc2_ < 0 && this._playState !== _loc2_ || this._playState <= 0 && this._currentPlayTimes !== _loc3_)
         {
            this._currentFrame = null;
         }
         this._currentPlayTimes = _loc3_;
         this._currentTime = _loc4_;
         return true;
      }
      
      public function _init(param1:Armature, param2:AnimationState, param3:TimelineData) : void
      {
         this._armature = param1;
         this._animationState = param2;
         this._timelineData = param3;
         this._mainTimeline = this._animationState._timeline;
         if(this === this._mainTimeline)
         {
            this._mainTimeline = null;
         }
         this._frameRate = this._armature.armatureData.frameRate;
         this._keyFrameCount = this._timelineData.frames.length;
         this._frameCount = this._animationState.animationData.frameCount;
         this._position = this._animationState._position;
         this._duration = this._animationState._duration;
         this._animationDutation = this._animationState.animationData.duration;
         this._timeScale = !this._mainTimeline ? 1 : 1 / this._timelineData.scale;
         this._timeOffset = !this._mainTimeline ? 0 : this._timelineData.offset;
      }
      
      public function fadeOut() : void
      {
      }
      
      public function invalidUpdate() : void
      {
         this._timeScale = this == this._animationState._timeline ? 1 : 1 / this._timelineData.scale;
         this._timeOffset = this == this._animationState._timeline ? 0 : this._timelineData.offset;
      }
      
      public function update(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:FrameData = null;
         if(this._playState <= 0 && this._setCurrentTime(param1))
         {
            _loc2_ = this._keyFrameCount > 1 ? uint(this._currentTime * this._frameRate) : 0;
            _loc3_ = this._timelineData.frames[_loc2_];
            if(this._currentFrame !== _loc3_)
            {
               this._currentFrame = _loc3_;
               this._onArriveAtFrame();
            }
            this._onUpdateFrame();
         }
      }
   }
}

