package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.ActionType;
   
   public final class ActionData extends BaseObject
   {
      
      public var type:int;
      
      public var bone:BoneData;
      
      public var slot:SlotData;
      
      public var animationConfig:AnimationConfig;
      
      public function ActionData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         if(this.animationConfig)
         {
            this.animationConfig.returnToPool();
         }
         this.type = ActionType.None;
         this.bone = null;
         this.slot = null;
         this.animationConfig = null;
      }
   }
}

