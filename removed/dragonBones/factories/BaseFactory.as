package dragonBones.factories
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.DisplayType;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.BoneData;
   import dragonBones.objects.DisplayData;
   import dragonBones.objects.DragonBonesData;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SkinSlotData;
   import dragonBones.objects.SlotData;
   import dragonBones.parsers.DataParser;
   import dragonBones.parsers.ObjectDataParser;
   import dragonBones.textures.TextureAtlasData;
   import dragonBones.textures.TextureData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   use namespace dragonBones_internal;
   
   public class BaseFactory extends EventDispatcher
   {
      
      protected static const _defaultDataParser:DataParser = new ObjectDataParser();
      
      public var autoSearch:Boolean = false;
      
      protected const _dragonBonesDataMap:Object = {};
      
      protected const _textureAtlasDataMap:Object = {};
      
      protected var _dataParser:DataParser = null;
      
      public var smoothing:Boolean = true;
      
      public var scaleForTexture:Number = 0;
      
      private var _delayID:uint = 0;
      
      private const _decodeDataList:Vector.<DecodedData> = new Vector.<DecodedData>();
      
      public function BaseFactory(param1:BaseFactory, param2:DataParser = null)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
         this._dataParser = param2 || _defaultDataParser;
      }
      
      protected function _getTextureData(param1:String, param2:String) : TextureData
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TextureData = null;
         var _loc7_:TextureAtlasData = null;
         var _loc3_:Vector.<TextureAtlasData> = this._textureAtlasDataMap[param1];
         if(_loc3_)
         {
            _loc4_ = 0;
            _loc5_ = _loc3_.length;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc3_[_loc4_].getTexture(param2);
               if(_loc6_)
               {
                  return _loc6_;
               }
               _loc4_++;
            }
         }
         if(this.autoSearch)
         {
            for each(_loc3_ in this._textureAtlasDataMap)
            {
               _loc4_ = 0;
               _loc5_ = _loc3_.length;
               while(_loc4_ < _loc5_)
               {
                  _loc7_ = _loc3_[_loc4_];
                  if(_loc7_.autoSearch)
                  {
                     _loc6_ = _loc7_.getTexture(param2);
                     if(_loc6_)
                     {
                        return _loc6_;
                     }
                  }
                  _loc4_++;
               }
            }
         }
         return null;
      }
      
      protected function _fillBuildArmaturePackage(param1:BuildArmaturePackage, param2:String, param3:String, param4:String, param5:String) : Boolean
      {
         var _loc8_:String = null;
         var _loc6_:DragonBonesData = null;
         var _loc7_:ArmatureData = null;
         if(param2)
         {
            _loc6_ = this._dragonBonesDataMap[param2];
            if(_loc6_)
            {
               _loc7_ = _loc6_.getArmature(param3);
            }
         }
         if(!_loc7_ && (!param2 || this.autoSearch))
         {
            for(_loc8_ in this._dragonBonesDataMap)
            {
               _loc6_ = this._dragonBonesDataMap[_loc8_];
               if(!param2 || _loc6_.autoSearch)
               {
                  _loc7_ = _loc6_.getArmature(param3);
                  if(_loc7_)
                  {
                     param2 = _loc8_;
                     break;
                  }
               }
            }
         }
         if(_loc7_)
         {
            param1.dataName = param2;
            param1.textureAtlasName = param5;
            param1.data = _loc6_;
            param1.armature = _loc7_;
            param1.skin = _loc7_.getSkin(param4);
            if(!param1.skin)
            {
               param1.skin = _loc7_.defaultSkin;
            }
            return true;
         }
         return false;
      }
      
      protected function _buildBones(param1:BuildArmaturePackage, param2:Armature) : void
      {
         var _loc6_:BoneData = null;
         var _loc7_:Bone = null;
         var _loc3_:Vector.<BoneData> = param1.armature.sortedBones;
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            _loc7_ = BaseObject.borrowObject(Bone) as Bone;
            _loc7_.dragonBones_internal::_init(_loc6_);
            if(_loc6_.parent)
            {
               param2.dragonBones_internal::_addBone(_loc7_,_loc6_.parent.name);
            }
            else
            {
               param2.dragonBones_internal::_addBone(_loc7_);
            }
            if(_loc6_.ik)
            {
               _loc7_.ikBendPositive = _loc6_.bendPositive;
               _loc7_.ikWeight = _loc6_.weight;
               _loc7_.dragonBones_internal::_setIK(param2.getBone(_loc6_.ik.name),_loc6_.chain,_loc6_.chainIndex);
            }
            _loc4_++;
         }
      }
      
      protected function _buildSlots(param1:BuildArmaturePackage, param2:Armature) : void
      {
         var _loc6_:SkinSlotData = null;
         var _loc10_:SlotData = null;
         var _loc11_:Slot = null;
         var _loc3_:SkinData = param1.skin;
         var _loc4_:SkinData = param1.armature.defaultSkin;
         var _loc5_:Object = {};
         for each(_loc6_ in _loc4_.slots)
         {
            _loc5_[_loc6_.slot.name] = _loc6_;
         }
         if(_loc3_ != _loc4_)
         {
            for each(_loc6_ in _loc3_.slots)
            {
               _loc5_[_loc6_.slot.name] = _loc6_;
            }
         }
         var _loc7_:Vector.<SlotData> = param1.armature.sortedSlots;
         var _loc8_:uint = 0;
         var _loc9_:uint = _loc7_.length;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = _loc7_[_loc8_];
            _loc6_ = _loc5_[_loc10_.name];
            if(_loc6_)
            {
               _loc11_ = this._generateSlot(param1,_loc6_,param2);
               if(_loc11_)
               {
                  param2.dragonBones_internal::_addSlot(_loc11_,_loc10_.parent.name);
                  _loc11_.dragonBones_internal::_setDisplayIndex(_loc10_.displayIndex);
               }
            }
            _loc8_++;
         }
      }
      
      protected function _replaceSlotDisplay(param1:BuildArmaturePackage, param2:DisplayData, param3:Slot, param4:int) : void
      {
         var _loc5_:Vector.<Object> = null;
         var _loc6_:Armature = null;
         var _loc7_:Vector.<DisplayData> = null;
         if(param4 < 0)
         {
            param4 = param3.displayIndex;
         }
         if(param4 >= 0)
         {
            _loc5_ = param3.displayList;
            if(_loc5_.length <= param4)
            {
               _loc5_.length = param4 + 1;
            }
            if(param3.dragonBones_internal::_replacedDisplayDatas.length <= param4)
            {
               param3.dragonBones_internal::_replacedDisplayDatas.length = param4 + 1;
            }
            param3.dragonBones_internal::_replacedDisplayDatas[param4] = param2;
            if(param2.type === DisplayType.Armature)
            {
               _loc6_ = this.buildArmature(param2.path,param1.dataName,null,param1.textureAtlasName);
               _loc5_[param4] = _loc6_;
            }
            else
            {
               if(!param2.texture || Boolean(param1.textureAtlasName))
               {
                  param2.texture = this._getTextureData(param1.textureAtlasName ? param1.textureAtlasName : param1.dataName,param2.path);
               }
               _loc7_ = param3.skinSlotData.displays;
               if(Boolean(param2.mesh) || param4 < _loc7_.length && _loc7_[param4].mesh)
               {
                  _loc5_[param4] = param3.meshDisplay;
               }
               else
               {
                  _loc5_[param4] = param3.rawDisplay;
               }
            }
            param3.displayList = _loc5_;
         }
      }
      
      protected function _generateTextureAtlasData(param1:TextureAtlasData, param2:Object) : TextureAtlasData
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      protected function _generateArmature(param1:BuildArmaturePackage) : Armature
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      protected function _generateSlot(param1:BuildArmaturePackage, param2:SkinSlotData, param3:Armature) : Slot
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      public function parseDragonBonesData(param1:Object, param2:String = null, param3:Number = 1) : DragonBonesData
      {
         var _loc6_:DecodedData = null;
         var _loc4_:Boolean = true;
         if(param1 is ByteArray)
         {
            _loc6_ = DecodedData.decode(param1 as ByteArray);
            if(!_loc6_)
            {
               return null;
            }
            this._decodeDataList.push(_loc6_);
            _loc6_.name = param2 || "";
            _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,this._loadTextureAtlasHandler);
            _loc6_.loadBytes(_loc6_.textureAtlasBytes,null);
            param1 = _loc6_.dragonBonesData;
            _loc4_ = false;
         }
         var _loc5_:DragonBonesData = this._dataParser.parseDragonBonesData(param1,param3);
         this.addDragonBonesData(_loc5_,param2);
         if(_loc4_)
         {
            clearTimeout(this._delayID);
            this._delayID = setTimeout(dispatchEvent,30,new Event(Event.COMPLETE));
         }
         return _loc5_;
      }
      
      public function parseTextureAtlasData(param1:Object, param2:Object, param3:String = null, param4:Number = 0, param5:Number = 0) : TextureAtlasData
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Matrix = null;
         var _loc6_:TextureAtlasData = this._generateTextureAtlasData(null,null);
         this._dataParser.parseTextureAtlasData(param1,_loc6_,param4,param5);
         if(param2 is Bitmap)
         {
            param2 = (param2 as Bitmap).bitmapData;
         }
         else if(param2 is DisplayObject)
         {
            _loc7_ = param2 as DisplayObject;
            _loc8_ = _loc7_.getRect(_loc7_);
            _loc9_ = new Matrix();
            _loc9_.scale(_loc6_.scale,_loc6_.scale);
            _loc6_.bitmapData = new BitmapData((_loc8_.x + _loc7_.width) * _loc6_.scale,(_loc8_.y + _loc7_.height) * _loc6_.scale,true,0);
            _loc6_.bitmapData.draw(_loc7_,_loc9_,null,null,null,this.smoothing);
            param2 = _loc6_.bitmapData;
         }
         this._generateTextureAtlasData(_loc6_,param2);
         this.addTextureAtlasData(_loc6_,param3);
         return _loc6_;
      }
      
      public function getDragonBonesData(param1:String) : DragonBonesData
      {
         return this._dragonBonesDataMap[param1] as DragonBonesData;
      }
      
      public function addDragonBonesData(param1:DragonBonesData, param2:String = null) : void
      {
         if(param1)
         {
            param2 ||= param1.name;
            if(param2)
            {
               if(!this._dragonBonesDataMap[param2])
               {
                  this._dragonBonesDataMap[param2] = param1;
                  return;
               }
               throw new Error("Same name data.");
            }
            throw new Error("Unnamed data.");
         }
         throw new ArgumentError();
      }
      
      public function removeDragonBonesData(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:DragonBonesData = this._dragonBonesDataMap[param1];
         if(_loc3_)
         {
            if(param2)
            {
               _loc3_.returnToPool();
            }
            delete this._dragonBonesDataMap[param1];
         }
      }
      
      public function getTextureAtlasData(param1:String) : Vector.<TextureAtlasData>
      {
         return this._textureAtlasDataMap[param1] as Vector.<TextureAtlasData>;
      }
      
      public function addTextureAtlasData(param1:TextureAtlasData, param2:String = null) : void
      {
         var _loc3_:Vector.<TextureAtlasData> = null;
         if(param1)
         {
            param2 ||= param1.name;
            if(param2)
            {
               _loc3_ = this._textureAtlasDataMap[param2] = this._textureAtlasDataMap[param2] || new Vector.<TextureAtlasData>();
               if(_loc3_.indexOf(param1) < 0)
               {
                  _loc3_.push(param1);
               }
               return;
            }
            throw new Error("Unnamed data.");
         }
         throw new ArgumentError();
      }
      
      public function removeTextureAtlasData(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:TextureAtlasData = null;
         var _loc3_:Vector.<TextureAtlasData> = this._textureAtlasDataMap[param1] as Vector.<TextureAtlasData>;
         if(_loc3_)
         {
            if(param2)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc4_.returnToPool();
               }
            }
            delete this._textureAtlasDataMap[param1];
         }
      }
      
      public function clear(param1:Boolean = true) : void
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<TextureAtlasData> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for(_loc2_ in this._dragonBonesDataMap)
         {
            if(param1)
            {
               (this._dragonBonesDataMap[_loc2_] as DragonBonesData).returnToPool();
            }
            delete this._dragonBonesDataMap[_loc2_];
         }
         for(_loc2_ in this._textureAtlasDataMap)
         {
            if(param1)
            {
               _loc3_ = this._textureAtlasDataMap[_loc2_];
               _loc4_ = 0;
               _loc5_ = _loc3_.length;
               while(_loc4_ < _loc5_)
               {
                  _loc3_[_loc4_].returnToPool();
                  _loc4_++;
               }
            }
            delete this._textureAtlasDataMap[_loc2_];
         }
      }
      
      public function buildArmature(param1:String, param2:String = null, param3:String = null, param4:String = null) : Armature
      {
         var _loc6_:Armature = null;
         var _loc5_:BuildArmaturePackage = new BuildArmaturePackage();
         if(this._fillBuildArmaturePackage(_loc5_,param2,param1,param3,param4))
         {
            _loc6_ = this._generateArmature(_loc5_);
            this._buildBones(_loc5_,_loc6_);
            this._buildSlots(_loc5_,_loc6_);
            _loc6_.invalidUpdate(null,true);
            _loc6_.advanceTime(0);
            return _loc6_;
         }
         return null;
      }
      
      public function copyAnimationsToArmature(param1:Armature, param2:String, param3:String = null, param4:String = null, param5:Boolean = true) : Boolean
      {
         var _loc7_:ArmatureData = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Vector.<Slot> = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Slot = null;
         var _loc14_:Vector.<Object> = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Object = null;
         var _loc18_:Vector.<DisplayData> = null;
         var _loc19_:DisplayData = null;
         var _loc6_:BuildArmaturePackage = new BuildArmaturePackage();
         if(this._fillBuildArmaturePackage(_loc6_,param4,param2,param3,null))
         {
            _loc7_ = _loc6_.armature;
            if(param5)
            {
               param1.animation.animations = _loc7_.animations;
            }
            else
            {
               _loc8_ = {};
               _loc9_ = null;
               for(_loc9_ in param1.animation.animations)
               {
                  _loc8_[_loc9_] = param1.animation.animations[_loc9_];
               }
               for(_loc9_ in _loc7_.animations)
               {
                  _loc8_[_loc9_] = _loc7_.animations[_loc9_];
               }
               param1.animation.animations = _loc8_;
            }
            if(_loc6_.skin)
            {
               _loc10_ = param1.getSlots();
               _loc11_ = 0;
               _loc12_ = _loc10_.length;
               while(_loc11_ < _loc12_)
               {
                  _loc13_ = _loc10_[_loc11_];
                  _loc14_ = _loc13_.displayList;
                  _loc15_ = 0;
                  _loc16_ = _loc14_.length;
                  while(_loc15_ < _loc16_)
                  {
                     _loc17_ = _loc14_[_loc15_];
                     if(_loc17_ is Armature)
                     {
                        _loc18_ = _loc6_.skin.getSlot(_loc13_.name).displays;
                        if(_loc15_ < _loc18_.length)
                        {
                           _loc19_ = _loc18_[_loc15_];
                           if(_loc19_.type == DisplayType.Armature)
                           {
                              this.copyAnimationsToArmature(_loc17_ as Armature,_loc19_.path,param3,param4,param5);
                           }
                        }
                     }
                     _loc15_++;
                  }
                  _loc11_++;
               }
               return true;
            }
         }
         return false;
      }
      
      public function replaceSlotDisplay(param1:String, param2:String, param3:String, param4:String, param5:Slot, param6:int = -1) : void
      {
         var _loc8_:SkinSlotData = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:DisplayData = null;
         var _loc7_:BuildArmaturePackage = new BuildArmaturePackage();
         if(this._fillBuildArmaturePackage(_loc7_,param1,param2,null,null))
         {
            _loc8_ = _loc7_.skin.getSlot(param3);
            if(_loc8_)
            {
               _loc9_ = 0;
               _loc10_ = _loc8_.displays.length;
               while(_loc9_ < _loc10_)
               {
                  _loc11_ = _loc8_.displays[_loc9_];
                  if(_loc11_.name === param4)
                  {
                     this._replaceSlotDisplay(_loc7_,_loc11_,param5,param6);
                     break;
                  }
                  _loc9_++;
               }
            }
         }
      }
      
      public function replaceSlotDisplayList(param1:String, param2:String, param3:String, param4:Slot) : void
      {
         var _loc6_:SkinSlotData = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:DisplayData = null;
         var _loc5_:BuildArmaturePackage = new BuildArmaturePackage();
         if(this._fillBuildArmaturePackage(_loc5_,param1,param2,null,null))
         {
            _loc6_ = _loc5_.skin.getSlot(param3);
            if(_loc6_)
            {
               _loc7_ = 0;
               _loc8_ = _loc6_.displays.length;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc6_.displays[_loc7_];
                  this._replaceSlotDisplay(_loc5_,_loc9_,param4,_loc7_);
                  _loc7_++;
               }
            }
         }
      }
      
      public function get allDragonBonesData() : Object
      {
         return this._dragonBonesDataMap;
      }
      
      public function get allTextureAtlasData() : Object
      {
         return this._textureAtlasDataMap;
      }
      
      private function _loadTextureAtlasHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         _loc2_ = param1.target as LoaderInfo;
         var _loc3_:DecodedData = _loc2_.loader as DecodedData;
         _loc2_.removeEventListener(Event.COMPLETE,this._loadTextureAtlasHandler);
         this.parseTextureAtlasData(_loc3_.textureAtlasData,_loc3_.content,_loc3_.name,this.scaleForTexture || 0,1);
         _loc3_.dispose();
         this._decodeDataList.splice(this._decodeDataList.indexOf(_loc3_),1);
         if(this._decodeDataList.length == 0)
         {
            dispatchEvent(param1);
         }
      }
   }
}

