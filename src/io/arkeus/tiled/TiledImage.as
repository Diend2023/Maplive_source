package io.arkeus.tiled
{
   public class TiledImage
   {
      
      public var source:String;
      
      public var width:uint;
      
      public var height:uint;
      
      public var transparentColor:int;
      
      public function TiledImage(param1:XMLList)
      {
         super();
         this.source = param1.@source;
         this.width = param1.@width;
         this.height = param1.@height;
         this.transparentColor = "@trans" in param1 ? int(TiledUtils.colorStringToUint(param1.@trans)) : -1;
      }
   }
}

