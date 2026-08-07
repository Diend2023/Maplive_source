package dragonBones.animation
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.EventType;
   import dragonBones.events.EventObject;
   import dragonBones.events.IEventDispatcher;
   import dragonBones.objects.ActionData;
   import dragonBones.objects.AnimationFrameData;
   import dragonBones.objects.EventData;
   import dragonBones.objects.FrameData;
   
   use namespace dragonBones_internal;
   
   public final class AnimationTimelineState extends TimelineState
   {
      
      public function AnimationTimelineState()
      {
         super(this);
      }
      
      protected function _onCrossFrame(param1:FrameData) : void
      {
         var _loc4_:Vector.<ActionData> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:EventData = null;
         var _loc8_:String = null;
         var _loc9_:EventObject = null;
         if(_animationState.actionEnabled)
         {
            _loc4_ = (param1 as AnimationFrameData).actions;
            _loc5_ = 0;
            _loc6_ = _loc4_.length;
            while(_loc5_ < _loc6_)
            {
               _armature.dragonBones_internal::_bufferAction(_loc4_[_loc5_]);
               _loc5_++;
            }
         }
         var _loc2_:IEventDispatcher = _armature.eventDispatcher;
         var _loc3_:Vector.<EventData> = (param1 as AnimationFrameData).events;
         _loc5_ = 0;
         _loc6_ = _loc3_.length;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc3_[_loc5_];
            _loc8_ = null;
            switch(_loc7_.type)
            {
               case EventType.Frame:
                  _loc8_ = EventObject.FRAME_EVENT;
                  break;
               case EventType.Sound:
                  _loc8_ = EventObject.SOUND_EVENT;
            }
            if(_loc2_.hasEvent(_loc8_) || _loc7_.type === EventType.Sound)
            {
               _loc9_ = BaseObject.borrowObject(EventObject) as EventObject;
               _loc9_.name = _loc7_.name;
               _loc9_.frame = param1 as AnimationFrameData;
               _loc9_.data = _loc7_.data;
               _loc9_.animationState = _animationState;
               if(_loc7_.bone)
               {
                  _loc9_.bone = _armature.getBone(_loc7_.bone.name);
               }
               if(_loc7_.slot)
               {
                  _loc9_.slot = _armature.getSlot(_loc7_.slot.name);
               }
               _armature.dragonBones_internal::_bufferEvent(_loc9_,_loc8_);
            }
            _loc5_++;
         }
      }
      
      override public function update(param1:Number) : void
      {
         var _loc5_:IEventDispatcher = null;
         var _loc6_:EventObject = null;
         var _loc7_:uint = 0;
         var _loc8_:AnimationFrameData = null;
         var _loc9_:Boolean = false;
         var _loc10_:AnimationFrameData = null;
         var _loc11_:uint = 0;
         var _loc2_:int = int(_playState);
         var _loc3_:uint = uint(_currentPlayTimes);
         var _loc4_:Number = Number(_currentTime);
         if(_playState <= 0 && _setCurrentTime(param1))
         {
            _loc5_ = _armature.eventDispatcher;
            if(_loc2_ < 0 && _playState !== _loc2_)
            {
               if(_animationState.displayControl)
               {
                  _armature.dragonBones_internal::_sortZOrder(null);
               }
               if(_loc5_.hasEvent(EventObject.START))
               {
                  _loc6_ = BaseObject.borrowObject(EventObject) as EventObject;
                  _loc6_.animationState = _animationState;
                  _armature.dragonBones_internal::_bufferEvent(_loc6_,EventObject.START);
               }
            }
            if(_loc4_ < 0)
            {
               return;
            }
            if(_keyFrameCount > 1)
            {
               _loc7_ = Math.floor(_currentTime * _frameRate);
               _loc8_ = _timelineData.frames[_loc7_] as AnimationFrameData;
               if(_currentFrame !== _loc8_)
               {
                  _loc9_ = _currentPlayTimes === _loc3_ && _loc4_ > _currentTime;
                  _loc10_ = _currentFrame as AnimationFrameData;
                  _currentFrame = _loc8_;
                  if(!_loc10_)
                  {
                     _loc11_ = Math.floor(_loc4_ * _frameRate);
                     _loc10_ = _timelineData.frames[_loc11_] as AnimationFrameData;
                     if(!_loc9_)
                     {
                        if(_loc4_ <= _loc10_.position)
                        {
                           _loc10_ = _loc10_.prev as AnimationFrameData;
                        }
                     }
                  }
                  if(_loc9_)
                  {
                     while(_loc10_ !== _loc8_)
                     {
                        this._onCrossFrame(_loc10_);
                        _loc10_ = _loc10_.prev as AnimationFrameData;
                     }
                  }
                  else
                  {
                     while(_loc10_ !== _loc8_)
                     {
                        _loc10_ = _loc10_.next as AnimationFrameData;
                        this._onCrossFrame(_loc10_);
                     }
                  }
               }
            }
            else if(_keyFrameCount > 0 && !_currentFrame)
            {
               _currentFrame = _timelineData.frames[0];
               this._onCrossFrame(_currentFrame);
            }
            if(_currentPlayTimes !== _loc3_)
            {
               if(_loc5_.hasEvent(EventObject.LOOP_COMPLETE))
               {
                  _loc6_ = BaseObject.borrowObject(EventObject) as EventObject;
                  _loc6_.animationState = _animationState;
                  _armature.dragonBones_internal::_bufferEvent(_loc6_,EventObject.LOOP_COMPLETE);
               }
               if(_playState > 0 && _loc5_.hasEvent(EventObject.COMPLETE))
               {
                  _loc6_ = BaseObject.borrowObject(EventObject) as EventObject;
                  _loc6_.animationState = _animationState;
                  _armature.dragonBones_internal::_bufferEvent(_loc6_,EventObject.COMPLETE);
               }
            }
         }
      }
      
      public function setCurrentTime(param1:Number) : void
      {
         _setCurrentTime(param1);
         _currentFrame = null;
      }
   }
}

