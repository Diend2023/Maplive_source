package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   
   public final class SkinData extends BaseObject
   {
      
      public var name:String;
      
      public const slots:Object = {};
      
      public function SkinData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.slots)
         {
            (this.slots[_loc1_] as SkinSlotData).returnToPool();
            delete this.slots[_loc1_];
         }
         this.name = null;
      }
      
      public function addSlot(param1:SkinSlotData) : void
      {
         if(param1 && param1.slot && !this.slots[param1.slot.name])
         {
            this.slots[param1.slot.name] = param1;
            return;
         }
         throw new ArgumentError();
      }
      
      public function getSlot(param1:String) : SkinSlotData
      {
         return this.slots[param1] as SkinSlotData;
      }
   }
}

