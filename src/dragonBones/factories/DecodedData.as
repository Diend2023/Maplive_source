package dragonBones.factories
{
   import flash.display.Loader;
   import flash.system.System;
   import flash.utils.ByteArray;
   
   public final class DecodedData extends Loader
   {
      
      public static const JPG:int = 1;
      
      public static const PNG:int = 2;
      
      public static const ATF:int = 3;
      
      public static const SWF:int = 4;
      
      public static const ZIP:int = 5;
      
      public static const DBDA:int = 6;
      
      public var textureAtlasFormat:uint = 0;
      
      public var dragonBonesData:Object = null;
      
      public var textureAtlasData:Object = null;
      
      public var textureAtlasBytes:ByteArray = null;
      
      public function DecodedData()
      {
         super();
      }
      
      public static function getFormat(param1:ByteArray) : int
      {
         var _loc2_:int = 0;
         var _loc3_:uint = uint(param1[0]);
         var _loc4_:uint = uint(param1[1]);
         var _loc5_:uint = uint(param1[2]);
         var _loc6_:uint = uint(param1[3]);
         if((_loc3_ == 70 || _loc3_ == 67 || _loc3_ == 90) && _loc4_ == 87 && _loc5_ == 83)
         {
            _loc2_ = SWF;
         }
         else if(_loc3_ == 137 && _loc4_ == 80 && _loc5_ == 78 && _loc6_ == 71)
         {
            _loc2_ = PNG;
         }
         else if(_loc3_ == 255)
         {
            _loc2_ = JPG;
         }
         else if(_loc3_ == 65 && _loc4_ == 84 && _loc5_ == 70)
         {
            _loc2_ = ATF;
         }
         else if(_loc3_ == 80 && _loc4_ == 75)
         {
            _loc2_ = ZIP;
         }
         else if(_loc3_ == 68 && _loc4_ == 66 && _loc5_ == 68)
         {
            if(_loc6_ == 1)
            {
               _loc2_ = DBDA;
            }
         }
         return _loc2_;
      }
      
      public static function encode(param1:Object, param2:Object, param3:ByteArray) : ByteArray
      {
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:ByteArray = new ByteArray();
         _loc5_.writeByte(68);
         _loc5_.writeByte(66);
         _loc5_.writeByte(68);
         _loc5_.writeByte(1);
         _loc5_.writeByte(0);
         _loc5_.writeByte(0);
         _loc5_.writeByte(0);
         _loc5_.writeByte(0);
         _loc6_.writeObject(param1);
         _loc5_.writeInt(_loc6_.length);
         _loc5_.writeBytes(_loc6_);
         _loc6_.length = 0;
         _loc6_.writeObject(param2);
         _loc5_.writeInt(_loc6_.length);
         _loc5_.writeBytes(_loc6_);
         _loc4_.writeBytes(param3);
         _loc4_.writeBytes(_loc5_);
         _loc4_.writeInt(_loc5_.length);
         _loc5_.clear();
         _loc6_.clear();
         return _loc4_;
      }
      
      public static function decode(param1:ByteArray) : DecodedData
      {
         var decodedBytes:ByteArray = null;
         var decodedData:DecodedData = null;
         var helpBytes:ByteArray = null;
         var dataSize:int = 0;
         var position:uint = 0;
         var inputBytes:ByteArray = param1;
         var intSize:uint = 4;
         var format:int = getFormat(inputBytes);
         switch(format)
         {
            case SWF:
            case PNG:
            case JPG:
            case ATF:
               try
               {
                  decodedBytes = new ByteArray();
                  decodedData = new DecodedData();
                  helpBytes = new ByteArray();
                  decodedBytes.writeBytes(inputBytes);
                  decodedBytes.position = decodedBytes.length - intSize;
                  dataSize = decodedBytes.readInt();
                  position = uint(decodedBytes.length - intSize - dataSize);
                  helpBytes.writeBytes(decodedBytes,position,dataSize);
                  if(getFormat(helpBytes) == DBDA)
                  {
                     decodedBytes.position = position + 8;
                     dataSize = decodedBytes.readInt();
                     helpBytes.length = 0;
                     helpBytes.writeBytes(decodedBytes,position + 8 + intSize,dataSize);
                     helpBytes.position = 0;
                     decodedData.dragonBonesData = helpBytes.readObject();
                     position = uint(position + 8 + intSize + dataSize);
                     decodedBytes.position = position;
                     dataSize = decodedBytes.readInt();
                     helpBytes.length = 0;
                     helpBytes.writeBytes(decodedBytes,position + intSize,dataSize);
                     helpBytes.position = 0;
                     decodedData.textureAtlasData = helpBytes.readObject();
                     decodedBytes.position = decodedBytes.length - intSize;
                     decodedBytes.length = decodedBytes.length - decodedBytes.readInt() - intSize;
                  }
                  else
                  {
                     helpBytes.uncompress();
                     helpBytes.position = 0;
                     decodedData.dragonBonesData = helpBytes.readObject();
                     decodedBytes.length = position;
                     decodedBytes.position = decodedBytes.length - intSize;
                     dataSize = decodedBytes.readInt();
                     position = uint(decodedBytes.length - intSize - dataSize);
                     helpBytes.length = 0;
                     helpBytes.writeBytes(decodedBytes,position,dataSize);
                     helpBytes.uncompress();
                     helpBytes.position = 0;
                     decodedData.textureAtlasData = helpBytes.readObject();
                     decodedBytes.length = position;
                  }
                  helpBytes.clear();
                  decodedData.textureAtlasFormat = format;
                  decodedData.textureAtlasBytes = decodedBytes;
                  return decodedData;
               }
               catch(e:Error)
               {
                  throw new Error("Data error!");
               }
               break;
            default:
               throw new Error("Nonsupport data!");
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.dragonBonesData) && this.dragonBonesData is XML)
         {
            System.disposeXML(this.dragonBonesData as XML);
         }
         if(Boolean(this.textureAtlasData) && this.textureAtlasData is XML)
         {
            System.disposeXML(this.textureAtlasData as XML);
         }
         if(this.textureAtlasBytes)
         {
            this.textureAtlasBytes.clear();
         }
         this.dragonBonesData = null;
         this.textureAtlasData = null;
         this.textureAtlasBytes = null;
      }
   }
}

