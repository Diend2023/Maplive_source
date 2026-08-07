package io.arkeus.tiled
{
   public class TiledObjectLayer extends TiledLayer
   {
      
      public var objects:Vector.<TiledObject>;
      
      public var typeMap:Object;
      
      public var nameMap:Object;
      
      public function TiledObjectLayer(param1:XML)
      {
         var _loc4_:TiledObject = null;
         super(param1);
         this.objects = new Vector.<TiledObject>();
         this.typeMap = {};
         this.nameMap = {};
         var _loc2_:XMLList = param1.object;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc4_ = new TiledObject(_loc2_[_loc3_]);
            this.objects.push(_loc4_);
            if(_loc4_.name)
            {
               this.nameMap[_loc4_.name] = _loc4_;
            }
            if(_loc4_.type)
            {
               (this.typeMap[_loc4_.type] = this.typeMap[_loc4_.type] || new Vector.<TiledObject>()).push(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function getObjectByIndex(param1:uint) : TiledObject
      {
         return this.objects[param1];
      }
      
      public function getObjectByName(param1:String) : TiledObject
      {
         return this.nameMap[param1];
      }
      
      public function getObjectsByType(param1:String) : Vector.<TiledObject>
      {
         return this.typeMap[param1];
      }
   }
}

