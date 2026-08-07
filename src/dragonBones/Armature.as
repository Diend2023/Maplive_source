package dragonBones
{
   import dragonBones.animation.Animation;
   import dragonBones.animation.IAnimateble;
   import dragonBones.animation.WorldClock;
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import dragonBones.core.IArmatureProxy;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.ActionType;
   import dragonBones.events.EventObject;
   import dragonBones.events.IEventDispatcher;
   import dragonBones.objects.ActionData;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SlotData;
   import dragonBones.textures.TextureAtlasData;
   import flash.geom.Point;
   
   use namespace dragonBones_internal;
   
   public final class Armature extends BaseObject implements IAnimateble
   {
      
      public var inheritAnimation:Boolean;
      
      public var debugDraw:Boolean;
      
      public var userData:Object;
      
      private var _debugDraw:Boolean;
      
      private var _delayDispose:Boolean;
      
      private var _lockDispose:Boolean;
      
      dragonBones_internal var _bonesDirty:Boolean;
      
      private var _slotsDirty:Boolean;
      
      private var _zOrderDirty:Boolean;
      
      private const _bones:Vector.<Bone> = new Vector.<Bone>();
      
      private const _slots:Vector.<Slot> = new Vector.<Slot>();
      
      private const _actions:Vector.<ActionData> = new Vector.<ActionData>();
      
      private const _events:Vector.<EventObject> = new Vector.<EventObject>();
      
      dragonBones_internal var _armatureData:ArmatureData;
      
      dragonBones_internal var _skinData:SkinData;
      
      private var _animation:Animation;
      
      private var _proxy:IArmatureProxy;
      
      private var _display:Object;
      
      private var _eventManager:IEventDispatcher;
      
      dragonBones_internal var _parent:Slot;
      
      private var _clock:WorldClock;
      
      dragonBones_internal var _replaceTextureAtlasData:TextureAtlasData;
      
      private var _replacedTexture:Object;
      
      public function Armature()
      {
         super(this);
      }
      
      private static function _onSortSlots(param1:Slot, param2:Slot) : int
      {
         return param1.dragonBones_internal::_zOrder > param2.dragonBones_internal::_zOrder ? 1 : -1;
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this._bones.length;
         while(_loc1_ < _loc2_)
         {
            this._bones[_loc1_].returnToPool();
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = this._slots.length;
         while(_loc1_ < _loc2_)
         {
            this._slots[_loc1_].returnToPool();
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = this._events.length;
         while(_loc1_ < _loc2_)
         {
            this._events[_loc1_].returnToPool();
            _loc1_++;
         }
         if(this._clock)
         {
            this._clock.remove(this);
         }
         if(this._proxy)
         {
            this._proxy._onClear();
         }
         if(this.dragonBones_internal::_replaceTextureAtlasData)
         {
            this.dragonBones_internal::_replaceTextureAtlasData.returnToPool();
         }
         if(this._animation)
         {
            this._animation.returnToPool();
         }
         this.inheritAnimation = true;
         this.debugDraw = false;
         this.userData = null;
         this._debugDraw = false;
         this._delayDispose = false;
         this._lockDispose = false;
         this.dragonBones_internal::_bonesDirty = false;
         this._slotsDirty = false;
         this._zOrderDirty = false;
         this._bones.fixed = false;
         this._bones.length = 0;
         this._slots.fixed = false;
         this._slots.length = 0;
         this._actions.length = 0;
         this._events.length = 0;
         this.dragonBones_internal::_armatureData = null;
         this.dragonBones_internal::_skinData = null;
         this._animation = null;
         this._proxy = null;
         this._display = null;
         this._eventManager = null;
         this.dragonBones_internal::_parent = null;
         this._clock = null;
         this.dragonBones_internal::_replaceTextureAtlasData = null;
         this._replacedTexture = null;
      }
      
      private function _sortBones() : void
      {
         var _loc5_:Bone = null;
         var _loc1_:uint = this._bones.length;
         if(_loc1_ <= 0)
         {
            return;
         }
         var _loc2_:Vector.<Bone> = this._bones.concat();
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this._bones.length = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = _loc2_[_loc3_++];
            if(_loc3_ >= _loc1_)
            {
               _loc3_ = 0;
            }
            if(this._bones.indexOf(_loc5_) < 0)
            {
               if(!(Boolean(_loc5_.parent) && this._bones.indexOf(_loc5_.parent) < 0))
               {
                  if(!(Boolean(_loc5_.ik) && this._bones.indexOf(_loc5_.ik) < 0))
                  {
                     if(_loc5_.ik && _loc5_.ikChain > 0 && _loc5_.ikChainIndex === _loc5_.ikChain)
                     {
                        this._bones.splice(this._bones.indexOf(_loc5_.parent) + 1,0,_loc5_);
                     }
                     else
                     {
                        this._bones.push(_loc5_);
                     }
                     _loc4_++;
                  }
               }
            }
         }
      }
      
      private function _sortSlots() : void
      {
         this._slots.sort(_onSortSlots);
      }
      
      private function _doAction(param1:ActionData) : void
      {
         switch(param1.type)
         {
            case ActionType.Play:
               this._animation.playConfig(param1.animationConfig);
         }
      }
      
      public function _init(param1:ArmatureData, param2:SkinData, param3:Object, param4:IArmatureProxy, param5:IEventDispatcher) : void
      {
         if(this.dragonBones_internal::_armatureData)
         {
            return;
         }
         this.dragonBones_internal::_armatureData = param1;
         this.dragonBones_internal::_skinData = param2;
         this._animation = BaseObject.borrowObject(Animation) as Animation;
         this._proxy = param4;
         this._display = param3;
         this._eventManager = param5;
         this._animation._init(this);
         this._animation.animations = this.dragonBones_internal::_armatureData.animations;
      }
      
      dragonBones_internal function _addBoneToBoneList(param1:Bone) : void
      {
         if(this._bones.indexOf(param1) < 0)
         {
            this._bones.fixed = false;
            this.dragonBones_internal::_bonesDirty = true;
            this._bones.push(param1);
            this._animation.dragonBones_internal::_timelineStateDirty = true;
         }
      }
      
      dragonBones_internal function _removeBoneFromBoneList(param1:Bone) : void
      {
         var _loc2_:int = int(this._bones.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this._bones.fixed = false;
            this._bones.splice(_loc2_,1);
            this._animation.dragonBones_internal::_timelineStateDirty = true;
            this._bones.fixed = true;
         }
      }
      
      dragonBones_internal function _addSlotToSlotList(param1:Slot) : void
      {
         if(this._slots.indexOf(param1) < 0)
         {
            this._slots.fixed = false;
            this._slotsDirty = true;
            this._slots.push(param1);
            this._animation.dragonBones_internal::_timelineStateDirty = true;
         }
      }
      
      dragonBones_internal function _removeSlotFromSlotList(param1:Slot) : void
      {
         var _loc2_:int = int(this._slots.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this._slots.fixed = false;
            this._slots.splice(_loc2_,1);
            this._animation.dragonBones_internal::_timelineStateDirty = true;
            this._slots.fixed = true;
         }
      }
      
      dragonBones_internal function _sortZOrder(param1:Vector.<int>) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:SlotData = null;
         var _loc8_:Slot = null;
         var _loc2_:Vector.<SlotData> = this.dragonBones_internal::_armatureData.sortedSlots;
         var _loc3_:Boolean = !param1 || param1.length < 1;
         if(this._zOrderDirty || !_loc3_)
         {
            _loc4_ = 0;
            _loc5_ = _loc2_.length;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc3_ ? int(_loc4_) : param1[_loc4_];
               _loc7_ = _loc2_[_loc6_];
               if(_loc7_)
               {
                  _loc8_ = this.getSlot(_loc7_.name);
                  if(_loc8_)
                  {
                     _loc8_.dragonBones_internal::_setZorder(_loc4_);
                  }
               }
               _loc4_++;
            }
            this._slotsDirty = true;
            this._zOrderDirty = !_loc3_;
         }
      }
      
      dragonBones_internal function _bufferAction(param1:ActionData) : void
      {
         this._actions.push(param1);
      }
      
      dragonBones_internal function _bufferEvent(param1:EventObject, param2:String) : void
      {
         param1.type = param2;
         param1.armature = this;
         this._events.push(param1);
      }
      
      public function dispose() : void
      {
         this._delayDispose = true;
         if(!this._lockDispose && Boolean(this.dragonBones_internal::_armatureData))
         {
            returnToPool();
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc7_:EventObject = null;
         var _loc8_:ActionData = null;
         var _loc9_:Slot = null;
         var _loc10_:Armature = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         if(!this.dragonBones_internal::_armatureData)
         {
            throw new Error("The armature has been disposed.");
         }
         if(!this.dragonBones_internal::_armatureData.parent)
         {
            throw new Error("The armature data has been disposed.");
         }
         if(this.dragonBones_internal::_bonesDirty)
         {
            this.dragonBones_internal::_bonesDirty = false;
            this._sortBones();
            this._bones.fixed = true;
         }
         if(this._slotsDirty)
         {
            this._slotsDirty = false;
            this._sortSlots();
            this._slots.fixed = true;
         }
         var _loc2_:int = this._animation.dragonBones_internal::_cacheFrameIndex;
         this._animation.dragonBones_internal::_advanceTime(param1);
         var _loc3_:int = this._animation.dragonBones_internal::_cacheFrameIndex;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(_loc3_ < 0 || _loc3_ !== _loc2_)
         {
            _loc4_ = 0;
            _loc5_ = this._bones.length;
            while(_loc4_ < _loc5_)
            {
               this._bones[_loc4_].dragonBones_internal::_update(_loc3_);
               _loc4_++;
            }
            _loc4_ = 0;
            _loc5_ = this._slots.length;
            while(_loc4_ < _loc5_)
            {
               this._slots[_loc4_].dragonBones_internal::_update(_loc3_);
               _loc4_++;
            }
         }
         var _loc6_:Boolean = this.debugDraw || DragonBones.debugDraw;
         if((_loc6_) || this._debugDraw)
         {
            this._debugDraw = _loc6_;
            this._proxy._debugDraw(this._debugDraw);
         }
         if(!this._lockDispose)
         {
            this._lockDispose = true;
            _loc5_ = this._events.length;
            if(_loc5_ > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc7_ = this._events[_loc4_];
                  this._proxy._dispatchEvent(_loc7_.type,_loc7_);
                  if(_loc7_.type === EventObject.SOUND_EVENT)
                  {
                     this._eventManager._dispatchEvent(_loc7_.type,_loc7_);
                  }
                  _loc7_.returnToPool();
                  _loc4_++;
               }
               this._events.length = 0;
            }
            _loc5_ = this._actions.length;
            if(_loc5_ > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc8_ = this._actions[_loc4_];
                  if(_loc8_.slot)
                  {
                     _loc9_ = this.getSlot(_loc8_.slot.name);
                     if(_loc9_)
                     {
                        _loc10_ = _loc9_.childArmature;
                        if(_loc10_)
                        {
                           _loc10_._doAction(_loc8_);
                        }
                     }
                  }
                  else if(_loc8_.bone)
                  {
                     _loc11_ = 0;
                     _loc12_ = this._slots.length;
                     while(_loc11_ < _loc12_)
                     {
                        _loc10_ = this._slots[_loc11_].childArmature;
                        if(_loc10_)
                        {
                           _loc10_._doAction(_loc8_);
                        }
                        _loc11_++;
                     }
                  }
                  else
                  {
                     this._doAction(_loc8_);
                  }
                  _loc4_++;
               }
               this._actions.length = 0;
            }
            this._lockDispose = false;
         }
         if(this._delayDispose)
         {
            returnToPool();
         }
      }
      
      public function invalidUpdate(param1:String = null, param2:Boolean = false) : void
      {
         var _loc3_:Bone = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Slot = null;
         if(param1)
         {
            _loc3_ = this.getBone(param1);
            if(_loc3_)
            {
               _loc3_.invalidUpdate();
               if(param2)
               {
                  _loc4_ = 0;
                  _loc5_ = this._slots.length;
                  while(_loc4_ < _loc5_)
                  {
                     _loc6_ = this._slots[_loc4_];
                     if(_loc6_.parent === _loc3_)
                     {
                        _loc6_.invalidUpdate();
                     }
                     _loc4_++;
                  }
               }
            }
         }
         else
         {
            _loc4_ = 0;
            _loc5_ = this._bones.length;
            while(_loc4_ < _loc5_)
            {
               this._bones[_loc4_].invalidUpdate();
               _loc4_++;
            }
            if(param2)
            {
               _loc4_ = 0;
               _loc5_ = this._slots.length;
               while(_loc4_ < _loc5_)
               {
                  this._slots[_loc4_].invalidUpdate();
                  _loc4_++;
               }
            }
         }
      }
      
      public function containsPoint(param1:Number, param2:Number) : Slot
      {
         var _loc5_:Slot = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = this._slots.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this._slots[_loc3_];
            if(_loc5_.containsPoint(param1,param2))
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function intersectsSegment(param1:Number, param2:Number, param3:Number, param4:Number, param5:Point = null, param6:Point = null, param7:Point = null) : Slot
      {
         var _loc21_:Slot = null;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc8_:* = param1 === param3;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Slot = null;
         var _loc18_:Slot = null;
         var _loc19_:uint = 0;
         var _loc20_:uint = this._slots.length;
         while(_loc19_ < _loc20_)
         {
            _loc21_ = this._slots[_loc19_];
            _loc22_ = _loc21_.intersectsSegment(param1,param2,param3,param4,param5,param6,param7);
            if(_loc22_ > 0)
            {
               if(!(Boolean(param5) || Boolean(param6)))
               {
                  _loc17_ = _loc21_;
                  break;
               }
               if(param5)
               {
                  _loc23_ = _loc8_ ? param5.y - param2 : param5.x - param1;
                  if(_loc23_ < 0)
                  {
                     _loc23_ = -_loc23_;
                  }
                  if(!_loc17_ || _loc23_ < _loc9_)
                  {
                     _loc9_ = _loc23_;
                     _loc11_ = param5.x;
                     _loc12_ = param5.y;
                     _loc17_ = _loc21_;
                     if(param7)
                     {
                        _loc15_ = param7.x;
                     }
                  }
               }
               if(param6)
               {
                  _loc23_ = param6.x - param1;
                  if(_loc23_ < 0)
                  {
                     _loc23_ = -_loc23_;
                  }
                  if(!_loc18_ || _loc23_ > _loc10_)
                  {
                     _loc10_ = _loc23_;
                     _loc13_ = param6.x;
                     _loc14_ = param6.y;
                     _loc18_ = _loc21_;
                     if(param7)
                     {
                        _loc16_ = param7.y;
                     }
                  }
               }
            }
            _loc19_++;
         }
         if(Boolean(_loc17_) && Boolean(param5))
         {
            param5.x = _loc11_;
            param5.y = _loc12_;
            if(param7)
            {
               param7.x = _loc15_;
            }
         }
         if(Boolean(_loc18_) && Boolean(param6))
         {
            param6.x = _loc13_;
            param6.y = _loc14_;
            if(param7)
            {
               param7.y = _loc16_;
            }
         }
         return _loc17_;
      }
      
      public function getBone(param1:String) : Bone
      {
         var _loc4_:Bone = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._bones.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._bones[_loc2_];
            if(_loc4_.name === param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getBoneByDisplay(param1:Object) : Bone
      {
         var _loc2_:Slot = this.getSlotByDisplay(param1);
         return _loc2_ ? _loc2_.parent : null;
      }
      
      public function getSlot(param1:String) : Slot
      {
         var _loc4_:Slot = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._slots.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._slots[_loc2_];
            if(_loc4_.name === param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getSlotByDisplay(param1:Object) : Slot
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Slot = null;
         if(param1)
         {
            _loc2_ = 0;
            _loc3_ = this._slots.length;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this._slots[_loc2_];
               if(_loc4_.display == param1)
               {
                  return _loc4_;
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      dragonBones_internal function _addBone(param1:Bone, param2:String = null) : void
      {
         if(param1)
         {
            param1.dragonBones_internal::_setArmature(this);
            param1.dragonBones_internal::_setParent(param2 ? this.getBone(param2) : null);
         }
      }
      
      dragonBones_internal function _addSlot(param1:Slot, param2:String) : void
      {
         var _loc3_:Bone = this.getBone(param2);
         if(_loc3_)
         {
            param1.dragonBones_internal::_setArmature(this);
            param1.dragonBones_internal::_setParent(_loc3_);
         }
      }
      
      public function replaceTexture(param1:Object) : void
      {
         this.replacedTexture = param1;
      }
      
      public function getBones() : Vector.<Bone>
      {
         return this._bones;
      }
      
      public function getSlots() : Vector.<Slot>
      {
         return this._slots;
      }
      
      public function get name() : String
      {
         return this.dragonBones_internal::_armatureData ? this.dragonBones_internal::_armatureData.name : null;
      }
      
      public function get armatureData() : ArmatureData
      {
         return this.dragonBones_internal::_armatureData;
      }
      
      public function get animation() : Animation
      {
         return this._animation;
      }
      
      public function get eventDispatcher() : IEventDispatcher
      {
         return this._proxy;
      }
      
      public function get display() : Object
      {
         return this._display;
      }
      
      public function get parent() : Slot
      {
         return this.dragonBones_internal::_parent;
      }
      
      public function get cacheFrameRate() : uint
      {
         return this.dragonBones_internal::_armatureData.cacheFrameRate;
      }
      
      public function set cacheFrameRate(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Armature = null;
         if(this.dragonBones_internal::_armatureData.cacheFrameRate !== param1)
         {
            this.dragonBones_internal::_armatureData.cacheFrames(param1);
            _loc2_ = 0;
            _loc3_ = this._slots.length;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this._slots[_loc2_].childArmature;
               if(_loc4_)
               {
                  _loc4_.cacheFrameRate = param1;
               }
               _loc2_++;
            }
         }
      }
      
      public function get clock() : WorldClock
      {
         return this._clock;
      }
      
      public function set clock(param1:WorldClock) : void
      {
         var _loc5_:Armature = null;
         if(this._clock === param1)
         {
            return;
         }
         var _loc2_:WorldClock = this._clock;
         this._clock = param1;
         if(_loc2_)
         {
            _loc2_.remove(this);
         }
         if(this._clock)
         {
            this._clock.add(this);
         }
         var _loc3_:uint = 0;
         var _loc4_:uint = this._slots.length;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this._slots[_loc3_].childArmature;
            if(_loc5_)
            {
               _loc5_.clock = this._clock;
            }
            _loc3_++;
         }
      }
      
      public function get replacedTexture() : Object
      {
         return this._replacedTexture;
      }
      
      public function set replacedTexture(param1:Object) : void
      {
         var _loc4_:Slot = null;
         if(this._replacedTexture === param1)
         {
            return;
         }
         if(this.dragonBones_internal::_replaceTextureAtlasData)
         {
            this.dragonBones_internal::_replaceTextureAtlasData.returnToPool();
            this.dragonBones_internal::_replaceTextureAtlasData = null;
         }
         this._replacedTexture = param1;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._slots.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._slots[_loc2_];
            _loc4_.invalidUpdate();
            _loc4_.dragonBones_internal::_update(-1);
            _loc2_++;
         }
      }
      
      public function hasEventListener(param1:String) : void
      {
         this._display.hasEvent(param1);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this._display.addEvent(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this._display.removeEvent(param1,param2);
      }
   }
}

