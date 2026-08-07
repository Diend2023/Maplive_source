package io.arkeus.tiled
{
   public class TiledImageLayer extends TiledLayer
   {
      
      public var image:TiledImage;
      
      public function TiledImageLayer(param1:XML)
      {
         super(param1);
         this.image = new TiledImage(param1.image);
      }
   }
}

