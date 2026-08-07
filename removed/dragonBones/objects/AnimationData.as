package dragonBones.objects
{
   public final class AnimationData extends TimelineData
   {
      
      public var frameCount:uint;
      
      public var playTimes:uint;
      
      public var duration:Number;
      
      public var fadeInTime:Number;
      
      public var cacheFrameRate:Number;
      
      public var name:String;
      
      public var zOrderTimeline:ZOrderTimelineData;
      
      public const boneTimelines:Object = {};
      
      public const slotTimelines:Object = {};
      
      public const ffdTimelines:Object = {};
      
      public const cachedFrames:Vector.<Boolean> = new Vector.<Boolean>();
      
      public const boneCachedFrameIndices:Object = {};
      
      public const slotCachedFrameIndices:Object = {};
      
      public function AnimationData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         super._onClear();
         for(_loc1_ in this.boneTimelines)
         {
            (this.boneTimelines[_loc1_] as BoneTimelineData).returnToPool();
            delete this.boneTimelines[_loc1_];
         }
         for(_loc1_ in this.slotTimelines)
         {
            (this.slotTimelines[_loc1_] as SlotTimelineData).returnToPool();
            delete this.slotTimelines[_loc1_];
         }
         for(_loc1_ in this.ffdTimelines)
         {
            for(_loc2_ in this.ffdTimelines[_loc1_])
            {
               for(_loc3_ in this.ffdTimelines[_loc1_][_loc2_])
               {
                  (this.ffdTimelines[_loc1_][_loc2_][_loc3_] as FFDTimelineData).returnToPool();
               }
            }
            delete this.ffdTimelines[_loc1_];
         }
         for(_loc1_ in this.boneCachedFrameIndices)
         {
            delete this.boneCachedFrameIndices[_loc1_];
         }
         for(_loc1_ in this.slotCachedFrameIndices)
         {
            delete this.slotCachedFrameIndices[_loc1_];
         }
         if(this.zOrderTimeline)
         {
            this.zOrderTimeline.returnToPool();
         }
         this.frameCount = 0;
         this.playTimes = 0;
         this.duration = 0;
         this.fadeInTime = 0;
         this.cacheFrameRate = 0;
         this.name = null;
         this.cachedFrames.fixed = false;
         this.cachedFrames.length = 0;
         this.zOrderTimeline = null;
      }
      
      public function cacheFrames(param1:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.cacheFrameRate > 0)
         {
            return;
         }
         this.cacheFrameRate = Math.max(Math.ceil(param1 * scale),1);
         var _loc2_:uint = Math.ceil(this.cacheFrameRate * this.duration) + 1;
         this.cachedFrames.length = _loc2_;
         this.cachedFrames.fixed = true;
         for(_loc3_ in this.boneTimelines)
         {
            _loc4_ = new Vector.<int>(_loc2_,true);
            _loc5_ = 0;
            _loc6_ = _loc4_.length;
            while(_loc5_ < _loc6_)
            {
               _loc4_[_loc5_] = -1;
               _loc5_++;
            }
            this.boneCachedFrameIndices[_loc3_] = _loc4_;
         }
         for(_loc3_ in this.slotTimelines)
         {
            _loc4_ = new Vector.<int>(_loc2_,true);
            _loc5_ = 0;
            _loc6_ = _loc4_.length;
            while(_loc5_ < _loc6_)
            {
               _loc4_[_loc5_] = -1;
               _loc5_++;
            }
            this.slotCachedFrameIndices[_loc3_] = _loc4_;
         }
      }
      
      public function addBoneTimeline(param1:BoneTimelineData) : void
      {
         if(param1 && param1.bone && !this.boneTimelines[param1.bone.name])
         {
            this.boneTimelines[param1.bone.name] = param1;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addSlotTimeline(param1:SlotTimelineData) : void
      {
         if(param1 && param1.slot && !this.slotTimelines[param1.slot.name])
         {
            this.slotTimelines[param1.slot.name] = param1;
            return;
         }
         throw new ArgumentError();
      }
      
      public function addFFDTimeline(param1:FFDTimelineData) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 && param1.skin && Boolean(param1.slot))
         {
            _loc2_ = this.ffdTimelines[param1.skin.name] = this.ffdTimelines[param1.skin.name] || {};
            _loc3_ = _loc2_[param1.slot.slot.name] = _loc2_[param1.slot.slot.name] || {};
            if(!_loc3_[param1.display.name])
            {
               _loc3_[param1.display.name] = param1;
               return;
            }
            throw new ArgumentError();
         }
         throw new ArgumentError();
      }
      
      public function getBoneTimeline(param1:String) : BoneTimelineData
      {
         return this.boneTimelines[param1] as BoneTimelineData;
      }
      
      public function getSlotTimeline(param1:String) : SlotTimelineData
      {
         return this.slotTimelines[param1] as SlotTimelineData;
      }
      
      public function getFFDTimeline(param1:String, param2:String) : Object
      {
         var _loc3_:Object = this.ffdTimelines[param1];
         if(_loc3_)
         {
            return _loc3_[param2];
         }
         return null;
      }
      
      public function getBoneCachedFrameIndices(param1:String) : Vector.<int>
      {
         return this.boneCachedFrameIndices[param1];
      }
      
      public function getSlotCachedFrameIndices(param1:String) : Vector.<int>
      {
         return this.slotCachedFrameIndices[param1];
      }
   }
}

