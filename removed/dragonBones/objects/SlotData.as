package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   import dragonBones.enum.BlendMode;
   import flash.geom.ColorTransform;
   
   public class SlotData extends BaseObject
   {
      
      public static const DEFAULT_COLOR:ColorTransform = new ColorTransform();
      
      public var displayIndex:int;
      
      public var zOrder:int;
      
      public var blendMode:int;
      
      public var name:String;
      
      public const actions:Vector.<ActionData> = new Vector.<ActionData>();
      
      public var parent:BoneData;
      
      public var color:ColorTransform;
      
      public var userData:CustomData;
      
      public function SlotData()
      {
         super(this);
      }
      
      public static function generateColor() : ColorTransform
      {
         return new ColorTransform();
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.actions.length;
         while(_loc1_ < _loc2_)
         {
            this.actions[_loc1_].returnToPool();
            _loc1_++;
         }
         if(this.userData)
         {
            this.userData.returnToPool();
         }
         this.displayIndex = -1;
         this.zOrder = 0;
         this.blendMode = BlendMode.None;
         this.name = null;
         this.actions.length = 0;
         this.parent = null;
         this.color = null;
         this.userData = null;
      }
   }
}

