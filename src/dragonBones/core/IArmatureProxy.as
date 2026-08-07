package dragonBones.core
{
   import dragonBones.Armature;
   import dragonBones.animation.Animation;
   import dragonBones.events.IEventDispatcher;
   
   public interface IArmatureProxy extends IEventDispatcher
   {
      
      function _onClear() : void;
      
      function _debugDraw(param1:Boolean) : void;
      
      function dispose() : void;
      
      function get armature() : Armature;
      
      function get animation() : Animation;
   }
}

