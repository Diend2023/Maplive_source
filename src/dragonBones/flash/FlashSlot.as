package dragonBones.flash
{
   import dragonBones.Bone;
   import dragonBones.Slot;
   import dragonBones.core.BaseObject;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.enum.BlendMode;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.GraphicsTrianglePath;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   use namespace dragonBones_internal;
   
   public class FlashSlot extends Slot
   {
      
      private var _renderDisplay:DisplayObject;
      
      private var _meshTexture:BitmapData;
      
      private var _path:GraphicsTrianglePath;
      
      public function FlashSlot()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this._renderDisplay = null;
         this._meshTexture = null;
         this._path = null;
      }
      
      override protected function _initDisplay(param1:Object) : void
      {
      }
      
      override protected function _disposeDisplay(param1:Object) : void
      {
      }
      
      override protected function _onUpdateDisplay() : void
      {
         this._renderDisplay = (_display ? _display : _rawDisplay) as DisplayObject;
      }
      
      override protected function _addDisplay() : void
      {
         var _loc1_:FlashArmatureDisplay = dragonBones_internal::_armature.display as FlashArmatureDisplay;
         _loc1_.addChild(this._renderDisplay);
      }
      
      override protected function _replaceDisplay(param1:Object) : void
      {
         var _loc2_:FlashArmatureDisplay = dragonBones_internal::_armature.display as FlashArmatureDisplay;
         var _loc3_:DisplayObject = param1 as DisplayObject;
         _loc2_.addChild(this._renderDisplay);
         _loc2_.swapChildren(this._renderDisplay,_loc3_);
         _loc2_.removeChild(_loc3_);
      }
      
      override protected function _removeDisplay() : void
      {
         this._renderDisplay.parent.removeChild(this._renderDisplay);
      }
      
      override protected function _updateZOrder() : void
      {
         var _loc1_:FlashArmatureDisplay = null;
         _loc1_ = dragonBones_internal::_armature.display as FlashArmatureDisplay;
         var _loc2_:int = _loc1_.getChildIndex(this._renderDisplay);
         if(_loc2_ === dragonBones_internal::_zOrder)
         {
            return;
         }
         _loc1_.addChildAt(this._renderDisplay,dragonBones_internal::_zOrder < _loc2_ ? int(dragonBones_internal::_zOrder) : int(dragonBones_internal::_zOrder + 1));
      }
      
      override dragonBones_internal function _updateVisible() : void
      {
         this._renderDisplay.visible = dragonBones_internal::_parent.visible;
      }
      
      override protected function _updateBlendMode() : void
      {
         switch(_blendMode)
         {
            case dragonBones.enum.BlendMode.Normal:
               this._renderDisplay.blendMode = flash.display.BlendMode.NORMAL;
               break;
            case dragonBones.enum.BlendMode.Add:
               this._renderDisplay.blendMode = flash.display.BlendMode.ADD;
               break;
            case dragonBones.enum.BlendMode.Alpha:
               this._renderDisplay.blendMode = flash.display.BlendMode.ALPHA;
               break;
            case dragonBones.enum.BlendMode.Darken:
               this._renderDisplay.blendMode = flash.display.BlendMode.DARKEN;
               break;
            case dragonBones.enum.BlendMode.Difference:
               this._renderDisplay.blendMode = flash.display.BlendMode.DIFFERENCE;
               break;
            case dragonBones.enum.BlendMode.Erase:
               this._renderDisplay.blendMode = flash.display.BlendMode.ERASE;
               break;
            case dragonBones.enum.BlendMode.HardLight:
               this._renderDisplay.blendMode = flash.display.BlendMode.HARDLIGHT;
               break;
            case dragonBones.enum.BlendMode.Invert:
               this._renderDisplay.blendMode = flash.display.BlendMode.INVERT;
               break;
            case dragonBones.enum.BlendMode.Layer:
               this._renderDisplay.blendMode = flash.display.BlendMode.LAYER;
               break;
            case dragonBones.enum.BlendMode.Lighten:
               this._renderDisplay.blendMode = flash.display.BlendMode.LIGHTEN;
               break;
            case dragonBones.enum.BlendMode.Multiply:
               this._renderDisplay.blendMode = flash.display.BlendMode.MULTIPLY;
               break;
            case dragonBones.enum.BlendMode.Overlay:
               this._renderDisplay.blendMode = flash.display.BlendMode.OVERLAY;
               break;
            case dragonBones.enum.BlendMode.Screen:
               this._renderDisplay.blendMode = flash.display.BlendMode.SCREEN;
               break;
            case dragonBones.enum.BlendMode.Subtract:
               this._renderDisplay.blendMode = flash.display.BlendMode.SUBTRACT;
         }
      }
      
      override protected function _updateColor() : void
      {
         this._renderDisplay.transform.colorTransform = dragonBones_internal::_colorTransform;
      }
      
      override protected function _updateFrame() : void
      {
         var _loc3_:FlashTextureAtlasData = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Shape = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Shape = null;
         var _loc1_:Boolean = Boolean(dragonBones_internal::_meshData) && this._renderDisplay === _meshDisplay;
         var _loc2_:FlashTextureData = _textureData as FlashTextureData;
         if(_displayIndex >= 0 && _display && Boolean(_loc2_))
         {
            _loc3_ = _loc2_.parent as FlashTextureAtlasData;
            if(dragonBones_internal::_armature.replacedTexture && _displayData && _loc3_ === _displayData.texture.parent)
            {
               _loc3_ = dragonBones_internal::_armature.dragonBones_internal::_replaceTextureAtlasData as FlashTextureAtlasData;
               if(!_loc3_)
               {
                  _loc3_ = BaseObject.borrowObject(FlashTextureAtlasData) as FlashTextureAtlasData;
                  _loc3_.copyFrom(_textureData.parent);
                  _loc3_.texture = dragonBones_internal::_armature.replacedTexture as BitmapData;
                  dragonBones_internal::_armature.dragonBones_internal::_replaceTextureAtlasData = _loc3_;
               }
               _loc2_ = _loc3_.getTexture(_loc2_.name) as FlashTextureData;
            }
            _loc4_ = _loc3_.texture;
            if(_loc4_)
            {
               _loc5_ = _loc3_.width > 0 ? _loc3_.width : _loc4_.width;
               _loc6_ = _loc3_.height > 0 ? _loc3_.height : _loc4_.height;
               if(_loc1_)
               {
                  _loc7_ = this._renderDisplay as Shape;
                  if(this._path)
                  {
                     this._path.uvtData.fixed = false;
                     this._path.vertices.fixed = false;
                     this._path.indices.fixed = false;
                     this._path.uvtData.length = dragonBones_internal::_meshData.uvs.length;
                     this._path.vertices.length = dragonBones_internal::_meshData.vertices.length;
                     this._path.indices.length = dragonBones_internal::_meshData.vertexIndices.length;
                     this._path.uvtData.fixed = true;
                     this._path.vertices.fixed = true;
                     this._path.indices.fixed = true;
                  }
                  else
                  {
                     this._path = new GraphicsTrianglePath(new Vector.<Number>(dragonBones_internal::_meshData.uvs.length,true),new Vector.<int>(dragonBones_internal::_meshData.vertexIndices.length,true),new Vector.<Number>(dragonBones_internal::_meshData.vertices.length,true));
                  }
                  _loc8_ = 0;
                  _loc9_ = 0;
                  _loc8_ = 0;
                  _loc9_ = this._path.uvtData.length;
                  while(_loc8_ < _loc9_)
                  {
                     _loc10_ = Number(dragonBones_internal::_meshData.uvs[_loc8_]);
                     _loc11_ = Number(dragonBones_internal::_meshData.uvs[_loc8_ + 1]);
                     this._path.uvtData[_loc8_] = (_loc2_.region.x + _loc10_ * _loc2_.region.width) / _loc5_;
                     this._path.uvtData[_loc8_ + 1] = (_loc2_.region.y + _loc11_ * _loc2_.region.height) / _loc6_;
                     _loc8_ += 2;
                  }
                  _loc8_ = 0;
                  _loc9_ = this._path.vertices.length;
                  while(_loc8_ < _loc9_)
                  {
                     this._path.vertices[_loc8_] = dragonBones_internal::_meshData.vertices[_loc8_] - dragonBones_internal::_pivotX;
                     this._path.vertices[_loc8_ + 1] = dragonBones_internal::_meshData.vertices[_loc8_ + 1] - dragonBones_internal::_pivotY;
                     _loc8_ += 2;
                  }
                  _loc8_ = 0;
                  _loc9_ = this._path.indices.length;
                  while(_loc8_ < _loc9_)
                  {
                     this._path.indices[_loc8_] = dragonBones_internal::_meshData.vertexIndices[_loc8_];
                     _loc8_++;
                  }
                  _loc7_.graphics.clear();
                  if(_loc4_)
                  {
                     _loc7_.graphics.beginBitmapFill(_loc4_,null,false,true);
                     _loc7_.graphics.drawTriangles(this._path.vertices,this._path.indices,this._path.uvtData);
                  }
                  this._meshTexture = _loc4_;
               }
               else
               {
                  _loc12_ = 0;
                  _loc13_ = 0;
                  if(_loc2_.rotated)
                  {
                     _loc12_ = _loc2_.region.height;
                     _loc13_ = _loc2_.region.width;
                  }
                  else
                  {
                     _loc13_ = _loc2_.region.height;
                     _loc12_ = _loc2_.region.width;
                  }
                  _loc14_ = 1 / _loc2_.parent.scale;
                  if(_loc2_.rotated)
                  {
                     _helpMatrix.a = 0;
                     _helpMatrix.b = -_loc14_;
                     _helpMatrix.c = _loc14_;
                     _helpMatrix.d = 0;
                     _helpMatrix.tx = -dragonBones_internal::_pivotX - _loc2_.region.y;
                     _helpMatrix.ty = -dragonBones_internal::_pivotY + _loc2_.region.x + _loc13_;
                  }
                  else
                  {
                     _helpMatrix.a = _loc14_;
                     _helpMatrix.b = 0;
                     _helpMatrix.c = 0;
                     _helpMatrix.d = _loc14_;
                     _helpMatrix.tx = -dragonBones_internal::_pivotX - _loc2_.region.x;
                     _helpMatrix.ty = -dragonBones_internal::_pivotY - _loc2_.region.y;
                  }
                  _loc15_ = this._renderDisplay as Shape;
                  _loc15_.graphics.clear();
                  if(_loc4_)
                  {
                     _loc15_.graphics.beginBitmapFill(_loc4_,_helpMatrix,false,true);
                     _loc15_.graphics.drawRect(-dragonBones_internal::_pivotX,-dragonBones_internal::_pivotY,_loc12_,_loc13_);
                  }
               }
               this.dragonBones_internal::_updateVisible();
               return;
            }
         }
         if(_loc1_)
         {
            _loc7_ = this._renderDisplay as Shape;
            _loc7_.graphics.clear();
            _loc7_.visible = false;
            _loc7_.x = 0;
            _loc7_.y = 0;
         }
         else
         {
            _loc15_ = this._renderDisplay as Shape;
            _loc15_.graphics.clear();
            _loc15_.visible = false;
            _loc15_.x = 0;
            _loc15_.y = 0;
         }
      }
      
      override protected function _updateMesh() : void
      {
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Vector.<Number> = null;
         var _loc11_:Vector.<Number> = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Bone = null;
         var _loc15_:Matrix = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Vector.<Number> = null;
         var _loc1_:Shape = this._renderDisplay as Shape;
         if(!this._meshTexture)
         {
            return;
         }
         var _loc2_:* = dragonBones_internal::_ffdVertices.length > 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = uint(dragonBones_internal::_meshData.vertices.length);
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(dragonBones_internal::_meshData.skinned)
         {
            _loc1_.graphics.clear();
            _loc3_ = 0;
            while(_loc3_ < _loc6_)
            {
               _loc4_ = _loc3_ / 2;
               _loc9_ = dragonBones_internal::_meshData.boneIndices[_loc4_];
               _loc10_ = dragonBones_internal::_meshData.boneVertices[_loc4_];
               _loc11_ = dragonBones_internal::_meshData.weights[_loc4_];
               _loc7_ = 0;
               _loc8_ = 0;
               _loc12_ = 0;
               _loc13_ = _loc9_.length;
               while(_loc12_ < _loc13_)
               {
                  _loc14_ = _meshBones[_loc9_[_loc12_]];
                  _loc15_ = _loc14_.globalTransformMatrix;
                  _loc16_ = _loc11_[_loc12_];
                  _loc17_ = 0;
                  _loc18_ = 0;
                  if(_loc2_)
                  {
                     _loc17_ = _loc10_[_loc12_ * 2] + dragonBones_internal::_ffdVertices[_loc5_];
                     _loc18_ = _loc10_[_loc12_ * 2 + 1] + dragonBones_internal::_ffdVertices[_loc5_ + 1];
                  }
                  else
                  {
                     _loc17_ = _loc10_[_loc12_ * 2];
                     _loc18_ = _loc10_[_loc12_ * 2 + 1];
                  }
                  _loc7_ += (_loc15_.a * _loc17_ + _loc15_.c * _loc18_ + _loc15_.tx) * _loc16_;
                  _loc8_ += (_loc15_.b * _loc17_ + _loc15_.d * _loc18_ + _loc15_.ty) * _loc16_;
                  _loc5_ += 2;
                  _loc12_++;
               }
               this._path.vertices[_loc3_] = _loc7_ - dragonBones_internal::_pivotX;
               this._path.vertices[_loc3_ + 1] = _loc8_ - dragonBones_internal::_pivotY;
               _loc3_ += 2;
            }
            _loc1_.graphics.beginBitmapFill(this._meshTexture,null,false,true);
            _loc1_.graphics.drawTriangles(this._path.vertices,this._path.indices,this._path.uvtData);
         }
         else if(_loc2_)
         {
            _loc1_.graphics.clear();
            _loc19_ = dragonBones_internal::_meshData.vertices;
            _loc3_ = 0;
            while(_loc3_ < _loc6_)
            {
               _loc7_ = _loc19_[_loc3_] + dragonBones_internal::_ffdVertices[_loc3_];
               _loc8_ = _loc19_[_loc3_ + 1] + dragonBones_internal::_ffdVertices[_loc3_ + 1];
               this._path.vertices[_loc3_] = _loc7_ - dragonBones_internal::_pivotX;
               this._path.vertices[_loc3_ + 1] = _loc8_ - dragonBones_internal::_pivotY;
               _loc3_ += 2;
            }
            _loc1_.graphics.beginBitmapFill(this._meshTexture,null,true,true);
            _loc1_.graphics.drawTriangles(this._path.vertices,this._path.indices,this._path.uvtData);
         }
      }
      
      override protected function _updateTransform(param1:Boolean) : void
      {
         if(param1)
         {
            this._renderDisplay.transform.matrix = null;
         }
         else
         {
            this._renderDisplay.transform.matrix = globalTransformMatrix;
         }
      }
   }
}

