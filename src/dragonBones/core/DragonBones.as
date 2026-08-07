package dragonBones.core
{
   public final class DragonBones
   {
      
      public static const PI_D:Number = Math.PI * 2;
      
      public static const PI_H:Number = Math.PI / 2;
      
      public static const PI_Q:Number = Math.PI / 4;
      
      public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
      
      public static const RADIAN_TO_ANGLE:Number = 180 / Math.PI;
      
      public static const SECOND_TO_MILLISECOND:Number = 1000;
      
      public static const NO_TWEEN:Number = 100;
      
      public static const ABSTRACT_CLASS_ERROR:String = "Abstract class can not be instantiated.";
      
      public static const ABSTRACT_METHOD_ERROR:String = "Abstract method needs to be implemented in subclass.";
      
      public static const VERSION:String = "5.0.0";
      
      public static var debugDraw:Boolean = false;
      
      public function DragonBones()
      {
         super();
      }
   }
}

