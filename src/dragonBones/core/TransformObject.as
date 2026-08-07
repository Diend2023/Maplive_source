package dragonBones.core
{
   import dragonBones.Armature;
   import dragonBones.Bone;
   import dragonBones.geom.Transform;
   import flash.geom.Matrix;
   
   use namespace dragonBones_internal;
   
   public class TransformObject extends BaseObject
   {
      
      public var name:String;
      
      public const globalTransformMatrix:Matrix = new Matrix();
      
      public const global:Transform = new Transform();
      
      public const offset:Transform = new Transform();
      
      public var origin:Transform;
      
      public var userData:Object;
      
      dragonBones_internal var _armature:Armature;
      
      dragonBones_internal var _parent:Bone;
      
      public function TransformObject(param1:TransformObject)
      {
         super(this);
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      override protected function _onClear() : void
      {
         this.name = null;
         this.globalTransformMatrix.identity();
         this.global.identity();
         this.offset.identity();
         this.origin = null;
         this.userData = null;
         this.dragonBones_internal::_armature = null;
         this.dragonBones_internal::_parent = null;
      }
      
      dragonBones_internal function _setArmature(param1:Armature) : void
      {
         this.dragonBones_internal::_armature = param1;
      }
      
      dragonBones_internal function _setParent(param1:Bone) : void
      {
         this.dragonBones_internal::_parent = param1;
      }
      
      public function get armature() : Armature
      {
         return this.dragonBones_internal::_armature;
      }
      
      public function get parent() : Bone
      {
         return this.dragonBones_internal::_parent;
      }
   }
}

