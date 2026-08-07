package air.update.ui
{
   import air.update.logging.Logger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   
   public class ResourceManagerReflection extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.utils.ResourceManagerReflection");
      
      private static const RESOURCE_MANAGER_CLASS_NAME:String = "mx.resources.ResourceManager";
      
      private static var _instance:ResourceManagerReflection = null;
      
      private var _resourceManager:Object = null;
      
      public function ResourceManagerReflection(param1:Class)
      {
         var _loc3_:Object = null;
         var _loc4_:Function = null;
         super();
         if(param1 != SingletonLock)
         {
            return;
         }
         var _loc2_:ApplicationDomain = ApplicationDomain.currentDomain;
         if(_loc2_.hasDefinition(RESOURCE_MANAGER_CLASS_NAME))
         {
            _loc3_ = _loc2_.getDefinition(RESOURCE_MANAGER_CLASS_NAME);
            if(Boolean(_loc3_) && _loc3_ is Class)
            {
               _loc4_ = getFunction("getInstance",_loc3_);
               this._resourceManager = _loc4_();
               this.addListeners();
            }
            else
            {
               logger.warning("ResourceManager class definition is null or not a class");
            }
         }
         else
         {
            logger.warning("Could not find definition: " + RESOURCE_MANAGER_CLASS_NAME);
         }
      }
      
      private static function getProperty(param1:String, param2:Object) : *
      {
         var _loc3_:* = null;
         if(Boolean(param2) && Boolean(param2.hasOwnProperty(param1)))
         {
            _loc3_ = param2[param1];
         }
         else
         {
            logger.warning("Could not find property - " + param1 + " on object - " + param2);
         }
         return _loc3_;
      }
      
      public static function getInstance() : ResourceManagerReflection
      {
         if(!_instance)
         {
            _instance = new ResourceManagerReflection(SingletonLock);
         }
         return _instance;
      }
      
      private static function getFunction(param1:String, param2:Object) : Function
      {
         var functionName:String = param1;
         var selfObject:Object = param2;
         var resultFunction:Function = function(... rest):*
         {
            logger.info(functionName + " not found. Empty (stub) function called.");
         };
         if(selfObject && selfObject.hasOwnProperty(functionName) && selfObject[functionName] is Function)
         {
            resultFunction = selfObject[functionName];
         }
         else
         {
            logger.warning("Could not find member function - " + functionName + " - on object - " + selfObject);
         }
         return resultFunction;
      }
      
      private function getResourceManagerFunction(param1:String) : Function
      {
         return getFunction(param1,this._resourceManager);
      }
      
      public function getResourceBundleContent(param1:String, param2:String) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Object = this.getResourceBundle(param1,param2);
         if(_loc4_)
         {
            _loc3_ = getProperty("content",_loc4_);
         }
         return _loc3_;
      }
      
      public function hasResourceManager() : Boolean
      {
         var _loc1_:Boolean = Boolean(this._resourceManager);
         logger.info("hasResourceManager: " + _loc1_);
         return _loc1_;
      }
      
      private function getResourceBundle(param1:String, param2:String) : Object
      {
         var _loc3_:Function = this.getResourceManagerFunction("getResourceBundle");
         return _loc3_(param1,param2);
      }
      
      public function getLocales() : Array
      {
         var _loc1_:Function = this.getResourceManagerFunction("getLocales");
         return _loc1_();
      }
      
      private function getResourceManagerProperty(param1:String) : *
      {
         return getProperty(param1,this._resourceManager);
      }
      
      private function addListeners() : void
      {
         var _loc1_:Function = this.getResourceManagerFunction("addEventListener");
         _loc1_(Event.CHANGE,dispatchEvent);
      }
      
      public function get localeChain() : Array
      {
         var _loc1_:Array = this.getResourceManagerProperty("localeChain");
         if(!_loc1_)
         {
            _loc1_ = [];
         }
         return _loc1_;
      }
   }
}

class SingletonLock
{
   
   public function SingletonLock()
   {
      super();
   }
}
