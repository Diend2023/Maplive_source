package dragonBones.objects
{
   import dragonBones.core.BaseObject;
   
   public final class CustomData extends BaseObject
   {
      
      public const ints:Vector.<Number> = new Vector.<Number>();
      
      public const floats:Vector.<Number> = new Vector.<Number>();
      
      public const strings:Vector.<String> = new Vector.<String>();
      
      public function CustomData()
      {
         super(this);
      }
      
      override protected function _onClear() : void
      {
         this.ints.length = 0;
         this.floats.length = 0;
         this.strings.length = 0;
      }
      
      public function getInt(param1:Number = 0) : Number
      {
         return param1 >= 0 && param1 < this.ints.length ? this.ints[param1] : 0;
      }
      
      public function getFloat(param1:Number = 0) : Number
      {
         return param1 >= 0 && param1 < this.floats.length ? this.floats[param1] : 0;
      }
      
      public function getString(param1:Number = 0) : String
      {
         return param1 >= 0 && param1 < this.strings.length ? this.strings[param1] : null;
      }
   }
}

