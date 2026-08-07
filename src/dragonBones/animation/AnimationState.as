package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.core.BaseObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.events.EventObject;
   import dragonBones.objects.AnimationConfig;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.BoneTimelineData;
   import dragonBones.objects.DisplayData;
   import dragonBones.objects.FFDTimelineData;
   import dragonBones.objects.SlotTimelineData;
   
   use namespace dragonBones_internal;
   
   public final class AnimationState extends BaseObject
   {
      
      public var displayControl:Boolean;
      
      public var additiveBlending:Boolean;
      
      public var actionEnabled:Boolean;
      
      public var playTimes:uint;
      
      public var timeScale:Number;
      
      public var weight:Number;
      
      public var autoFadeOutTime:Number;
      
      public var fadeTotalTime:Number;
      
      internal var _playheadState:int;
      
      internal var _fadeState:int;
      
      internal var _subFadeState:int;
      
      internal var _layer:int;
      
      internal var _position:Number;
      
      internal var _duration:Number;
      
      private var _fadeTime:Number;
      
      private var _time:Number;
      
      internal var _fadeProgress:Number;
      
      internal var _weightResult:Number;
      
      private var _name:String;
      
      internal var _group:String;
      
      private const _boneMask:Vector.<String> = new Vector.<String>();
      
      private const _boneTimelines:Vector.<BoneTimelineState> = new Vector.<BoneTimelineState>();
      
      private const _slotTimelines:Vector.<SlotTimelineState> = new Vector.<SlotTimelineState>();
      
      private const _ffdTimelines:Vector.<FFDTimelineState> = new Vector.<FFDTimelineState>();
      
      private var _animationData:AnimationData;
      
      private var _armature:Armature;
      
      internal var _timeline:AnimationTimelineState;
      
      private var _zOrderTimeline:ZOrderTimelineState;
      
      public function AnimationState()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this._boneTimelines.length;
         while(_loc1_ < _loc2_)
         {
            this._boneTimelines[_loc1_].returnToPool();
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = this._slotTimelines.length;
         while(_loc1_ < _loc2_)
         {
            this._slotTimelines[_loc1_].returnToPool();
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = this._ffdTimelines.length;
         while(_loc1_ < _loc2_)
         {
            this._ffdTimelines[_loc1_].returnToPool();
            _loc1_++;
         }
         if(this._timeline)
         {
            this._timeline.returnToPool();
         }
         if(this._zOrderTimeline)
         {
            this._zOrderTimeline.returnToPool();
         }
         this.displayControl = true;
         this.additiveBlending = false;
         this.actionEnabled = false;
         this.playTimes = 1;
         this.timeScale = 1;
         this.weight = 1;
         this.autoFadeOutTime = -1;
         this.fadeTotalTime = 0;
         this._playheadState = 0;
         this._fadeState = -1;
         this._subFadeState = -1;
         this._layer = 0;
         this._position = 0;
         this._duration = 0;
         this._fadeTime = 0;
         this._time = 0;
         this._fadeProgress = 0;
         this._weightResult = 0;
         this._name = null;
         this._group = null;
         this._boneMask.fixed = false;
         this._boneMask.length = 0;
         this._boneTimelines.fixed = false;
         this._boneTimelines.length = 0;
         this._slotTimelines.fixed = false;
         this._slotTimelines.length = 0;
         this._ffdTimelines.fixed = false;
         this._ffdTimelines.length = 0;
         this._animationData = null;
         this._armature = null;
         this._timeline = null;
         this._zOrderTimeline = null;
      }
      
      private function _advanceFadeTime(param1:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:EventObject = null;
         var _loc2_:* = this._fadeState > 0;
         if(this._subFadeState < 0)
         {
            this._subFadeState = 0;
            _loc3_ = _loc2_ ? EventObject.FADE_OUT : EventObject.FADE_IN;
            if(this._armature.eventDispatcher.hasEvent(_loc3_))
            {
               _loc4_ = BaseObject.borrowObject(EventObject) as EventObject;
               _loc4_.animationState = this;
               this._armature.dragonBones_internal::_bufferEvent(_loc4_,_loc3_);
            }
         }
         if(param1 < 0)
         {
            param1 = -param1;
         }
         this._fadeTime += param1;
         if(this._fadeTime >= this.fadeTotalTime)
         {
            this._subFadeState = 1;
            this._fadeProgress = _loc2_ ? 0 : 1;
         }
         else if(this._fadeTime > 0)
         {
            this._fadeProgress = _loc2_ ? 1 - this._fadeTime / this.fadeTotalTime : this._fadeTime / this.fadeTotalTime;
         }
         else
         {
            this._fadeProgress = _loc2_ ? 1 : 0;
         }
         if(this._subFadeState > 0)
         {
            if(!_loc2_)
            {
               this._playheadState |= 1;
               this._fadeState = 0;
            }
            _loc3_ = _loc2_ ? EventObject.FADE_OUT_COMPLETE : EventObject.FADE_IN_COMPLETE;
            if(this._armature.eventDispatcher.hasEvent(_loc3_))
            {
               _loc4_ = BaseObject.borrowObject(EventObject) as EventObject;
               _loc4_.animationState = this;
               this._armature.dragonBones_internal::_bufferEvent(_loc4_,_loc3_);
            }
         }
      }
      
      public function _init(param1:Armature, param2:AnimationData, param3:AnimationConfig) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this._armature = param1;
         this._animationData = param2;
         this._name = param3.name ? param3.name : param3.animationName;
         this.actionEnabled = param3.actionEnabled;
         this.additiveBlending = param3.additiveBlending;
         this.displayControl = param3.displayControl;
         this.playTimes = param3.playTimes;
         this.timeScale = param3.timeScale;
         this.fadeTotalTime = param3.fadeInTime;
         this.autoFadeOutTime = param3.autoFadeOutTime;
         this.weight = param3.weight;
         if(param3.pauseFadeIn)
         {
            this._playheadState = 2;
         }
         else
         {
            this._playheadState = 3;
         }
         this._fadeState = -1;
         this._subFadeState = -1;
         this._layer = param3.layer;
         this._time = param3.position;
         this._group = param3.group;
         if(param3.duration < 0)
         {
            this._position = 0;
            this._duration = this._animationData.duration;
         }
         else
         {
            this._position = param3.position;
            this._duration = param3.duration;
         }
         if(this.fadeTotalTime <= 0)
         {
            this._fadeProgress = 0.999999;
         }
         if(param3.boneMask.length > 0)
         {
            this._boneMask.length = param3.boneMask.length;
            _loc4_ = 0;
            _loc5_ = this._boneMask.length;
            while(_loc4_ < _loc5_)
            {
               this._boneMask[_loc4_] = param3.boneMask[_loc4_];
               _loc4_++;
            }
            this._boneMask.fixed = true;
         }
         this._timeline = BaseObject.borrowObject(AnimationTimelineState) as AnimationTimelineState;
         this._timeline._init(this._armature,this,this._animationData);
         if(this._animationData.zOrderTimeline)
         {
            this._zOrderTimeline = BaseObject.borrowObject(ZOrderTimelineState) as ZOrderTimelineState;
            this._zOrderTimeline._init(this._armature,this,this._animationData.zOrderTimeline);
         }
         this._updateTimelineStates();
      }
      
      internal function _updateTimelineStates() : void
      {
         var _loc8_:BoneTimelineState = null;
         var _loc9_:Bone = null;
         var _loc10_:String = null;
         var _loc11_:BoneTimelineData = null;
         var _loc12_:SlotTimelineState = null;
         var _loc13_:FFDTimelineState = null;
         var _loc14_:DisplayData = null;
         var _loc15_:String = null;
         var _loc16_:Slot = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:Boolean = false;
         var _loc20_:SlotTimelineData = null;
         var _loc21_:Object = null;
         var _loc22_:String = null;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         this._boneTimelines.fixed = false;
         this._slotTimelines.fixed = false;
         this._ffdTimelines.fixed = false;
         var _loc1_:Object = {};
         var _loc2_:Object = {};
         var _loc3_:Object = {};
         var _loc4_:uint = 0;
         var _loc5_:uint = this._boneTimelines.length;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = this._boneTimelines[_loc4_];
            _loc1_[_loc8_.bone.name] = _loc8_;
            _loc4_++;
         }
         var _loc6_:Vector.<Bone> = this._armature.getBones();
         _loc4_ = 0;
         _loc5_ = _loc6_.length;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc6_[_loc4_];
            _loc10_ = _loc9_.name;
            if(this.containsBoneMask(_loc10_))
            {
               _loc11_ = this._animationData.getBoneTimeline(_loc10_);
               if(_loc11_)
               {
                  if(_loc1_[_loc10_])
                  {
                     delete _loc1_[_loc10_];
                  }
                  else
                  {
                     _loc8_ = BaseObject.borrowObject(BoneTimelineState) as BoneTimelineState;
                     _loc8_.bone = _loc9_;
                     _loc8_._init(this._armature,this,_loc11_);
                     this._boneTimelines.push(_loc8_);
                  }
               }
            }
            _loc4_++;
         }
         for each(_loc8_ in _loc1_)
         {
            _loc8_.bone.invalidUpdate();
            this._boneTimelines.splice(this._boneTimelines.indexOf(_loc8_),1);
            _loc8_.returnToPool();
         }
         _loc4_ = 0;
         _loc5_ = this._slotTimelines.length;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = this._slotTimelines[_loc4_];
            _loc2_[_loc12_.slot.name] = _loc12_;
            _loc4_++;
         }
         _loc4_ = 0;
         _loc5_ = this._ffdTimelines.length;
         while(_loc4_ < _loc5_)
         {
            _loc13_ = this._ffdTimelines[_loc4_];
            _loc14_ = (_loc13_._timelineData as FFDTimelineData).display;
            _loc15_ = _loc14_.inheritAnimation ? _loc14_.mesh.name : _loc14_.name;
            _loc3_[_loc15_] = _loc13_;
            _loc4_++;
         }
         var _loc7_:Vector.<Slot> = this._armature.getSlots();
         _loc4_ = 0;
         _loc5_ = _loc7_.length;
         while(_loc4_ < _loc5_)
         {
            _loc16_ = _loc7_[_loc4_];
            _loc17_ = _loc16_.name;
            _loc18_ = _loc16_.parent.name;
            _loc19_ = false;
            if(this.containsBoneMask(_loc18_))
            {
               _loc20_ = this._animationData.getSlotTimeline(_loc17_);
               if(_loc20_)
               {
                  if(_loc2_[_loc17_])
                  {
                     delete _loc2_[_loc17_];
                  }
                  else
                  {
                     _loc12_ = BaseObject.borrowObject(SlotTimelineState) as SlotTimelineState;
                     _loc12_.slot = _loc16_;
                     _loc12_._init(this._armature,this,_loc20_);
                     this._slotTimelines.push(_loc12_);
                  }
               }
               _loc21_ = this._animationData.getFFDTimeline(this._armature.dragonBones_internal::_skinData.name,_loc17_);
               if(_loc21_)
               {
                  for(_loc22_ in _loc21_)
                  {
                     if(_loc3_[_loc22_])
                     {
                        delete _loc3_[_loc22_];
                     }
                     else
                     {
                        _loc13_ = BaseObject.borrowObject(FFDTimelineState) as FFDTimelineState;
                        _loc13_.slot = _loc16_;
                        _loc13_._init(this._armature,this,_loc21_[_loc22_]);
                        this._ffdTimelines.push(_loc13_);
                     }
                  }
               }
               else
               {
                  _loc19_ = true;
               }
            }
            else
            {
               _loc19_ = true;
            }
            if(_loc19_)
            {
               _loc23_ = 0;
               _loc24_ = _loc16_.dragonBones_internal::_ffdVertices.length;
               while(_loc23_ < _loc24_)
               {
                  _loc16_.dragonBones_internal::_ffdVertices[_loc23_] = 0;
                  _loc23_++;
               }
               _loc16_.dragonBones_internal::_meshDirty = true;
            }
            _loc4_++;
         }
         for each(_loc12_ in _loc2_)
         {
            this._slotTimelines.splice(this._slotTimelines.indexOf(_loc12_),1);
            _loc12_.returnToPool();
         }
         for each(_loc13_ in _loc3_)
         {
            this._ffdTimelines.splice(this._ffdTimelines.indexOf(_loc13_),1);
            _loc13_.returnToPool();
         }
         this._boneTimelines.fixed = true;
         this._slotTimelines.fixed = true;
         this._ffdTimelines.fixed = true;
      }
      
      internal function _advanceTime(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         if(this._fadeState !== 0 || this._subFadeState !== 0)
         {
            this._advanceFadeTime(param1);
         }
         if(this.timeScale !== 1)
         {
            param1 *= this.timeScale;
         }
         if(param1 !== 0 && this._playheadState === 3)
         {
            this._time += param1;
         }
         this._weightResult = this.weight * this._fadeProgress;
         if(this._weightResult !== 0)
         {
            _loc3_ = this._fadeState === 0 && param2 > 0;
            _loc4_ = true;
            _loc5_ = true;
            _loc6_ = this._time;
            this._timeline.update(_loc6_);
            if(_loc3_)
            {
               this._timeline._currentTime = Math.floor(this._timeline._currentTime * param2) / param2;
            }
            if(this._zOrderTimeline)
            {
               this._zOrderTimeline.update(_loc6_);
            }
            if(_loc3_)
            {
               _loc7_ = Math.floor(this._timeline._currentTime * param2);
               if(this._armature.animation.dragonBones_internal::_cacheFrameIndex === _loc7_)
               {
                  _loc4_ = false;
                  _loc5_ = false;
               }
               else
               {
                  this._armature.animation.dragonBones_internal::_cacheFrameIndex = _loc7_;
                  if(this._animationData.cachedFrames[_loc7_])
                  {
                     _loc5_ = false;
                  }
                  else
                  {
                     this._animationData.cachedFrames[_loc7_] = true;
                  }
               }
            }
            if(_loc4_)
            {
               if(_loc5_)
               {
                  _loc8_ = 0;
                  _loc9_ = this._boneTimelines.length;
                  while(_loc8_ < _loc9_)
                  {
                     this._boneTimelines[_loc8_].update(_loc6_);
                     _loc8_++;
                  }
               }
               _loc8_ = 0;
               _loc9_ = this._slotTimelines.length;
               while(_loc8_ < _loc9_)
               {
                  this._slotTimelines[_loc8_].update(_loc6_);
                  _loc8_++;
               }
               _loc8_ = 0;
               _loc9_ = this._ffdTimelines.length;
               while(_loc8_ < _loc9_)
               {
                  this._ffdTimelines[_loc8_].update(_loc6_);
                  _loc8_++;
               }
            }
         }
         if(this._fadeState === 0)
         {
            if(this._subFadeState > 0)
            {
               this._subFadeState = 0;
            }
            if(this.autoFadeOutTime >= 0)
            {
               if(this._timeline._playState > 0)
               {
                  this.fadeOut(this.autoFadeOutTime);
               }
            }
         }
      }
      
      internal function _isDisabled(param1:Slot) : Boolean
      {
         if(this.displayControl && (!param1.displayController || param1.displayController === this._name || param1.displayController === this._group))
         {
            return false;
         }
         return true;
      }
      
      internal function _getBoneTimelineState(param1:String) : BoneTimelineState
      {
         var _loc2_:BoneTimelineState = null;
         for each(_loc2_ in this._boneTimelines)
         {
            if(_loc2_.bone.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function play() : void
      {
         this._playheadState = 3;
      }
      
      public function stop() : void
      {
         this._playheadState &= 1;
      }
      
      public function fadeOut(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 < 0 || param1 !== param1)
         {
            param1 = 0;
         }
         if(param2)
         {
            this._playheadState &= 2;
         }
         if(this._fadeState > 0)
         {
            if(param1 > param1 - this._fadeTime)
            {
               return;
            }
         }
         else
         {
            this._fadeState = 1;
            this._subFadeState = -1;
            if(param1 <= 0 || this._fadeProgress <= 0)
            {
               this._fadeProgress = 0.000001;
            }
            _loc3_ = 0;
            _loc4_ = this._boneTimelines.length;
            while(_loc3_ < _loc4_)
            {
               this._boneTimelines[_loc3_].fadeOut();
               _loc3_++;
            }
            _loc3_ = 0;
            _loc4_ = this._slotTimelines.length;
            while(_loc3_ < _loc4_)
            {
               this._slotTimelines[_loc3_].fadeOut();
               _loc3_++;
            }
            _loc3_ = 0;
            _loc4_ = this._ffdTimelines.length;
            while(_loc3_ < _loc4_)
            {
               this._ffdTimelines[_loc3_].fadeOut();
               _loc3_++;
            }
         }
         this.displayControl = false;
         this.fadeTotalTime = this._fadeProgress > 0.000001 ? param1 / this._fadeProgress : 0;
         this._fadeTime = this.fadeTotalTime * (1 - this._fadeProgress);
      }
      
      public function containsBoneMask(param1:String) : Boolean
      {
         return this._boneMask.length === 0 || this._boneMask.indexOf(param1) >= 0;
      }
      
      public function addBoneMask(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:Vector.<Bone> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Bone = null;
         var _loc3_:Bone = this._armature.getBone(param1);
         if(!_loc3_)
         {
            return;
         }
         this._boneMask.fixed = false;
         if(this._boneMask.indexOf(param1) < 0)
         {
            this._boneMask.push(param1);
         }
         if(param2)
         {
            _loc4_ = this._armature.getBones();
            _loc5_ = 0;
            _loc6_ = _loc4_.length;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc4_[_loc5_];
               if(this._boneMask.indexOf(_loc7_.name) < 0 && _loc3_.contains(_loc7_))
               {
                  this._boneMask.push(_loc7_.name);
               }
               _loc5_++;
            }
         }
         this._boneMask.fixed = true;
         this._updateTimelineStates();
      }
      
      public function removeBoneMask(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:Bone = null;
         var _loc5_:Vector.<Bone> = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Bone = null;
         this._boneMask.fixed = false;
         var _loc3_:int = int(this._boneMask.indexOf(param1));
         if(_loc3_ >= 0)
         {
            this._boneMask.splice(_loc3_,1);
         }
         if(param2)
         {
            _loc4_ = this._armature.getBone(param1);
            if(_loc4_)
            {
               _loc5_ = this._armature.getBones();
               if(this._boneMask.length > 0)
               {
                  _loc6_ = 0;
                  _loc7_ = _loc5_.length;
                  while(_loc6_ < _loc7_)
                  {
                     _loc8_ = _loc5_[_loc6_];
                     _loc3_ = int(this._boneMask.indexOf(_loc8_.name));
                     if(_loc3_ >= 0 && _loc4_.contains(_loc8_))
                     {
                        this._boneMask.splice(_loc3_,1);
                     }
                     _loc6_++;
                  }
               }
               else
               {
                  _loc6_ = 0;
                  _loc7_ = _loc5_.length;
                  while(_loc6_ < _loc7_)
                  {
                     _loc8_ = _loc5_[_loc6_];
                     if(!_loc4_.contains(_loc8_))
                     {
                        this._boneMask.push(_loc8_.name);
                     }
                     _loc6_++;
                  }
               }
            }
         }
         this._boneMask.fixed = true;
         this._updateTimelineStates();
      }
      
      public function removeAllBoneMask() : void
      {
         this._boneMask.fixed = false;
         this._boneMask.length = 0;
         this._boneMask.fixed = true;
         this._updateTimelineStates();
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
      
      public function get group() : String
      {
         return this._group;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get animationData() : AnimationData
      {
         return this._animationData;
      }
      
      public function get isCompleted() : Boolean
      {
         return this._timeline._playState > 0;
      }
      
      public function get isPlaying() : Boolean
      {
         return Boolean(this._playheadState & 2) && this._timeline._playState <= 0;
      }
      
      public function get currentPlayTimes() : uint
      {
         return this._timeline._currentPlayTimes;
      }
      
      public function get totalTime() : Number
      {
         return this._duration;
      }
      
      public function get currentTime() : Number
      {
         return this._timeline._currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         if(param1 < 0 || param1 != param1)
         {
            param1 = 0;
         }
         var _loc2_:uint = this._timeline._currentPlayTimes - (this._timeline._playState > 0 ? 1 : 0);
         param1 = param1 % this._duration + _loc2_ * this._duration;
         if(this._time === param1)
         {
            return;
         }
         this._time = param1;
         this._timeline.setCurrentTime(this._time);
         if(this._zOrderTimeline)
         {
            this._zOrderTimeline._playState = -1;
         }
         var _loc3_:uint = 0;
         var _loc4_:uint = this._boneTimelines.length;
         while(_loc3_ < _loc4_)
         {
            this._boneTimelines[_loc3_]._playState = -1;
            _loc3_++;
         }
         _loc3_ = 0;
         _loc4_ = this._slotTimelines.length;
         while(_loc3_ < _loc4_)
         {
            this._slotTimelines[_loc3_]._playState = -1;
            _loc3_++;
         }
         _loc3_ = 0;
         _loc4_ = this._ffdTimelines.length;
         while(_loc3_ < _loc4_)
         {
            this._ffdTimelines[_loc3_]._playState = -1;
            _loc3_++;
         }
      }
   }
}

