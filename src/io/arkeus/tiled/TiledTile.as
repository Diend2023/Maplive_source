package io.arkeus.tiled
{
   public class TiledTile
   {
      
      public static const TOP_LEFT:uint = 1;
      
      public static const TOP_RIGHT:uint = 16;
      
      public static const BOTTOM_LEFT:uint = 256;
      
      public static const BOTTOM_RIGHT:uint = 4096;
      
      public static const TOP:uint = TOP_LEFT | TOP_RIGHT;
      
      public static const LEFT:uint = BOTTOM_LEFT | TOP_LEFT;
      
      public static const RIGHT:uint = TOP_RIGHT | BOTTOM_RIGHT;
      
      public static const BOTTOM:uint = BOTTOM_LEFT | BOTTOM_RIGHT;
      
      private static const CORNER_MAP:Vector.<uint> = new <uint>[TOP_LEFT,TOP_RIGHT,BOTTOM_LEFT,BOTTOM_RIGHT];
      
      public var id:uint;
      
      public var rawTerrain:String;
      
      public var terrain:uint;
      
      public var probability:Number;
      
      public var properties:TiledProperties;
      
      public var image:TiledImage;
      
      public function TiledTile(param1:XML)
      {
         super();
         this.id = param1.@id;
         this.rawTerrain = param1.@terrain;
         this.terrain = csvToTerrain(param1.@terrain);
         this.probability = "@probability" in param1 ? Number(param1.@probability) : Number.NaN;
         this.properties = new TiledProperties(param1.properties);
         this.image = new TiledImage(param1.image);
      }
      
      private static function csvToTerrain(param1:String) : uint
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].length > 0)
            {
               _loc3_ += 1 << _loc4_;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}

