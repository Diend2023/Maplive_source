package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   
   public final class SkinSlotData extends BaseObject
   {
      
      public const displays:Vector.<DisplayData> = new Vector.<DisplayData>();
      
      public const meshs:Object = {};
      
      public var slot:SlotData;
      
      public function SkinSlotData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         var _loc3_:String = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = this.displays.length;
         while(_loc1_ < _loc2_)
         {
            this.displays[_loc1_].returnToPool();
            _loc1_++;
         }
         for(_loc3_ in this.meshs)
         {
            this.meshs[_loc3_].returnToPool();
            delete this.meshs[_loc3_];
         }
         this.displays.fixed = false;
         this.displays.length = 0;
         this.slot = null;
      }
      
      public function getDisplay(param1:String) : DisplayData
      {
         var _loc4_:DisplayData = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this.displays.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.displays[_loc2_];
            if(_loc4_.name === param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addMesh(param1:MeshData) : void
      {
         if(param1 && param1.name && !this.meshs[param1.name])
         {
            this.meshs[param1.name] = param1;
            return;
         }
         throw new ArgumentError();
      }
      
      public function getMesh(param1:String) : MeshData
      {
         return this.meshs[param1];
      }
   }
}

