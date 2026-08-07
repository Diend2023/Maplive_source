package dragonBones.flash
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.animation.Animation;
   import dragonBones.core.IArmatureDisplay;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.BoundingBoxType;
   import dragonBones.events.EventObject;
   import dragonBones.objects.BoundingBoxData;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   use namespace dragonBones_internal;
   
   public class FlashArmatureDisplay extends Sprite implements IArmatureDisplay
   {
      
      dragonBones_internal var _armature:Armature;
      
      private var _debugDrawer:Sprite;
      
      public function FlashArmatureDisplay()
      {
         super();
      }
      
      public function _onClear() : void
      {
         this.dragonBones_internal::_armature = null;
         this._debugDrawer = null;
      }
      
      public function _dispatchEvent(param1:String, param2:EventObject) : void
      {
         var _loc3_:FlashEvent = new FlashEvent(param1,param2);
         dispatchEvent(_loc3_);
      }
      
      public function _debugDraw(param1:Boolean) : void
      {
         var _loc2_:Vector.<Bone> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<Slot> = null;
         var _loc6_:Bone = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Slot = null;
         var _loc13_:BoundingBoxData = null;
         var _loc14_:Shape = null;
         var _loc15_:Vector.<Number> = null;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         if(param1)
         {
            if(!this._debugDrawer)
            {
               this._debugDrawer = new Sprite();
            }
            addChild(this._debugDrawer);
            this._debugDrawer.graphics.clear();
            _loc2_ = this.dragonBones_internal::_armature.getBones();
            _loc3_ = 0;
            _loc4_ = _loc2_.length;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = _loc2_[_loc3_];
               _loc7_ = _loc6_.length;
               _loc8_ = _loc6_.globalTransformMatrix.tx;
               _loc9_ = _loc6_.globalTransformMatrix.ty;
               _loc10_ = _loc8_ + _loc6_.globalTransformMatrix.a * _loc7_;
               _loc11_ = _loc9_ + _loc6_.globalTransformMatrix.b * _loc7_;
               this._debugDrawer.graphics.lineStyle(2,_loc6_.ik ? 16711680 : 65535,0.7);
               this._debugDrawer.graphics.moveTo(_loc8_,_loc9_);
               this._debugDrawer.graphics.lineTo(_loc10_,_loc11_);
               this._debugDrawer.graphics.lineStyle(0,0,0);
               this._debugDrawer.graphics.beginFill(65535,0.7);
               this._debugDrawer.graphics.drawCircle(_loc8_,_loc9_,3);
               this._debugDrawer.graphics.endFill();
               _loc3_++;
            }
            _loc5_ = this.dragonBones_internal::_armature.getSlots();
            _loc3_ = 0;
            _loc4_ = _loc5_.length;
            while(_loc3_ < _loc4_)
            {
               _loc12_ = _loc5_[_loc3_];
               _loc13_ = _loc12_.boundingBoxData;
               if(_loc13_)
               {
                  _loc14_ = this._debugDrawer.getChildByName(_loc12_.name) as Shape;
                  if(!_loc14_)
                  {
                     _loc14_ = new Shape();
                     _loc14_.name = _loc12_.name;
                     this._debugDrawer.addChild(_loc14_);
                  }
                  _loc14_.graphics.clear();
                  _loc14_.graphics.beginFill(_loc13_.color ? _loc13_.color : 16711935,0.3);
                  switch(_loc13_.type)
                  {
                     case BoundingBoxType.Rectangle:
                        _loc14_.graphics.drawRect(-_loc13_.width * 0.5,-_loc13_.height * 0.5,_loc13_.width,_loc13_.height);
                        break;
                     case BoundingBoxType.Ellipse:
                        _loc14_.graphics.drawEllipse(-_loc13_.width * 0.5,-_loc13_.height * 0.5,_loc13_.width,_loc13_.height);
                        break;
                     case BoundingBoxType.Polygon:
                        _loc15_ = _loc13_.vertices;
                        _loc16_ = 0;
                        _loc17_ = _loc13_.vertices.length;
                        while(_loc16_ < _loc17_)
                        {
                           if(_loc16_ === 0)
                           {
                              _loc14_.graphics.moveTo(_loc15_[_loc16_],_loc15_[_loc16_ + 1]);
                           }
                           else
                           {
                              _loc14_.graphics.lineTo(_loc15_[_loc16_],_loc15_[_loc16_ + 1]);
                           }
                           _loc16_ += 2;
                        }
                  }
                  _loc14_.graphics.endFill();
                  _loc12_.dragonBones_internal::_updateTransformAndMatrix();
                  _loc14_.transform.matrix = _loc12_.globalTransformMatrix;
               }
               else
               {
                  _loc14_ = this._debugDrawer.getChildByName(_loc12_.name) as Shape;
                  if(_loc14_)
                  {
                     this._debugDrawer.removeChild(_loc14_);
                  }
               }
               _loc3_++;
            }
         }
         else if(Boolean(this._debugDrawer) && this._debugDrawer.parent === this)
         {
            removeChild(this._debugDrawer);
         }
      }
      
      public function dispose() : void
      {
         if(this.dragonBones_internal::_armature)
         {
            this.dragonBones_internal::_armature.dispose();
            this.dragonBones_internal::_armature = null;
         }
      }
      
      public function hasEvent(param1:String) : Boolean
      {
         return hasEventListener(param1);
      }
      
      public function addEvent(param1:String, param2:Function) : void
      {
         addEventListener(param1,param2);
      }
      
      public function removeEvent(param1:String, param2:Function) : void
      {
         removeEventListener(param1,param2);
      }
      
      public function get armature() : Armature
      {
         return this.dragonBones_internal::_armature;
      }
      
      public function get animation() : Animation
      {
         return this.dragonBones_internal::_armature.animation;
      }
      
      public function advanceTimeBySelf(param1:Boolean) : void
      {
         if(param1)
         {
            this.dragonBones_internal::_armature.clock = FlashFactory.dragonBones_internal::_clock;
         }
         else
         {
            this.dragonBones_internal::_armature.clock = null;
         }
      }
   }
}

