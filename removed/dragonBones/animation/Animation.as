package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.core.BaseObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.AnimationConfig;
   import dragonBones.objects.AnimationData;
   
   use namespace dragonBones_internal;
   
   public class Animation extends BaseObject
   {
      
      public var timeScale:Number;
      
      private var _isPlaying:Boolean;
      
      private var _animationStateDirty:Boolean;
      
      dragonBones_internal var _timelineStateDirty:Boolean;
      
      dragonBones_internal var _cacheFrameIndex:Number;
      
      private const _animationNames:Vector.<String> = new Vector.<String>();
      
      private const _animations:Object = {};
      
      private const _animationStates:Vector.<AnimationState> = new Vector.<AnimationState>();
      
      private var _armature:Armature;
      
      private var _lastAnimationState:AnimationState;
      
      private var _animationConfig:AnimationConfig;
      
      public function Animation()
      {
         super(this);
      }
      
      private static function _sortAnimationState(param1:AnimationState, param2:AnimationState) : int
      {
         return param1.layer > param2.layer ? -1 : 1;
      }
      
      override protected function _onClear() : void
      {
         var _loc3_:String = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = this._animationStates.length;
         while(_loc1_ < _loc2_)
         {
            this._animationStates[_loc1_].returnToPool();
            _loc1_++;
         }
         if(this._animationConfig)
         {
            this._animationConfig.returnToPool();
         }
         for(_loc3_ in this._animations)
         {
            delete this._animations[_loc3_];
         }
         this.timeScale = 1;
         this._isPlaying = false;
         this._animationStateDirty = false;
         this.dragonBones_internal::_timelineStateDirty = false;
         this.dragonBones_internal::_cacheFrameIndex = -1;
         this._animationNames.length = 0;
         this._animationStates.length = 0;
         this._armature = null;
         this._lastAnimationState = null;
         this._animationConfig = null;
      }
      
      private function _fadeOut(param1:AnimationConfig) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._animationStates.length;
         var _loc4_:AnimationState = null;
         loop5:
         switch(param1.fadeOutMode)
         {
            case AnimationFadeOutMode.SameLayer:
               while(true)
               {
                  if(_loc2_ >= _loc3_)
                  {
                     break loop5;
                  }
                  _loc4_ = this._animationStates[_loc2_];
                  if(_loc4_.layer === param1.layer)
                  {
                     _loc4_.fadeOut(param1.fadeOutTime,param1.pauseFadeOut);
                  }
                  _loc2_++;
               }
               break;
            case AnimationFadeOutMode.SameGroup:
               while(true)
               {
                  if(_loc2_ >= _loc3_)
                  {
                     break loop5;
                  }
                  _loc4_ = this._animationStates[_loc2_];
                  if(_loc4_.group === param1.group)
                  {
                     _loc4_.fadeOut(param1.fadeOutTime,param1.pauseFadeOut);
                  }
                  _loc2_++;
               }
               break;
            case AnimationFadeOutMode.SameLayerAndGroup:
               while(true)
               {
                  if(_loc2_ >= _loc3_)
                  {
                     break loop5;
                  }
                  _loc4_ = this._animationStates[_loc2_];
                  if(_loc4_.layer === param1.layer && _loc4_.group === param1.group)
                  {
                     _loc4_.fadeOut(param1.fadeOutTime,param1.pauseFadeOut);
                  }
                  _loc2_++;
               }
               break;
            case AnimationFadeOutMode.All:
               while(true)
               {
                  if(_loc2_ >= _loc3_)
                  {
                     break loop5;
                  }
                  _loc4_ = this._animationStates[_loc2_];
                  _loc4_.fadeOut(param1.fadeOutTime,param1.pauseFadeOut);
                  _loc2_++;
               }
               break;
            case AnimationFadeOutMode.None:
         }
      }
      
      public function _init(param1:Armature) : void
      {
         if(this._armature)
         {
            return;
         }
         this._armature = param1;
         this._animationConfig = BaseObject.borrowObject(AnimationConfig) as AnimationConfig;
      }
      
      dragonBones_internal function _advanceTime(param1:Number) : void
      {
         var _loc4_:AnimationData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Vector.<Bone> = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Slot> = null;
         var _loc10_:Bone = null;
         var _loc11_:Slot = null;
         var _loc12_:uint = 0;
         if(!this._isPlaying)
         {
            return;
         }
         if(param1 < 0)
         {
            param1 = -param1;
         }
         if(this._armature.inheritAnimation && Boolean(this._armature.dragonBones_internal::_parent))
         {
            param1 *= this._armature.dragonBones_internal::_parent.dragonBones_internal::_armature.animation.timeScale;
         }
         if(this.timeScale !== 1)
         {
            param1 *= this.timeScale;
         }
         var _loc2_:AnimationState = null;
         var _loc3_:uint = this._animationStates.length;
         if(_loc3_ === 1)
         {
            _loc2_ = this._animationStates[0];
            if(_loc2_._fadeState > 0 && _loc2_._subFadeState > 0)
            {
               _loc2_.returnToPool();
               this._animationStates.length = 0;
               this._animationStateDirty = true;
               this._lastAnimationState = null;
            }
            else
            {
               _loc4_ = _loc2_.animationData;
               _loc5_ = _loc4_.cacheFrameRate;
               if(this._animationStateDirty && _loc5_ > 0)
               {
                  this._animationStateDirty = false;
                  _loc6_ = this._armature.getBones();
                  _loc7_ = 0;
                  _loc8_ = _loc6_.length;
                  while(_loc7_ < _loc8_)
                  {
                     _loc10_ = _loc6_[_loc7_];
                     _loc10_.dragonBones_internal::_cachedFrameIndices = _loc4_.getBoneCachedFrameIndices(_loc10_.name);
                     _loc7_++;
                  }
                  _loc9_ = this._armature.getSlots();
                  _loc7_ = 0;
                  _loc8_ = _loc9_.length;
                  while(_loc7_ < _loc8_)
                  {
                     _loc11_ = _loc9_[_loc7_];
                     _loc11_.dragonBones_internal::_cachedFrameIndices = _loc4_.getSlotCachedFrameIndices(_loc11_.name);
                     _loc7_++;
                  }
               }
               if(this.dragonBones_internal::_timelineStateDirty)
               {
                  _loc2_._updateTimelineStates();
               }
               _loc2_._advanceTime(param1,_loc5_);
            }
         }
         else if(_loc3_ > 1)
         {
            _loc12_ = 0;
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               _loc2_ = this._animationStates[_loc7_];
               if(_loc2_._fadeState > 0 && _loc2_._fadeProgress <= 0)
               {
                  _loc12_++;
                  _loc2_.returnToPool();
                  this._animationStateDirty = true;
                  if(this._lastAnimationState === _loc2_)
                  {
                     this._lastAnimationState = null;
                  }
               }
               else
               {
                  if(_loc12_ > 0)
                  {
                     this._animationStates[_loc7_ - _loc12_] = _loc2_;
                  }
                  if(this.dragonBones_internal::_timelineStateDirty)
                  {
                     _loc2_._updateTimelineStates();
                  }
                  _loc2_._advanceTime(param1,0);
               }
               if(_loc7_ === _loc3_ - 1 && _loc12_ > 0)
               {
                  this._animationStates.length -= _loc12_;
                  if(!this._lastAnimationState && this._animationStates.length > 0)
                  {
                     this._lastAnimationState = this._animationStates[this._animationStates.length - 1];
                  }
               }
               _loc7_++;
            }
            this.dragonBones_internal::_cacheFrameIndex = -1;
         }
         else
         {
            this.dragonBones_internal::_cacheFrameIndex = -1;
         }
         this.dragonBones_internal::_timelineStateDirty = false;
      }
      
      public function reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this._animationStates.length;
         while(_loc1_ < _loc2_)
         {
            this._animationStates[_loc1_].returnToPool();
            _loc1_++;
         }
         this._isPlaying = false;
         this._animationStateDirty = false;
         this.dragonBones_internal::_timelineStateDirty = false;
         this.dragonBones_internal::_cacheFrameIndex = -1;
         this._animationConfig.clear();
         this._animationStates.length = 0;
         this._lastAnimationState = null;
      }
      
      public function stop(param1:String = null) : void
      {
         var _loc2_:AnimationState = null;
         if(param1)
         {
            _loc2_ = this.getState(param1);
            if(_loc2_)
            {
               _loc2_.stop();
            }
         }
         else
         {
            this._isPlaying = false;
         }
      }
      
      public function playConfig(param1:AnimationConfig) : AnimationState
      {
         var _loc8_:Armature = null;
         if(!param1)
         {
            throw new ArgumentError();
         }
         var _loc2_:String = param1.animationName ? param1.animationName : param1.name;
         var _loc3_:AnimationData = this._animations[_loc2_];
         if(!_loc3_)
         {
            return null;
         }
         this._isPlaying = true;
         if(param1.playTimes < 0)
         {
            param1.playTimes = _loc3_.playTimes;
         }
         if(param1.fadeInTime < 0 || param1.fadeInTime !== param1.fadeInTime)
         {
            if(this._lastAnimationState)
            {
               param1.fadeInTime = _loc3_.fadeInTime;
            }
            else
            {
               param1.fadeInTime = 0;
            }
         }
         if(param1.fadeOutTime < 0 || param1.fadeOutTime !== param1.fadeOutTime)
         {
            param1.fadeOutTime = param1.fadeInTime;
         }
         if(param1.timeScale <= -100 || param1.timeScale !== param1.timeScale)
         {
            param1.timeScale = 1 / _loc3_.scale;
         }
         if(_loc3_.duration > 0)
         {
            if(param1.position !== param1.position)
            {
               param1.position = 0;
            }
            else if(param1.position < 0)
            {
               param1.position %= _loc3_.duration;
               param1.position = _loc3_.duration - param1.position;
            }
            else if(param1.position === _loc3_.duration)
            {
               param1.position -= 0.001;
            }
            else if(param1.position > _loc3_.duration)
            {
               param1.position %= _loc3_.duration;
            }
            if(param1.position + param1.duration > _loc3_.duration)
            {
               param1.duration = _loc3_.duration - param1.position;
            }
         }
         else
         {
            param1.position = 0;
            param1.duration = -1;
         }
         var _loc4_:* = param1.duration === 0;
         if(_loc4_)
         {
            param1.playTimes = 1;
            param1.duration = -1;
            param1.fadeInTime = 0;
         }
         this._fadeOut(param1);
         this._lastAnimationState = BaseObject.borrowObject(AnimationState) as AnimationState;
         this._lastAnimationState._init(this._armature,_loc3_,param1);
         this._animationStates.push(this._lastAnimationState);
         this._animationStateDirty = true;
         this.dragonBones_internal::_cacheFrameIndex = -1;
         if(this._animationStates.length > 1)
         {
            this._animationStates.sort(Animation._sortAnimationState);
         }
         var _loc5_:Vector.<Slot> = this._armature.getSlots();
         var _loc6_:uint = 0;
         var _loc7_:uint = _loc5_.length;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc5_[_loc6_].childArmature;
            if((_loc8_) && _loc8_.inheritAnimation && _loc8_.animation.hasAnimation(_loc2_) && !_loc8_.animation.getState(_loc2_))
            {
               _loc8_.animation.fadeIn(_loc2_);
            }
            _loc6_++;
         }
         if(param1.fadeInTime <= 0)
         {
            this._armature.advanceTime(0);
         }
         if(_loc4_)
         {
            this._lastAnimationState.stop();
         }
         return this._lastAnimationState;
      }
      
      public function fadeIn(param1:String, param2:Number = -1, param3:int = -1, param4:int = 0, param5:String = null, param6:int = 3) : AnimationState
      {
         this._animationConfig.clear();
         this._animationConfig.fadeOutMode = param6;
         this._animationConfig.playTimes = param3;
         this._animationConfig.layer = param4;
         this._animationConfig.fadeInTime = param2;
         this._animationConfig.animationName = param1;
         this._animationConfig.group = param5;
         return this.playConfig(this._animationConfig);
      }
      
      public function play(param1:String = null, param2:int = -1) : AnimationState
      {
         var _loc3_:AnimationData = null;
         this._animationConfig.clear();
         this._animationConfig.playTimes = param2;
         this._animationConfig.fadeInTime = 0;
         this._animationConfig.animationName = param1;
         if(param1)
         {
            this.playConfig(this._animationConfig);
         }
         else if(!this._lastAnimationState)
         {
            _loc3_ = this._armature.armatureData.defaultAnimation;
            if(_loc3_)
            {
               this._animationConfig.animationName = _loc3_.name;
               this.playConfig(this._animationConfig);
            }
         }
         else if(!this._isPlaying || !this._lastAnimationState.isPlaying && !this._lastAnimationState.isCompleted)
         {
            this._isPlaying = true;
            this._lastAnimationState.play();
         }
         else
         {
            this._animationConfig.animationName = this._lastAnimationState.name;
            this.playConfig(this._animationConfig);
         }
         return this._lastAnimationState;
      }
      
      public function gotoAndPlayByTime(param1:String, param2:Number = 0, param3:int = -1) : AnimationState
      {
         this._animationConfig.clear();
         this._animationConfig.playTimes = param3;
         this._animationConfig.position = param2;
         this._animationConfig.fadeInTime = 0;
         this._animationConfig.animationName = param1;
         return this.playConfig(this._animationConfig);
      }
      
      public function gotoAndPlayByFrame(param1:String, param2:uint = 0, param3:int = -1) : AnimationState
      {
         this._animationConfig.clear();
         this._animationConfig.playTimes = param3;
         this._animationConfig.fadeInTime = 0;
         this._animationConfig.animationName = param1;
         var _loc4_:AnimationData = this._animations[param1];
         if(_loc4_)
         {
            this._animationConfig.position = _loc4_.duration * param2 / _loc4_.frameCount;
         }
         return this.playConfig(this._animationConfig);
      }
      
      public function gotoAndPlayByProgress(param1:String, param2:Number = 0, param3:int = -1) : AnimationState
      {
         this._animationConfig.clear();
         this._animationConfig.playTimes = param3;
         this._animationConfig.fadeInTime = 0;
         this._animationConfig.animationName = param1;
         var _loc4_:AnimationData = this._animations[param1];
         if(_loc4_)
         {
            this._animationConfig.position = _loc4_.duration * (param2 > 0 ? param2 : 0);
         }
         return this.playConfig(this._animationConfig);
      }
      
      public function gotoAndStopByTime(param1:String, param2:Number = 0) : AnimationState
      {
         var _loc3_:AnimationState = this.gotoAndPlayByTime(param1,param2,1);
         if(_loc3_)
         {
            _loc3_.stop();
         }
         return _loc3_;
      }
      
      public function gotoAndStopByFrame(param1:String, param2:uint = 0) : AnimationState
      {
         var _loc3_:AnimationState = this.gotoAndPlayByFrame(param1,param2,1);
         if(_loc3_)
         {
            _loc3_.stop();
         }
         return _loc3_;
      }
      
      public function gotoAndStopByProgress(param1:String, param2:Number = 0) : AnimationState
      {
         var _loc3_:AnimationState = this.gotoAndPlayByProgress(param1,param2,1);
         if(_loc3_)
         {
            _loc3_.stop();
         }
         return _loc3_;
      }
      
      public function getState(param1:String) : AnimationState
      {
         var _loc4_:AnimationState = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._animationStates.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._animationStates[_loc2_];
            if(_loc4_.name === param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return this._animations[param1] != null;
      }
      
      public function get isPlaying() : Boolean
      {
         if(this._animationStates.length > 1)
         {
            return this._isPlaying && !this.isCompleted;
         }
         if(this._lastAnimationState)
         {
            return this._isPlaying && this._lastAnimationState.isPlaying;
         }
         return this._isPlaying;
      }
      
      public function get isCompleted() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this._lastAnimationState)
         {
            if(!this._lastAnimationState.isCompleted)
            {
               return false;
            }
            _loc1_ = 0;
            _loc2_ = this._animationStates.length;
            while(_loc1_ < _loc2_)
            {
               if(!this._animationStates[_loc1_].isCompleted)
               {
                  return false;
               }
               _loc1_++;
            }
            return true;
         }
         return false;
      }
      
      public function get lastAnimationName() : String
      {
         return this._lastAnimationState ? this._lastAnimationState.name : null;
      }
      
      public function get lastAnimationState() : AnimationState
      {
         return this._lastAnimationState;
      }
      
      public function get animationConfig() : AnimationConfig
      {
         this._animationConfig.clear();
         return this._animationConfig;
      }
      
      public function get animationNames() : Vector.<String>
      {
         return this._animationNames;
      }
      
      public function get animations() : Object
      {
         return this._animations;
      }
      
      public function set animations(param1:Object) : void
      {
         var _loc2_:String = null;
         if(this._animations == param1)
         {
            return;
         }
         this._animationNames.length = 0;
         for(_loc2_ in this._animations)
         {
            delete this._animations[_loc2_];
         }
         if(param1)
         {
            for(_loc2_ in param1)
            {
               this._animations[_loc2_] = param1[_loc2_];
               this._animationNames.push(_loc2_);
            }
         }
      }
   }
}

