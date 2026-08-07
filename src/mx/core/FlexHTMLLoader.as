package mx.core
{
   import flash.events.Event;
   import flash.html.HTMLLoader;
   import mx.managers.IFocusManagerComplexComponent;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   public class FlexHTMLLoader extends HTMLLoader implements IFocusManagerComplexComponent, IIMESupport
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _hasFocusableContent:Boolean;
      
      private var _focusEnabled:Boolean = true;
      
      private var _hasFocusableChildren:Boolean = false;
      
      private var _imeMode:String = null;
      
      private var _mouseFocusEnabled:Boolean = true;
      
      private var _tabFocusEnabled:Boolean = true;
      
      public function FlexHTMLLoader()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
         }
         catch(e:Error)
         {
         }
         addEventListener(Event.HTML_RENDER,this.htmlRenderHandler);
      }
      
      public function get enableIME() : Boolean
      {
         return this._hasFocusableContent;
      }
      
      public function get focusEnabled() : Boolean
      {
         return this._focusEnabled;
      }
      
      public function set focusEnabled(param1:Boolean) : void
      {
         this._focusEnabled = param1;
      }
      
      [Bindable("hasFocusableChildrenChange")]
      public function get hasFocusableChildren() : Boolean
      {
         return this._hasFocusableChildren;
      }
      
      public function set hasFocusableChildren(param1:Boolean) : void
      {
         if(param1 != this._hasFocusableChildren)
         {
            this._hasFocusableChildren = param1;
            dispatchEvent(new Event("hasFocusableChildrenChange"));
         }
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         this._imeMode = param1;
      }
      
      public function get mouseFocusEnabled() : Boolean
      {
         return this._mouseFocusEnabled;
      }
      
      public function set mouseFocusEnabled(param1:Boolean) : void
      {
         this._mouseFocusEnabled = param1;
      }
      
      [Bindable("tabFocusEnabledChange")]
      public function get tabFocusEnabled() : Boolean
      {
         return this._tabFocusEnabled;
      }
      
      public function set tabFocusEnabled(param1:Boolean) : void
      {
         if(param1 != this._tabFocusEnabled)
         {
            this._tabFocusEnabled = param1;
            dispatchEvent(new Event("tabFocusEnabledChange"));
         }
      }
      
      public function setFocus() : void
      {
         stage.focus = this;
      }
      
      public function drawFocus(param1:Boolean) : void
      {
      }
      
      public function assignFocus(param1:String) : void
      {
         stage.assignFocus(this,param1);
      }
      
      private function htmlRenderHandler(param1:Event) : void
      {
         this._hasFocusableContent = hasFocusableContent;
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}

