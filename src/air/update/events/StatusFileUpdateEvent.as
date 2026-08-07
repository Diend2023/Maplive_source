package air.update.events
{
   import flash.events.Event;
   
   public class StatusFileUpdateEvent extends UpdateEvent
   {
      
      public static const FILE_UPDATE_STATUS:String = "fileUpdateStatus";
      
      public var path:String = null;
      
      public var version:String = "";
      
      public var available:Boolean = false;
      
      public var versionLabel:String = "";
      
      public function StatusFileUpdateEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:String = "", param6:String = "", param7:String = "")
      {
         super(param1,param2,param3);
         this.available = param4;
         this.version = param5;
         this.path = param6;
         this.versionLabel = param7;
      }
      
      override public function toString() : String
      {
         return "[StatusFileUpdateEvent (type=" + type + " available=" + this.available + " version=" + this.version + " path=" + this.path + " versionLabel=" + this.versionLabel + ")]";
      }
      
      override public function clone() : Event
      {
         return new StatusFileUpdateEvent(type,bubbles,cancelable,this.available,this.version,this.path,this.versionLabel);
      }
   }
}

