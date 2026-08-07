package io.arkeus.tiled
{
   public class TiledLayer
   {
      
      public var name:String;
      
      public var width:uint;
      
      public var height:uint;
      
      public var opacity:Number;
      
      public var visible:Boolean;
      
      public var properties:TiledProperties;
      
      public function TiledLayer(param1:XML)
      {
         super();
         this.name = param1.@name;
         this.width = param1.@width;
         this.height = param1.@height;
         this.opacity = "@opacity" in param1 ? Number(param1.@opacity) : 1;
         this.visible = !("@visible" in param1 && param1.@visible == "0");
         this.properties = new TiledProperties(param1.properties);
      }
   }
}

