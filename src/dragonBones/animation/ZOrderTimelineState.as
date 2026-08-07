package dragonBones.animation
{
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.ZOrderFrameData;
   
   use namespace dragonBones_internal;
   
   public final class ZOrderTimelineState extends TimelineState
   {
      
      public function ZOrderTimelineState()
      {
         super(this);
      }
      
      override protected function _onArriveAtFrame() : void
      {
         super._onArriveAtFrame();
         _armature.dragonBones_internal::_sortZOrder((_currentFrame as ZOrderFrameData).zOrder);
      }
   }
}

