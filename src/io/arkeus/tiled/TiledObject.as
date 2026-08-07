package io.arkeus.tiled
{
   import flash.geom.Point;
   
   public class TiledObject
   {
      
      public static const RECTANGLE:uint = 0;
      
      public static const ELLIPSE:uint = 1;
      
      public static const POLYGON:uint = 2;
      
      public static const POLYLINE:uint = 3;
      
      public var name:String;
      
      public var type:String;
      
      public var gid:uint;
      
      public var x:int;
      
      public var y:int;
      
      public var width:uint;
      
      public var height:uint;
      
      public var visible:Boolean;
      
      public var properties:TiledProperties;
      
      public var shape:uint;
      
      public var points:Vector.<Point>;
      
      public function TiledObject(param1:XML)
      {
         super();
         this.name = "@name" in param1 ? param1.@name : null;
         this.type = "@type" in param1 ? param1.@type : null;
         this.gid = "@gid" in param1 ? uint(param1.@gid) : 0;
         this.x = param1.@x;
         this.y = param1.@y;
         this.width = "@width" in param1 ? uint(param1.@width) : 0;
         this.height = "@height" in param1 ? uint(param1.@height) : 0;
         this.visible = !("@visible" in param1 && param1.@visible == "0");
         this.properties = new TiledProperties(param1.properties);
         this.shape = RECTANGLE;
         if(param1.ellipse.length() > 0)
         {
            this.shape = ELLIPSE;
         }
         else if(param1.polygon.length() > 0)
         {
            this.shape = POLYGON;
            this.populatePoints(param1.polygon.@points);
         }
         else if(param1.polyline.length() > 0)
         {
            this.shape = POLYLINE;
            this.populatePoints(param1.polyline.@points);
         }
      }
      
      private function populatePoints(param1:String) : void
      {
         var _loc4_:Array = null;
         this.points = new Vector.<Point>();
         var _loc2_:Array = param1.split(" ");
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_].split(",");
            if(_loc4_.length != 2)
            {
               throw new ArgumentError("Invalid poly point: " + _loc2_[_loc3_]);
            }
            this.points.push(new Point(parseFloat(_loc4_[0]),parseFloat(_loc4_[1])));
            _loc3_++;
         }
      }
   }
}

