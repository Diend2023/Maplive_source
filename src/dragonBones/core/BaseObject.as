package dragonBones.core
{
   import flash.utils.Dictionary;
   
   public class BaseObject
   {
      
      private static var _hashCode:uint = 0;
      
      private static var _defaultMaxCount:uint = 5000;
      
      private static const _maxCountMap:Dictionary = new Dictionary();
      
      private static const _poolsMap:Dictionary = new Dictionary();
      
      public const hashCode:uint = _hashCode++;
      
      public function BaseObject(param1:BaseObject)
      {
         super();
         if(param1 != this)
         {
            throw new Error(DragonBones.ABSTRACT_CLASS_ERROR);
         }
      }
      
      private static function _returnObject(param1:BaseObject) : void
      {
         var _loc2_:Class = null;
         _loc2_ = param1["constructor"] as Class;
         var _loc3_:uint = _maxCountMap[_loc2_] == null ? _defaultMaxCount : uint(_maxCountMap[_loc2_]);
         var _loc4_:Vector.<BaseObject> = _poolsMap[_loc2_] = _poolsMap[_loc2_] || new Vector.<BaseObject>();
         if(_loc4_.length < _loc3_)
         {
            if(_loc4_.indexOf(param1) >= 0)
            {
               throw new Error();
            }
            _loc4_.push(param1);
         }
      }
      
      public static function setMaxCount(param1:Class, param2:uint) : void
      {
         var _loc3_:Vector.<BaseObject> = null;
         var _loc4_:Object = null;
         if(param1)
         {
            _maxCountMap[param1] = param2;
            _loc3_ = _poolsMap[param1];
            if(Boolean(_loc3_) && _loc3_.length > param2)
            {
               _loc3_.length = param2;
            }
         }
         else
         {
            _defaultMaxCount = param2;
            for(_loc4_ in _poolsMap)
            {
               if(_maxCountMap[_loc4_] != null)
               {
                  _loc3_ = _poolsMap[_loc4_];
                  if(_loc3_.length > param2)
                  {
                     _loc3_.length = param2;
                  }
               }
            }
         }
      }
      
      public static function clearPool(param1:Class = null) : void
      {
         var _loc2_:Vector.<BaseObject> = null;
         if(param1)
         {
            _loc2_ = _poolsMap[param1];
            if(Boolean(_loc2_) && Boolean(_loc2_.length))
            {
               _loc2_.length = 0;
            }
         }
         else
         {
            for each(_loc2_ in _poolsMap)
            {
               _loc2_.length = 0;
            }
         }
      }
      
      public static function borrowObject(param1:Class) : BaseObject
      {
         var _loc3_:BaseObject = null;
         var _loc2_:Vector.<BaseObject> = _poolsMap[param1];
         if(Boolean(_loc2_) && _loc2_.length > 0)
         {
            return _loc2_.pop();
         }
         _loc3_ = new param1();
         _loc3_._onClear();
         return _loc3_;
      }
      
      protected function _onClear() : void
      {
      }
      
      final public function returnToPool() : void
      {
         this._onClear();
         _returnObject(this);
      }
   }
}

