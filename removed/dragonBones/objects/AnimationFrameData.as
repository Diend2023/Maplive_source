package dragonBones.objects
{
   public final class AnimationFrameData extends FrameData
   {
      
      public const actions:Vector.<ActionData> = new Vector.<ActionData>();
      
      public const events:Vector.<EventData> = new Vector.<EventData>();
      
      public function AnimationFrameData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         var _loc1_:uint = 0;
         var _loc2_:uint = this.actions.length;
         while(_loc1_ < _loc2_)
         {
            this.actions[_loc1_].returnToPool();
            _loc1_++;
         }
         _loc1_ = 0;
         _loc2_ = this.events.length;
         while(_loc1_ < _loc2_)
         {
            this.events[_loc1_].returnToPool();
            _loc1_++;
         }
         this.actions.length = 0;
         this.events.length = 0;
      }
   }
}

