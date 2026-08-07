package io.arkeus.tiled
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import io.arkeus.tiled.base64.Base64;
   
   public class TiledUtils
   {
      
      public function TiledUtils()
      {
         super();
      }
      
      public static function colorStringToUint(param1:String) : uint
      {
         return uint("0x" + param1.replace("#",""));
      }
      
      public static function stringToTileData(param1:String, param2:uint, param3:String, param4:String) : Array
      {
         return byteArrayToMapData(decompressByteArray(decodeString(param1,param3),param4),param2);
      }
      
      private static function decodeString(param1:String, param2:String) : ByteArray
      {
         switch(param2)
         {
            case "csv":
               return stringToByteArray(param1);
            case "base64":
               return Base64.decode(param1);
            default:
               throw new Error("Unsupported encoding: " + param2);
         }
      }
      
      private static function decompressByteArray(param1:ByteArray, param2:String) : ByteArray
      {
         switch(param2)
         {
            case "gzip":
               throw new Error("gzip is unsupported, change Tiled preferences to use zlib");
            case "zlib":
               param1.uncompress();
               param1.endian = Endian.LITTLE_ENDIAN;
               return param1;
            case null:
               return param1;
            default:
               throw new Error("Unsupported compression: " + param2);
         }
      }
      
      private static function stringToByteArray(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return _loc2_;
      }
      
      private static function byteArrayToMapData(param1:ByteArray, param2:uint) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         param1.position = 0;
         while(param1.position < param1.length)
         {
            if(_loc4_.length == param2)
            {
               _loc3_.push(_loc4_);
               _loc4_ = [];
            }
            _loc4_.push(param1.readInt());
         }
         _loc3_.push(_loc4_);
         return _loc3_;
      }
   }
}

