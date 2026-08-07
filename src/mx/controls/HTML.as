package mx.controls
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.HTMLUncaughtScriptExceptionEvent;
   import flash.events.MouseEvent;
   import flash.html.HTMLHistoryItem;
   import flash.html.HTMLHost;
   import flash.html.HTMLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexHTMLLoader;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   
   use namespace mx_internal;
   
   public class HTML extends ScrollControlBase implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFocusManagerComponent
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const MAX_HTML_WIDTH:Number = 2880;
      
      private static const MAX_HTML_HEIGHT:Number = 2880;
      
      private var textSet:Boolean;
      
      private var errorCaught:Boolean = false;
      
      private var _data:Object;
      
      public var htmlLoader:HTMLLoader;
      
      private var _htmlLoaderFactory:IFactory = new ClassFactory(FlexHTMLLoader);
      
      private var _htmlHost:HTMLHost;
      
      private var htmlHostChanged:Boolean = false;
      
      private var _htmlText:String;
      
      private var htmlTextChanged:Boolean = false;
      
      private var _imeMode:String = null;
      
      private var _listData:BaseListData;
      
      private var _location:String;
      
      private var locationChanged:Boolean = false;
      
      private var _paintsDefaultBackground:Boolean;
      
      private var paintsDefaultBackgroundChanged:Boolean = false;
      
      private var _runtimeApplicationDomain:ApplicationDomain;
      
      private var runtimeApplicationDomainChanged:Boolean = false;
      
      private var _userAgent:String;
      
      private var userAgentChanged:Boolean = false;
      
      public function HTML()
      {
         super();
         mx_internal::_horizontalScrollPolicy = ScrollPolicy.AUTO;
         mx_internal::_verticalScrollPolicy = ScrollPolicy.AUTO;
         tabFocusEnabled = false;
      }
      
      public static function get pdfCapability() : int
      {
         return HTMLLoader.pdfCapability;
      }
      
      override public function set verticalScrollPosition(param1:Number) : void
      {
         param1 = Math.max(param1,0);
         if(Boolean(this.htmlLoader) && this.htmlLoader.contentHeight > this.htmlLoader.height)
         {
            param1 = Math.min(param1,this.htmlLoader.contentHeight - this.htmlLoader.height);
         }
         super.verticalScrollPosition = param1;
         if(this.htmlLoader)
         {
            this.htmlLoader.scrollV = param1;
         }
         else
         {
            invalidateProperties();
         }
      }
      
      public function get contentHeight() : Number
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.contentHeight;
      }
      
      public function get contentWidth() : Number
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.contentWidth;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this._data = param1;
         if(this._listData)
         {
            _loc2_ = this._listData.label;
         }
         else if(this._data != null)
         {
            if(this._data is String)
            {
               _loc2_ = String(this._data);
            }
            else
            {
               _loc2_ = this._data.toString();
            }
         }
         if(_loc2_ !== undefined && !this.textSet)
         {
            this.htmlText = _loc2_;
            this.textSet = false;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get historyLength() : int
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.historyLength;
      }
      
      public function get historyPosition() : int
      {
         if(!this.htmlLoader)
         {
            return 0;
         }
         return this.htmlLoader.historyPosition;
      }
      
      public function set historyPosition(param1:int) : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.historyPosition = param1;
         }
      }
      
      [Bindable("htmlLoaderFactoryChanged")]
      public function get htmlLoaderFactory() : IFactory
      {
         return this._htmlLoaderFactory;
      }
      
      public function set htmlLoaderFactory(param1:IFactory) : void
      {
         this._htmlLoaderFactory = param1;
         dispatchEvent(new Event("htmlLoaderFactoryChanged"));
      }
      
      public function get htmlHost() : HTMLHost
      {
         return this._htmlHost;
      }
      
      public function set htmlHost(param1:HTMLHost) : void
      {
         this._htmlHost = param1;
         this.htmlHostChanged = true;
         invalidateProperties();
      }
      
      [Bindable("htmlTextChanged")]
      public function get htmlText() : String
      {
         return this._htmlText;
      }
      
      public function set htmlText(param1:String) : void
      {
         this._htmlText = param1;
         this.htmlTextChanged = true;
         this._location = null;
         this.locationChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("htmlTextChanged"));
      }
      
      public function get domWindow() : Object
      {
         if(!this.htmlLoader)
         {
            return null;
         }
         return this.htmlLoader.window;
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         this._imeMode = param1;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(param1:BaseListData) : void
      {
         this._listData = param1;
      }
      
      public function get loaded() : Boolean
      {
         if(!this.htmlLoader || this.locationChanged || this.htmlTextChanged)
         {
            return false;
         }
         return this.htmlLoader.loaded;
      }
      
      [Bindable("locationChange")]
      public function get location() : String
      {
         return this._location;
      }
      
      public function set location(param1:String) : void
      {
         this._location = param1;
         this.locationChanged = true;
         this._htmlText = null;
         this.htmlTextChanged = false;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("locationChange"));
      }
      
      public function get paintsDefaultBackground() : Boolean
      {
         return this._paintsDefaultBackground;
      }
      
      public function set paintsDefaultBackground(param1:Boolean) : void
      {
         this._paintsDefaultBackground = param1;
         this.paintsDefaultBackgroundChanged = true;
         invalidateProperties();
      }
      
      public function get runtimeApplicationDomain() : ApplicationDomain
      {
         return this._runtimeApplicationDomain;
      }
      
      public function set runtimeApplicationDomain(param1:ApplicationDomain) : void
      {
         this._runtimeApplicationDomain = param1;
         this.runtimeApplicationDomainChanged = true;
         invalidateProperties();
      }
      
      public function get userAgent() : String
      {
         return this._userAgent;
      }
      
      public function set userAgent(param1:String) : void
      {
         this._userAgent = param1;
         this.userAgentChanged = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.htmlLoader)
         {
            this.htmlLoader = this.htmlLoaderFactory.newInstance();
            this.htmlLoader.addEventListener(Event.HTML_DOM_INITIALIZE,this.htmlLoader_domInitialize);
            this.htmlLoader.addEventListener(Event.COMPLETE,this.htmlLoader_completeHandler);
            this.htmlLoader.addEventListener(Event.HTML_RENDER,this.htmlLoader_htmlRenderHandler);
            this.htmlLoader.addEventListener(Event.LOCATION_CHANGE,this.htmlLoader_locationChangeHandler);
            this.htmlLoader.addEventListener(Event.HTML_BOUNDS_CHANGE,this.htmlLoader_htmlBoundsChangeHandler);
            this.htmlLoader.addEventListener(Event.SCROLL,this.htmlLoader_scrollHandler);
            this.htmlLoader.addEventListener(HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION,this.htmlLoader_uncaughtScriptExceptionHandler);
            addChild(this.htmlLoader);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.htmlHostChanged)
         {
            this.htmlLoader.htmlHost = this._htmlHost;
            this.htmlHostChanged = false;
         }
         if(this.paintsDefaultBackgroundChanged)
         {
            this.htmlLoader.paintsDefaultBackground = this._paintsDefaultBackground;
            this.paintsDefaultBackgroundChanged = false;
         }
         if(this.runtimeApplicationDomainChanged)
         {
            this.htmlLoader.runtimeApplicationDomain = this._runtimeApplicationDomain;
            this.runtimeApplicationDomainChanged = false;
         }
         if(this.userAgentChanged)
         {
            this.htmlLoader.userAgent = this._userAgent;
            this.userAgentChanged = false;
         }
         if(this.locationChanged)
         {
            this.htmlLoader.load(new URLRequest(this._location));
            this.locationChanged = false;
         }
         if(this.htmlTextChanged)
         {
            this.htmlLoader.loadString(this._htmlText);
            this.htmlTextChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:EdgeMetrics = viewMetrics;
         _loc1_.left += getStyle("paddingLeft");
         _loc1_.top += getStyle("paddingTop");
         _loc1_.right += getStyle("paddingRight");
         _loc1_.bottom += getStyle("paddingBottom");
         measuredWidth = Math.min(this.htmlLoader.contentWidth + _loc1_.left + _loc1_.right,MAX_HTML_WIDTH);
         measuredHeight = Math.min(this.htmlLoader.contentHeight + _loc1_.top + _loc1_.bottom,MAX_HTML_HEIGHT);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:EdgeMetrics = viewMetrics;
         _loc3_.left += getStyle("paddingLeft");
         _loc3_.top += getStyle("paddingTop");
         _loc3_.right += getStyle("paddingRight");
         _loc3_.bottom += getStyle("paddingBottom");
         this.htmlLoader.x = _loc3_.left;
         this.htmlLoader.y = _loc3_.top;
         var _loc4_:Number = Math.max(param1 - _loc3_.left - _loc3_.right,1);
         var _loc5_:Number = Math.max(param2 - _loc3_.top - _loc3_.bottom,1);
         this.htmlLoader.width = _loc4_;
         this.htmlLoader.height = _loc5_;
      }
      
      public function cancelLoad() : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.cancelLoad();
         }
      }
      
      public function getHistoryAt(param1:int) : HTMLHistoryItem
      {
         if(!this.htmlLoader)
         {
            return null;
         }
         return this.htmlLoader.getHistoryAt(param1);
      }
      
      public function historyBack() : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.historyBack();
         }
      }
      
      public function historyForward() : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.historyForward();
         }
      }
      
      public function historyGo(param1:int) : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.historyGo(param1);
         }
      }
      
      public function reload() : void
      {
         if(this.htmlLoader)
         {
            this.htmlLoader.reload();
         }
      }
      
      private function adjustScrollBars() : void
      {
         setScrollBarProperties(this.htmlLoader.contentWidth,this.htmlLoader.width,this.htmlLoader.contentHeight,this.htmlLoader.height);
         if(verticalScrollBar)
         {
            verticalScrollBar.lineScrollSize = 20;
         }
         if(horizontalScrollBar)
         {
            horizontalScrollBar.lineScrollSize = 20;
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         var message:String = null;
         var event:FocusEvent = param1;
         super.focusInHandler(event);
         if(this._imeMode != null && (this.htmlLoader is IIMESupport && IIMESupport(this.htmlLoader).enableIME))
         {
            try
            {
               if(!this.errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = this._imeMode;
               }
               this.errorCaught = false;
            }
            catch(e:Error)
            {
               errorCaught = true;
               message = resourceManager.getString("controls","unsupportedMode",[_imeMode]);
               throw new Error(message);
            }
         }
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         super.scrollHandler(param1);
         this.htmlLoader.scrollH = horizontalScrollPosition;
         this.htmlLoader.scrollV = verticalScrollPosition;
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(param1.target != this)
         {
            return;
         }
         param1.delta *= 6;
         super.mouseWheelHandler(param1);
      }
      
      private function htmlLoader_domInitialize(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function htmlLoader_completeHandler(param1:Event) : void
      {
         invalidateSize();
         dispatchEvent(param1);
      }
      
      private function htmlLoader_htmlRenderHandler(param1:Event) : void
      {
         dispatchEvent(param1);
         this.adjustScrollBars();
         hasFocusableChildren = this.htmlLoader.hasFocusableContent;
      }
      
      private function htmlLoader_locationChangeHandler(param1:Event) : void
      {
         var _loc2_:* = this._location != this.htmlLoader.location;
         this._location = this.htmlLoader.location;
         if(_loc2_)
         {
            dispatchEvent(param1);
         }
      }
      
      private function htmlLoader_htmlBoundsChangeHandler(param1:Event) : void
      {
         invalidateSize();
         this.adjustScrollBars();
      }
      
      private function htmlLoader_scrollHandler(param1:Event) : void
      {
         horizontalScrollPosition = this.htmlLoader.scrollH;
         this.verticalScrollPosition = this.htmlLoader.scrollV;
      }
      
      private function htmlLoader_uncaughtScriptExceptionHandler(param1:HTMLUncaughtScriptExceptionEvent) : void
      {
         var _loc2_:Event = param1.clone();
         dispatchEvent(_loc2_);
         if(_loc2_.isDefaultPrevented())
         {
            param1.preventDefault();
         }
      }
   }
}

