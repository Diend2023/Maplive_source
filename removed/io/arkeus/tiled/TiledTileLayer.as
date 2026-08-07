package io.arkeus.tiled
{
   public class TiledTileLayer extends TiledLayer
   {
      
      public var encoding:String;
      
      public var compression:String;
      
      public var data:Array;
      
      public function TiledTileLayer(param1:XML)
      {
         super(param1);
         var _loc2_:XML = param1.data[0];
         this.encoding = "@encoding" in _loc2_ ? _loc2_.@encoding : null;
         this.compression = "@compression" in _loc2_ ? _loc2_.@compression : null;
         this.data = TiledUtils.stringToTileData(_loc2_.text(),width,this.encoding,this.compression);
      }
   }
}

