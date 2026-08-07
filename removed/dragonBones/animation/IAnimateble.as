package dragonBones.animation
{
   public interface IAnimateble
   {
      
      function advanceTime(param1:Number) : void;
      
      function get clock() : WorldClock;
      
      function set clock(param1:WorldClock) : void;
   }
}

