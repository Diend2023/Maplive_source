package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.ArmatureType;
   import dragonBones.geom.Transform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ArmatureData extends BaseObject
   {
      
      public var frameRate:uint;
      
      public var type:int;
      
      public var cacheFrameRate:uint;
      
      public var scale:Number;
      
      public var name:String;
      
      public const aabb:Rectangle = new Rectangle();
      
      public const bones:Object = {};
      
      public const slots:Object = {};
      
      public const skins:Object = {};
      
      public const animations:Object = {};
      
      public const actions:Vector.<ActionData> = new Vector.<ActionData>();
      
      public var parent:DragonBonesData;
      
      public var userData:CustomData;
      
      private var _boneDirty:Boolean;
      
      private var _slotDirty:Boolean;
      
      private const _animationNames:Vector.<String> = new Vector.<String>();
      
      private const _sortedBones:Vector.<BoneData> = new Vector.<BoneData>();
      
      private const _sortedSlots:Vector.<SlotData> = new Vector.<SlotData>();
      
      private const _bonesChildren:Object = {};
      
      private var _defaultSkin:SkinData;
      
      private var _defaultAnimation:AnimationData;
      
      public function ArmatureData()
      {
         super(this);
      }
      
      private static function _onSortSlots(param1:SlotData, param2:SlotData) : int
      {
         return param1.zOrder > param2.zOrder ? 1 : -1;
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         for(_loc1_ in this.bones)
         {
            (this.bones[_loc1_] as BoneData).returnToPool();
            delete this.bones[_loc1_];
         }
         for(_loc1_ in this.slots)
         {
            (this.slots[_loc1_] as SlotData).returnToPool();
            delete this.slots[_loc1_];
         }
         for(_loc1_ in this.skins)
         {
            (this.skins[_loc1_] as SkinData).returnToPool();
            delete this.skins[_loc1_];
         }
         for(_loc1_ in this.animations)
         {
            (this.animations[_loc1_] as AnimationData).returnToPool();
            delete this.animations[_loc1_];
         }
         _loc2_ = 0;
         _loc3_ = this.actions.length;
         while(_loc2_ < _loc3_)
         {
            this.actions[_loc2_].returnToPool();
            _loc2_++;
         }
         for(_loc1_ in this._bonesChildren)
         {
            delete this._bonesChildren[_loc1_];
         }
         if(this.userData)
         {
            this.userData.returnToPool();
         }
         this.frameRate = 0;
         this.type = ArmatureType.None;
         this.cacheFrameRate = 0;
         this.scale = 1;
         this.name = null;
         this.aabb.x = 0;
         this.aabb.y = 0;
         this.aabb.width = 0;
         this.aabb.height = 0;
         this.actions.length = 0;
         this.parent = null;
         this.userData = null;
         this._boneDirty = false;
         this._slotDirty = false;
         this._animationNames.length = 0;
         this._sortedBones.length = 0;
         this._sortedSlots.length = 0;
         this._defaultSkin = null;
         this._defaultAnimation = null;
      }
      
      private function _sortBones() : void
      {
         var _loc5_:BoneData = null;
         var _loc1_:uint = this._sortedBones.length;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Vector.<BoneData> = this._sortedBones.concat();
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this._sortedBones.length = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = _loc2_[_loc3_++];
            if(_loc3_ >= _loc1_)
            {
               _loc3_ = 0;
            }
            if(this._sortedBones.indexOf(_loc5_) < 0)
            {
               if(!(Boolean(_loc5_.parent) && this._sortedBones.indexOf(_loc5_.parent) < 0))
               {
                  if(!(Boolean(_loc5_.ik) && this._sortedBones.indexOf(_loc5_.ik) < 0))
                  {
                     if(_loc5_.ik && _loc5_.chain > 0 && _loc5_.chainIndex == _loc5_.chain)
                     {
                        this._sortedBones.splice(this._sortedBones.indexOf(_loc5_.parent) + 1,0,_loc5_);
                     }
                     else
                     {
                        this._sortedBones.push(_loc5_);
                     }
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      private function _sortSlots() : void
      {
         this._sortedSlots.sort(_onSortSlots);
      }
      
      public function cacheFrames(param1:uint) : void
      {
         var _loc2_:AnimationData = null;
         if(this.cacheFrameRate > 0)
         {
            return;
         }
         this.cacheFrameRate = this.frameRate;
         for each(_loc2_ in this.animations)
         {
            _loc2_.cacheFrames(this.cacheFrameRate);
         }
      }
      
      public function setCacheFrame(param1:Matrix, param2:Transform) : Number
      {
         var _loc3_:Vector.<Number> = null;
         _loc3_ = this.parent.cachedFrames;
         var _loc4_:uint = _loc3_.length;
         _loc3_.length += 10;
         _loc3_[_loc4_] = param1.a;
         _loc3_[_loc4_ + 1] = param1.b;
         _loc3_[_loc4_ + 2] = param1.c;
         _loc3_[_loc4_ + 3] = param1.d;
         _loc3_[_loc4_ + 4] = param1.tx;
         _loc3_[_loc4_ + 5] = param1.ty;
         _loc3_[_loc4_ + 6] = param2.skewX;
         _loc3_[_loc4_ + 7] = param2.skewY;
         _loc3_[_loc4_ + 8] = param2.scaleX;
         _loc3_[_loc4_ + 9] = param2.scaleY;
         return _loc4_;
      }
      
      public function getCacheFrame(param1:Matrix, param2:Transform, param3:Number) : void
      {
         var _loc4_:Vector.<Number> = null;
         _loc4_ = this.parent.cachedFrames;
         param1.a = _loc4_[param3];
         param1.b = _loc4_[param3 + 1];
         param1.c = _loc4_[param3 + 2];
         param1.d = _loc4_[param3 + 3];
         param1.tx = _loc4_[param3 + 4];
         param1.ty = _loc4_[param3 + 5];
         param2.skewX = _loc4_[param3 + 6];
         param2.skewY = _loc4_[param3 + 7];
         param2.scaleX = _loc4_[param3 + 8];
         param2.scaleY = _loc4_[param3 + 9];
      }
      
      public function addBone(param1:BoneData, param2:String) : void
      {
         var _loc3_:Vector.<BoneData> = null;
         var _loc4_:BoneData = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 && param1.name && !this.bones[param1.name])
         {
            if(param2)
            {
               _loc4_ = this.getBone(param2);
               if(_loc4_)
               {
                  param1.parent = _loc4_;
               }
               else
               {
                  (this._bonesChildren[param2] = this._bonesChildren[param2] || new Vector.<BoneData>()).push(param1);
               }
            }
            _loc3_ = this._bonesChildren[param1.name];
            if(_loc3_)
            {
               _loc5_ = 0;
               _loc6_ = _loc3_.length;
               while(_loc5_ < _loc6_)
               {
                  _loc3_[_loc5_].parent = param1;
                  _loc5_++;
               }
               delete this._bonesChildren[param1.name];
            }
            this.bones[param1.name] = param1;
            this._sortedBones.push(param1);
            this._boneDirty = true;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addSlot(param1:SlotData) : void
      {
         if(param1 && param1.name && !this.slots[param1.name])
         {
            this.slots[param1.name] = param1;
            this._sortedSlots.push(param1);
            this._slotDirty = true;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addSkin(param1:SkinData) : void
      {
         if(param1 && param1.name && !this.skins[param1.name])
         {
            this.skins[param1.name] = param1;
            if(!this._defaultSkin)
            {
               this._defaultSkin = param1;
            }
            return;
         }
         throw new ArgumentError();
      }
      
      public function addAnimation(param1:AnimationData) : void
      {
         if(param1 && param1.name && !this.animations[param1.name])
         {
            this.animations[param1.name] = param1;
            this._animationNames.push(param1.name);
            if(!this._defaultAnimation)
            {
               this._defaultAnimation = param1;
            }
            return;
         }
         throw new ArgumentError();
      }
      
      public function getBone(param1:String) : BoneData
      {
         return this.bones[param1] as BoneData;
      }
      
      public function getSlot(param1:String) : SlotData
      {
         return this.slots[param1] as SlotData;
      }
      
      public function getSkin(param1:String) : SkinData
      {
         return param1 ? this.skins[param1] as SkinData : this._defaultSkin;
      }
      
      public function getAnimation(param1:String) : AnimationData
      {
         return param1 ? this.animations[param1] as AnimationData : this._defaultAnimation;
      }
      
      public function get animationNames() : Vector.<String>
      {
         return this._animationNames;
      }
      
      public function get sortedBones() : Vector.<BoneData>
      {
         if(this._boneDirty)
         {
            this._boneDirty = false;
            this._sortBones();
         }
         return this._sortedBones;
      }
      
      public function get sortedSlots() : Vector.<SlotData>
      {
         if(this._slotDirty)
         {
            this._slotDirty = false;
            this._sortSlots();
         }
         return this._sortedSlots;
      }
      
      public function get defaultSkin() : SkinData
      {
         return this._defaultSkin;
      }
      
      public function get defaultAnimation() : AnimationData
      {
         return this._defaultAnimation;
      }
   }
}

