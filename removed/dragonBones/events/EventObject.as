package dragonBones.events
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.animation.AnimationState;
   import dragonBones.core.BaseObject;
   import dragonBones.objects.AnimationFrameData;
   import dragonBones.objects.CustomData;
   
   public class EventObject extends BaseObject
   {
      
      public static const START:String = "start";
      
      public static const LOOP_COMPLETE:String = "loopComplete";
      
      public static const COMPLETE:String = "complete";
      
      public static const FADE_IN:String = "fadeIn";
      
      public static const FADE_IN_COMPLETE:String = "fadeInComplete";
      
      public static const FADE_OUT:String = "fadeOut";
      
      public static const FADE_OUT_COMPLETE:String = "fadeOutComplete";
      
      public static const FRAME_EVENT:String = "frameEvent";
      
      public static const SOUND_EVENT:String = "soundEvent";
      
      public var type:String;
      
      public var name:String;
      
      public var frame:AnimationFrameData;
      
      public var data:CustomData;
      
      public var armature:Armature;
      
      public var bone:Bone;
      
      public var slot:Slot;
      
      public var animationState:AnimationState;
      
      public function EventObject()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         this.type = null;
         this.name = null;
         this.frame = null;
         this.data = null;
         this.armature = null;
         this.bone = null;
         this.slot = null;
         this.animationState = null;
      }
   }
}

