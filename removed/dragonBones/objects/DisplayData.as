package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.DisplayType;
   import dragonBones.geom.Transform;
   import dragonBones.textures.TextureData;
   import flash.geom.Point;
   
   public class DisplayData extends BaseObject
   {
      
      public var isRelativePivot:Boolean;
      
      public var inheritAnimation:Boolean;
      
      public var type:int;
      
      public var name:String;
      
      public var path:String;
      
      public var share:String;
      
      public const pivot:Point = new Point();
      
      public const transform:Transform = new Transform();
      
      public var texture:TextureData;
      
      public var armature:ArmatureData;
      
      public var mesh:MeshData;
      
      public var boundingBox:BoundingBoxData;
      
      public function DisplayData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         if(this.boundingBox)
         {
            this.boundingBox.returnToPool();
         }
         this.isRelativePivot = false;
         this.type = DisplayType.None;
         this.name = null;
         this.path = null;
         this.share = null;
         this.pivot.x = 0;
         this.pivot.y = 0;
         this.transform.identity();
         this.texture = null;
         this.armature = null;
         this.mesh = null;
         this.boundingBox = null;
      }
   }
}

