package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import flash.geom.Matrix;
   
   public final class MeshData extends BaseObject
   {
      
      public var skinned:Boolean;
      
      public var name:String;
      
      public const slotPose:Matrix = new Matrix();
      
      public const uvs:Vector.<Number> = new Vector.<Number>();
      
      public const vertices:Vector.<Number> = new Vector.<Number>();
      
      public const vertexIndices:Vector.<uint> = new Vector.<uint>();
      
      public const boneIndices:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
      
      public const weights:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
      
      public const boneVertices:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
      
      public const bones:Vector.<BoneData> = new Vector.<BoneData>();
      
      public const inverseBindPose:Vector.<Matrix> = new Vector.<Matrix>();
      
      public function MeshData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         this.skinned = false;
         this.name = null;
         this.slotPose.identity();
         this.uvs.fixed = false;
         this.uvs.length = 0;
         this.vertices.fixed = false;
         this.vertices.length = 0;
         this.vertexIndices.fixed = false;
         this.vertexIndices.length = 0;
         this.boneIndices.fixed = false;
         this.boneIndices.length = 0;
         this.weights.fixed = false;
         this.weights.length = 0;
         this.boneVertices.fixed = false;
         this.boneVertices.length = 0;
         this.bones.fixed = false;
         this.bones.length = 0;
         this.inverseBindPose.fixed = false;
         this.inverseBindPose.length = 0;
      }
   }
}

