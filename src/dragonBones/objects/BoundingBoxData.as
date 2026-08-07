package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.BoundingBoxType;
   import flash.geom.Point;
   
   public final class BoundingBoxData extends BaseObject
   {
      
      private static const OutCode_InSide:uint = 0;
      
      private static const OutCode_Left:uint = 0;
      
      private static const OutCode_Right:uint = 0;
      
      private static const OutCode_Top:uint = 0;
      
      private static const OutCode_Bottom:uint = 0;
      
      public var type:int;
      
      public var color:uint;
      
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var vertices:Vector.<Number> = new Vector.<Number>();
      
      public function BoundingBoxData()
      {
         super(this);
      }
      
      private static function _computeOutCode(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : uint
      {
         var _loc7_:uint = OutCode_InSide;
         if(param1 < param3)
         {
            _loc7_ |= OutCode_Left;
         }
         else if(param1 > param5)
         {
            _loc7_ |= OutCode_Right;
         }
         if(param2 < param4)
         {
            _loc7_ |= OutCode_Top;
         }
         else if(param2 > param6)
         {
            _loc7_ |= OutCode_Bottom;
         }
         return _loc7_;
      }
      
      public static function segmentIntersectsRectangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null, param10:Point = null, param11:Point = null) : int
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:uint = 0;
         var _loc12_:Boolean = param1 > param5 && param1 < param7 && param2 > param6 && param2 < param8;
         var _loc13_:Boolean = param3 > param5 && param3 < param7 && param4 > param6 && param4 < param8;
         if(_loc12_ && _loc13_)
         {
            return -1;
         }
         var _loc14_:int = 0;
         var _loc15_:uint = uint(BoundingBoxData._computeOutCode(param1,param2,param5,param6,param7,param8));
         var _loc16_:uint = uint(BoundingBoxData._computeOutCode(param3,param4,param5,param6,param7,param8));
         while(true)
         {
            if(!(_loc15_ | _loc16_))
            {
               _loc14_ = 2;
               break;
            }
            if(_loc15_ & _loc16_)
            {
               break;
            }
            _loc17_ = 0;
            _loc18_ = 0;
            _loc19_ = 0;
            _loc20_ = _loc15_ ? _loc15_ : _loc16_;
            if(_loc20_ & OutCode_Top)
            {
               _loc17_ = param1 + (param3 - param1) * (param6 - param2) / (param4 - param2);
               _loc18_ = param6;
               if(param11)
               {
                  _loc19_ = -Math.PI * 0.5;
               }
            }
            else if(_loc20_ & OutCode_Bottom)
            {
               _loc17_ = param1 + (param3 - param1) * (param8 - param2) / (param4 - param2);
               _loc18_ = param8;
               if(param11)
               {
                  _loc19_ = Math.PI * 0.5;
               }
            }
            else if(_loc20_ & OutCode_Right)
            {
               _loc18_ = param2 + (param4 - param2) * (param7 - param1) / (param3 - param1);
               _loc17_ = param7;
               if(param11)
               {
                  _loc19_ = 0;
               }
            }
            else if(_loc20_ & OutCode_Left)
            {
               _loc18_ = param2 + (param4 - param2) * (param5 - param1) / (param3 - param1);
               _loc17_ = param5;
               if(param11)
               {
                  _loc19_ = Math.PI;
               }
            }
            if(_loc20_ === _loc15_)
            {
               param1 = _loc17_;
               param2 = _loc18_;
               _loc15_ = uint(BoundingBoxData._computeOutCode(param1,param2,param5,param6,param7,param8));
               if(param11)
               {
                  param11.x = _loc19_;
               }
            }
            else
            {
               param3 = _loc17_;
               param4 = _loc18_;
               _loc16_ = uint(BoundingBoxData._computeOutCode(param3,param4,param5,param6,param7,param8));
               if(param11)
               {
                  param11.y = _loc19_;
               }
            }
         }
         if(_loc14_)
         {
            if(_loc12_)
            {
               _loc14_ = 2;
               if(param9)
               {
                  param9.x = param3;
                  param9.y = param4;
               }
               if(param10)
               {
                  param10.x = param3;
                  param10.y = param3;
               }
               if(param11)
               {
                  param11.x = param11.y + Math.PI;
               }
            }
            else if(_loc13_)
            {
               _loc14_ = 1;
               if(param9)
               {
                  param9.x = param1;
                  param9.y = param2;
               }
               if(param10)
               {
                  param10.x = param1;
                  param10.y = param2;
               }
               if(param11)
               {
                  param11.y = param11.x + Math.PI;
               }
            }
            else
            {
               _loc14_ = 3;
               if(param9)
               {
                  param9.x = param1;
                  param9.y = param2;
               }
               if(param10)
               {
                  param10.x = param3;
                  param10.y = param4;
               }
            }
         }
         return _loc14_;
      }
      
      public static function segmentIntersectsEllipse(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Point = null, param10:Point = null, param11:Point = null) : int
      {
         var _loc12_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         _loc12_ = param7 / param8;
         var _loc13_:Number = _loc12_ * _loc12_;
         param2 *= _loc12_;
         param4 *= _loc12_;
         _loc14_ = param3 - param1;
         _loc15_ = param4 - param2;
         _loc16_ = Math.sqrt(_loc14_ * _loc14_ + _loc15_ * _loc15_);
         _loc17_ = _loc14_ / _loc16_;
         _loc18_ = _loc15_ / _loc16_;
         _loc19_ = (param5 - param1) * _loc17_ + (param6 - param2) * _loc18_;
         _loc20_ = _loc19_ * _loc19_;
         _loc21_ = param1 * param1 + param2 * param2;
         _loc22_ = param7 * param7;
         var _loc23_:Number = _loc22_ - _loc21_ + _loc20_;
         var _loc24_:int = 0;
         if(_loc23_ >= 0)
         {
            _loc25_ = Math.sqrt(_loc23_);
            _loc26_ = _loc19_ - _loc25_;
            _loc27_ = _loc19_ + _loc25_;
            _loc28_ = _loc26_ < 0 ? -1 : (_loc26_ <= _loc16_ ? 0 : 1);
            _loc29_ = _loc27_ < 0 ? -1 : (_loc27_ <= _loc16_ ? 0 : 1);
            _loc30_ = _loc28_ * _loc29_;
            if(_loc30_ < 0)
            {
               return -1;
            }
            if(_loc30_ === 0)
            {
               if(_loc28_ === -1)
               {
                  _loc24_ = 2;
                  param3 = param1 + _loc27_ * _loc17_;
                  param4 = (param2 + _loc27_ * _loc18_) / _loc12_;
                  if(param9)
                  {
                     param9.x = param3;
                     param9.y = param4;
                  }
                  if(param10)
                  {
                     param10.x = param3;
                     param10.y = param4;
                  }
                  if(param11)
                  {
                     param11.x = Math.atan2(param4 / _loc22_ * _loc13_,param3 / _loc22_);
                     param11.y = param11.x + Math.PI;
                  }
               }
               else if(_loc29_ === 1)
               {
                  _loc24_ = 1;
                  param1 += _loc26_ * _loc17_;
                  param2 = (param2 + _loc26_ * _loc18_) / _loc12_;
                  if(param9)
                  {
                     param9.x = param1;
                     param9.y = param2;
                  }
                  if(param10)
                  {
                     param10.x = param1;
                     param10.y = param2;
                  }
                  if(param11)
                  {
                     param11.x = Math.atan2(param2 / _loc22_ * _loc13_,param1 / _loc22_);
                     param11.y = param11.x + Math.PI;
                  }
               }
               else
               {
                  _loc24_ = 3;
                  if(param9)
                  {
                     param9.x = param1 + _loc26_ * _loc17_;
                     param9.y = (param2 + _loc26_ * _loc18_) / _loc12_;
                     if(param11)
                     {
                        param11.x = Math.atan2(param9.y / _loc22_ * _loc13_,param9.x / _loc22_);
                     }
                  }
                  if(param10)
                  {
                     param10.x = param1 + _loc27_ * _loc17_;
                     param10.y = (param2 + _loc27_ * _loc18_) / _loc12_;
                     if(param11)
                     {
                        param11.y = Math.atan2(param10.y / _loc22_ * _loc13_,param10.x / _loc22_);
                     }
                  }
               }
            }
         }
         return _loc24_;
      }
      
      public static function segmentIntersectsPolygon(param1:Number, param2:Number, param3:Number, param4:Number, param5:Vector.<Number>, param6:Point = null, param7:Point = null, param8:Point = null) : int
      {
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         if(param1 === param3)
         {
            param1 = param3 + 0.01;
         }
         if(param2 === param4)
         {
            param2 = param4 + 0.01;
         }
         var _loc9_:uint = param5.length;
         var _loc10_:Number = param1 - param3;
         var _loc11_:Number = param2 - param4;
         var _loc12_:Number = param1 * param4 - param2 * param3;
         var _loc13_:int = 0;
         var _loc14_:Number = param5[_loc9_ - 2];
         var _loc15_:Number = param5[_loc9_ - 1];
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         var _loc20_:Number = 0;
         var _loc21_:Number = 0;
         var _loc22_:uint = 0;
         while(_loc22_ < _loc9_)
         {
            _loc23_ = param5[_loc22_];
            _loc24_ = param5[_loc22_ + 1];
            if(_loc14_ === _loc23_)
            {
               _loc14_ = _loc23_ + 0.01;
            }
            if(_loc15_ === _loc24_)
            {
               _loc15_ = _loc24_ + 0.01;
            }
            _loc25_ = _loc14_ - _loc23_;
            _loc26_ = _loc15_ - _loc24_;
            _loc27_ = _loc14_ * _loc24_ - _loc15_ * _loc23_;
            _loc28_ = _loc10_ * _loc26_ - _loc11_ * _loc25_;
            _loc29_ = (_loc12_ * _loc25_ - _loc10_ * _loc27_) / _loc28_;
            if((_loc29_ >= _loc14_ && _loc29_ <= _loc23_ || _loc29_ >= _loc23_ && _loc29_ <= _loc14_) && (_loc10_ === 0 || _loc29_ >= param1 && _loc29_ <= param3 || _loc29_ >= param3 && _loc29_ <= param1))
            {
               _loc30_ = (_loc12_ * _loc26_ - _loc11_ * _loc27_) / _loc28_;
               if((_loc30_ >= _loc15_ && _loc30_ <= _loc24_ || _loc30_ >= _loc24_ && _loc30_ <= _loc15_) && (_loc11_ === 0 || _loc30_ >= param2 && _loc30_ <= param4 || _loc30_ >= param4 && _loc30_ <= param2))
               {
                  if(!param7)
                  {
                     _loc18_ = _loc29_;
                     _loc19_ = _loc30_;
                     _loc20_ = _loc29_;
                     _loc21_ = _loc30_;
                     if(++param8)
                     {
                        param8.x = Math.atan2(_loc24_ - _loc15_,_loc23_ - _loc14_) - Math.PI * 0.5;
                        param8.y = param8.x;
                     }
                     break;
                  }
                  _loc31_ = _loc29_ - param1;
                  if(_loc31_ < 0)
                  {
                     _loc31_ = -_loc31_;
                  }
                  if(_loc13_ === 0)
                  {
                     _loc16_ = _loc31_;
                     _loc17_ = _loc31_;
                     _loc18_ = _loc29_;
                     _loc19_ = _loc30_;
                     _loc20_ = _loc29_;
                     _loc21_ = _loc30_;
                     if(param8)
                     {
                        param8.x = Math.atan2(_loc24_ - _loc15_,_loc23_ - _loc14_) - Math.PI * 0.5;
                        param8.y = param8.x;
                     }
                  }
                  else
                  {
                     if(_loc31_ < _loc16_)
                     {
                        _loc16_ = _loc31_;
                        _loc18_ = _loc29_;
                        _loc19_ = _loc30_;
                        if(param8)
                        {
                           param8.x = Math.atan2(_loc24_ - _loc15_,_loc23_ - _loc14_) - Math.PI * 0.5;
                        }
                     }
                     if(_loc31_ > _loc17_)
                     {
                        _loc17_ = _loc31_;
                        _loc20_ = _loc29_;
                        _loc21_ = _loc30_;
                        if(param8)
                        {
                           param8.y = Math.atan2(_loc24_ - _loc15_,_loc23_ - _loc14_) - Math.PI * 0.5;
                        }
                     }
                  }
                  _loc13_++;
               }
            }
            _loc14_ = _loc23_;
            _loc15_ = _loc24_;
            _loc22_ += 2;
         }
         if(_loc13_ === 1)
         {
            if(param6)
            {
               param6.x = _loc18_;
               param6.y = _loc19_;
            }
            if(param7)
            {
               param7.x = _loc18_;
               param7.y = _loc19_;
            }
            if(param8)
            {
               param8.y = param8.x + Math.PI;
            }
         }
         else if(_loc13_ > 1)
         {
            if(++param6)
            {
               param6.x = _loc18_;
               param6.y = _loc19_;
            }
            if(param7)
            {
               param7.x = _loc20_;
               param7.y = _loc21_;
            }
         }
         return _loc13_;
      }
      
      override protected function _onClear() : void
      {
         this.type = BoundingBoxType.None;
         this.color = 0;
         this.x = 0;
         this.y = 0;
         this.width = 0;
         this.height = 0;
         this.vertices.fixed = false;
         this.vertices.length = 0;
      }
      
      public function containsPoint(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc3_:* = false;
         if(this.type === BoundingBoxType.Polygon)
         {
            if(param1 >= this.x && param1 <= this.width && param2 >= this.y && param2 <= this.height)
            {
               _loc4_ = 0;
               _loc5_ = this.vertices.length;
               _loc6_ = uint(_loc5_ - 2);
               while(_loc4_ < _loc5_)
               {
                  _loc7_ = this.vertices[_loc6_ + 1];
                  _loc8_ = this.vertices[_loc4_ + 1];
                  if(_loc8_ < param2 && _loc7_ >= param2 || _loc7_ < param2 && _loc8_ >= param2)
                  {
                     _loc9_ = this.vertices[_loc6_];
                     _loc10_ = this.vertices[_loc4_];
                     if((param2 - _loc8_) * (_loc9_ - _loc10_) / (_loc7_ - _loc8_) + _loc10_ < param1)
                     {
                        _loc3_ = !_loc3_;
                     }
                  }
                  _loc6_ = _loc4_;
                  _loc4_ += 2;
               }
            }
         }
         else
         {
            _loc11_ = this.width * 0.5;
            if(param1 >= -_loc11_ && param1 <= _loc11_)
            {
               _loc12_ = this.height * 0.5;
               if(param2 >= -_loc12_ && param2 <= _loc12_)
               {
                  if(this.type === BoundingBoxType.Ellipse)
                  {
                     param2 *= _loc11_ / _loc12_;
                     _loc3_ = Math.sqrt(param1 * param1 + param2 * param2) <= _loc11_;
                  }
                  else
                  {
                     _loc3_ = true;
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function intersectsSegment(param1:Number, param2:Number, param3:Number, param4:Number, param5:Point = null, param6:Point = null, param7:Point = null) : int
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc8_:int = 0;
         switch(this.type)
         {
            case BoundingBoxType.Rectangle:
               _loc9_ = this.width * 0.5;
               _loc10_ = this.height * 0.5;
               _loc8_ = segmentIntersectsRectangle(param1,param2,param3,param4,-_loc9_,-_loc10_,_loc9_,_loc10_,param5,param6,param7);
               break;
            case BoundingBoxType.Ellipse:
               _loc8_ = segmentIntersectsEllipse(param1,param2,param3,param4,0,0,this.width * 0.5,this.height * 0.5,param5,param6,param7);
               break;
            case BoundingBoxType.Polygon:
               if(segmentIntersectsRectangle(param1,param2,param3,param4,this.x,this.y,this.width,this.height,null,null) !== 0)
               {
                  _loc8_ = segmentIntersectsPolygon(param1,param2,param3,param4,this.vertices,param5,param6,param7);
               }
         }
         return _loc8_;
      }
   }
}

