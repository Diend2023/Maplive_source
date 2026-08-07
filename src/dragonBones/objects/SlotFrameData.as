package dragonBones.objects
{
   import flash.geom.ColorTransform;
   
   public final class SlotFrameData extends TweenFrameData
   {
      
      public static const DEFAULT_COLOR:ColorTransform = new ColorTransform();
      
      public var displayIndex:int;
      
      public var color:ColorTransform;
      
      public function SlotFrameData()
      {
         super(this);
      }
      
      public static function generateColor() : ColorTransform
      {
         return new ColorTransform();
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.displayIndex = 0;
         this.color = null;
      }
   }
}

