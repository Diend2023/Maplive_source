package mx.events
{
   import flash.events.Event;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TreeEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const ITEM_CLOSE:String = "itemClose";
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      public static const ITEM_OPENING:String = "itemOpening";
      
      public var animate:Boolean;
      
      public var dispatchEvent:Boolean;
      
      public var item:Object;
      
      public var itemRenderer:IListItemRenderer;
      
      public var opening:Boolean;
      
      public var triggerEvent:Event;
      
      public function TreeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null, param5:IListItemRenderer = null, param6:Event = null)
      {
         super(param1,param2,param3);
         this.item = param4;
         this.itemRenderer = param5;
         this.triggerEvent = param6;
      }
      
      override public function clone() : Event
      {
         return new TreeEvent(type,bubbles,cancelable,this.item,this.itemRenderer,this.triggerEvent);
      }
   }
}

