package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.controls.ColorPicker;
   import mx.controls.ComboBase;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.DropdownEvent;
   
   use namespace mx_internal;
   
   public class ColorPickerAccImpl extends ComboBaseAccImpl
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function ColorPickerAccImpl(param1:UIComponent)
      {
         super(param1);
         param1.accessibilityProperties.description = "Color Picker";
         Accessibility.updateProperties();
         ColorPicker(param1).addEventListener(DropdownEvent.OPEN,this.openHandler);
         ColorPicker(param1).addEventListener(DropdownEvent.CLOSE,this.closeHandler);
      }
      
      public static function enableAccessibility() : void
      {
         ColorPicker.mx_internal::createAccessibilityImplementation = mx_internal::createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(param1:UIComponent) : void
      {
         param1.accessibilityImplementation = new ColorPickerAccImpl(param1);
      }
      
      private function openHandler(param1:Event) : void
      {
         ColorPicker(master).mx_internal::dropdown.addEventListener("change",this.dropdown_changeHandler);
      }
      
      private function closeHandler(param1:Event) : void
      {
         ColorPicker(master).mx_internal::dropdown.removeEventListener("change",this.dropdown_changeHandler);
      }
      
      private function dropdown_changeHandler(param1:Event) : void
      {
         master.dispatchEvent(new Event("childChange"));
      }
      
      override protected function getName(param1:uint) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1 == 0)
         {
            return "";
         }
         var _loc2_:ColorPicker = ColorPicker(master);
         var _loc3_:IViewCursor = _loc2_.mx_internal::collectionIterator;
         _loc3_.seek(CursorBookmark.FIRST,param1 - 1);
         var _loc4_:Object = _loc3_.current;
         if(typeof _loc4_ != "object")
         {
            _loc5_ = _loc4_.toString(16);
            return this.formatColorString(_loc5_);
         }
         return !_loc4_.label ? _loc4_.data : _loc4_.label;
      }
      
      override public function get_accState(param1:uint) : uint
      {
         var _loc2_:uint = getState(param1);
         if(param1 > 0)
         {
            _loc2_ |= AccConst.STATE_SYSTEM_SELECTABLE;
            _loc2_ |= AccConst.STATE_SYSTEM_SELECTED | AccConst.STATE_SYSTEM_FOCUSED;
         }
         return _loc2_;
      }
      
      override public function get_accValue(param1:uint) : String
      {
         if(ColorPicker(master).mx_internal::showingDropdown)
         {
            return ColorPicker(master).mx_internal::dropdown ? ColorPicker(master).mx_internal::dropdown.mx_internal::textInput.text : null;
         }
         return ColorPicker(master).selectedColor.toString(16);
      }
      
      override public function getChildIDArray() : Array
      {
         var _loc1_:int = ColorPicker(master).mx_internal::dropdown ? ColorPicker(master).mx_internal::dropdown.length : 0;
         return createChildIDArray(_loc1_);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["childChange"]);
      }
      
      override protected function eventHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         $eventHandler(param1);
         switch(param1.type)
         {
            case "childChange":
               _loc2_ = ComboBase(master).selectedIndex;
               Accessibility.sendEvent(master,ColorPicker(master).mx_internal::dropdown.mx_internal::focusedIndex + 1,AccConst.EVENT_OBJECT_SELECTION);
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE,true);
               break;
            case "valueCommit":
               Accessibility.sendEvent(master,0,AccConst.EVENT_OBJECT_VALUECHANGE);
         }
      }
      
      private function formatColorString(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ += param1.charAt(_loc4_) + " ";
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

