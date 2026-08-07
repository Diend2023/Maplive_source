package dragonBones.objects
{
   public class FFDTimelineData extends TimelineData
   {
      
      public var skin:SkinData;
      
      public var slot:SkinSlotData;
      
      public var display:DisplayData;
      
      public function FFDTimelineData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.skin = null;
         this.slot = null;
         this.display = null;
      }
   }
}

