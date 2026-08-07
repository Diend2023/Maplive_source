package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.EventType;
   
   public final class EventData extends BaseObject
   {
      
      public var type:int;
      
      public var name:String;
      
      public var bone:BoneData;
      
      public var slot:SlotData;
      
      public var data:CustomData;
      
      public function EventData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         if(this.data)
         {
            this.data.returnToPool();
         }
         this.type = EventType.None;
         this.name = null;
         this.bone = null;
         this.slot = null;
         this.data = null;
      }
   }
}

