package io.arkeus.tiled
{
   public class TiledProperties
   {
      
      public var properties:Object = {};
      
      public function TiledProperties(param1:XMLList)
      {
         super();
         var _loc2_:uint = 0;
         while(_loc2_ < param1.property.length())
         {
            this.set(param1.property[_loc2_].@name,param1.property[_loc2_].@value);
            _loc2_++;
         }
      }
      
      public function get(param1:String) : String
      {
         return this.properties[param1];
      }
      
      public function set(param1:String, param2:String) : void
      {
         this.properties[param1] = param2;
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         for(_loc2_ in this.properties)
         {
            _loc1_.push(_loc2_ + "=" + this.properties[_loc2_]);
         }
         return "(" + _loc1_.join(", ") + ")";
      }
   }
}

