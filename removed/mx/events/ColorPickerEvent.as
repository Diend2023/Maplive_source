package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ColorPickerEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public static const ENTER:String = "enter";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public var color:uint;
      
      public var index:int;
      
      public function ColorPickerEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:uint = 4294967295)
      {
         super(param1,param2,param3);
         this.index = param4;
         this.color = param5;
      }
      
      override public function clone() : Event
      {
         return new ColorPickerEvent(type,bubbles,cancelable,this.index,this.color);
      }
   }
}

