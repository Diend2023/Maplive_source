package dragonBones.objects
{
   import dragonBones.core.DragonBones;
   import flash.geom.Point;
   
   public class TweenFrameData extends FrameData
   {
      
      public var tweenEasing:Number;
      
      public var curve:Vector.<Number>;
      
      public function TweenFrameData(param1:TweenFrameData)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      private static function _getCurvePoint(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Point) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         _loc11_ = 1 - param9;
         _loc12_ = _loc11_ * _loc11_;
         _loc13_ = param9 * param9;
         var _loc14_:Number = _loc11_ * _loc12_;
         var _loc15_:Number = 3 * param9 * _loc12_;
         var _loc16_:Number = 3 * _loc11_ * _loc13_;
         var _loc17_:Number = param9 * _loc13_;
         param10.x = _loc14_ * param1 + _loc15_ * param3 + _loc16_ * param5 + _loc17_ * param7;
         param10.y = _loc14_ * param2 + _loc15_ * param4 + _loc16_ * param6 + _loc17_ * param8;
      }
      
      public static function samplingEasingCurve(param1:Array, param2:Vector.<Number>) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc3_:uint = param1.length;
         var _loc4_:Point = new Point();
         var _loc5_:int = -2;
         var _loc6_:uint = 0;
         var _loc7_:uint = param2.length;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = (_loc6_ + 1) / (_loc7_ + 1);
            while((_loc5_ + 6 < _loc3_ ? param1[_loc5_ + 6] : 1) < _loc8_)
            {
               _loc5_ += 6;
            }
            _loc9_ = _loc5_ >= 0 && _loc5_ + 6 < _loc3_;
            _loc10_ = _loc9_ ? Number(param1[_loc5_]) : 0;
            _loc11_ = _loc9_ ? Number(param1[_loc5_ + 1]) : 0;
            _loc12_ = Number(param1[_loc5_ + 2]);
            _loc13_ = Number(param1[_loc5_ + 3]);
            _loc14_ = Number(param1[_loc5_ + 4]);
            _loc15_ = Number(param1[_loc5_ + 5]);
            _loc16_ = _loc9_ ? Number(param1[_loc5_ + 6]) : 1;
            _loc17_ = _loc9_ ? Number(param1[_loc5_ + 7]) : 1;
            _loc18_ = 0;
            _loc19_ = 1;
            while(_loc19_ - _loc18_ > 0.01)
            {
               _loc20_ = (_loc19_ + _loc18_) / 2;
               _getCurvePoint(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc20_,_loc4_);
               if(_loc8_ - _loc4_.x > 0)
               {
                  _loc18_ = _loc20_;
               }
               else
               {
                  _loc19_ = _loc20_;
               }
            }
            param2[_loc6_] = _loc4_.y;
            _loc6_++;
         }
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.tweenEasing = 0;
         this.curve = null;
      }
   }
}

