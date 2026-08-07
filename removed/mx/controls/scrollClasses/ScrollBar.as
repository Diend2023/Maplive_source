package mx.controls.scrollClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   public class ScrollBar extends UIComponent
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const THICKNESS:Number = 16;
      
      mx_internal var upArrow:Button;
      
      mx_internal var downArrow:Button;
      
      mx_internal var scrollTrack:Button;
      
      mx_internal var scrollThumb:ScrollThumb;
      
      mx_internal var _minWidth:Number = 16;
      
      mx_internal var _minHeight:Number = 32;
      
      mx_internal var isScrolling:Boolean;
      
      private var trackScrollTimer:Timer;
      
      private var trackScrollRepeatDirection:int;
      
      private var trackScrolling:Boolean = false;
      
      private var trackPosition:Number;
      
      mx_internal var oldPosition:Number;
      
      private var _direction:String = "vertical";
      
      private var _lineScrollSize:Number = 1;
      
      private var _maxScrollPosition:Number = 0;
      
      private var _minScrollPosition:Number = 0;
      
      private var _pageSize:Number = 0;
      
      private var _pageScrollSize:Number = 0;
      
      private var _scrollPosition:Number = 0;
      
      public function ScrollBar()
      {
         super();
      }
      
      override public function set doubleClickEnabled(param1:Boolean) : void
      {
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         invalidateDisplayList();
      }
      
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      protected function get downArrowStyleFilters() : Object
      {
         return null;
      }
      
      mx_internal function get lineMinusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.LINE_UP : ScrollEventDetail.LINE_LEFT;
      }
      
      mx_internal function get linePlusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.LINE_DOWN : ScrollEventDetail.LINE_RIGHT;
      }
      
      public function get lineScrollSize() : Number
      {
         return this._lineScrollSize;
      }
      
      public function set lineScrollSize(param1:Number) : void
      {
         this._lineScrollSize = param1;
      }
      
      private function get maxDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.AT_BOTTOM : ScrollEventDetail.AT_RIGHT;
      }
      
      public function get maxScrollPosition() : Number
      {
         return this._maxScrollPosition;
      }
      
      public function set maxScrollPosition(param1:Number) : void
      {
         this._maxScrollPosition = param1;
         invalidateDisplayList();
      }
      
      private function get minDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.AT_TOP : ScrollEventDetail.AT_LEFT;
      }
      
      public function get minScrollPosition() : Number
      {
         return this._minScrollPosition;
      }
      
      public function set minScrollPosition(param1:Number) : void
      {
         this._minScrollPosition = param1;
         invalidateDisplayList();
      }
      
      mx_internal function get pageMinusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.PAGE_UP : ScrollEventDetail.PAGE_LEFT;
      }
      
      mx_internal function get pagePlusDetail() : String
      {
         return this.direction == ScrollBarDirection.VERTICAL ? ScrollEventDetail.PAGE_DOWN : ScrollEventDetail.PAGE_RIGHT;
      }
      
      public function get pageSize() : Number
      {
         return this._pageSize;
      }
      
      public function set pageSize(param1:Number) : void
      {
         this._pageSize = param1;
      }
      
      public function get pageScrollSize() : Number
      {
         return this._pageScrollSize;
      }
      
      public function set pageScrollSize(param1:Number) : void
      {
         this._pageScrollSize = param1;
      }
      
      public function get scrollPosition() : Number
      {
         return this._scrollPosition;
      }
      
      public function set scrollPosition(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         this._scrollPosition = param1;
         if(this.mx_internal::scrollThumb)
         {
            if(!cacheAsBitmap)
            {
               cacheHeuristic = this.mx_internal::scrollThumb.cacheHeuristic = true;
            }
            if(!this.mx_internal::isScrolling)
            {
               param1 = Math.min(param1,this.maxScrollPosition);
               param1 = Math.max(param1,this.minScrollPosition);
               _loc2_ = this.maxScrollPosition - this.minScrollPosition;
               _loc3_ = _loc2_ == 0 || isNaN(_loc2_) ? 0 : (param1 - this.minScrollPosition) * (this.trackHeight - this.mx_internal::scrollThumb.height) / _loc2_ + this.trackY;
               _loc4_ = (this.mx_internal::virtualWidth - this.mx_internal::scrollThumb.width) / 2 + getStyle("thumbOffset");
               this.mx_internal::scrollThumb.move(Math.round(_loc4_),Math.round(_loc3_));
            }
         }
      }
      
      protected function get thumbStyleFilters() : Object
      {
         return null;
      }
      
      private function get trackHeight() : Number
      {
         return this.mx_internal::virtualHeight - (this.mx_internal::upArrow.getExplicitOrMeasuredHeight() + this.mx_internal::downArrow.getExplicitOrMeasuredHeight());
      }
      
      private function get trackY() : Number
      {
         return this.mx_internal::upArrow.getExplicitOrMeasuredHeight();
      }
      
      protected function get upArrowStyleFilters() : Object
      {
         return null;
      }
      
      mx_internal function get virtualHeight() : Number
      {
         return unscaledHeight;
      }
      
      mx_internal function get virtualWidth() : Number
      {
         return unscaledWidth;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.mx_internal::scrollTrack)
         {
            this.mx_internal::scrollTrack = new Button();
            this.mx_internal::scrollTrack.focusEnabled = false;
            this.mx_internal::scrollTrack.tabEnabled = false;
            this.mx_internal::scrollTrack.mx_internal::skinName = "trackSkin";
            this.mx_internal::scrollTrack.mx_internal::upSkinName = "trackUpSkin";
            this.mx_internal::scrollTrack.mx_internal::overSkinName = "trackOverSkin";
            this.mx_internal::scrollTrack.mx_internal::downSkinName = "trackDownSkin";
            this.mx_internal::scrollTrack.mx_internal::disabledSkinName = "trackDisabledSkin";
            if(this.mx_internal::scrollTrack is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.mx_internal::scrollTrack).styleName = this;
            }
            addChild(this.mx_internal::scrollTrack);
            this.mx_internal::scrollTrack.validateProperties();
         }
         if(!this.mx_internal::upArrow)
         {
            this.mx_internal::upArrow = new Button();
            this.mx_internal::upArrow.enabled = false;
            this.mx_internal::upArrow.autoRepeat = true;
            this.mx_internal::upArrow.focusEnabled = false;
            this.mx_internal::upArrow.tabEnabled = false;
            this.mx_internal::upArrow.mx_internal::upSkinName = "upArrowUpSkin";
            this.mx_internal::upArrow.mx_internal::overSkinName = "upArrowOverSkin";
            this.mx_internal::upArrow.mx_internal::downSkinName = "upArrowDownSkin";
            this.mx_internal::upArrow.mx_internal::disabledSkinName = "upArrowDisabledSkin";
            this.mx_internal::upArrow.mx_internal::skinName = "upArrowSkin";
            this.mx_internal::upArrow.mx_internal::upIconName = "";
            this.mx_internal::upArrow.mx_internal::overIconName = "";
            this.mx_internal::upArrow.mx_internal::downIconName = "";
            this.mx_internal::upArrow.mx_internal::disabledIconName = "";
            addChild(this.mx_internal::upArrow);
            this.mx_internal::upArrow.styleName = new StyleProxy(this,this.upArrowStyleFilters);
            this.mx_internal::upArrow.validateProperties();
            this.mx_internal::upArrow.addEventListener(FlexEvent.BUTTON_DOWN,this.upArrow_buttonDownHandler);
         }
         if(!this.mx_internal::downArrow)
         {
            this.mx_internal::downArrow = new Button();
            this.mx_internal::downArrow.enabled = false;
            this.mx_internal::downArrow.autoRepeat = true;
            this.mx_internal::downArrow.focusEnabled = false;
            this.mx_internal::downArrow.tabEnabled = false;
            this.mx_internal::downArrow.mx_internal::upSkinName = "downArrowUpSkin";
            this.mx_internal::downArrow.mx_internal::overSkinName = "downArrowOverSkin";
            this.mx_internal::downArrow.mx_internal::downSkinName = "downArrowDownSkin";
            this.mx_internal::downArrow.mx_internal::disabledSkinName = "downArrowDisabledSkin";
            this.mx_internal::downArrow.mx_internal::skinName = "downArrowSkin";
            this.mx_internal::downArrow.mx_internal::upIconName = "";
            this.mx_internal::downArrow.mx_internal::overIconName = "";
            this.mx_internal::downArrow.mx_internal::downIconName = "";
            this.mx_internal::downArrow.mx_internal::disabledIconName = "";
            addChild(this.mx_internal::downArrow);
            this.mx_internal::downArrow.styleName = new StyleProxy(this,this.downArrowStyleFilters);
            this.mx_internal::downArrow.validateProperties();
            this.mx_internal::downArrow.addEventListener(FlexEvent.BUTTON_DOWN,this.downArrow_buttonDownHandler);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.mx_internal::upArrow.validateSize();
         this.mx_internal::downArrow.validateSize();
         this.mx_internal::scrollTrack.validateSize();
         this.mx_internal::_minWidth = this.mx_internal::scrollThumb ? this.mx_internal::scrollThumb.getExplicitOrMeasuredWidth() : 0;
         this.mx_internal::_minWidth = Math.max(this.mx_internal::scrollTrack.getExplicitOrMeasuredWidth(),this.mx_internal::upArrow.getExplicitOrMeasuredWidth(),this.mx_internal::downArrow.getExplicitOrMeasuredWidth(),this.mx_internal::_minWidth);
         this.mx_internal::_minHeight = this.mx_internal::upArrow.getExplicitOrMeasuredHeight() + this.mx_internal::downArrow.getExplicitOrMeasuredHeight();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(mx_internal::$height == 1)
         {
            return;
         }
         if(!this.mx_internal::upArrow)
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         if(cacheAsBitmap)
         {
            cacheHeuristic = false;
            if(this.mx_internal::scrollThumb)
            {
               this.mx_internal::scrollThumb.cacheHeuristic = false;
            }
         }
         this.mx_internal::upArrow.setActualSize(this.mx_internal::upArrow.getExplicitOrMeasuredWidth(),this.mx_internal::upArrow.getExplicitOrMeasuredHeight());
         this.mx_internal::upArrow.move((this.mx_internal::virtualWidth - this.mx_internal::upArrow.width) / 2,0);
         this.mx_internal::scrollTrack.setActualSize(this.mx_internal::scrollTrack.getExplicitOrMeasuredWidth(),this.mx_internal::virtualHeight);
         this.mx_internal::scrollTrack.x = (this.mx_internal::virtualWidth - this.mx_internal::scrollTrack.width) / 2;
         this.mx_internal::scrollTrack.y = 0;
         this.mx_internal::downArrow.setActualSize(this.mx_internal::downArrow.getExplicitOrMeasuredWidth(),this.mx_internal::downArrow.getExplicitOrMeasuredHeight());
         this.mx_internal::downArrow.move((this.mx_internal::virtualWidth - this.mx_internal::downArrow.width) / 2,this.mx_internal::virtualHeight - this.mx_internal::downArrow.getExplicitOrMeasuredHeight());
         this.setScrollProperties(this.pageSize,this.minScrollPosition,this.maxScrollPosition,this._pageScrollSize);
         this.scrollPosition = this._scrollPosition;
      }
      
      public function setScrollProperties(param1:Number, param2:Number, param3:Number, param4:Number = 0) : void
      {
         var _loc5_:Number = NaN;
         this.pageSize = param1;
         this._pageScrollSize = param4 > 0 ? param4 : param1;
         this.minScrollPosition = Math.max(param2,0);
         this.maxScrollPosition = Math.max(param3,0);
         this._scrollPosition = Math.max(this.minScrollPosition,this._scrollPosition);
         this._scrollPosition = Math.min(this.maxScrollPosition,this._scrollPosition);
         if(this.maxScrollPosition - this.minScrollPosition > 0 && enabled)
         {
            this.mx_internal::upArrow.enabled = true;
            this.mx_internal::downArrow.enabled = true;
            this.mx_internal::scrollTrack.enabled = true;
            addEventListener(MouseEvent.MOUSE_DOWN,this.scrollTrack_mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_OVER,this.scrollTrack_mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,this.scrollTrack_mouseOutHandler);
            if(!this.mx_internal::scrollThumb)
            {
               this.mx_internal::scrollThumb = new ScrollThumb();
               this.mx_internal::scrollThumb.focusEnabled = false;
               this.mx_internal::scrollThumb.tabEnabled = false;
               addChildAt(this.mx_internal::scrollThumb,getChildIndex(this.mx_internal::downArrow));
               this.mx_internal::scrollThumb.styleName = new StyleProxy(this,this.thumbStyleFilters);
               this.mx_internal::scrollThumb.mx_internal::upSkinName = "thumbUpSkin";
               this.mx_internal::scrollThumb.mx_internal::overSkinName = "thumbOverSkin";
               this.mx_internal::scrollThumb.mx_internal::downSkinName = "thumbDownSkin";
               this.mx_internal::scrollThumb.mx_internal::iconName = "thumbIcon";
               this.mx_internal::scrollThumb.mx_internal::skinName = "thumbSkin";
            }
            _loc5_ = this.trackHeight < 0 ? 0 : Math.round(param1 / (this.maxScrollPosition - this.minScrollPosition + param1) * this.trackHeight);
            if(_loc5_ < this.mx_internal::scrollThumb.minHeight)
            {
               if(this.trackHeight < this.mx_internal::scrollThumb.minHeight)
               {
                  this.mx_internal::scrollThumb.visible = false;
               }
               else
               {
                  _loc5_ = this.mx_internal::scrollThumb.minHeight;
                  this.mx_internal::scrollThumb.visible = true;
                  this.mx_internal::scrollThumb.setActualSize(this.mx_internal::scrollThumb.measuredWidth,this.mx_internal::scrollThumb.minHeight);
               }
            }
            else
            {
               this.mx_internal::scrollThumb.visible = true;
               this.mx_internal::scrollThumb.setActualSize(this.mx_internal::scrollThumb.measuredWidth,_loc5_);
            }
            this.mx_internal::scrollThumb.mx_internal::setRange(this.mx_internal::upArrow.getExplicitOrMeasuredHeight() + 0,this.mx_internal::virtualHeight - this.mx_internal::downArrow.getExplicitOrMeasuredHeight() - this.mx_internal::scrollThumb.height,this.minScrollPosition,this.maxScrollPosition);
            this.scrollPosition = Math.max(Math.min(this.scrollPosition,this.maxScrollPosition),this.minScrollPosition);
         }
         else
         {
            this.mx_internal::upArrow.enabled = false;
            this.mx_internal::downArrow.enabled = false;
            this.mx_internal::scrollTrack.enabled = false;
            if(this.mx_internal::scrollThumb)
            {
               this.mx_internal::scrollThumb.visible = false;
            }
         }
      }
      
      mx_internal function lineScroll(param1:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Number = this._lineScrollSize;
         var _loc3_:Number = this._scrollPosition + param1 * _loc2_;
         if(_loc3_ > this.maxScrollPosition)
         {
            _loc3_ = this.maxScrollPosition;
         }
         else if(_loc3_ < this.minScrollPosition)
         {
            _loc3_ = this.minScrollPosition;
         }
         if(_loc3_ != this.scrollPosition)
         {
            _loc4_ = this.scrollPosition;
            this.scrollPosition = _loc3_;
            _loc5_ = param1 < 0 ? this.mx_internal::lineMinusDetail : this.mx_internal::linePlusDetail;
            this.mx_internal::dispatchScrollEvent(_loc4_,_loc5_);
         }
      }
      
      mx_internal function pageScroll(param1:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Number = this._pageScrollSize != 0 ? this._pageScrollSize : this.pageSize;
         var _loc3_:Number = this._scrollPosition + param1 * _loc2_;
         if(_loc3_ > this.maxScrollPosition)
         {
            _loc3_ = this.maxScrollPosition;
         }
         else if(_loc3_ < this.minScrollPosition)
         {
            _loc3_ = this.minScrollPosition;
         }
         if(_loc3_ != this.scrollPosition)
         {
            _loc4_ = this.scrollPosition;
            this.scrollPosition = _loc3_;
            _loc5_ = param1 < 0 ? this.mx_internal::pageMinusDetail : this.mx_internal::pagePlusDetail;
            this.mx_internal::dispatchScrollEvent(_loc4_,_loc5_);
         }
      }
      
      mx_internal function dispatchScrollEvent(param1:Number, param2:String) : void
      {
         var _loc3_:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
         _loc3_.detail = param2;
         _loc3_.position = this.scrollPosition;
         _loc3_.delta = this.scrollPosition - param1;
         _loc3_.direction = this.direction;
         dispatchEvent(_loc3_);
      }
      
      mx_internal function isScrollBarKey(param1:uint) : Boolean
      {
         var _loc2_:Number = NaN;
         if(param1 == Keyboard.HOME)
         {
            if(this.scrollPosition != 0)
            {
               _loc2_ = this.scrollPosition;
               this.scrollPosition = 0;
               this.mx_internal::dispatchScrollEvent(_loc2_,this.minDetail);
            }
            return true;
         }
         if(param1 == Keyboard.END)
         {
            if(this.scrollPosition < this.maxScrollPosition)
            {
               _loc2_ = this.scrollPosition;
               this.scrollPosition = this.maxScrollPosition;
               this.mx_internal::dispatchScrollEvent(_loc2_,this.maxDetail);
            }
            return true;
         }
         return false;
      }
      
      private function upArrow_buttonDownHandler(param1:FlexEvent) : void
      {
         if(isNaN(this.mx_internal::oldPosition))
         {
            this.mx_internal::oldPosition = this.scrollPosition;
         }
         this.mx_internal::lineScroll(-1);
      }
      
      private function downArrow_buttonDownHandler(param1:FlexEvent) : void
      {
         if(isNaN(this.mx_internal::oldPosition))
         {
            this.mx_internal::oldPosition = this.scrollPosition;
         }
         this.mx_internal::lineScroll(1);
      }
      
      private function scrollTrack_mouseOverHandler(param1:MouseEvent) : void
      {
         if(!(param1.target == this || param1.target == this.mx_internal::scrollTrack) || !enabled)
         {
            return;
         }
         if(this.trackScrolling)
         {
            this.trackScrollTimer.start();
         }
      }
      
      private function scrollTrack_mouseOutHandler(param1:MouseEvent) : void
      {
         if(this.trackScrolling && enabled)
         {
            this.trackScrollTimer.stop();
         }
      }
      
      private function scrollTrack_mouseDownHandler(param1:MouseEvent) : void
      {
         if(!(param1.target == this || param1.target == this.mx_internal::scrollTrack) || !enabled)
         {
            return;
         }
         this.trackScrolling = true;
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.scrollTrack_mouseUpHandler,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.scrollTrack_mouseMoveHandler,true);
         _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(true);
         var _loc3_:Point = new Point(param1.localX,param1.localY);
         _loc3_ = param1.target.localToGlobal(_loc3_);
         _loc3_ = globalToLocal(_loc3_);
         this.trackPosition = _loc3_.y;
         if(isNaN(this.mx_internal::oldPosition))
         {
            this.mx_internal::oldPosition = this.scrollPosition;
         }
         this.trackScrollRepeatDirection = this.mx_internal::scrollThumb.y + this.mx_internal::scrollThumb.height < _loc3_.y ? 1 : (this.mx_internal::scrollThumb.y > _loc3_.y ? -1 : 0);
         this.mx_internal::pageScroll(this.trackScrollRepeatDirection);
         if(!this.trackScrollTimer)
         {
            this.trackScrollTimer = new Timer(getStyle("repeatDelay"),1);
            this.trackScrollTimer.addEventListener(TimerEvent.TIMER,this.trackScrollTimerHandler);
         }
         else
         {
            this.trackScrollTimer.delay = getStyle("repeatDelay");
            this.trackScrollTimer.repeatCount = 1;
         }
         this.trackScrollTimer.start();
      }
      
      private function trackScrollTimerHandler(param1:Event) : void
      {
         if(this.trackScrollRepeatDirection == 1)
         {
            if(this.mx_internal::scrollThumb.y + this.mx_internal::scrollThumb.height > this.trackPosition)
            {
               return;
            }
         }
         if(this.trackScrollRepeatDirection == -1)
         {
            if(this.mx_internal::scrollThumb.y < this.trackPosition)
            {
               return;
            }
         }
         this.mx_internal::pageScroll(this.trackScrollRepeatDirection);
         if(Boolean(this.trackScrollTimer) && this.trackScrollTimer.repeatCount == 1)
         {
            this.trackScrollTimer.delay = getStyle("repeatInterval");
            this.trackScrollTimer.repeatCount = 0;
         }
      }
      
      private function scrollTrack_mouseUpHandler(param1:MouseEvent) : void
      {
         this.scrollTrack_mouseLeaveHandler(param1);
      }
      
      private function scrollTrack_mouseLeaveHandler(param1:Event) : void
      {
         this.trackScrolling = false;
         var _loc2_:DisplayObject = systemManager.getSandboxRoot();
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.scrollTrack_mouseUpHandler,true);
         _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.scrollTrack_mouseMoveHandler,true);
         _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.scrollTrack_mouseLeaveHandler);
         systemManager.deployMouseShields(false);
         if(this.trackScrollTimer)
         {
            this.trackScrollTimer.reset();
         }
         if(param1.target != this.mx_internal::scrollTrack)
         {
            return;
         }
         var _loc3_:String = this.mx_internal::oldPosition > this.scrollPosition ? this.mx_internal::pageMinusDetail : this.mx_internal::pagePlusDetail;
         this.mx_internal::dispatchScrollEvent(this.mx_internal::oldPosition,_loc3_);
         this.mx_internal::oldPosition = NaN;
      }
      
      private function scrollTrack_mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this.trackScrolling)
         {
            _loc2_ = new Point(param1.stageX,param1.stageY);
            _loc2_ = globalToLocal(_loc2_);
            this.trackPosition = _loc2_.y;
         }
      }
   }
}

