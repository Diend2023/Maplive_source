package io.arkeus.tiled
{
   public class TiledMap
   {
      
      public var version:String;
      
      public var orientation:String;
      
      public var width:uint;
      
      public var height:uint;
      
      public var tileWidth:uint;
      
      public var tileHeight:uint;
      
      public var backgroundColor:uint;
      
      public var properties:TiledProperties;
      
      public var tilesets:TiledTilesets;
      
      public var layers:TiledLayers;
      
      public function TiledMap(param1:XML)
      {
         super();
         this.version = "@version" in param1 ? param1.@version : "?";
         this.orientation = "@orientation" in param1 ? param1.@orientation : "othogonal";
         this.width = param1.@width;
         this.height = param1.@height;
         this.tileWidth = param1.@tilewidth;
         this.tileHeight = param1.@tileheight;
         this.backgroundColor = "@backgroundcolor" in param1 ? TiledUtils.colorStringToUint(param1.@backgroundcolor) : 16777215;
         this.properties = new TiledProperties(param1.properties);
         this.tilesets = new TiledTilesets(param1.tileset);
         this.parseLayers(param1);
      }
      
      private function parseLayers(param1:XML) : void
      {
         var _loc4_:QName = null;
         this.layers = new TiledLayers();
         var _loc2_:XMLList = param1.children();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc4_ = (_loc2_[_loc3_] as XML).name() as QName;
            if(_loc4_.localName == "layer")
            {
               this.layers.addLayer(new TiledTileLayer(_loc2_[_loc3_]));
            }
            else if(_loc4_.localName == "objectgroup")
            {
               this.layers.addLayer(new TiledObjectLayer(_loc2_[_loc3_]));
            }
            else if(_loc4_.localName == "imagelayer")
            {
               this.layers.addLayer(new TiledImageLayer(_loc2_[_loc3_]));
            }
            _loc3_++;
         }
      }
      
      public function toString() : String
      {
         return ["Version: " + this.version,"Orientation: " + this.orientation,"Width: " + this.width,"Height: " + this.height,"TileWidth: " + this.tileWidth,"TileHeight: " + this.tileHeight,"BackgroundColor: " + this.backgroundColor,"Properties: " + this.properties,"Tilesets: " + this.tilesets,"Layers: " + this.layers].join(", ");
      }
   }
}

