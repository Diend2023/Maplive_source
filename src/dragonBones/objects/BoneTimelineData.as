package dragonBones.objects
{
   import dragonBones.geom.Transform;
   
   public final class BoneTimelineData extends TimelineData
   {
      
      public const originalTransform:Transform = new Transform();
      
      public var bone:BoneData;
      
      public function BoneTimelineData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.originalTransform.identity();
         this.bone = null;
      }
   }
}

