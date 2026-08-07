package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   
   public class DragonBonesData extends BaseObject
   {
      
      public var autoSearch:Boolean;
      
      public var frameRate:uint;
      
      public var name:String;
      
      public const armatures:Object = {};
      
      public const cachedFrames:Vector.<Number> = new Vector.<Number>();
      
      public var userData:CustomData;
      
      private const _armatureNames:Vector.<String> = new Vector.<String>();
      
      public function DragonBonesData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.armatures)
         {
            (this.armatures[_loc1_] as ArmatureData).returnToPool();
            delete this.armatures[_loc1_];
         }
         if(this.userData)
         {
            this.userData.returnToPool();
         }
         this.autoSearch = false;
         this.frameRate = 0;
         this.name = null;
         this.cachedFrames.length = 0;
         this.userData = null;
         this._armatureNames.length = 0;
      }
      
      public function addArmature(param1:ArmatureData) : void
      {
         if(param1 && param1.name && !this.armatures[param1.name])
         {
            this.armatures[param1.name] = param1;
            this._armatureNames.push(param1.name);
            param1.parent = this;
            return;
         }
         throw new ArgumentError();
      }
      
      public function getArmature(param1:String) : ArmatureData
      {
         return this.armatures[param1] as ArmatureData;
      }
      
      public function get armatureNames() : Vector.<String>
      {
         return this._armatureNames;
      }
   }
}

