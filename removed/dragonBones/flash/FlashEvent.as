package dragonBones.flash
{
   import dragonBones.events.EventObject;
   import flash.events.Event;
   
   public final class FlashEvent extends Event
   {
      
      public var eventObject:EventObject = null;
      
      public function FlashEvent(param1:String, param2:EventObject)
      {
         super(param1);
         this.eventObject = param2;
      }
      
      override public function clone() : Event
      {
         return new FlashEvent(type,this.eventObject);
      }
   }
}

