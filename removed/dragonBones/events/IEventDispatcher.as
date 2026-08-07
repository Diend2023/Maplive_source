package dragonBones.events
{
   public interface IEventDispatcher
   {
      
      function _dispatchEvent(param1:String, param2:EventObject) : void;
      
      function hasEvent(param1:String) : Boolean;
      
      function addEvent(param1:String, param2:Function) : void;
      
      function removeEvent(param1:String, param2:Function) : void;
   }
}

