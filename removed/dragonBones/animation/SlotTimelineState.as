package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Slot;
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.SlotFrameData;
   import dragonBones.objects.TimelineData;
   import flash.geom.ColorTransform;
   
   use namespace dragonBones_internal;
   
   public final class SlotTimelineState extends TweenTimelineState
   {
      
      public var slot:Slot;
      
      private var _colorDirty:Boolean;
      
      private var _tweenColor:int;
      
      private const _color:ColorTransform = new ColorTransform();
      
      private const _durationColor:ColorTransform = new ColorTransform();
      
      private var _slotColor:ColorTransform;
      
      public function SlotTimelineState()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.slot = null;
         this._colorDirty = false;
         this._tweenColor = TWEEN_TYPE_NONE;
         this._color.alphaMultiplier = 1;
         this._color.redMultiplier = 1;
         this._color.greenMultiplier = 1;
         this._color.blueMultiplier = 1;
         this._color.alphaOffset = 0;
         this._color.redOffset = 0;
         this._color.greenOffset = 0;
         this._color.blueOffset = 0;
         this._durationColor.alphaMultiplier = 1;
         this._durationColor.redMultiplier = 1;
         this._durationColor.greenMultiplier = 1;
         this._durationColor.blueMultiplier = 1;
         this._durationColor.alphaOffset = 0;
         this._durationColor.redOffset = 0;
         this._durationColor.greenOffset = 0;
         this._durationColor.blueOffset = 0;
         this._slotColor = null;
      }
      
      override protected function _onArriveAtFrame() : void
      {
         var _loc1_:SlotFrameData = null;
         var _loc3_:ColorTransform = null;
         var _loc4_:SlotFrameData = null;
         var _loc5_:ColorTransform = null;
         super._onArriveAtFrame();
         if(_animationState._isDisabled(this.slot))
         {
            _tweenEasing = DragonBones.NO_TWEEN;
            _curve = null;
            this._tweenColor = TWEEN_TYPE_NONE;
            return;
         }
         _loc1_ = _currentFrame as SlotFrameData;
         var _loc2_:int = _loc1_.displayIndex;
         if(_playState >= 0 && this.slot.displayIndex !== _loc2_)
         {
            this.slot.dragonBones_internal::_setDisplayIndex(_loc2_);
         }
         if(_loc2_ >= 0)
         {
            this._tweenColor = TWEEN_TYPE_NONE;
            _loc3_ = _loc1_.color;
            if(_tweenEasing !== DragonBones.NO_TWEEN || Boolean(_curve))
            {
               _loc4_ = _loc1_.next as SlotFrameData;
               _loc5_ = _loc4_.color;
               if(_loc3_ !== _loc5_)
               {
                  this._durationColor.alphaMultiplier = _loc5_.alphaMultiplier - _loc3_.alphaMultiplier;
                  this._durationColor.redMultiplier = _loc5_.redMultiplier - _loc3_.redMultiplier;
                  this._durationColor.greenMultiplier = _loc5_.greenMultiplier - _loc3_.greenMultiplier;
                  this._durationColor.blueMultiplier = _loc5_.blueMultiplier - _loc3_.blueMultiplier;
                  this._durationColor.alphaOffset = _loc5_.alphaOffset - _loc3_.alphaOffset;
                  this._durationColor.redOffset = _loc5_.redOffset - _loc3_.redOffset;
                  this._durationColor.greenOffset = _loc5_.greenOffset - _loc3_.greenOffset;
                  this._durationColor.blueOffset = _loc5_.blueOffset - _loc3_.blueOffset;
                  if(this._durationColor.alphaMultiplier !== 0 || this._durationColor.redMultiplier !== 0 || this._durationColor.greenMultiplier !== 0 || this._durationColor.blueMultiplier !== 0 || this._durationColor.alphaOffset !== 0 || this._durationColor.redOffset !== 0 || this._durationColor.greenOffset !== 0 || this._durationColor.blueOffset !== 0)
                  {
                     this._tweenColor = TWEEN_TYPE_ALWAYS;
                  }
               }
            }
            if(this._tweenColor === TWEEN_TYPE_NONE)
            {
               if(this._slotColor.alphaMultiplier !== _loc3_.alphaMultiplier || this._slotColor.redMultiplier !== _loc3_.redMultiplier || this._slotColor.greenMultiplier !== _loc3_.greenMultiplier || this._slotColor.blueMultiplier !== _loc3_.blueMultiplier || this._slotColor.alphaOffset !== _loc3_.alphaOffset || this._slotColor.redOffset !== _loc3_.redOffset || this._slotColor.greenOffset !== _loc3_.greenOffset || this._slotColor.blueOffset !== _loc3_.blueOffset)
               {
                  this._tweenColor = TWEEN_TYPE_ONCE;
               }
            }
         }
         else
         {
            _tweenEasing = DragonBones.NO_TWEEN;
            _curve = null;
            this._tweenColor = TWEEN_TYPE_NONE;
         }
      }
      
      override protected function _onUpdateFrame() : void
      {
         var _loc3_:ColorTransform = null;
         super._onUpdateFrame();
         var _loc1_:SlotFrameData = _currentFrame as SlotFrameData;
         var _loc2_:Number = 0;
         if(this._tweenColor !== TWEEN_TYPE_NONE && this.slot.parent.dragonBones_internal::_blendLayer >= _animationState._layer)
         {
            if(this._tweenColor === TWEEN_TYPE_ONCE)
            {
               this._tweenColor = TWEEN_TYPE_NONE;
               _loc2_ = 0;
            }
            else
            {
               _loc2_ = _tweenProgress;
            }
            _loc3_ = _loc1_.color;
            this._color.alphaMultiplier = _loc3_.alphaMultiplier + this._durationColor.alphaMultiplier * _loc2_;
            this._color.redMultiplier = _loc3_.redMultiplier + this._durationColor.redMultiplier * _loc2_;
            this._color.greenMultiplier = _loc3_.greenMultiplier + this._durationColor.greenMultiplier * _loc2_;
            this._color.blueMultiplier = _loc3_.blueMultiplier + this._durationColor.blueMultiplier * _loc2_;
            this._color.alphaOffset = _loc3_.alphaOffset + this._durationColor.alphaOffset * _loc2_;
            this._color.redOffset = _loc3_.redOffset + this._durationColor.redOffset * _loc2_;
            this._color.greenOffset = _loc3_.greenOffset + this._durationColor.greenOffset * _loc2_;
            this._color.blueOffset = _loc3_.blueOffset + this._durationColor.blueOffset * _loc2_;
            this._colorDirty = true;
         }
      }
      
      override public function _init(param1:Armature, param2:AnimationState, param3:TimelineData) : void
      {
         super._init(param1,param2,param3);
         this._slotColor = this.slot.dragonBones_internal::_colorTransform;
      }
      
      override public function fadeOut() : void
      {
         this._tweenColor = TWEEN_TYPE_NONE;
      }
      
      override public function update(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         super.update(param1);
         if(this._tweenColor !== TWEEN_TYPE_NONE || this._colorDirty)
         {
            if(_animationState._fadeState !== 0 || _animationState._subFadeState !== 0)
            {
               _loc2_ = _animationState._fadeProgress;
               this._slotColor.alphaMultiplier += (this._color.alphaMultiplier - this._slotColor.alphaMultiplier) * _loc2_;
               this._slotColor.redMultiplier += (this._color.redMultiplier - this._slotColor.redMultiplier) * _loc2_;
               this._slotColor.greenMultiplier += (this._color.greenMultiplier - this._slotColor.greenMultiplier) * _loc2_;
               this._slotColor.blueMultiplier += (this._color.blueMultiplier - this._slotColor.blueMultiplier) * _loc2_;
               this._slotColor.alphaOffset += (this._color.alphaOffset - this._slotColor.alphaOffset) * _loc2_;
               this._slotColor.redOffset += (this._color.redOffset - this._slotColor.redOffset) * _loc2_;
               this._slotColor.greenOffset += (this._color.greenOffset - this._slotColor.greenOffset) * _loc2_;
               this._slotColor.blueOffset += (this._color.blueOffset - this._slotColor.blueOffset) * _loc2_;
               this.slot.dragonBones_internal::_colorDirty = true;
            }
            else if(this._colorDirty)
            {
               this._colorDirty = false;
               this._slotColor.alphaMultiplier = this._color.alphaMultiplier;
               this._slotColor.redMultiplier = this._color.redMultiplier;
               this._slotColor.greenMultiplier = this._color.greenMultiplier;
               this._slotColor.blueMultiplier = this._color.blueMultiplier;
               this._slotColor.alphaOffset = this._color.alphaOffset;
               this._slotColor.redOffset = this._color.redOffset;
               this._slotColor.greenOffset = this._color.greenOffset;
               this._slotColor.blueOffset = this._color.blueOffset;
               this.slot.dragonBones_internal::_colorDirty = true;
            }
         }
      }
   }
}

