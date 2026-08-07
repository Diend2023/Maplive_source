package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   
   public class FrameData extends BaseObject
   {
      
      public var position:Number;
      
      public var duration:Number;
      
      public var prev:FrameData;
      
      public var next:FrameData;
      
      public function FrameData(param1:FrameData)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      override protected function _onClear() : void
      {
         this.position = 0;
         this.duration = 0;
         this.prev = null;
         this.next = null;
      }
   }
}

