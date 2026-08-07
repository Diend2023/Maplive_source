package dragonBones.flash
{
   import dragonBones.Armature;
   import dragonBones.Slot;
   import dragonBones.animation.WorldClock;
   import dragonBones.core.BaseObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.DisplayType;
   import dragonBones.factories.BaseFactory;
   import dragonBones.factories.BuildArmaturePackage;
   import dragonBones.objects.ActionData;
   import dragonBones.objects.DisplayData;
   import dragonBones.objects.SkinSlotData;
   import dragonBones.objects.SlotData;
   import dragonBones.parsers.DataParser;
   import dragonBones.textures.TextureAtlasData;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.utils.getTimer;
   
   use namespace dragonBones_internal;
   
   public class FlashFactory extends BaseFactory
   {
      
      protected static const _eventManager:FlashArmatureDisplay = new FlashArmatureDisplay();
      
      dragonBones_internal static const _clock:WorldClock = new WorldClock();
      
      public static const factory:FlashFactory = new FlashFactory();
      
      public function FlashFactory(param1:DataParser = null)
      {
         super(this,param1);
      }
      
      protected static function _clockHandler(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = getTimer() * 0.001;
         var _loc3_:Number = _loc2_ - dragonBones_internal::_clock.time;
         dragonBones_internal::_clock.advanceTime(_loc3_);
         dragonBones_internal::_clock.time = _loc2_;
      }
      
      override protected function _generateTextureAtlasData(param1:TextureAtlasData, param2:Object) : TextureAtlasData
      {
         if(param1)
         {
            if(param2 is BitmapData)
            {
               (param1 as FlashTextureAtlasData).texture = param2 as BitmapData;
            }
         }
         else
         {
            param1 = BaseObject.borrowObject(FlashTextureAtlasData) as FlashTextureAtlasData;
         }
         return param1;
      }
      
      override protected function _generateArmature(param1:BuildArmaturePackage) : Armature
      {
         if(!_eventManager.hasEventListener(Event.ENTER_FRAME))
         {
            dragonBones_internal::_clock.time = getTimer() * 0.001;
            _eventManager.addEventListener(Event.ENTER_FRAME,_clockHandler,false,-999999);
         }
         var _loc2_:Armature = BaseObject.borrowObject(Armature) as Armature;
         var _loc3_:FlashArmatureDisplay = new FlashArmatureDisplay();
         _loc3_.dragonBones_internal::_armature = _loc2_;
         _loc2_._init(param1.armature,param1.skin,_loc3_,_loc3_,_eventManager);
         return _loc2_;
      }
      
      override protected function _generateSlot(param1:BuildArmaturePackage, param2:SkinSlotData, param3:Armature) : Slot
      {
         var _loc10_:DisplayData = null;
         var _loc11_:Armature = null;
         var _loc12_:Vector.<ActionData> = null;
         var _loc13_:ActionData = null;
         var _loc4_:FlashSlot = BaseObject.borrowObject(FlashSlot) as FlashSlot;
         var _loc5_:SlotData = param2.slot;
         var _loc6_:Vector.<Object> = new Vector.<Object>(param2.displays.length,true);
         var _loc7_:Shape = new Shape();
         _loc4_.dragonBones_internal::_init(param2,_loc7_,_loc7_);
         var _loc8_:uint = 0;
         var _loc9_:uint = param2.displays.length;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = param2.displays[_loc8_];
            switch(_loc10_.type)
            {
               case DisplayType.Image:
                  if(!_loc10_.texture)
                  {
                     _loc10_.texture = _getTextureData(param1.dataName,_loc10_.path);
                  }
                  if(param1.textureAtlasName)
                  {
                     _loc4_.dragonBones_internal::_textureDatas[_loc8_] = _getTextureData(param1.textureAtlasName,_loc10_.path);
                  }
                  _loc6_[_loc8_] = _loc4_.rawDisplay;
                  break;
               case DisplayType.Mesh:
                  if(!_loc10_.texture)
                  {
                     _loc10_.texture = _getTextureData(param1.dataName,_loc10_.path);
                  }
                  if(param1.textureAtlasName)
                  {
                     _loc4_.dragonBones_internal::_textureDatas[_loc8_] = _getTextureData(param1.textureAtlasName,_loc10_.path);
                  }
                  _loc6_[_loc8_] = _loc4_.meshDisplay;
                  break;
               case DisplayType.Armature:
                  _loc11_ = buildArmature(_loc10_.path,param1.dataName,null,param1.textureAtlasName);
                  if(_loc11_)
                  {
                     if(!_loc11_.inheritAnimation)
                     {
                        _loc12_ = _loc5_.actions.length > 0 ? _loc5_.actions : _loc11_.armatureData.actions;
                        if(_loc12_.length > 0)
                        {
                           for each(_loc13_ in _loc12_)
                           {
                              _loc11_.dragonBones_internal::_bufferAction(_loc13_);
                           }
                        }
                        else
                        {
                           _loc11_.animation.play();
                        }
                     }
                     _loc10_.armature = _loc11_.armatureData;
                  }
                  _loc6_[_loc8_] = _loc11_;
                  break;
               default:
                  _loc6_[_loc8_] = null;
            }
            _loc8_++;
         }
         _loc4_.dragonBones_internal::_setDisplayList(_loc6_);
         return _loc4_;
      }
      
      public function buildArmatureDisplay(param1:String, param2:String = null, param3:String = null, param4:String = null) : FlashArmatureDisplay
      {
         var _loc5_:Armature = buildArmature(param1,param2,param3,param4);
         if(_loc5_)
         {
            dragonBones_internal::_clock.add(_loc5_);
            return _loc5_.display as FlashArmatureDisplay;
         }
         return null;
      }
      
      public function getTextureDisplay(param1:String, param2:String = null) : Shape
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Matrix = null;
         var _loc8_:Shape = null;
         var _loc3_:FlashTextureData = _getTextureData(param2,param1) as FlashTextureData;
         if(_loc3_)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            if(_loc3_.rotated)
            {
               _loc4_ = _loc3_.region.height;
               _loc5_ = _loc3_.region.width;
            }
            else
            {
               _loc5_ = _loc3_.region.height;
               _loc4_ = _loc3_.region.width;
            }
            _loc6_ = 1 / _loc3_.parent.scale;
            _loc7_ = new Matrix();
            if(_loc3_.rotated)
            {
               _loc7_.a = 0;
               _loc7_.b = -_loc6_;
               _loc7_.c = _loc6_;
               _loc7_.d = 0;
               _loc7_.tx = -_loc3_.region.y;
               _loc7_.ty = _loc3_.region.x + _loc5_;
            }
            else
            {
               _loc7_.a = _loc6_;
               _loc7_.b = 0;
               _loc7_.c = 0;
               _loc7_.d = _loc6_;
               _loc7_.tx = -_loc3_.region.x;
               _loc7_.ty = -_loc3_.region.y;
            }
            _loc8_ = new Shape();
            _loc8_.graphics.beginBitmapFill((_loc3_.parent as FlashTextureAtlasData).texture,_loc7_,false,true);
            _loc8_.graphics.drawRect(0,0,_loc4_,_loc5_);
            return _loc8_;
         }
         return null;
      }
      
      public function get soundEventManager() : FlashArmatureDisplay
      {
         return _eventManager;
      }
   }
}

