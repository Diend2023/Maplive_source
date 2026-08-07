package io.arkeus.tiled
{
   public class TiledTerrain
   {
      
      public var name:String;
      
      public var tile:int;
      
      public var properties:TiledProperties;
      
      public function TiledTerrain(param1:XML)
      {
         super();
         this.name = param1.@name;
         this.tile = param1.@tile;
         this.properties = new TiledProperties(param1.properties);
      }
   }
}

