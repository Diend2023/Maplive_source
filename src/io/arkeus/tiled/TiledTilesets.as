package io.arkeus.tiled
{
   public class TiledTilesets
   {
      
      public var tilesets:Object = {};
      
      public var tilesetsVector:Vector.<TiledTileset> = new Vector.<TiledTileset>(0);
      
      public function TiledTilesets(param1:XMLList)
      {
         super();
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length())
         {
            this.addTileset(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addTileset(param1:XML) : void
      {
         var _loc2_:TiledTileset = new TiledTileset(param1);
         this.tilesets[_loc2_.name] = _loc2_;
         this.tilesetsVector.push(_loc2_);
      }
      
      public function getTileset(param1:uint) : TiledTileset
      {
         return this.tilesetsVector[param1];
      }
      
      public function getTilesetByName(param1:String) : TiledTileset
      {
         return this.tilesets[param1];
      }
      
      public function size() : uint
      {
         return this.tilesetsVector.length;
      }
      
      public function toString() : String
      {
         return this.size() + " tilesets";
      }
   }
}

