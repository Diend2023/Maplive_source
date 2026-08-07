package dragonBones.parsers
{
   import dragonBones.animation.TweenTimelineState;
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.ActionType;
   import dragonBones.enum.ArmatureType;
   import dragonBones.enum.BlendMode;
   import dragonBones.enum.BoundingBoxType;
   import dragonBones.enum.DisplayType;
   import dragonBones.geom.Transform;
   import dragonBones.objects.ActionData;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.AnimationFrameData;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.BoneData;
   import dragonBones.objects.BoneFrameData;
   import dragonBones.objects.BoneTimelineData;
   import dragonBones.objects.DragonBonesData;
   import dragonBones.objects.EventData;
   import dragonBones.objects.FrameData;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SkinSlotData;
   import dragonBones.objects.TimelineData;
   import dragonBones.textures.TextureAtlasData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   use namespace dragonBones_internal;
   
   public class DataParser
   {
      
      protected static const DATA_VERSION_2_3:String = "2.3";
      
      protected static const DATA_VERSION_3_0:String = "3.0";
      
      protected static const DATA_VERSION_4_0:String = "4.0";
      
      protected static const DATA_VERSION_4_5:String = "4.5";
      
      protected static const DATA_VERSION_5_0:String = "5.0";
      
      protected static const DATA_VERSION:String = DATA_VERSION_5_0;
      
      protected static const DATA_VERSIONS:Vector.<String> = Vector.<String>([DATA_VERSION_5_0,DATA_VERSION_4_5,DATA_VERSION_4_0,DATA_VERSION_3_0,DATA_VERSION_2_3]);
      
      protected static const TEXTURE_ATLAS:String = "TextureAtlas";
      
      protected static const SUB_TEXTURE:String = "SubTexture";
      
      protected static const FORMAT:String = "format";
      
      protected static const IMAGE_PATH:String = "imagePath";
      
      protected static const WIDTH:String = "width";
      
      protected static const HEIGHT:String = "height";
      
      protected static const ROTATED:String = "rotated";
      
      protected static const FRAME_X:String = "frameX";
      
      protected static const FRAME_Y:String = "frameY";
      
      protected static const FRAME_WIDTH:String = "frameWidth";
      
      protected static const FRAME_HEIGHT:String = "frameHeight";
      
      protected static const DRADON_BONES:String = "dragonBones";
      
      protected static const ARMATURE:String = "armature";
      
      protected static const BONE:String = "bone";
      
      protected static const IK:String = "ik";
      
      protected static const SLOT:String = "slot";
      
      protected static const SKIN:String = "skin";
      
      protected static const DISPLAY:String = "display";
      
      protected static const ANIMATION:String = "animation";
      
      protected static const Z_ORDER:String = "zOrder";
      
      protected static const FFD:String = "ffd";
      
      protected static const FRAME:String = "frame";
      
      protected static const ACTIONS:String = "actions";
      
      protected static const EVENTS:String = "events";
      
      protected static const INTS:String = "ints";
      
      protected static const FLOATS:String = "floats";
      
      protected static const STRINGS:String = "strings";
      
      protected static const PIVOT:String = "pivot";
      
      protected static const TRANSFORM:String = "transform";
      
      protected static const AABB:String = "aabb";
      
      protected static const COLOR:String = "color";
      
      protected static const VERSION:String = "version";
      
      protected static const COMPATIBLE_VERSION:String = "compatibleVersion";
      
      protected static const FRAME_RATE:String = "frameRate";
      
      protected static const TYPE:String = "type";
      
      protected static const SUB_TYPE:String = "subType";
      
      protected static const NAME:String = "name";
      
      protected static const PARENT:String = "parent";
      
      protected static const TARGET:String = "target";
      
      protected static const SHARE:String = "share";
      
      protected static const PATH:String = "path";
      
      protected static const LENGTH:String = "length";
      
      protected static const DISPLAY_INDEX:String = "displayIndex";
      
      protected static const BLEND_MODE:String = "blendMode";
      
      protected static const INHERIT_TRANSLATION:String = "inheritTranslation";
      
      protected static const INHERIT_ROTATION:String = "inheritRotation";
      
      protected static const INHERIT_SCALE:String = "inheritScale";
      
      protected static const INHERIT_ANIMATION:String = "inheritAnimation";
      
      protected static const BEND_POSITIVE:String = "bendPositive";
      
      protected static const CHAIN:String = "chain";
      
      protected static const WEIGHT:String = "weight";
      
      protected static const FADE_IN_TIME:String = "fadeInTime";
      
      protected static const PLAY_TIMES:String = "playTimes";
      
      protected static const SCALE:String = "scale";
      
      protected static const OFFSET:String = "offset";
      
      protected static const POSITION:String = "position";
      
      protected static const DURATION:String = "duration";
      
      protected static const TWEEN_TYPE:String = "tweenType";
      
      protected static const TWEEN_EASING:String = "tweenEasing";
      
      protected static const TWEEN_ROTATE:String = "tweenRotate";
      
      protected static const TWEEN_SCALE:String = "tweenScale";
      
      protected static const CURVE:String = "curve";
      
      protected static const EVENT:String = "event";
      
      protected static const SOUND:String = "sound";
      
      protected static const ACTION:String = "action";
      
      protected static const DEFAULT_ACTIONS:String = "defaultActions";
      
      protected static const X:String = "x";
      
      protected static const Y:String = "y";
      
      protected static const SKEW_X:String = "skX";
      
      protected static const SKEW_Y:String = "skY";
      
      protected static const SCALE_X:String = "scX";
      
      protected static const SCALE_Y:String = "scY";
      
      protected static const ALPHA_OFFSET:String = "aO";
      
      protected static const RED_OFFSET:String = "rO";
      
      protected static const GREEN_OFFSET:String = "gO";
      
      protected static const BLUE_OFFSET:String = "bO";
      
      protected static const ALPHA_MULTIPLIER:String = "aM";
      
      protected static const RED_MULTIPLIER:String = "rM";
      
      protected static const GREEN_MULTIPLIER:String = "gM";
      
      protected static const BLUE_MULTIPLIER:String = "bM";
      
      protected static const UVS:String = "uvs";
      
      protected static const VERTICES:String = "vertices";
      
      protected static const TRIANGLES:String = "triangles";
      
      protected static const WEIGHTS:String = "weights";
      
      protected static const SLOT_POSE:String = "slotPose";
      
      protected static const BONE_POSE:String = "bonePose";
      
      protected static const COLOR_TRANSFORM:String = "colorTransform";
      
      protected static const TIMELINE:String = "timeline";
      
      protected static const IS_GLOBAL:String = "isGlobal";
      
      protected static const PIVOT_X:String = "pX";
      
      protected static const PIVOT_Y:String = "pY";
      
      protected static const Z:String = "z";
      
      protected static const LOOP:String = "loop";
      
      protected static const AUTO_TWEEN:String = "autoTween";
      
      protected static const HIDE:String = "hide";
      
      protected static const DEFAULT_NAME:String = "__default";
      
      protected var _isOldData:Boolean = false;
      
      protected var _isGlobalTransform:Boolean = false;
      
      protected var _isAutoTween:Boolean = false;
      
      protected var _animationTweenEasing:Number = 0;
      
      protected const _timelinePivot:Point = new Point();
      
      protected const _helpPoint:Point = new Point();
      
      protected const _helpTransformA:Transform = new Transform();
      
      protected const _helpTransformB:Transform = new Transform();
      
      protected const _helpMatrix:Matrix = new Matrix();
      
      protected const _rawBones:Vector.<BoneData> = new Vector.<BoneData>();
      
      protected var _data:DragonBonesData = null;
      
      protected var _armature:ArmatureData = null;
      
      protected var _skin:SkinData = null;
      
      protected var _skinSlotData:SkinSlotData = null;
      
      protected var _animation:AnimationData = null;
      
      protected var _timeline:TimelineData = null;
      
      public function DataParser(param1:DataParser)
      {
         super();
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      protected static function _getArmatureType(param1:String) : int
      {
         switch(param1.toLowerCase())
         {
            case "stage":
               return ArmatureType.Stage;
            case "armature":
               return ArmatureType.Armature;
            case "movieclip":
               return ArmatureType.MovieClip;
            default:
               return ArmatureType.None;
         }
      }
      
      protected static function _getDisplayType(param1:String) : int
      {
         switch(param1.toLowerCase())
         {
            case "image":
               return DisplayType.Image;
            case "armature":
               return DisplayType.Armature;
            case "mesh":
               return DisplayType.Mesh;
            case "boundingbox":
               return DisplayType.BoundingBox;
            default:
               return DisplayType.None;
         }
      }
      
      protected static function _getBoundingBoxType(param1:String) : int
      {
         switch(param1.toLowerCase())
         {
            case "rectangle":
               return BoundingBoxType.Rectangle;
            case "ellipse":
               return BoundingBoxType.Ellipse;
            case "polygon":
               return BoundingBoxType.Polygon;
            default:
               return BoundingBoxType.None;
         }
      }
      
      protected static function _getBlendMode(param1:String) : int
      {
         switch(param1.toLowerCase())
         {
            case "normal":
               return BlendMode.Normal;
            case "add":
               return BlendMode.Add;
            case "alpha":
               return BlendMode.Alpha;
            case "darken":
               return BlendMode.Darken;
            case "difference":
               return BlendMode.Difference;
            case "erase":
               return BlendMode.Erase;
            case "hardlight":
               return BlendMode.HardLight;
            case "invert":
               return BlendMode.Invert;
            case "layer":
               return BlendMode.Layer;
            case "lighten":
               return BlendMode.Lighten;
            case "multiply":
               return BlendMode.Multiply;
            case "overlay":
               return BlendMode.Overlay;
            case "screen":
               return BlendMode.Screen;
            case "subtract":
               return BlendMode.Subtract;
            default:
               return BlendMode.None;
         }
      }
      
      protected static function _getActionType(param1:String) : int
      {
         switch(param1.toLowerCase())
         {
            case "play":
               return ActionType.Play;
            default:
               return ActionType.None;
         }
      }
      
      public function parseDragonBonesData(param1:Object, param2:Number = 1) : DragonBonesData
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      public function parseTextureAtlasData(param1:Object, param2:TextureAtlasData, param3:Number = 0, param4:Number = 0) : void
      {
         throw new Error(DragonBones.ABSTRACT_METHOD_ERROR);
      }
      
      private function _getTimelineFrameMatrix(param1:AnimationData, param2:BoneTimelineData, param3:Number, param4:Transform) : void
      {
         var _loc6_:BoneFrameData = null;
         var _loc7_:Number = NaN;
         var _loc8_:BoneFrameData = null;
         var _loc5_:uint = uint(param3 * param1.frameCount / param1.duration);
         if(param2.frames.length == 1 || _loc5_ >= param2.frames.length)
         {
            param4.copyFrom((param2.frames[0] as BoneFrameData).transform);
         }
         else
         {
            _loc6_ = param2.frames[_loc5_] as BoneFrameData;
            _loc7_ = 0;
            if(_loc6_.tweenEasing != DragonBones.NO_TWEEN)
            {
               _loc7_ = (param3 - _loc6_.position) / _loc6_.duration;
               if(_loc6_.tweenEasing != 0)
               {
                  _loc7_ = TweenTimelineState.dragonBones_internal::_getEasingValue(_loc7_,_loc6_.tweenEasing);
               }
            }
            else if(_loc6_.curve)
            {
               _loc7_ = (param3 - _loc6_.position) / _loc6_.duration;
               _loc7_ = TweenTimelineState.dragonBones_internal::_getCurveEasingValue(_loc7_,_loc6_.curve);
            }
            _loc8_ = _loc6_.next as BoneFrameData;
            param4.x = _loc8_.transform.x - _loc6_.transform.x;
            param4.y = _loc8_.transform.y - _loc6_.transform.y;
            param4.skewX = Transform.normalizeRadian(_loc8_.transform.skewX - _loc6_.transform.skewX);
            param4.skewY = Transform.normalizeRadian(_loc8_.transform.skewY - _loc6_.transform.skewY);
            param4.scaleX = _loc8_.transform.scaleX - _loc6_.transform.scaleX;
            param4.scaleY = _loc8_.transform.scaleY - _loc6_.transform.scaleY;
            param4.x = _loc6_.transform.x + param4.x * _loc7_;
            param4.y = _loc6_.transform.y + param4.y * _loc7_;
            param4.skewX = _loc6_.transform.skewX + param4.skewX * _loc7_;
            param4.skewY = _loc6_.transform.skewY + param4.skewY * _loc7_;
            param4.scaleX = _loc6_.transform.scaleX + param4.scaleX * _loc7_;
            param4.scaleY = _loc6_.transform.scaleY + param4.scaleY * _loc7_;
         }
         param4.add(param2.originalTransform);
      }
      
      protected function _globalToLocal(param1:ArmatureData) : void
      {
         var _loc6_:BoneData = null;
         var _loc7_:BoneFrameData = null;
         var _loc8_:AnimationData = null;
         var _loc9_:BoneTimelineData = null;
         var _loc10_:BoneTimelineData = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc2_:Vector.<BoneFrameData> = new Vector.<BoneFrameData>();
         var _loc3_:Vector.<BoneData> = param1.sortedBones.concat().reverse();
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc3_.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc3_[_loc4_];
            if(_loc6_.parent)
            {
               _loc6_.parent.transform.toMatrix(this._helpMatrix);
               this._helpMatrix.invert();
               Transform.transformPoint(this._helpMatrix,_loc6_.transform.x,_loc6_.transform.y,this._helpPoint);
               _loc6_.transform.x = this._helpPoint.x;
               _loc6_.transform.y = this._helpPoint.y;
               _loc6_.transform.rotation -= _loc6_.parent.transform.rotation;
            }
            _loc7_ = null;
            for each(_loc8_ in param1.animations)
            {
               _loc9_ = _loc8_.getBoneTimeline(_loc6_.name);
               if(_loc9_)
               {
                  _loc10_ = _loc6_.parent ? _loc8_.getBoneTimeline(_loc6_.parent.name) : null;
                  this._helpTransformB.copyFrom(_loc9_.originalTransform);
                  _loc2_.length = 0;
                  _loc11_ = 0;
                  _loc12_ = _loc9_.frames.length;
                  while(_loc11_ < _loc12_)
                  {
                     _loc7_ = _loc9_.frames[_loc11_] as BoneFrameData;
                     if(_loc2_.indexOf(_loc7_) < 0)
                     {
                        _loc2_.push(_loc7_);
                        if(_loc10_)
                        {
                           this._getTimelineFrameMatrix(_loc8_,_loc10_,_loc7_.position,this._helpTransformA);
                           _loc7_.transform.add(this._helpTransformB);
                           this._helpTransformA.toMatrix(this._helpMatrix);
                           this._helpMatrix.invert();
                           Transform.transformPoint(this._helpMatrix,_loc7_.transform.x,_loc7_.transform.y,this._helpPoint);
                           _loc7_.transform.x = this._helpPoint.x;
                           _loc7_.transform.y = this._helpPoint.y;
                           _loc7_.transform.rotation -= this._helpTransformA.rotation;
                        }
                        else
                        {
                           _loc7_.transform.add(this._helpTransformB);
                        }
                        _loc7_.transform.minus(_loc6_.transform);
                        if(_loc11_ == 0)
                        {
                           _loc9_.originalTransform.copyFrom(_loc7_.transform);
                           _loc7_.transform.identity();
                        }
                        else
                        {
                           _loc7_.transform.minus(_loc9_.originalTransform);
                        }
                     }
                     _loc11_++;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      protected function _mergeFrameToAnimationTimeline(param1:Number, param2:Vector.<ActionData>, param3:Vector.<EventData>) : void
      {
         var _loc12_:AnimationFrameData = null;
         var _loc13_:AnimationFrameData = null;
         var _loc14_:AnimationFrameData = null;
         var _loc4_:uint = Math.floor(param1 * this._armature.frameRate);
         var _loc5_:Vector.<FrameData> = this._animation.frames;
         _loc5_.fixed = false;
         if(_loc5_.length == 0)
         {
            _loc12_ = BaseObject.borrowObject(AnimationFrameData) as AnimationFrameData;
            _loc12_.position = 0;
            if(this._animation.frameCount > 1)
            {
               _loc5_.length = this._animation.frameCount + 1;
               _loc13_ = BaseObject.borrowObject(AnimationFrameData) as AnimationFrameData;
               _loc13_.position = this._animation.frameCount / this._armature.frameRate;
               _loc5_[0] = _loc12_;
               _loc5_[this._animation.frameCount] = _loc13_;
            }
         }
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:AnimationFrameData = null;
         var _loc9_:AnimationFrameData = _loc5_.length ? _loc5_[_loc4_] as AnimationFrameData : null;
         if((Boolean(_loc9_)) && (_loc4_ == 0 || _loc5_[_loc4_ - 1] == _loc9_.prev))
         {
            _loc8_ = _loc9_;
         }
         else
         {
            _loc8_ = BaseObject.borrowObject(AnimationFrameData) as AnimationFrameData;
            _loc8_.position = _loc4_ / this._armature.frameRate;
            _loc5_[_loc4_] = _loc8_;
            _loc6_ = uint(_loc4_ + 1);
            _loc7_ = _loc5_.length;
            while(_loc6_ < _loc7_)
            {
               if(Boolean(_loc9_) && _loc5_[_loc6_] == _loc9_)
               {
                  _loc5_[_loc6_] = null;
               }
               _loc6_++;
            }
         }
         if(param2)
         {
            _loc8_.actions.fixed = false;
            _loc6_ = 0;
            _loc7_ = param2.length;
            while(_loc6_ < _loc7_)
            {
               _loc8_.actions.push(param2[_loc6_]);
               _loc6_++;
            }
            _loc8_.actions.fixed = true;
         }
         if(param3)
         {
            _loc8_.events.fixed = false;
            _loc6_ = 0;
            _loc7_ = param3.length;
            while(_loc6_ < _loc7_)
            {
               _loc8_.events.push(param3[_loc6_]);
               _loc6_++;
            }
            _loc8_.events.fixed = true;
         }
         var _loc10_:AnimationFrameData = null;
         var _loc11_:AnimationFrameData = null;
         _loc6_ = 0;
         _loc7_ = _loc5_.length;
         while(_loc6_ < _loc7_)
         {
            _loc14_ = _loc5_[_loc6_] as AnimationFrameData;
            if((Boolean(_loc14_)) && _loc11_ != _loc14_)
            {
               _loc11_ = _loc14_;
               if(_loc10_)
               {
                  _loc11_.prev = _loc10_;
                  _loc10_.next = _loc11_;
                  _loc10_.duration = _loc11_.position - _loc10_.position;
               }
               _loc10_ = _loc11_;
            }
            else
            {
               _loc5_[_loc6_] = _loc10_;
            }
            _loc6_++;
         }
         _loc11_.duration = this._animation.duration - _loc11_.position;
         _loc11_ = _loc5_[0] as AnimationFrameData;
         _loc10_.next = _loc11_;
         _loc11_.prev = _loc10_;
         _loc5_.fixed = true;
      }
   }
}

