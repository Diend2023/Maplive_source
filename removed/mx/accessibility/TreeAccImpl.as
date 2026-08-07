package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.Tree;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.TreeEvent;
   
   use namespace mx_internal;
   
   public class TreeAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function TreeAccImpl(param1:UIComponent)
      {
         super(param1);
         role = AccConst.ROLE_SYSTEM_OUTLINE;
      }
      
      public static function enableAccessibility() : void
      {
         Tree.mx_internal::createAccessibilityImplementation = mx_internal::createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(param1:UIComponent) : void
      {
         param1.accessibilityImplementation = new TreeAccImpl(param1);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["change",TreeEvent.ITEM_OPEN,TreeEvent.ITEM_CLOSE]);
      }
      
      override public function get_accRole(param1:uint) : uint
      {
         return param1 == 0 ? role : AccConst.ROLE_SYSTEM_OUTLINEITEM;
      }
      
      override public function get_accValue(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Tree = null;
         var _loc6_:int = 0;
         if(param1 != 0)
         {
            _loc3_ = int(param1 - 1);
            _loc4_ = this.getItemAt(_loc3_);
            if(!_loc4_)
            {
               return _loc2_;
            }
            _loc5_ = Tree(master);
            _loc6_ = _loc5_.mx_internal::getItemDepth(_loc4_,_loc3_ - _loc5_.verticalScrollPosition);
            _loc2_ = String(_loc6_ - 1);
         }
         return _loc2_;
      }
      
      override public function get_accState(param1:uint) : uint
      {
         var _loc3_:Tree = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:IListItemRenderer = null;
         var _loc2_:uint = getState(param1);
         if(param1 > 0)
         {
            _loc3_ = Tree(master);
            _loc4_ = int(param1 - 1);
            if(_loc4_ < _loc3_.verticalScrollPosition || _loc4_ >= _loc3_.verticalScrollPosition + _loc3_.rowCount)
            {
               _loc2_ |= AccConst.STATE_SYSTEM_INVISIBLE;
            }
            else
            {
               _loc2_ |= AccConst.STATE_SYSTEM_SELECTABLE;
               _loc5_ = this.getItemAt(_loc4_);
               if((Boolean(_loc5_)) && _loc3_.dataDescriptor.isBranch(_loc5_,_loc3_.dataProvider))
               {
                  if(_loc3_.isItemOpen(_loc5_))
                  {
                     _loc2_ |= AccConst.STATE_SYSTEM_EXPANDED;
                  }
                  else
                  {
                     _loc2_ |= AccConst.STATE_SYSTEM_COLLAPSED;
                  }
               }
               _loc6_ = _loc3_.itemToItemRenderer(_loc5_);
               if(_loc6_ != null && _loc3_.isItemSelected(_loc6_.data))
               {
                  _loc2_ |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
               }
            }
         }
         return _loc2_;
      }
      
      override public function get_accDefaultAction(param1:uint) : String
      {
         if(param1 == 0)
         {
            return null;
         }
         var _loc2_:Tree = Tree(master);
         var _loc3_:Object = this.getItemAt(param1 - 1);
         if(!_loc3_)
         {
            return null;
         }
         if(_loc2_.dataDescriptor.isBranch(_loc3_,_loc2_.dataProvider))
         {
            return _loc2_.isItemOpen(_loc3_) ? "Collapse" : "Expand";
         }
         return null;
      }
      
      override public function accDoDefaultAction(param1:uint) : void
      {
         var _loc2_:Tree = Tree(master);
         if(param1 == 0 || !_loc2_.enabled)
         {
            return;
         }
         var _loc3_:Object = this.getItemAt(param1 - 1);
         if(!_loc3_)
         {
            return;
         }
         if(_loc2_.dataDescriptor.isBranch(_loc3_,_loc2_.dataProvider))
         {
            _loc2_.expandItem(_loc3_,!_loc2_.isItemOpen(_loc3_));
         }
      }
      
      override public function getChildIDArray() : Array
      {
         var _loc1_:int = Tree(master).dataProvider ? Tree(master).mx_internal::collectionLength : 0;
         return createChildIDArray(_loc1_);
      }
      
      override public function accLocation(param1:uint) : *
      {
         var _loc2_:Tree = Tree(master);
         var _loc3_:int = int(param1 - 1);
         if(_loc3_ < _loc2_.verticalScrollPosition || _loc3_ >= _loc2_.verticalScrollPosition + _loc2_.rowCount)
         {
            return null;
         }
         return _loc2_.itemToItemRenderer(this.getItemAt(_loc3_));
      }
      
      override public function get_accFocus() : uint
      {
         var _loc1_:int = Tree(master).selectedIndex;
         return _loc1_ >= 0 ? uint(_loc1_ + 1) : 0;
      }
      
      override protected function getName(param1:uint) : String
      {
         if(param1 == 0)
         {
            return "";
         }
         var _loc2_:Tree = Tree(master);
         var _loc3_:Object = this.getItemAt(param1 - 1);
         var _loc4_:String = "";
         if(!_loc3_)
         {
            return _loc4_;
         }
         if(_loc2_.itemToLabel(_loc3_))
         {
            _loc4_ = _loc2_.itemToLabel(_loc3_);
         }
         return _loc4_;
      }
      
      private function getItemAt(param1:int) : Object
      {
         var _loc2_:IViewCursor = Tree(master).mx_internal::collectionIterator;
         _loc2_.seek(CursorBookmark.FIRST,param1);
         return _loc2_.current;
      }
      
      override protected function eventHandler(param1:Event) : void
      {
         $eventHandler(param1);
         var _loc2_:int = Tree(master).selectedIndex;
         var _loc3_:uint = uint(_loc2_ + 1);
         switch(param1.type)
         {
            case "change":
               if(_loc2_ >= 0)
               {
                  Accessibility.sendEvent(master,_loc3_,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,_loc3_,AccConst.EVENT_OBJECT_SELECTION);
               }
               break;
            case TreeEvent.ITEM_OPEN:
            case TreeEvent.ITEM_CLOSE:
               if(_loc2_ >= 0)
               {
                  Accessibility.sendEvent(master,_loc3_,AccConst.EVENT_OBJECT_STATECHANGE);
               }
         }
      }
   }
}

