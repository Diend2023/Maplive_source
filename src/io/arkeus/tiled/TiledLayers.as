package io.arkeus.tiled
{
   public class TiledLayers
   {
      
      public var layers:Vector.<TiledLayer>;
      
      public function TiledLayers()
      {
         super();
         this.layers = new Vector.<TiledLayer>();
      }
      
      public function addLayer(param1:TiledLayer) : void
      {
         this.layers.push(param1);
      }
      
      public function getAllLayers() : Vector.<TiledLayer>
      {
         return this.layers;
      }
      
      public function getVisibleLayers() : Vector.<TiledLayer>
      {
         return this.layers.filter(function(param1:TiledLayer, param2:int, param3:Vector.<TiledLayer>):Boolean
         {
            return param1.visible;
         });
      }
      
      public function getTileLayers() : Vector.<TiledLayer>
      {
         return this.layers.filter(function(param1:TiledLayer, param2:int, param3:Vector.<TiledLayer>):Boolean
         {
            return param1 is TiledTileLayer;
         });
      }
      
      public function getObjectLayers() : Vector.<TiledLayer>
      {
         return this.layers.filter(function(param1:TiledLayer, param2:int, param3:Vector.<TiledLayer>):Boolean
         {
            return param1 is TiledObjectLayer;
         });
      }
      
      public function get length() : uint
      {
         return this.layers.length;
      }
      
      public function toString() : String
      {
         return this.length + " layers";
      }
   }
}

