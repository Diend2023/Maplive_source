package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.geom.Transform;
   
   public class BoneData extends BaseObject
   {
      
      public var inheritTranslation:Boolean;
      
      public var inheritRotation:Boolean;
      
      public var inheritScale:Boolean;
      
      public var bendPositive:Boolean;
      
      public var chain:uint;
      
      public var chainIndex:uint;
      
      public var weight:Number;
      
      public var length:Number;
      
      public var name:String;
      
      public const transform:Transform = new Transform();
      
      public var parent:BoneData;
      
      public var ik:BoneData;
      
      public var userData:CustomData;
      
      public function BoneData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         if(this.userData)
         {
            this.userData.returnToPool();
         }
         this.inheritTranslation = false;
         this.inheritRotation = false;
         this.inheritScale = false;
         this.bendPositive = false;
         this.chain = 0;
         this.chainIndex = 0;
         this.weight = 0;
         this.length = 0;
         this.name = null;
         this.transform.identity();
         this.parent = null;
         this.ik = null;
         this.userData = null;
      }
      
      public function toString() : String
      {
         return this.name;
      }
   }
}

