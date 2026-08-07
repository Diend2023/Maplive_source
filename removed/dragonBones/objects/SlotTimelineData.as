package dragonBones.objects
{
   public final class SlotTimelineData extends TimelineData
   {
      
      public var slot:SlotData;
      
      public function SlotTimelineData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.slot = null;
      }
   }
}

