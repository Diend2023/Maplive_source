package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   
   public class TimelineData extends BaseObject
   {
      
      public var scale:Number;
      
      public var offset:Number;
      
      public const frames:Vector.<FrameData> = new Vector.<FrameData>();
      
      public function TimelineData(param1:TimelineData)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      override protected function _onClear() : void
      {
         var _loc4_:FrameData = null;
         this.scale = 1;
         this.offset = 0;
         var _loc1_:FrameData = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this.frames.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.frames[_loc2_];
            if(Boolean(_loc1_) && _loc4_ !== _loc1_)
            {
               _loc1_.returnToPool();
            }
            _loc1_ = _loc4_;
            _loc2_++;
         }
         this.frames.fixed = false;
         this.frames.length = 0;
      }
   }
}

