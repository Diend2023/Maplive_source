package dragonBones.animation
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.geom.Transform;
   import dragonBones.objects.BoneFrameData;
   import dragonBones.objects.BoneTimelineData;
   import dragonBones.objects.TimelineData;
   
   use namespace dragonBones_internal;
   
   public final class BoneTimelineState extends TweenTimelineState
   {
      
      public var bone:Bone;
      
      private var _transformDirty:Boolean;
      
      private var _tweenTransform:int;
      
      private var _tweenRotate:int;
      
      private var _tweenScale:int;
      
      private const _transform:Transform = new Transform();
      
      private const _durationTransform:Transform = new Transform();
      
      private var _boneTransform:Transform;
      
      private var _originalTransform:Transform;
      
      public function BoneTimelineState()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.bone = null;
         this._transformDirty = false;
         this._tweenTransform = TWEEN_TYPE_NONE;
         this._tweenRotate = TWEEN_TYPE_NONE;
         this._tweenScale = TWEEN_TYPE_NONE;
         this._transform.identity();
         this._durationTransform.identity();
         this._boneTransform = null;
         this._originalTransform = null;
      }
      
      override protected function _onArriveAtFrame() : void
      {
         var _loc2_:Transform = null;
         var _loc3_:BoneFrameData = null;
         var _loc4_:Transform = null;
         var _loc5_:Number = NaN;
         super._onArriveAtFrame();
         var _loc1_:BoneFrameData = _currentFrame as BoneFrameData;
         this._tweenTransform = TWEEN_TYPE_ONCE;
         this._tweenRotate = TWEEN_TYPE_ONCE;
         this._tweenScale = TWEEN_TYPE_ONCE;
         if(_keyFrameCount > 1 && (_tweenEasing !== DragonBones.NO_TWEEN || _curve))
         {
            _loc2_ = _loc1_.transform;
            _loc3_ = _loc1_.next as BoneFrameData;
            _loc4_ = _loc3_.transform;
            this._durationTransform.x = _loc4_.x - _loc2_.x;
            this._durationTransform.y = _loc4_.y - _loc2_.y;
            if(this._durationTransform.x !== 0 || this._durationTransform.y !== 0)
            {
               this._tweenTransform = TWEEN_TYPE_ALWAYS;
            }
            _loc5_ = _loc1_.tweenRotate;
            if(_loc5_ !== DragonBones.NO_TWEEN)
            {
               if(_loc5_)
               {
                  if(_loc5_ > 0 ? _loc4_.skewY >= _loc2_.skewY : _loc4_.skewY <= _loc2_.skewY)
                  {
                     _loc5_ = _loc5_ > 0 ? _loc5_ - 1 : _loc5_ + 1;
                  }
                  this._durationTransform.skewX = _loc4_.skewX - _loc2_.skewX + DragonBones.PI_D * _loc5_;
                  this._durationTransform.skewY = _loc4_.skewY - _loc2_.skewY + DragonBones.PI_D * _loc5_;
               }
               else
               {
                  this._durationTransform.skewX = Transform.normalizeRadian(_loc4_.skewX - _loc2_.skewX);
                  this._durationTransform.skewY = Transform.normalizeRadian(_loc4_.skewY - _loc2_.skewY);
               }
               if(this._durationTransform.skewX !== 0 || this._durationTransform.skewY !== 0)
               {
                  this._tweenRotate = TWEEN_TYPE_ALWAYS;
               }
            }
            else
            {
               this._durationTransform.skewX = 0;
               this._durationTransform.skewY = 0;
            }
            if(_loc1_.tweenScale)
            {
               this._durationTransform.scaleX = _loc4_.scaleX - _loc2_.scaleX;
               this._durationTransform.scaleY = _loc4_.scaleY - _loc2_.scaleY;
               if(this._durationTransform.scaleX !== 0 || this._durationTransform.scaleY !== 0)
               {
                  this._tweenScale = TWEEN_TYPE_ALWAYS;
               }
            }
            else
            {
               this._durationTransform.scaleX = 0;
               this._durationTransform.scaleY = 0;
            }
         }
         else
         {
            this._durationTransform.x = 0;
            this._durationTransform.y = 0;
            this._durationTransform.skewX = 0;
            this._durationTransform.skewY = 0;
            this._durationTransform.scaleX = 0;
            this._durationTransform.scaleY = 0;
         }
      }
      
      override protected function _onUpdateFrame() : void
      {
         super._onUpdateFrame();
         var _loc1_:Number = 0;
         var _loc2_:Transform = (_currentFrame as BoneFrameData).transform;
         if(this._tweenTransform !== TWEEN_TYPE_NONE)
         {
            if(this._tweenTransform === TWEEN_TYPE_ONCE)
            {
               this._tweenTransform = TWEEN_TYPE_NONE;
               _loc1_ = 0;
            }
            else
            {
               _loc1_ = _tweenProgress;
            }
            if(_animationState.additiveBlending)
            {
               this._transform.x = _loc2_.x + this._durationTransform.x * _loc1_;
               this._transform.y = _loc2_.y + this._durationTransform.y * _loc1_;
            }
            else
            {
               this._transform.x = this._originalTransform.x + _loc2_.x + this._durationTransform.x * _loc1_;
               this._transform.y = this._originalTransform.y + _loc2_.y + this._durationTransform.y * _loc1_;
            }
            this._transformDirty = true;
         }
         if(this._tweenRotate !== TWEEN_TYPE_NONE)
         {
            if(this._tweenRotate === TWEEN_TYPE_ONCE)
            {
               this._tweenRotate = TWEEN_TYPE_NONE;
               _loc1_ = 0;
            }
            else
            {
               _loc1_ = _tweenProgress;
            }
            if(_animationState.additiveBlending)
            {
               this._transform.skewX = _loc2_.skewX + this._durationTransform.skewX * _loc1_;
               this._transform.skewY = _loc2_.skewY + this._durationTransform.skewY * _loc1_;
            }
            else
            {
               this._transform.skewX = this._originalTransform.skewX + _loc2_.skewX + this._durationTransform.skewX * _loc1_;
               this._transform.skewY = this._originalTransform.skewY + _loc2_.skewY + this._durationTransform.skewY * _loc1_;
            }
            this._transformDirty = true;
         }
         if(this._tweenScale !== TWEEN_TYPE_NONE)
         {
            if(this._tweenScale === TWEEN_TYPE_ONCE)
            {
               this._tweenScale = TWEEN_TYPE_NONE;
               _loc1_ = 0;
            }
            else
            {
               _loc1_ = _tweenProgress;
            }
            if(_animationState.additiveBlending)
            {
               this._transform.scaleX = _loc2_.scaleX + this._durationTransform.scaleX * _loc1_;
               this._transform.scaleY = _loc2_.scaleY + this._durationTransform.scaleY * _loc1_;
            }
            else
            {
               this._transform.scaleX = this._originalTransform.scaleX * (_loc2_.scaleX + this._durationTransform.scaleX * _loc1_);
               this._transform.scaleY = this._originalTransform.scaleY * (_loc2_.scaleY + this._durationTransform.scaleY * _loc1_);
            }
            this._transformDirty = true;
         }
      }
      
      override public function _init(param1:Armature, param2:AnimationState, param3:TimelineData) : void
      {
         super._init(param1,param2,param3);
         this._originalTransform = (_timelineData as BoneTimelineData).originalTransform;
         this._boneTransform = this.bone.dragonBones_internal::_animationPose;
      }
      
      override public function fadeOut() : void
      {
         this._transform.skewX = Transform.normalizeRadian(this._transform.skewX);
         this._transform.skewY = Transform.normalizeRadian(this._transform.skewY);
      }
      
      override public function update(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = _animationState._layer;
         _loc3_ = _animationState._weightResult;
         if(this.bone.dragonBones_internal::_updateState <= 0)
         {
            super.update(param1);
            this.bone.dragonBones_internal::_blendLayer = _loc2_;
            this.bone.dragonBones_internal::_blendLeftWeight = 1;
            this.bone.dragonBones_internal::_blendTotalWeight = _loc3_;
            this._boneTransform.x = this._transform.x * _loc3_;
            this._boneTransform.y = this._transform.y * _loc3_;
            this._boneTransform.skewX = this._transform.skewX * _loc3_;
            this._boneTransform.skewY = this._transform.skewY * _loc3_;
            this._boneTransform.scaleX = (this._transform.scaleX - 1) * _loc3_ + 1;
            this._boneTransform.scaleY = (this._transform.scaleY - 1) * _loc3_ + 1;
            this.bone.dragonBones_internal::_updateState = 1;
         }
         else if(this.bone.dragonBones_internal::_blendLeftWeight > 0)
         {
            if(this.bone.dragonBones_internal::_blendLayer !== _loc2_)
            {
               if(this.bone.dragonBones_internal::_blendTotalWeight >= this.bone.dragonBones_internal::_blendLeftWeight)
               {
                  this.bone.dragonBones_internal::_blendLeftWeight = 0;
               }
               else
               {
                  this.bone.dragonBones_internal::_blendLayer = _loc2_;
                  this.bone.dragonBones_internal::_blendLeftWeight -= this.bone.dragonBones_internal::_blendTotalWeight;
                  this.bone.dragonBones_internal::_blendTotalWeight = 0;
               }
            }
            _loc3_ *= this.bone.dragonBones_internal::_blendLeftWeight;
            if(_loc3_ >= 0)
            {
               super.update(param1);
               this.bone.dragonBones_internal::_blendTotalWeight += _loc3_;
               this._boneTransform.x += this._transform.x * _loc3_;
               this._boneTransform.y += this._transform.y * _loc3_;
               this._boneTransform.skewX += this._transform.skewX * _loc3_;
               this._boneTransform.skewY += this._transform.skewY * _loc3_;
               this._boneTransform.scaleX += (this._transform.scaleX - 1) * _loc3_;
               this._boneTransform.scaleY += (this._transform.scaleY - 1) * _loc3_;
               ++this.bone.dragonBones_internal::_updateState;
            }
         }
         if(this.bone.dragonBones_internal::_updateState > 0)
         {
            if(this._transformDirty || _animationState._fadeState !== 0 || _animationState._subFadeState !== 0)
            {
               this._transformDirty = false;
               this.bone.invalidUpdate();
            }
         }
      }
   }
}

