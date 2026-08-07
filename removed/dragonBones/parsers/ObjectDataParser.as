package dragonBones.parsers
{
   import dragonBones.core.BaseObject;
   import dragonBones.core.DragonBones;
   import dragonBones.enum.ActionType;
   import dragonBones.enum.ArmatureType;
   import dragonBones.enum.BlendMode;
   import dragonBones.enum.BoundingBoxType;
   import dragonBones.enum.DisplayType;
   import dragonBones.enum.EventType;
   import dragonBones.geom.Transform;
   import dragonBones.objects.ActionData;
   import dragonBones.objects.AnimationConfig;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.AnimationFrameData;
   import dragonBones.objects.ArmatureData;
   import dragonBones.objects.BoneData;
   import dragonBones.objects.BoneFrameData;
   import dragonBones.objects.BoneTimelineData;
   import dragonBones.objects.BoundingBoxData;
   import dragonBones.objects.CustomData;
   import dragonBones.objects.DisplayData;
   import dragonBones.objects.DragonBonesData;
   import dragonBones.objects.EventData;
   import dragonBones.objects.ExtensionFrameData;
   import dragonBones.objects.FFDTimelineData;
   import dragonBones.objects.FrameData;
   import dragonBones.objects.MeshData;
   import dragonBones.objects.SkinData;
   import dragonBones.objects.SkinSlotData;
   import dragonBones.objects.SlotData;
   import dragonBones.objects.SlotFrameData;
   import dragonBones.objects.SlotTimelineData;
   import dragonBones.objects.TimelineData;
   import dragonBones.objects.TweenFrameData;
   import dragonBones.objects.ZOrderFrameData;
   import dragonBones.objects.ZOrderTimelineData;
   import dragonBones.textures.TextureAtlasData;
   import dragonBones.textures.TextureData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public class ObjectDataParser extends DataParser
   {
      
      private static var _instance:ObjectDataParser = null;
      
      public function ObjectDataParser()
      {
         super(this);
      }
      
      protected static function _getBoolean(param1:Object, param2:String, param3:Boolean) : Boolean
      {
         var _loc4_:* = undefined;
         if(!(param2 in param1))
         {
            return param3;
         }
         _loc4_ = param1[param2];
         if(_loc4_ is Boolean || _loc4_ is Number)
         {
            return _loc4_;
         }
         if(!(_loc4_ is String))
         {
            return _loc4_;
         }
         switch(_loc4_)
         {
            case "0":
            case "NaN":
            case "":
            case "false":
            case "null":
            case "undefined":
               return false;
            default:
               return true;
         }
      }
      
      protected static function _getNumber(param1:Object, param2:String, param3:Number) : Number
      {
         var _loc4_:* = undefined;
         if(param2 in param1)
         {
            _loc4_ = param1[param2];
            if(_loc4_ == null || _loc4_ == "NaN")
            {
               return param3;
            }
            return _loc4_;
         }
         return param3;
      }
      
      protected static function _getString(param1:Object, param2:String, param3:String) : String
      {
         if(param2 in param1)
         {
            return param1[param2];
         }
         return param3;
      }
      
      public static function getInstance() : ObjectDataParser
      {
         if(!_instance)
         {
            _instance = new ObjectDataParser();
         }
         return _instance;
      }
      
      protected function _parseArmature(param1:Object, param2:Number) : ArmatureData
      {
         var _loc4_:Object = null;
         var _loc5_:BoneData = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc3_:ArmatureData = BaseObject.borrowObject(ArmatureData) as ArmatureData;
         _loc3_.name = _getString(param1,NAME,null);
         _loc3_.frameRate = uint(_getNumber(param1,FRAME_RATE,_data.frameRate)) || _data.frameRate;
         _loc3_.scale = param2;
         if(TYPE in param1 && param1[TYPE] is String)
         {
            _loc3_.type = _getArmatureType(param1[TYPE]);
         }
         else
         {
            _loc3_.type = _getNumber(param1,TYPE,ArmatureType.Armature);
         }
         _armature = _loc3_;
         _rawBones.length = 0;
         if(BONE in param1)
         {
            for each(_loc4_ in param1[BONE])
            {
               _loc5_ = this._parseBone(_loc4_);
               _loc3_.addBone(_loc5_,_getString(_loc4_,PARENT,null));
               _rawBones.push(_loc5_);
            }
         }
         if(IK in param1)
         {
            for each(_loc6_ in param1[IK])
            {
               this._parseIK(_loc6_);
            }
         }
         if(SLOT in param1)
         {
            _loc7_ = 0;
            for each(_loc8_ in param1[SLOT])
            {
               _loc3_.addSlot(this._parseSlot(_loc8_,_loc7_++));
            }
         }
         if(SKIN in param1)
         {
            for each(_loc9_ in param1[SKIN])
            {
               _loc3_.addSkin(this._parseSkin(_loc9_));
            }
         }
         if(ANIMATION in param1)
         {
            for each(_loc10_ in param1[ANIMATION])
            {
               _loc3_.addAnimation(this._parseAnimation(_loc10_));
            }
         }
         if(ACTIONS in param1 || DEFAULT_ACTIONS in param1)
         {
            this._parseActionData(param1,_loc3_.actions,null,null);
         }
         if(_isOldData && _isGlobalTransform)
         {
            _globalToLocal(_loc3_);
         }
         _armature = null;
         _rawBones.length = 0;
         return _loc3_;
      }
      
      protected function _parseBone(param1:Object) : BoneData
      {
         var _loc2_:BoneData = BaseObject.borrowObject(BoneData) as BoneData;
         _loc2_.name = _getString(param1,NAME,null);
         _loc2_.inheritTranslation = _getBoolean(param1,INHERIT_TRANSLATION,true);
         _loc2_.inheritRotation = _getBoolean(param1,INHERIT_ROTATION,true);
         _loc2_.inheritScale = _getBoolean(param1,INHERIT_SCALE,true);
         _loc2_.length = _getNumber(param1,LENGTH,0) * _armature.scale;
         if(TRANSFORM in param1)
         {
            this._parseTransform(param1[TRANSFORM],_loc2_.transform);
         }
         if(_isOldData)
         {
            _loc2_.inheritScale = false;
         }
         return _loc2_;
      }
      
      protected function _parseIK(param1:Object) : void
      {
         var _loc2_:BoneData = _armature.getBone(_getString(param1,BONE in param1 ? BONE : NAME,null));
         if(_loc2_)
         {
            _loc2_.ik = _armature.getBone(_getString(param1,TARGET,null));
            _loc2_.bendPositive = _getBoolean(param1,BEND_POSITIVE,true);
            _loc2_.chain = _getNumber(param1,CHAIN,0);
            _loc2_.weight = _getNumber(param1,WEIGHT,1);
            if(_loc2_.chain > 0 && _loc2_.parent && !_loc2_.parent.ik)
            {
               _loc2_.parent.ik = _loc2_.ik;
               _loc2_.parent.chainIndex = 0;
               _loc2_.parent.chain = 0;
               _loc2_.chainIndex = 1;
            }
            else
            {
               _loc2_.chain = 0;
               _loc2_.chainIndex = 0;
            }
         }
      }
      
      protected function _parseSlot(param1:Object, param2:int) : SlotData
      {
         var _loc3_:SlotData = BaseObject.borrowObject(SlotData) as SlotData;
         _loc3_.name = _getString(param1,NAME,null);
         _loc3_.parent = _armature.getBone(_getString(param1,PARENT,null));
         _loc3_.displayIndex = _getNumber(param1,DISPLAY_INDEX,0);
         _loc3_.zOrder = _getNumber(param1,Z,param2);
         if(COLOR in param1)
         {
            _loc3_.color = SlotData.generateColor();
            this._parseColorTransform(param1[COLOR],_loc3_.color);
         }
         else
         {
            _loc3_.color = SlotData.DEFAULT_COLOR;
         }
         if(BLEND_MODE in param1 && param1[BLEND_MODE] is String)
         {
            _loc3_.blendMode = _getBlendMode(param1[BLEND_MODE]);
         }
         else
         {
            _loc3_.blendMode = _getNumber(param1,BLEND_MODE,BlendMode.Normal);
         }
         if(ACTIONS in param1 || DEFAULT_ACTIONS in param1)
         {
            this._parseActionData(param1,_loc3_.actions,null,null);
         }
         if(_isOldData)
         {
            if(COLOR_TRANSFORM in param1)
            {
               _loc3_.color = SlotData.generateColor();
               this._parseColorTransform(param1[COLOR_TRANSFORM],_loc3_.color);
            }
            else
            {
               _loc3_.color = SlotData.DEFAULT_COLOR;
            }
         }
         return _loc3_;
      }
      
      protected function _parseSkin(param1:Object) : SkinData
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:SkinData = BaseObject.borrowObject(SkinData) as SkinData;
         _loc2_.name = _getString(param1,NAME,DEFAULT_NAME) || DEFAULT_NAME;
         if(SLOT in param1)
         {
            _skin = _loc2_;
            _loc3_ = 0;
            for each(_loc4_ in param1[SLOT])
            {
               if(_isOldData)
               {
                  _armature.addSlot(this._parseSlot(_loc4_,_loc3_++));
               }
               _loc2_.addSlot(this._parseSlotDisplaySet(_loc4_));
            }
            _skin = null;
         }
         return _loc2_;
      }
      
      protected function _parseSlotDisplaySet(param1:Object) : SkinSlotData
      {
         var _loc3_:Array = null;
         var _loc4_:Vector.<DisplayData> = null;
         var _loc5_:Object = null;
         var _loc2_:SkinSlotData = BaseObject.borrowObject(SkinSlotData) as SkinSlotData;
         _loc2_.slot = _armature.getSlot(_getString(param1,NAME,null));
         if(DISPLAY in param1)
         {
            _loc3_ = param1[DISPLAY];
            _loc4_ = _loc2_.displays;
            _skinSlotData = _loc2_;
            for each(_loc5_ in _loc3_)
            {
               _loc4_.push(this._parseDisplay(_loc5_));
            }
            _loc4_.fixed = true;
            _skinSlotData = null;
         }
         return _loc2_;
      }
      
      protected function _parseDisplay(param1:Object) : DisplayData
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc2_:DisplayData = BaseObject.borrowObject(DisplayData) as DisplayData;
         _loc2_.name = _getString(param1,NAME,null);
         _loc2_.path = _getString(param1,PATH,_loc2_.name);
         if(TYPE in param1 && param1[TYPE] is String)
         {
            _loc2_.type = _getDisplayType(param1[TYPE]);
         }
         else
         {
            _loc2_.type = _getNumber(param1,TYPE,DisplayType.Image);
         }
         _loc2_.isRelativePivot = true;
         if(PIVOT in param1)
         {
            _loc3_ = param1[PIVOT];
            _loc2_.pivot.x = _getNumber(_loc3_,X,0);
            _loc2_.pivot.y = _getNumber(_loc3_,Y,0);
         }
         else if(_isOldData)
         {
            _loc4_ = param1[TRANSFORM];
            _loc2_.isRelativePivot = false;
            _loc2_.pivot.x = _getNumber(_loc4_,PIVOT_X,0) * _armature.scale;
            _loc2_.pivot.y = _getNumber(_loc4_,PIVOT_Y,0) * _armature.scale;
         }
         else
         {
            _loc2_.pivot.x = 0.5;
            _loc2_.pivot.y = 0.5;
         }
         if(TRANSFORM in param1)
         {
            this._parseTransform(param1[TRANSFORM],_loc2_.transform);
         }
         switch(_loc2_.type)
         {
            case DisplayType.Image:
            case DisplayType.Armature:
               break;
            case DisplayType.Mesh:
               _loc2_.share = _getString(param1,SHARE,null);
               if(!_loc2_.share)
               {
                  _loc2_.mesh = this._parseMesh(param1);
                  _skinSlotData.addMesh(_loc2_.mesh);
               }
               break;
            case DisplayType.BoundingBox:
               _loc2_.boundingBox = this._parseBoundingBox(param1);
         }
         return _loc2_;
      }
      
      protected function _parseBoundingBox(param1:Object) : BoundingBoxData
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:BoundingBoxData = BaseObject.borrowObject(BoundingBoxData) as BoundingBoxData;
         if(SUB_TYPE in param1 && param1[SUB_TYPE] is String)
         {
            _loc2_.type = _getBoundingBoxType(param1[SUB_TYPE]);
         }
         else
         {
            _loc2_.type = _getNumber(param1,SUB_TYPE,BoundingBoxType.Rectangle);
         }
         _loc2_.color = _getNumber(param1,COLOR,0);
         switch(_loc2_.type)
         {
            case BoundingBoxType.Rectangle:
            case BoundingBoxType.Ellipse:
               _loc2_.width = _getNumber(param1,WIDTH,0);
               _loc2_.height = _getNumber(param1,HEIGHT,0);
               break;
            case BoundingBoxType.Polygon:
               if(VERTICES in param1)
               {
                  _loc3_ = param1[VERTICES];
                  _loc2_.vertices.length = _loc3_.length;
                  _loc2_.vertices.fixed = true;
                  _loc4_ = 0;
                  _loc5_ = _loc2_.vertices.length;
                  while(_loc4_ < _loc5_)
                  {
                     _loc6_ = uint(_loc4_ + 1);
                     _loc7_ = Number(_loc3_[_loc4_]);
                     _loc8_ = Number(_loc3_[_loc6_]);
                     _loc2_.vertices[_loc4_] = _loc7_;
                     _loc2_.vertices[_loc6_] = _loc8_;
                     if(_loc4_ === 0)
                     {
                        _loc2_.x = _loc7_;
                        _loc2_.y = _loc8_;
                        _loc2_.width = _loc7_;
                        _loc2_.height = _loc8_;
                     }
                     else
                     {
                        if(_loc7_ < _loc2_.x)
                        {
                           _loc2_.x = _loc7_;
                        }
                        else if(_loc7_ > _loc2_.width)
                        {
                           _loc2_.width = _loc7_;
                        }
                        if(_loc8_ < _loc2_.y)
                        {
                           _loc2_.y = _loc8_;
                        }
                        else if(_loc8_ > _loc2_.height)
                        {
                           _loc2_.height = _loc8_;
                        }
                     }
                     _loc4_ += 2;
                  }
               }
         }
         return _loc2_;
      }
      
      protected function _parseMesh(param1:Object) : MeshData
      {
         var _loc3_:Array = null;
         var _loc5_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Matrix = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Array = null;
         var _loc20_:uint = 0;
         var _loc21_:Vector.<uint> = null;
         var _loc22_:Vector.<Number> = null;
         var _loc23_:Vector.<Number> = null;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:BoneData = null;
         var _loc28_:int = 0;
         var _loc2_:MeshData = BaseObject.borrowObject(MeshData) as MeshData;
         _loc3_ = param1[VERTICES];
         var _loc4_:Array = param1[UVS];
         _loc5_ = param1[TRIANGLES];
         var _loc6_:uint = uint(_loc3_.length / 2);
         var _loc7_:uint = uint(_loc5_.length / 3);
         var _loc8_:Vector.<Matrix> = new Vector.<Matrix>(_armature.sortedBones.length,true);
         _loc2_.skinned = WEIGHTS in param1 && (param1[WEIGHTS] as Array).length > 0;
         _loc2_.name = _getString(param1,NAME,null);
         _loc2_.uvs.length = _loc6_ * 2;
         _loc2_.uvs.fixed = true;
         _loc2_.vertices.length = _loc6_ * 2;
         _loc2_.vertices.fixed = true;
         _loc2_.vertexIndices.length = _loc7_ * 3;
         _loc2_.vertexIndices.fixed = true;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(_loc2_.skinned)
         {
            _loc2_.boneIndices.length = _loc6_;
            _loc2_.boneIndices.fixed = true;
            _loc2_.weights.length = _loc6_;
            _loc2_.weights.fixed = true;
            _loc2_.boneVertices.length = _loc6_;
            _loc2_.boneVertices.fixed = true;
            if(SLOT_POSE in param1)
            {
               _loc12_ = param1[SLOT_POSE];
               _loc2_.slotPose.a = _loc12_[0];
               _loc2_.slotPose.b = _loc12_[1];
               _loc2_.slotPose.c = _loc12_[2];
               _loc2_.slotPose.d = _loc12_[3];
               _loc2_.slotPose.tx = _loc12_[4] * _armature.scale;
               _loc2_.slotPose.ty = _loc12_[5] * _armature.scale;
            }
            if(BONE_POSE in param1)
            {
               _loc13_ = param1[BONE_POSE];
               _loc10_ = 0;
               _loc9_ = _loc13_.length;
               while(_loc10_ < _loc9_)
               {
                  _loc14_ = _loc8_[_loc13_[_loc10_]] = new Matrix();
                  _loc14_.a = _loc13_[_loc10_ + 1];
                  _loc14_.b = _loc13_[_loc10_ + 2];
                  _loc14_.c = _loc13_[_loc10_ + 3];
                  _loc14_.d = _loc13_[_loc10_ + 4];
                  _loc14_.tx = _loc13_[_loc10_ + 5] * _armature.scale;
                  _loc14_.ty = _loc13_[_loc10_ + 6] * _armature.scale;
                  _loc14_.invert();
                  _loc10_ += 7;
               }
            }
         }
         var _loc11_:uint = 0;
         _loc10_ = 0;
         _loc9_ = _loc3_.length;
         while(_loc10_ < _loc9_)
         {
            _loc15_ = uint(_loc10_ + 1);
            _loc16_ = _loc10_ / 2;
            _loc17_ = _loc2_.vertices[_loc10_] = _loc3_[_loc10_] * _armature.scale;
            _loc18_ = _loc2_.vertices[_loc15_] = _loc3_[_loc15_] * _armature.scale;
            _loc2_.uvs[_loc10_] = _loc4_[_loc10_];
            _loc2_.uvs[_loc15_] = _loc4_[_loc15_];
            if(_loc2_.skinned)
            {
               _loc19_ = param1[WEIGHTS];
               _loc20_ = uint(_loc19_[_loc11_]);
               _loc21_ = _loc2_.boneIndices[_loc16_] = new Vector.<uint>(_loc20_,true);
               _loc22_ = _loc2_.weights[_loc16_] = new Vector.<Number>(_loc20_,true);
               _loc23_ = _loc2_.boneVertices[_loc16_] = new Vector.<Number>(_loc20_ * 2,true);
               Transform.transformPoint(_loc2_.slotPose,_loc17_,_loc18_,_helpPoint);
               _loc17_ = _loc2_.vertices[_loc10_] = _helpPoint.x;
               _loc18_ = _loc2_.vertices[_loc15_] = _helpPoint.y;
               _loc24_ = 0;
               while(_loc24_ < _loc20_)
               {
                  _loc25_ = _loc11_ + 1 + _loc24_ * 2;
                  _loc26_ = uint(_loc19_[_loc25_]);
                  _loc27_ = _rawBones[_loc26_];
                  _loc28_ = int(_loc2_.bones.indexOf(_loc27_));
                  if(_loc28_ < 0)
                  {
                     _loc28_ = int(_loc2_.bones.length);
                     _loc2_.bones[_loc28_] = _loc27_;
                     _loc2_.inverseBindPose[_loc28_] = _loc8_[_loc26_];
                  }
                  Transform.transformPoint(_loc2_.inverseBindPose[_loc28_],_loc17_,_loc18_,_helpPoint);
                  _loc21_[_loc24_] = _loc28_;
                  _loc22_[_loc24_] = _loc19_[_loc25_ + 1];
                  _loc23_[_loc24_ * 2] = _helpPoint.x;
                  _loc23_[_loc24_ * 2 + 1] = _helpPoint.y;
                  _loc24_++;
               }
               _loc11_ += _loc20_ * 2 + 1;
               _loc21_.fixed = true;
               _loc22_.fixed = true;
               _loc23_.fixed = true;
            }
            _loc10_ += 2;
         }
         _loc2_.bones.fixed = true;
         _loc2_.inverseBindPose.fixed = true;
         _loc10_ = 0;
         _loc9_ = _loc5_.length;
         while(_loc10_ < _loc9_)
         {
            _loc2_.vertexIndices[_loc10_] = _loc5_[_loc10_];
            _loc10_++;
         }
         return _loc2_;
      }
      
      protected function _parseAnimation(param1:Object) : AnimationData
      {
         var _loc3_:BoneData = null;
         var _loc4_:SlotData = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:BoneTimelineData = null;
         var _loc12_:BoneFrameData = null;
         var _loc13_:SlotTimelineData = null;
         var _loc14_:SlotFrameData = null;
         var _loc2_:AnimationData = BaseObject.borrowObject(AnimationData) as AnimationData;
         _loc2_.name = _getString(param1,NAME,DEFAULT_NAME) || DEFAULT_NAME;
         _loc2_.frameCount = Math.max(_getNumber(param1,DURATION,1),1);
         _loc2_.duration = _loc2_.frameCount / _armature.frameRate;
         _loc2_.playTimes = _getNumber(param1,PLAY_TIMES,1);
         _loc2_.fadeInTime = _getNumber(param1,FADE_IN_TIME,0);
         _animation = _loc2_;
         this._parseTimeline(param1,_loc2_,this._parseAnimationFrame);
         if(Z_ORDER in param1)
         {
            _loc2_.zOrderTimeline = BaseObject.borrowObject(ZOrderTimelineData) as ZOrderTimelineData;
            this._parseTimeline(param1[Z_ORDER],_loc2_.zOrderTimeline,this._parseZOrderFrame);
         }
         if(BONE in param1)
         {
            for each(_loc5_ in param1[BONE])
            {
               _loc2_.addBoneTimeline(this._parseBoneTimeline(_loc5_));
            }
         }
         if(SLOT in param1)
         {
            for each(_loc6_ in param1[SLOT])
            {
               _loc2_.addSlotTimeline(this._parseSlotTimeline(_loc6_));
            }
         }
         if(FFD in param1)
         {
            for each(_loc7_ in param1[FFD])
            {
               _loc2_.addFFDTimeline(this._parseFFDTimeline(_loc7_));
            }
         }
         if(_isOldData)
         {
            _isAutoTween = _getBoolean(param1,AUTO_TWEEN,true);
            _animationTweenEasing = _getNumber(param1,TWEEN_EASING,0) || 0;
            _loc2_.playTimes = _getNumber(param1,LOOP,1);
            if(TIMELINE in param1)
            {
               _loc8_ = param1[TIMELINE];
               _loc9_ = 0;
               _loc10_ = _loc8_.length;
               while(_loc9_ < _loc10_)
               {
                  _loc2_.addBoneTimeline(this._parseBoneTimeline(_loc8_[_loc9_]));
                  _loc9_++;
               }
               _loc9_ = 0;
               _loc10_ = _loc8_.length;
               while(_loc9_ < _loc10_)
               {
                  _loc2_.addSlotTimeline(this._parseSlotTimeline(_loc8_[_loc9_]));
                  _loc9_++;
               }
            }
         }
         else
         {
            _isAutoTween = false;
            _animationTweenEasing = 0;
         }
         for each(_loc3_ in _armature.bones)
         {
            if(!_loc2_.getBoneTimeline(_loc3_.name))
            {
               _loc11_ = BaseObject.borrowObject(BoneTimelineData) as BoneTimelineData;
               _loc12_ = BaseObject.borrowObject(BoneFrameData) as BoneFrameData;
               _loc11_.bone = _loc3_;
               _loc11_.frames.fixed = false;
               _loc11_.frames[0] = _loc12_;
               _loc11_.frames.fixed = true;
               _loc2_.addBoneTimeline(_loc11_);
            }
         }
         for each(_loc4_ in _armature.slots)
         {
            if(!_loc2_.getSlotTimeline(_loc4_.name))
            {
               _loc13_ = BaseObject.borrowObject(SlotTimelineData) as SlotTimelineData;
               _loc14_ = BaseObject.borrowObject(SlotFrameData) as SlotFrameData;
               _loc13_.slot = _loc4_;
               _loc14_.displayIndex = _loc4_.displayIndex;
               if(_loc4_.color == SlotData.DEFAULT_COLOR)
               {
                  _loc14_.color = SlotFrameData.DEFAULT_COLOR;
               }
               else
               {
                  _loc14_.color = SlotFrameData.generateColor();
                  _loc14_.color.alphaMultiplier = _loc4_.color.alphaMultiplier;
                  _loc14_.color.redMultiplier = _loc4_.color.redMultiplier;
                  _loc14_.color.greenMultiplier = _loc4_.color.greenMultiplier;
                  _loc14_.color.blueMultiplier = _loc4_.color.blueMultiplier;
                  _loc14_.color.alphaOffset = _loc4_.color.alphaOffset;
                  _loc14_.color.redOffset = _loc4_.color.redOffset;
                  _loc14_.color.greenOffset = _loc4_.color.greenOffset;
                  _loc14_.color.blueOffset = _loc4_.color.blueOffset;
               }
               _loc13_.frames.fixed = false;
               _loc13_.frames[0] = _loc14_;
               _loc13_.frames.fixed = true;
               _loc2_.addSlotTimeline(_loc13_);
               if(_isOldData)
               {
                  _loc14_.displayIndex = -1;
               }
            }
         }
         _animation = null;
         return _loc2_;
      }
      
      protected function _parseBoneTimeline(param1:Object) : BoneTimelineData
      {
         var _loc2_:BoneTimelineData = null;
         var _loc5_:BoneFrameData = null;
         _loc2_ = BaseObject.borrowObject(BoneTimelineData) as BoneTimelineData;
         _loc2_.bone = _armature.getBone(_getString(param1,NAME,null));
         this._parseTimeline(param1,_loc2_,this._parseBoneFrame);
         var _loc3_:Transform = _loc2_.originalTransform;
         var _loc4_:BoneFrameData = null;
         for each(_loc5_ in _loc2_.frames)
         {
            if(!_loc4_)
            {
               _loc3_.copyFrom(_loc5_.transform);
               _loc5_.transform.identity();
               if(_loc3_.scaleX == 0)
               {
                  _loc3_.scaleX = 0.001;
               }
               if(_loc3_.scaleY == 0)
               {
                  _loc3_.scaleY = 0.001;
               }
            }
            else if(_loc4_ != _loc5_)
            {
               _loc5_.transform.minus(_loc3_);
            }
            _loc4_ = _loc5_;
         }
         if(_isOldData && (PIVOT_X in param1 || PIVOT_Y in param1))
         {
            _timelinePivot.x = _getNumber(param1,PIVOT_X,0) * _armature.scale;
            _timelinePivot.y = _getNumber(param1,PIVOT_Y,0) * _armature.scale;
         }
         else
         {
            _timelinePivot.x = 0;
            _timelinePivot.y = 0;
         }
         return _loc2_;
      }
      
      protected function _parseSlotTimeline(param1:Object) : SlotTimelineData
      {
         var _loc2_:SlotTimelineData = BaseObject.borrowObject(SlotTimelineData) as SlotTimelineData;
         _loc2_.slot = _armature.getSlot(_getString(param1,NAME,null));
         this._parseTimeline(param1,_loc2_,this._parseSlotFrame);
         return _loc2_;
      }
      
      protected function _parseFFDTimeline(param1:Object) : FFDTimelineData
      {
         var _loc6_:DisplayData = null;
         var _loc2_:FFDTimelineData = BaseObject.borrowObject(FFDTimelineData) as FFDTimelineData;
         _loc2_.skin = _armature.getSkin(_getString(param1,SKIN,null));
         _loc2_.slot = _loc2_.skin.getSlot(_getString(param1,SLOT,null));
         var _loc3_:String = _getString(param1,NAME,null);
         var _loc4_:uint = 0;
         var _loc5_:uint = _loc2_.slot.displays.length;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc2_.slot.displays[_loc4_];
            if(Boolean(_loc6_.mesh) && _loc6_.name == _loc3_)
            {
               _loc2_.display = _loc6_;
               break;
            }
            _loc4_++;
         }
         this._parseTimeline(param1,_loc2_,this._parseFFDFrame);
         return _loc2_;
      }
      
      protected function _parseAnimationFrame(param1:Object, param2:uint, param3:uint) : AnimationFrameData
      {
         var _loc4_:AnimationFrameData = BaseObject.borrowObject(AnimationFrameData) as AnimationFrameData;
         this._parseFrame(param1,_loc4_,param2,param3);
         if(ACTION in param1 || ACTIONS in param1)
         {
            this._parseActionData(param1,_loc4_.actions,null,null);
         }
         if(EVENTS in param1 || EVENT in param1 || SOUND in param1)
         {
            this._parseEventData(param1,_loc4_.events,null,null);
         }
         return _loc4_;
      }
      
      protected function _parseZOrderFrame(param1:Object, param2:uint, param3:uint) : ZOrderFrameData
      {
         var _loc6_:uint = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc4_:ZOrderFrameData = BaseObject.borrowObject(ZOrderFrameData) as ZOrderFrameData;
         this._parseFrame(param1,_loc4_,param2,param3);
         var _loc5_:Array = param1[Z_ORDER] as Array;
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc6_ = _armature.sortedSlots.length;
            _loc7_ = new Vector.<int>(_loc6_ - _loc5_.length / 2);
            _loc4_.zOrder.length = _loc6_;
            _loc8_ = 0;
            _loc9_ = _loc6_;
            while(_loc8_ < _loc9_)
            {
               _loc4_.zOrder[_loc8_] = -1;
               _loc8_++;
            }
            _loc10_ = 0;
            _loc11_ = 0;
            _loc8_ = 0;
            _loc9_ = _loc5_.length;
            while(_loc8_ < _loc9_)
            {
               _loc12_ = int(_loc5_[_loc8_]);
               _loc13_ = int(_loc5_[_loc8_ + 1]);
               while(_loc10_ != _loc12_)
               {
                  var _loc14_:*;
                  _loc7_[_loc14_ = _loc11_++] = _loc10_++;
               }
               _loc4_.zOrder[_loc10_ + _loc13_] = _loc10_++;
               _loc8_ += 2;
            }
            while(_loc10_ < _loc6_)
            {
               _loc7_[_loc14_ = _loc11_++] = _loc10_++;
            }
            _loc8_ = _loc6_;
            while(_loc8_--)
            {
               if(_loc4_.zOrder[_loc8_] == -1)
               {
                  _loc4_.zOrder[_loc8_] = _loc7_[--_loc11_];
               }
            }
         }
         return _loc4_;
      }
      
      protected function _parseBoneFrame(param1:Object, param2:uint, param3:uint) : BoneFrameData
      {
         var _loc8_:Object = null;
         var _loc9_:SlotData = null;
         var _loc4_:BoneFrameData = BaseObject.borrowObject(BoneFrameData) as BoneFrameData;
         _loc4_.tweenRotate = _getNumber(param1,TWEEN_ROTATE,0);
         _loc4_.tweenScale = _getBoolean(param1,TWEEN_SCALE,true);
         this._parseTweenFrame(param1,_loc4_,param2,param3);
         if(TRANSFORM in param1)
         {
            _loc8_ = param1[TRANSFORM];
            this._parseTransform(param1[TRANSFORM],_loc4_.transform);
            if(_isOldData)
            {
               _helpPoint.x = _timelinePivot.x + _getNumber(_loc8_,PIVOT_X,0) * _armature.scale;
               _helpPoint.y = _timelinePivot.y + _getNumber(_loc8_,PIVOT_Y,0) * _armature.scale;
               _loc4_.transform.toMatrix(_helpMatrix);
               Transform.transformPoint(_helpMatrix,_helpPoint.x,_helpPoint.y,_helpPoint,true);
               _loc4_.transform.x += _helpPoint.x;
               _loc4_.transform.y += _helpPoint.y;
            }
         }
         var _loc5_:BoneData = (_timeline as BoneTimelineData).bone;
         var _loc6_:Vector.<ActionData> = new Vector.<ActionData>();
         var _loc7_:Vector.<EventData> = new Vector.<EventData>();
         if(ACTION in param1 || ACTIONS in param1)
         {
            _loc9_ = _armature.getSlot(_loc5_.name);
            this._parseActionData(param1,_loc6_,_loc5_,_loc9_);
         }
         if(EVENT in param1 || SOUND in param1)
         {
            this._parseEventData(param1,_loc7_,_loc5_,null);
         }
         if(_loc6_.length > 0 || _loc7_.length > 0)
         {
            _mergeFrameToAnimationTimeline(_loc4_.position,_loc6_,_loc7_);
         }
         return _loc4_;
      }
      
      protected function _parseSlotFrame(param1:Object, param2:uint, param3:uint) : SlotFrameData
      {
         var _loc5_:SlotData = null;
         var _loc6_:Vector.<ActionData> = null;
         var _loc4_:SlotFrameData = BaseObject.borrowObject(SlotFrameData) as SlotFrameData;
         _loc4_.displayIndex = _getNumber(param1,DISPLAY_INDEX,0);
         this._parseTweenFrame(param1,_loc4_,param2,param3);
         if(COLOR in param1 || COLOR_TRANSFORM in param1)
         {
            _loc4_.color = SlotFrameData.generateColor();
            this._parseColorTransform(param1[COLOR] || param1[COLOR_TRANSFORM],_loc4_.color);
         }
         else
         {
            _loc4_.color = SlotFrameData.DEFAULT_COLOR;
         }
         if(_isOldData)
         {
            if(_getBoolean(param1,HIDE,false))
            {
               _loc4_.displayIndex = -1;
            }
         }
         else if(ACTION in param1 || ACTIONS in param1)
         {
            _loc5_ = (_timeline as SlotTimelineData).slot;
            _loc6_ = new Vector.<ActionData>();
            this._parseActionData(param1,_loc6_,_loc5_.parent,_loc5_);
            _mergeFrameToAnimationTimeline(_loc4_.position,_loc6_,null);
         }
         return _loc4_;
      }
      
      protected function _parseFFDFrame(param1:Object, param2:uint, param3:uint) : ExtensionFrameData
      {
         var _loc4_:FFDTimelineData = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         _loc4_ = _timeline as FFDTimelineData;
         var _loc5_:MeshData = _loc4_.display.mesh;
         var _loc6_:ExtensionFrameData = BaseObject.borrowObject(ExtensionFrameData) as ExtensionFrameData;
         this._parseTweenFrame(param1,_loc6_,param2,param3);
         var _loc7_:Array = param1[VERTICES];
         var _loc8_:uint = _getNumber(param1,OFFSET,0);
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = _loc5_.vertices.length;
         while(_loc11_ < _loc12_)
         {
            if(!_loc7_ || _loc11_ < _loc8_ || _loc11_ - _loc8_ >= _loc7_.length)
            {
               _loc9_ = 0;
               _loc10_ = 0;
            }
            else
            {
               _loc9_ = _loc7_[_loc11_ - _loc8_] * _armature.scale;
               _loc10_ = _loc7_[_loc11_ + 1 - _loc8_] * _armature.scale;
            }
            if(_loc5_.skinned)
            {
               Transform.transformPoint(_loc5_.slotPose,_loc9_,_loc10_,_helpPoint,true);
               _loc9_ = _helpPoint.x;
               _loc10_ = _helpPoint.y;
               _loc13_ = _loc5_.boneIndices[_loc11_ / 2];
               _loc14_ = 0;
               _loc15_ = _loc13_.length;
               while(_loc14_ < _loc15_)
               {
                  _loc16_ = _loc13_[_loc14_];
                  Transform.transformPoint(_loc5_.inverseBindPose[_loc16_],_loc9_,_loc10_,_helpPoint,true);
                  _loc6_.tweens.push(_helpPoint.x,_helpPoint.y);
                  _loc14_++;
               }
            }
            else
            {
               _loc6_.tweens.push(_loc9_,_loc10_);
            }
            _loc11_ += 2;
         }
         _loc6_.tweens.fixed = true;
         return _loc6_;
      }
      
      protected function _parseTweenFrame(param1:Object, param2:TweenFrameData, param3:uint, param4:uint) : void
      {
         this._parseFrame(param1,param2,param3,param4);
         if(param2.duration > 0)
         {
            if(TWEEN_EASING in param1)
            {
               param2.tweenEasing = _getNumber(param1,TWEEN_EASING,DragonBones.NO_TWEEN);
            }
            else if(_isOldData)
            {
               param2.tweenEasing = _isAutoTween ? _animationTweenEasing : DragonBones.NO_TWEEN;
            }
            else
            {
               param2.tweenEasing = DragonBones.NO_TWEEN;
            }
            if(_isOldData && _animation.scale == 1 && _timeline.scale == 1 && param2.duration * _armature.frameRate < 2)
            {
               param2.tweenEasing = DragonBones.NO_TWEEN;
            }
            if(CURVE in param1)
            {
               param2.curve = new Vector.<Number>(param4 * 2 - 1,true);
               TweenFrameData.samplingEasingCurve(param1[CURVE],param2.curve);
            }
         }
         else
         {
            param2.tweenEasing = DragonBones.NO_TWEEN;
            param2.curve = null;
         }
      }
      
      protected function _parseFrame(param1:Object, param2:FrameData, param3:uint, param4:uint) : void
      {
         param2.position = param3 / _armature.frameRate;
         param2.duration = param4 / _armature.frameRate;
      }
      
      protected function _parseTimeline(param1:Object, param2:TimelineData, param3:Function) : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:FrameData = null;
         var _loc8_:FrameData = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Object = null;
         param2.scale = _getNumber(param1,SCALE,1);
         param2.offset = _getNumber(param1,OFFSET,0);
         _timeline = param2;
         if(FRAME in param1)
         {
            _loc4_ = param1[FRAME];
            if(_loc4_.length === 1)
            {
               param2.frames.length = 1;
               param2.frames[0] = param3(_loc4_[0],0,_getNumber(_loc4_[0],DURATION,1));
            }
            else if(_loc4_.length > 1)
            {
               param2.frames.length = _animation.frameCount + 1;
               _loc5_ = 0;
               _loc6_ = 0;
               _loc7_ = null;
               _loc8_ = null;
               _loc9_ = 0;
               _loc10_ = 0;
               _loc11_ = param2.frames.length;
               while(_loc9_ < _loc11_)
               {
                  if(_loc5_ + _loc6_ <= _loc9_ && _loc10_ < _loc4_.length)
                  {
                     _loc12_ = _loc4_[_loc10_++];
                     _loc5_ = _loc9_;
                     _loc6_ = _getNumber(_loc12_,DURATION,1);
                     _loc7_ = param3(_loc12_,_loc5_,_loc6_);
                     if(_loc8_)
                     {
                        _loc8_.next = _loc7_;
                        _loc7_.prev = _loc8_;
                        if(_isOldData)
                        {
                           if(_loc8_ is TweenFrameData && _loc12_[DISPLAY_INDEX] == -1)
                           {
                              (_loc8_ as TweenFrameData).tweenEasing = DragonBones.NO_TWEEN;
                           }
                        }
                     }
                     _loc8_ = _loc7_;
                  }
                  param2.frames[_loc9_] = _loc7_;
                  _loc9_++;
               }
               _loc7_.duration = _animation.duration - _loc7_.position;
               _loc7_ = param2.frames[0];
               _loc8_.next = _loc7_;
               _loc7_.prev = _loc8_;
               if(_isOldData)
               {
                  if(_loc8_ is TweenFrameData && _loc4_[0][DISPLAY_INDEX] == -1)
                  {
                     (_loc8_ as TweenFrameData).tweenEasing = DragonBones.NO_TWEEN;
                  }
               }
            }
            param2.frames.fixed = true;
         }
         _timeline = null;
      }
      
      protected function _parseActionData(param1:Object, param2:Vector.<ActionData>, param3:BoneData, param4:SlotData) : void
      {
         var _loc6_:ActionData = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         var _loc11_:String = null;
         var _loc12_:Object = null;
         var _loc5_:Object = param1[ACTION] || param1[ACTIONS] || param1[DEFAULT_ACTIONS];
         if(_loc5_ is String)
         {
            _loc6_ = BaseObject.borrowObject(ActionData) as ActionData;
            _loc6_.type = ActionType.Play;
            _loc6_.bone = param3;
            _loc6_.slot = param4;
            _loc6_.animationConfig = BaseObject.borrowObject(AnimationConfig) as AnimationConfig;
            _loc6_.animationConfig.animationName = _loc5_ as String;
            param2.push(_loc6_);
         }
         else if(_loc5_ is Array)
         {
            _loc7_ = 0;
            _loc8_ = uint(_loc5_.length);
            while(_loc7_ < _loc8_)
            {
               _loc9_ = _loc5_[_loc7_];
               _loc10_ = _loc9_ is Array;
               _loc6_ = BaseObject.borrowObject(ActionData) as ActionData;
               _loc11_ = _loc10_ ? _loc9_[1] : _getString(_loc9_,"gotoAndPlay",null);
               if(_loc10_)
               {
                  _loc12_ = _loc9_[0];
                  if(_loc12_ is String)
                  {
                     _loc6_.type = _getActionType(_loc12_ as String);
                  }
                  else
                  {
                     _loc6_.type = _loc12_ as int;
                  }
               }
               else
               {
                  _loc6_.type = ActionType.Play;
               }
               switch(_loc6_.type)
               {
                  case ActionType.Play:
                     _loc6_.animationConfig = BaseObject.borrowObject(AnimationConfig) as AnimationConfig;
                     _loc6_.animationConfig.animationName = _loc11_;
               }
               _loc6_.bone = param3;
               _loc6_.slot = param4;
               param2.push(_loc6_);
               _loc7_++;
            }
         }
      }
      
      protected function _parseEventData(param1:Object, param2:Vector.<EventData>, param3:BoneData, param4:SlotData) : void
      {
         var _loc5_:EventData = null;
         var _loc6_:EventData = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         if(SOUND in param1)
         {
            _loc5_ = BaseObject.borrowObject(EventData) as EventData;
            _loc5_.type = EventType.Sound;
            _loc5_.name = _getString(param1,SOUND,null);
            _loc5_.bone = param3;
            _loc5_.slot = param4;
            param2.push(_loc5_);
         }
         if(EVENT in param1)
         {
            _loc6_ = BaseObject.borrowObject(EventData) as EventData;
            _loc6_.type = EventType.Frame;
            _loc6_.name = _getString(param1,EVENT,null);
            _loc6_.bone = param3;
            _loc6_.slot = param4;
            param2.push(_loc6_);
         }
         if(EVENTS in param1)
         {
            for each(_loc7_ in param1[EVENTS])
            {
               _loc8_ = _getString(_loc7_,BONE,null);
               _loc9_ = _getString(_loc7_,SLOT,null);
               _loc6_ = BaseObject.borrowObject(EventData) as EventData;
               _loc6_.type = EventType.Frame;
               _loc6_.name = _getString(_loc7_,NAME,null);
               _loc6_.bone = _armature.getBone(_loc8_);
               _loc6_.slot = _armature.getSlot(_loc9_);
               if(INTS in _loc7_)
               {
                  if(!_loc6_.data)
                  {
                     _loc6_.data = BaseObject.borrowObject(CustomData) as CustomData;
                  }
                  for each(_loc10_ in _loc7_[INTS] as Array)
                  {
                     _loc6_.data.ints.push(_loc10_);
                  }
               }
               if(FLOATS in _loc7_)
               {
                  if(!_loc6_.data)
                  {
                     _loc6_.data = BaseObject.borrowObject(CustomData) as CustomData;
                  }
                  for each(_loc11_ in _loc7_[FLOATS] as Array)
                  {
                     _loc6_.data.floats.push(_loc11_);
                  }
               }
               if(STRINGS in _loc7_)
               {
                  if(!_loc6_.data)
                  {
                     _loc6_.data = BaseObject.borrowObject(CustomData) as CustomData;
                  }
                  for each(_loc12_ in _loc7_[STRINGS] as Array)
                  {
                     _loc6_.data.strings.push(_loc12_);
                  }
               }
               param2.push(_loc6_);
            }
         }
      }
      
      protected function _parseTransform(param1:Object, param2:Transform) : void
      {
         param2.x = _getNumber(param1,X,0) * _armature.scale;
         param2.y = _getNumber(param1,Y,0) * _armature.scale;
         param2.skewX = _getNumber(param1,SKEW_X,0) * DragonBones.ANGLE_TO_RADIAN;
         param2.skewY = _getNumber(param1,SKEW_Y,0) * DragonBones.ANGLE_TO_RADIAN;
         param2.scaleX = _getNumber(param1,SCALE_X,1);
         param2.scaleY = _getNumber(param1,SCALE_Y,1);
      }
      
      protected function _parseColorTransform(param1:Object, param2:ColorTransform) : void
      {
         param2.alphaMultiplier = _getNumber(param1,ALPHA_MULTIPLIER,100) * 0.01;
         param2.redMultiplier = _getNumber(param1,RED_MULTIPLIER,100) * 0.01;
         param2.greenMultiplier = _getNumber(param1,GREEN_MULTIPLIER,100) * 0.01;
         param2.blueMultiplier = _getNumber(param1,BLUE_MULTIPLIER,100) * 0.01;
         param2.alphaOffset = _getNumber(param1,ALPHA_OFFSET,0);
         param2.redOffset = _getNumber(param1,RED_OFFSET,0);
         param2.greenOffset = _getNumber(param1,GREEN_OFFSET,0);
         param2.blueOffset = _getNumber(param1,BLUE_OFFSET,0);
      }
      
      override public function parseDragonBonesData(param1:Object, param2:Number = 1) : DragonBonesData
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:DragonBonesData = null;
         var _loc6_:Object = null;
         if(param1)
         {
            _loc3_ = _getString(param1,VERSION,null);
            _loc4_ = _getString(param1,VERSION,null);
            _isOldData = _loc3_ === DATA_VERSION_2_3 || _loc3_ === DATA_VERSION_3_0;
            if(_isOldData)
            {
               _isGlobalTransform = _getBoolean(param1,IS_GLOBAL,true);
            }
            else
            {
               _isGlobalTransform = false;
            }
            if(_loc3_ == DATA_VERSION || _loc3_ == DATA_VERSION_4_5 || _loc3_ == DATA_VERSION_4_0 || _loc3_ == DATA_VERSION_3_0 || _loc3_ == DATA_VERSION_2_3 || _loc4_ == DATA_VERSION_4_0)
            {
               _loc5_ = BaseObject.borrowObject(DragonBonesData) as DragonBonesData;
               _loc5_.name = _getString(param1,NAME,null);
               _loc5_.frameRate = _getNumber(param1,FRAME_RATE,24);
               if(_loc5_.frameRate === 0)
               {
                  _loc5_.frameRate = 24;
               }
               if(ARMATURE in param1)
               {
                  _data = _loc5_;
                  for each(_loc6_ in param1[ARMATURE])
                  {
                     _loc5_.addArmature(this._parseArmature(_loc6_,param2));
                  }
                  _data = null;
               }
               return _loc5_;
            }
            throw new Error("Nonsupport data version.");
         }
         throw new ArgumentError();
      }
      
      override public function parseTextureAtlasData(param1:Object, param2:TextureAtlasData, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc5_:Object = null;
         var _loc6_:TextureData = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1)
         {
            param2.name = _getString(param1,NAME,null);
            param2.imagePath = _getString(param1,IMAGE_PATH,null);
            param2.width = _getNumber(param1,WIDTH,0);
            param2.height = _getNumber(param1,HEIGHT,0);
            if(param3 > 0)
            {
               param2.scale = param3;
            }
            else
            {
               param3 = param2.scale = _getNumber(param1,SCALE,param2.scale);
            }
            param3 = 1 / (param4 > 0 ? param4 : param3);
            if(SUB_TEXTURE in param1)
            {
               for each(_loc5_ in param1[SUB_TEXTURE])
               {
                  _loc6_ = param2.generateTexture();
                  _loc6_.name = _getString(_loc5_,NAME,null);
                  _loc6_.rotated = _getBoolean(_loc5_,ROTATED,false);
                  _loc6_.region.x = _getNumber(_loc5_,X,0) * param3;
                  _loc6_.region.y = _getNumber(_loc5_,Y,0) * param3;
                  _loc6_.region.width = _getNumber(_loc5_,WIDTH,0) * param3;
                  _loc6_.region.height = _getNumber(_loc5_,HEIGHT,0) * param3;
                  _loc7_ = _getNumber(_loc5_,FRAME_WIDTH,-1);
                  _loc8_ = _getNumber(_loc5_,FRAME_HEIGHT,-1);
                  if(_loc7_ > 0 && _loc8_ > 0)
                  {
                     _loc6_.frame = TextureData.generateRectangle();
                     _loc6_.frame.x = _getNumber(_loc5_,FRAME_X,0) * param3;
                     _loc6_.frame.y = _getNumber(_loc5_,FRAME_Y,0) * param3;
                     _loc6_.frame.width = _loc7_ * param3;
                     _loc6_.frame.height = _loc8_ * param3;
                  }
                  param2.addTexture(_loc6_);
               }
            }
            return;
         }
         throw new ArgumentError();
      }
   }
}

