package dragonBones.objects
{
   public final class ZOrderFrameData extends FrameData
   {
      
      public const zOrder:Vector.<int> = new Vector.<int>();
      
      public function ZOrderFrameData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.zOrder.length = 0;
      }
   }
}

