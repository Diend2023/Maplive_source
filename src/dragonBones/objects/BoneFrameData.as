package dragonBones.objects
{
   import dragonBones.geom.Transform;
   
   public final class BoneFrameData extends TweenFrameData
   {
      
      public var tweenScale:Boolean;
      
      public var tweenRotate:Number;
      
      public const transform:Transform = new Transform();
      
      public function BoneFrameData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         super._onClear();
         this.tweenScale = false;
         this.tweenRotate = 0;
         this.transform.identity();
      }
   }
}

