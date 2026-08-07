package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Slot;
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.ExtensionFrameData;
   import dragonBones.objects.FFDTimelineData;
   import dragonBones.objects.TimelineData;
   
   use namespace dragonBones_internal;
   
   public final class FFDTimelineState extends TweenTimelineState
   {
      
      public var slot:Slot;
      
      private var _ffdDirty:Boolean;
      
      private var _tweenFFD:int;
      
      private const _ffdVertices:Vector.<Number> = new Vector.<Number>();
      
      private const _durationFFDVertices:Vector.<Number> = new Vector.<Number>();
      
      private var _slotFFDVertices:Vector.<Number>;
      
      public function FFDTimelineState()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.slot = null;
         this._ffdDirty = false;
         this._tweenFFD = TWEEN_TYPE_NONE;
         this._ffdVertices.fixed = false;
         this._durationFFDVertices.fixed = false;
         this._ffdVertices.length = 0;
         this._durationFFDVertices.length = 0;
         this._slotFFDVertices = null;
      }
      
      override protected function _onArriveAtFrame() : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:Vector.<Number> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         super._onArriveAtFrame();
         if(this.slot.displayIndex >= 0 && _animationState._isDisabled(this.slot))
         {
            _tweenEasing = DragonBones.NO_TWEEN;
            _curve = null;
            this._tweenFFD = TWEEN_TYPE_NONE;
            return;
         }
         var _loc1_:ExtensionFrameData = _currentFrame as ExtensionFrameData;
         this._tweenFFD = TWEEN_TYPE_NONE;
         if(_tweenEasing !== DragonBones.NO_TWEEN || Boolean(_curve))
         {
            _loc2_ = _loc1_.tweens;
            _loc3_ = (_loc1_.next as ExtensionFrameData).tweens;
            _loc4_ = 0;
            _loc5_ = _loc2_.length;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc3_[_loc4_] - _loc2_[_loc4_];
               this._durationFFDVertices[_loc4_] = _loc6_;
               if(_loc6_ !== 0)
               {
                  this._tweenFFD = TWEEN_TYPE_ALWAYS;
               }
               _loc4_++;
            }
         }
         if(this._tweenFFD === TWEEN_TYPE_NONE)
         {
            this._tweenFFD = TWEEN_TYPE_ONCE;
            _loc4_ = 0;
            _loc5_ = this._durationFFDVertices.length;
            while(_loc4_ < _loc5_)
            {
               this._durationFFDVertices[_loc4_] = 0;
               _loc4_++;
            }
         }
      }
      
      override protected function _onUpdateFrame() : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super._onUpdateFrame();
         var _loc1_:Number = 0;
         if(this._tweenFFD !== TWEEN_TYPE_NONE && this.slot.parent.dragonBones_internal::_blendLayer >= _animationState._layer)
         {
            if(this._tweenFFD === TWEEN_TYPE_ONCE)
            {
               this._tweenFFD = TWEEN_TYPE_NONE;
               _loc1_ = 0;
            }
            else
            {
               _loc1_ = _tweenProgress;
            }
            _loc2_ = (_currentFrame as ExtensionFrameData).tweens;
            _loc3_ = 0;
            _loc4_ = _loc2_.length;
            while(_loc3_ < _loc4_)
            {
               this._ffdVertices[_loc3_] = _loc2_[_loc3_] + this._durationFFDVertices[_loc3_] * _loc1_;
               _loc3_++;
            }
            this._ffdDirty = true;
         }
      }
      
      override public function _init(param1:Armature, param2:AnimationState, param3:TimelineData) : void
      {
         super._init(param1,param2,param3);
         this._slotFFDVertices = this.slot.dragonBones_internal::_ffdVertices;
         this._ffdVertices.length = (_timelineData.frames[0] as ExtensionFrameData).tweens.length;
         this._durationFFDVertices.length = this._ffdVertices.length;
         this._ffdVertices.fixed = true;
         this._durationFFDVertices.fixed = true;
         var _loc4_:uint = 0;
         var _loc5_:uint = this._ffdVertices.length;
         while(_loc4_ < _loc5_)
         {
            this._ffdVertices[_loc4_] = 0;
            _loc4_++;
         }
         _loc4_ = 0;
         _loc5_ = this._durationFFDVertices.length;
         while(_loc4_ < _loc5_)
         {
            this._durationFFDVertices[_loc4_] = 0;
            _loc4_++;
         }
      }
      
      override public function fadeOut() : void
      {
         this._tweenFFD = TWEEN_TYPE_NONE;
      }
      
      override public function update(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.update(param1);
         if(this.slot.dragonBones_internal::_meshData !== (_timelineData as FFDTimelineData).display.mesh)
         {
            return;
         }
         if(this._tweenFFD !== TWEEN_TYPE_NONE || this._ffdDirty)
         {
            if(_animationState._fadeState !== 0 || _animationState._subFadeState !== 0)
            {
               _loc2_ = Math.pow(_animationState._fadeProgress,4);
               _loc3_ = 0;
               _loc4_ = this._ffdVertices.length;
               while(_loc3_ < _loc4_)
               {
                  this._slotFFDVertices[_loc3_] += (this._ffdVertices[_loc3_] - this._slotFFDVertices[_loc3_]) * _loc2_;
                  _loc3_++;
               }
               this.slot.dragonBones_internal::_meshDirty = true;
            }
            else if(this._ffdDirty)
            {
               this._ffdDirty = false;
               _loc3_ = 0;
               _loc4_ = this._ffdVertices.length;
               while(_loc3_ < _loc4_)
               {
                  this._slotFFDVertices[_loc3_] = this._ffdVertices[_loc3_];
                  _loc3_++;
               }
               this.slot.dragonBones_internal::_meshDirty = true;
            }
         }
      }
   }
}

