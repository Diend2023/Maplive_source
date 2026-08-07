package dragonBones.animation
{
   import dragonBones.core.DragonBones;
   
   public final class WorldClock implements IAnimateble
   {
      
      public static const clock:WorldClock = new WorldClock();
      
      public var time:Number = new Date().getTime() / DragonBones.SECOND_TO_MILLISECOND;
      
      public var timeScale:Number = 1;
      
      private const _animatebles:Vector.<IAnimateble> = new Vector.<IAnimateble>();
      
      private var _clock:WorldClock = null;
      
      public function WorldClock()
      {
         super();
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:IAnimateble = null;
         if(param1 !== param1)
         {
            param1 = 0;
         }
         if(param1 < 0)
         {
            param1 = new Date().getTime() / DragonBones.SECOND_TO_MILLISECOND - this.time;
         }
         if(this.timeScale !== 1)
         {
            param1 *= this.timeScale;
         }
         if(param1 < 0)
         {
            this.time -= param1;
         }
         else
         {
            this.time += param1;
         }
         if(param1)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = this._animatebles.length;
            while(_loc2_ < _loc4_)
            {
               _loc5_ = this._animatebles[_loc2_];
               if(_loc5_)
               {
                  if(_loc3_ > 0)
                  {
                     this._animatebles[_loc2_ - _loc3_] = _loc5_;
                     this._animatebles[_loc2_] = null;
                  }
                  _loc5_.advanceTime(param1);
               }
               else
               {
                  _loc3_++;
               }
               _loc2_++;
            }
            if(_loc3_ > 0)
            {
               _loc4_ = this._animatebles.length;
               while(_loc2_ < _loc4_)
               {
                  _loc5_ = this._animatebles[_loc2_];
                  if(_loc5_)
                  {
                     this._animatebles[_loc2_ - _loc3_] = _loc5_;
                  }
                  else
                  {
                     _loc3_++;
                  }
                  _loc2_++;
               }
               this._animatebles.length -= _loc3_;
            }
         }
      }
      
      public function contains(param1:IAnimateble) : Boolean
      {
         return this._animatebles.indexOf(param1) >= 0;
      }
      
      public function add(param1:IAnimateble) : void
      {
         if(Boolean(param1) && this._animatebles.indexOf(param1) < 0)
         {
            this._animatebles.push(param1);
            param1.clock = this;
         }
      }
      
      public function remove(param1:IAnimateble) : void
      {
         var _loc2_:int = int(this._animatebles.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this._animatebles[_loc2_] = null;
            param1.clock = null;
         }
      }
      
      public function clear() : void
      {
         var _loc3_:IAnimateble = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = this._animatebles.length;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._animatebles[_loc1_];
            this._animatebles[_loc1_] = null;
            if(_loc3_ != null)
            {
               _loc3_.clock = null;
            }
            _loc1_++;
         }
      }
      
      public function get clock() : WorldClock
      {
         return this._clock;
      }
      
      public function set clock(param1:WorldClock) : void
      {
         if(this._clock === param1)
         {
            return;
         }
         var _loc2_:WorldClock = this._clock;
         this._clock = param1;
         if(_loc2_)
         {
            _loc2_.remove(this);
         }
         if(this._clock)
         {
            this._clock.add(this);
         }
      }
   }
}

