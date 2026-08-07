package io.arkeus.tiled
{
   import flash.geom.Point;
   
   public class TiledTileset
   {
      
      public var firstGid:uint;
      
      public var name:String;
      
      public var tileWidth:uint;
      
      public var tileHeight:uint;
      
      public var spacing:uint;
      
      public var margin:uint;
      
      public var tileOffset:Point;
      
      public var properties:TiledProperties;
      
      public var image:TiledImage;
      
      public var terrain:Object;
      
      public var tiles:Object;
      
      public function TiledTileset(param1:XML)
      {
         super();
         this.firstGid = param1.@firstgid;
         this.name = param1.@name;
         this.tileWidth = param1.@tilewidth;
         this.tileHeight = param1.@tileheight;
         this.spacing = "@spacing" in param1 ? uint(param1.@spacing) : 0;
         this.margin = "@margin" in param1 ? uint(param1.@margin) : 0;
         var _loc2_:XMLList = param1.tileoffset;
         this.tileOffset = _loc2_.length() == 1 ? new Point(_loc2_.@x,_loc2_.@y) : new Point();
         this.image = new TiledImage(param1.image);
         this.terrain = loadTerrain(param1.terraintypes);
         this.tiles = loadTiles(param1.tile);
      }
      
      private static function loadTerrain(param1:XMLList) : Object
      {
         var _loc4_:TiledTerrain = null;
         var _loc2_:Object = {};
         var _loc3_:uint = 0;
         while(_loc3_ < param1.terrain.length())
         {
            _loc4_ = new TiledTerrain(param1.terrain[_loc3_]);
            _loc2_[_loc4_.name] = _loc4_;
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function loadTiles(param1:XMLList) : Object
      {
         var _loc4_:TiledTile = null;
         var _loc2_:Object = {};
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length())
         {
            _loc4_ = new TiledTile(param1[_loc3_]);
            _loc2_[_loc4_.id] = _loc4_;
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

