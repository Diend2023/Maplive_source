package air.update.events
{
   import flash.events.Event;
   
   public class StatusUpdateEvent extends UpdateEvent
   {
      
      public static const UPDATE_STATUS:String = "updateStatus";
      
      public var details:Array = [];
      
      public var version:String = "";
      
      public var available:Boolean = false;
      
      public var versionLabel:String = "";
      
      public function StatusUpdateEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:String = "", param6:Array = null, param7:String = "")
      {
         super(param1,param2,param3);
         this.available = param4;
         this.version = param5;
         this.details = param6 == null ? [] : param6;
         this.versionLabel = param7;
      }
      
      override public function toString() : String
      {
         return "[StatusUpdateEvent (type=" + type + " available=" + this.available + " version=" + this.version + " details=" + this.details + " versionLabel=" + this.versionLabel + " )]";
      }
      
      override public function clone() : Event
      {
         return new StatusUpdateEvent(type,bubbles,cancelable,this.available,this.version,this.details,this.versionLabel);
      }
   }
}

