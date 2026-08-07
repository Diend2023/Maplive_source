package dragonBones.animation
{
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.TweenFrameData;
   
   use namespace dragonBones_internal;
   
   public class TweenTimelineState extends TimelineState
   {
      
      protected static const TWEEN_TYPE_NONE:int = 0;
      
      protected static const TWEEN_TYPE_ONCE:int = 1;
      
      protected static const TWEEN_TYPE_ALWAYS:int = 2;
      
      protected var _tweenProgress:Number;
      
      protected var _tweenEasing:Number;
      
      protected var _curve:Vector.<Number>;
      
      public function TweenTimelineState(param1:TimelineState)
      {
         super(param1);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      dragonBones_internal static function _getEasingValue(param1:Number, param2:Number) : Number
      {
         if(param1 <= 0)
         {
            return 0;
         }
         if(param1 >= 1)
         {
            return 1;
         }
         var _loc3_:Number = 1;
         if(param2 > 2)
         {
            return param1;
         }
         if(param2 > 1)
         {
            _loc3_ = 0.5 * (1 - Math.cos(param1 * Math.PI));
            param2--;
         }
         else if(param2 > 0)
         {
            _loc3_ = 1 - Math.pow(1 - param1,2);
         }
         else if(param2 >= -1)
         {
            param2 *= -1;
            _loc3_ = Math.pow(param1,2);
         }
         else
         {
            if(param2 < -2)
            {
               return param1;
            }
            param2 *= -1;
            _loc3_ = Math.acos(1 - param1 * 2) / Math.PI;
            param2--;
         }
         return (_loc3_ - param1) * param2 + param1;
      }
      
      dragonBones_internal static function _getCurveEasingValue(param1:Number, param2:Vector.<Number>) : Number
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 <= 0)
         {
            return 0;
         }
         if(param1 >= 1)
         {
            return 1;
         }
         _loc3_ = uint(param2.length + 1);
         _loc4_ = Math.floor(param1 * _loc3_);
         var _loc5_:Number = _loc4_ === 0 ? 0 : param2[_loc4_ - 1];
         var _loc6_:Number = _loc4_ === _loc3_ - 1 ? 1 : param2[_loc4_];
         return _loc5_ + (_loc6_ - _loc5_) * (param1 - _loc4_ / _loc3_);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this._tweenProgress = 0;
         this._tweenEasing = DragonBones.NO_TWEEN;
         this._curve = null;
      }
      
      override protected function _onArriveAtFrame() : void
      {
         var _loc1_:TweenFrameData = null;
         if(_keyFrameCount > 1 && (_currentFrame.next !== _timelineData.frames[0] || _animationState.playTimes === 0 || _animationState.currentPlayTimes < _animationState.playTimes - 1))
         {
            _loc1_ = _currentFrame as TweenFrameData;
            this._tweenEasing = _loc1_.tweenEasing;
            this._curve = _loc1_.curve;
         }
         else
         {
            this._tweenEasing = DragonBones.NO_TWEEN;
            this._curve = null;
         }
      }
      
      override protected function _onUpdateFrame() : void
      {
         if(this._tweenEasing != DragonBones.NO_TWEEN)
         {
            this._tweenProgress = (_currentTime - _currentFrame.position + _position) / _currentFrame.duration;
            if(this._tweenEasing != 0)
            {
               this._tweenProgress = dragonBones_internal::_getEasingValue(this._tweenProgress,this._tweenEasing);
            }
         }
         else if(this._curve)
         {
            this._tweenProgress = (_currentTime - _currentFrame.position + _position) / _currentFrame.duration;
            this._tweenProgress = dragonBones_internal::_getCurveEasingValue(this._tweenProgress,this._curve);
         }
         else
         {
            this._tweenProgress = 0;
         }
      }
   }
}

