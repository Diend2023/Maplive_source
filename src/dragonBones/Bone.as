package dragonBones
{
   import dragonBones.core.TransformObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.geom.Transform;
   import dragonBones.objects.BoneData;
   import flash.geom.Matrix;
   
   use namespace dragonBones_internal;
   
   public final class Bone extends TransformObject
   {
      
      public var inheritTranslation:Boolean;
      
      public var inheritRotation:Boolean;
      
      public var inheritScale:Boolean;
      
      public var ikBendPositive:Boolean;
      
      public var length:Number;
      
      public var ikWeight:Number;
      
      dragonBones_internal var _transformDirty:int;
      
      private var _visible:Boolean;
      
      private var _cachedFrameIndex:int;
      
      private var _ikChain:uint;
      
      private var _ikChainIndex:int;
      
      dragonBones_internal var _updateState:int;
      
      dragonBones_internal var _blendLayer:int;
      
      dragonBones_internal var _blendLeftWeight:Number;
      
      dragonBones_internal var _blendTotalWeight:Number;
      
      dragonBones_internal const _animationPose:Transform = new Transform();
      
      private const _bones:Vector.<Bone> = new Vector.<Bone>();
      
      private const _slots:Vector.<Slot> = new Vector.<Slot>();
      
      private var _boneData:BoneData;
      
      private var _ik:Bone;
      
      dragonBones_internal var _cachedFrameIndices:Vector.<int>;
      
      public function Bone()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.inheritTranslation = false;
         this.inheritRotation = false;
         this.inheritScale = false;
         this.ikBendPositive = false;
         this.length = 0;
         this.ikWeight = 0;
         this.dragonBones_internal::_transformDirty = 0;
         this._visible = true;
         this._cachedFrameIndex = -1;
         this._ikChain = 0;
         this._ikChainIndex = 0;
         this.dragonBones_internal::_updateState = -1;
         this.dragonBones_internal::_blendLayer = 0;
         this.dragonBones_internal::_blendLeftWeight = 1;
         this.dragonBones_internal::_blendTotalWeight = 0;
         this.dragonBones_internal::_animationPose.identity();
         this._bones.length = 0;
         this._slots.length = 0;
         this._boneData = null;
         this._ik = null;
         this.dragonBones_internal::_cachedFrameIndices = null;
      }
      
      private function _updateGlobalTransformMatrix() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Matrix = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         global.x = origin.x + offset.x + this.dragonBones_internal::_animationPose.x;
         global.y = origin.y + offset.y + this.dragonBones_internal::_animationPose.y;
         global.skewX = origin.skewX + offset.skewX + this.dragonBones_internal::_animationPose.skewX;
         global.skewY = origin.skewY + offset.skewY + this.dragonBones_internal::_animationPose.skewY;
         global.scaleX = origin.scaleX * offset.scaleX * this.dragonBones_internal::_animationPose.scaleX;
         global.scaleY = origin.scaleY * offset.scaleY * this.dragonBones_internal::_animationPose.scaleY;
         if(dragonBones_internal::_parent)
         {
            _loc1_ = Number(dragonBones_internal::_parent.global.skewY);
            _loc2_ = dragonBones_internal::_parent.globalTransformMatrix;
            if(this.inheritScale)
            {
               if(!this.inheritRotation)
               {
                  global.skewX -= _loc1_;
                  global.skewY -= _loc1_;
               }
               global.toMatrix(globalTransformMatrix);
               globalTransformMatrix.concat(_loc2_);
               if(!this.inheritTranslation)
               {
                  globalTransformMatrix.tx = global.x;
                  globalTransformMatrix.ty = global.y;
               }
               global.fromMatrix(globalTransformMatrix);
            }
            else
            {
               if(this.inheritTranslation)
               {
                  _loc3_ = global.x;
                  _loc4_ = global.y;
                  global.x = _loc2_.a * _loc3_ + _loc2_.c * _loc4_ + _loc2_.tx;
                  global.y = _loc2_.d * _loc4_ + _loc2_.b * _loc3_ + _loc2_.ty;
               }
               if(this.inheritRotation)
               {
                  global.skewX += _loc1_;
                  global.skewY += _loc1_;
               }
               global.toMatrix(globalTransformMatrix);
            }
         }
         else
         {
            global.toMatrix(globalTransformMatrix);
         }
         if(this._ik && this._ikChainIndex == this._ikChain && this.ikWeight > 0)
         {
            if(this.inheritTranslation && this._ikChain > 0 && Boolean(dragonBones_internal::_parent))
            {
               this._computeIKB();
            }
            else
            {
               this._computeIKA();
            }
         }
      }
      
      private function _computeIKA() : void
      {
         var _loc1_:Transform = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc1_ = this._ik.global;
         _loc2_ = globalTransformMatrix.a * this.length;
         _loc3_ = globalTransformMatrix.b * this.length;
         var _loc4_:Number = (Math.atan2(_loc1_.y - global.y,_loc1_.x - global.x) + offset.skewY - global.skewY * 2 + Math.atan2(_loc3_,_loc2_)) * this.ikWeight;
         global.skewX += _loc4_;
         global.skewY += _loc4_;
         global.toMatrix(globalTransformMatrix);
      }
      
      private function _computeIKB() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc1_:Transform = dragonBones_internal::_parent.global;
         var _loc2_:Transform = this._ik.global;
         _loc3_ = globalTransformMatrix.a * this.length;
         _loc4_ = globalTransformMatrix.b * this.length;
         _loc5_ = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         var _loc6_:Number = Math.sqrt(_loc5_);
         _loc7_ = global.x - _loc1_.x;
         _loc8_ = global.y - _loc1_.y;
         _loc9_ = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc10_:Number = Math.sqrt(_loc9_);
         _loc7_ = _loc2_.x - _loc1_.x;
         _loc8_ = _loc2_.y - _loc1_.y;
         _loc11_ = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc12_:Number = Math.sqrt(_loc11_);
         var _loc13_:Number = 0;
         if(_loc6_ + _loc10_ <= _loc12_ || _loc12_ + _loc6_ <= _loc10_ || _loc12_ + _loc10_ <= _loc6_)
         {
            _loc13_ = Math.atan2(_loc2_.y - _loc1_.y,_loc2_.x - _loc1_.x) + dragonBones_internal::_parent.offset.skewY;
            if(_loc6_ + _loc10_ > _loc12_)
            {
               if(_loc10_ < _loc6_)
               {
                  _loc13_ += Math.PI;
               }
            }
         }
         else
         {
            _loc15_ = (_loc9_ - _loc5_ + _loc11_) / (2 * _loc11_);
            _loc16_ = Math.sqrt(_loc9_ - _loc15_ * _loc15_ * _loc11_) / _loc12_;
            _loc17_ = _loc1_.x + _loc7_ * _loc15_;
            _loc18_ = _loc1_.y + _loc8_ * _loc15_;
            _loc19_ = -_loc8_ * _loc16_;
            _loc20_ = _loc7_ * _loc16_;
            if(this.ikBendPositive)
            {
               global.x = _loc17_ - _loc19_;
               global.y = _loc18_ - _loc20_;
            }
            else
            {
               global.x = _loc17_ + _loc19_;
               global.y = _loc18_ + _loc20_;
            }
            _loc13_ = Math.atan2(global.y - _loc1_.y,global.x - _loc1_.x) + dragonBones_internal::_parent.offset.skewY;
         }
         _loc13_ = (_loc13_ - _loc1_.skewY) * this.ikWeight;
         _loc1_.skewX += _loc13_;
         _loc1_.skewY += _loc13_;
         _loc1_.toMatrix(dragonBones_internal::_parent.globalTransformMatrix);
         dragonBones_internal::_parent.dragonBones_internal::_transformDirty = 1;
         global.x = _loc1_.x + Math.cos(_loc1_.skewY) * _loc10_;
         global.y = _loc1_.y + Math.sin(_loc1_.skewY) * _loc10_;
         var _loc14_:Number = (Math.atan2(_loc2_.y - global.y,_loc2_.x - global.x) + offset.skewY - global.skewY * 2 + Math.atan2(_loc4_,_loc3_)) * this.ikWeight;
         global.skewX += _loc14_;
         global.skewY += _loc14_;
         global.toMatrix(globalTransformMatrix);
      }
      
      dragonBones_internal function _init(param1:BoneData) : void
      {
         if(this._boneData)
         {
            return;
         }
         this._boneData = param1;
         this.inheritTranslation = this._boneData.inheritTranslation;
         this.inheritRotation = this._boneData.inheritRotation;
         this.inheritScale = this._boneData.inheritScale;
         this.length = this._boneData.length;
         name = this._boneData.name;
         origin = this._boneData.transform;
      }
      
      override dragonBones_internal function _setArmature(param1:Armature) : void
      {
         dragonBones_internal::_armature = param1;
         dragonBones_internal::_armature.dragonBones_internal::_addBoneToBoneList(this);
      }
      
      dragonBones_internal function _setIK(param1:Bone, param2:uint, param3:uint) : void
      {
         var _loc4_:Bone = null;
         var _loc5_:Bone = null;
         if(param1)
         {
            if(param2 == param3)
            {
               _loc4_ = dragonBones_internal::_parent;
               if(Boolean(param2) && Boolean(_loc4_))
               {
                  param2 = 1;
               }
               else
               {
                  param2 = 0;
                  param3 = 0;
                  _loc4_ = this;
               }
               if(_loc4_ == param1 || _loc4_.contains(param1))
               {
                  param1 = null;
                  param2 = 0;
                  param3 = 0;
               }
               else
               {
                  _loc5_ = param1;
                  while(Boolean(_loc5_.ik) && Boolean(_loc5_.ikChain))
                  {
                     if(_loc4_.contains(_loc5_.ik))
                     {
                        param1 = null;
                        param2 = 0;
                        param3 = 0;
                        break;
                     }
                     _loc5_ = _loc5_.parent;
                  }
               }
            }
         }
         else
         {
            param2 = 0;
            param3 = 0;
         }
         this._ik = param1;
         this._ikChain = param2;
         this._ikChainIndex = param3;
         if(dragonBones_internal::_armature)
         {
            dragonBones_internal::_armature.dragonBones_internal::_bonesDirty = true;
         }
      }
      
      dragonBones_internal function _update(param1:int) : void
      {
         var _loc2_:int = 0;
         this.dragonBones_internal::_updateState = -1;
         if(param1 >= 0 && Boolean(this.dragonBones_internal::_cachedFrameIndices))
         {
            _loc2_ = this.dragonBones_internal::_cachedFrameIndices[param1];
            if(_loc2_ >= 0 && this._cachedFrameIndex === _loc2_)
            {
               this.dragonBones_internal::_transformDirty = 0;
            }
            else if(_loc2_ >= 0)
            {
               this.dragonBones_internal::_transformDirty = 2;
               this._cachedFrameIndex = _loc2_;
            }
            else if(this.dragonBones_internal::_transformDirty === 2 || dragonBones_internal::_parent && dragonBones_internal::_parent.dragonBones_internal::_transformDirty !== 0 || this._ik && this.ikWeight > 0 && this._ik.dragonBones_internal::_transformDirty !== 0)
            {
               this.dragonBones_internal::_transformDirty = 2;
               this._cachedFrameIndex = -1;
            }
            else if(this._cachedFrameIndex >= 0)
            {
               this.dragonBones_internal::_transformDirty = 0;
               this.dragonBones_internal::_cachedFrameIndices[param1] = this._cachedFrameIndex;
            }
            else
            {
               this.dragonBones_internal::_transformDirty = 2;
               this._cachedFrameIndex = -1;
            }
         }
         else if(this.dragonBones_internal::_transformDirty === 2 || dragonBones_internal::_parent && dragonBones_internal::_parent.dragonBones_internal::_transformDirty !== 0 || this._ik && this.ikWeight > 0 && this._ik.dragonBones_internal::_transformDirty !== 0)
         {
            param1 = -1;
            this.dragonBones_internal::_transformDirty = 2;
            this._cachedFrameIndex = -1;
         }
         if(this.dragonBones_internal::_transformDirty !== 0)
         {
            if(this.dragonBones_internal::_transformDirty === 2)
            {
               this.dragonBones_internal::_transformDirty = 1;
               if(this._cachedFrameIndex < 0)
               {
                  this._updateGlobalTransformMatrix();
                  if(param1 >= 0)
                  {
                     this._cachedFrameIndex = this.dragonBones_internal::_cachedFrameIndices[param1] = dragonBones_internal::_armature.dragonBones_internal::_armatureData.setCacheFrame(globalTransformMatrix,global);
                  }
               }
               else
               {
                  dragonBones_internal::_armature.dragonBones_internal::_armatureData.getCacheFrame(globalTransformMatrix,global,this._cachedFrameIndex);
               }
               this.dragonBones_internal::_updateState = 0;
            }
            else
            {
               this.dragonBones_internal::_transformDirty = 0;
            }
         }
      }
      
      public function invalidUpdate() : void
      {
         this.dragonBones_internal::_transformDirty = 2;
      }
      
      public function contains(param1:TransformObject) : Boolean
      {
         var _loc2_:TransformObject = null;
         if(param1)
         {
            if(param1 === this)
            {
               return false;
            }
            _loc2_ = param1;
            while(_loc2_ != this && Boolean(_loc2_))
            {
               _loc2_ = _loc2_.parent;
            }
            return _loc2_ === this;
         }
         return false;
      }
      
      public function getBones() : Vector.<Bone>
      {
         var _loc4_:Bone = null;
         this._bones.length = 0;
         var _loc1_:Vector.<Bone> = dragonBones_internal::_armature.getBones();
         var _loc2_:uint = 0;
         var _loc3_:uint = _loc1_.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_[_loc2_];
            if(_loc4_.parent === this)
            {
               this._bones.push(_loc4_);
            }
            _loc2_++;
         }
         return this._bones;
      }
      
      public function getSlots() : Vector.<Slot>
      {
         var _loc4_:Slot = null;
         this._slots.length = 0;
         var _loc1_:Vector.<Slot> = dragonBones_internal::_armature.getSlots();
         var _loc2_:uint = 0;
         var _loc3_:uint = _loc1_.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc1_[_loc2_];
            if(_loc4_.parent === this)
            {
               this._slots.push(_loc4_);
            }
            _loc2_++;
         }
         return this._slots;
      }
      
      public function get boneData() : BoneData
      {
         return this._boneData;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc5_:Slot = null;
         if(this._visible == param1)
         {
            return;
         }
         this._visible = param1;
         var _loc2_:Vector.<Slot> = dragonBones_internal::_armature.getSlots();
         var _loc3_:uint = 0;
         var _loc4_:uint = _loc2_.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_[_loc3_];
            if(_loc5_.dragonBones_internal::_parent == this)
            {
               _loc5_.dragonBones_internal::_updateVisible();
            }
            _loc3_++;
         }
      }
      
      public function get ikChain() : uint
      {
         return this._ikChain;
      }
      
      public function get ikChainIndex() : int
      {
         return this._ikChainIndex;
      }
      
      public function get ik() : Bone
      {
         return this._ik;
      }
   }
}

