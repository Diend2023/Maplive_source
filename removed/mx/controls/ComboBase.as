package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.ListCollectionView;
   import mx.collections.XMLListCollection;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IIMESupport;
   import mx.core.IRectangularBorder;
   import mx.core.ITextInput;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   import mx.utils.UIDUtil;
   
   use namespace mx_internal;
   
   public class ComboBase extends UIComponent implements IIMESupport, IFocusManagerComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var _textInputStyleFilters:Object = {
         "backgroundAlpha":"backgroundAlpha",
         "backgroundColor":"backgroundColor",
         "backgroundImage":"backgroundImage",
         "backgroundDisabledColor":"backgroundDisabledColor",
         "backgroundSize":"backgroundSize",
         "borderAlpha":"borderAlpha",
         "borderColor":"borderColor",
         "borderSides":"borderSides",
         "borderStyle":"borderStyle",
         "borderThickness":"borderThickness",
         "dropShadowColor":"dropShadowColor",
         "dropShadowEnabled":"dropShadowEnabled",
         "embedFonts":"embedFonts",
         "focusAlpha":"focusAlpha",
         "focusBlendMode":"focusBlendMode",
         "focusRoundedCorners":"focusRoundedCorners",
         "focusThickness":"focusThickness",
         "leading":"leading",
         "paddingLeft":"paddingLeft",
         "paddingRight":"paddingRight",
         "shadowDirection":"shadowDirection",
         "shadowDistance":"shadowDistance",
         "textDecoration":"textDecoration"
      };
      
      protected var collection:ICollectionView;
      
      protected var iterator:IViewCursor;
      
      mx_internal var collectionIterator:IViewCursor;
      
      mx_internal var border:IFlexDisplayObject;
      
      mx_internal var downArrowButton:Button;
      
      mx_internal var wrapDownArrowButton:Boolean = true;
      
      mx_internal var useFullDropdownSkin:Boolean = false;
      
      private var selectedUID:String;
      
      mx_internal var selectionChanged:Boolean = false;
      
      mx_internal var selectedIndexChanged:Boolean = false;
      
      mx_internal var selectedItemChanged:Boolean = false;
      
      mx_internal var oldBorderStyle:String;
      
      private var _enabled:Boolean = false;
      
      private var enabledChanged:Boolean = false;
      
      private var _editable:Boolean = false;
      
      mx_internal var editableChanged:Boolean = true;
      
      private var _imeMode:String = null;
      
      private var _restrict:String;
      
      private var _selectedIndex:int = -1;
      
      private var _selectedItem:Object;
      
      private var _text:String = "";
      
      mx_internal var textChanged:Boolean;
      
      protected var textInput:ITextInput;
      
      public function ComboBase()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!mx_internal::validateBaselinePosition())
         {
            return NaN;
         }
         return this.textInput.y + this.textInput.baselinePosition;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this._enabled = param1;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      protected function get arrowButtonStyleFilters() : Object
      {
         return null;
      }
      
      protected function get borderMetrics() : EdgeMetrics
      {
         if(Boolean(this.mx_internal::border) && this.mx_internal::border is IRectangularBorder)
         {
            return IRectangularBorder(this.mx_internal::border).borderMetrics;
         }
         return EdgeMetrics.EMPTY;
      }
      
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         return this.collection;
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc3_:Array = null;
         if(param1 is Array)
         {
            this.collection = new ArrayCollection(param1 as Array);
         }
         else if(param1 is ICollectionView)
         {
            this.collection = ICollectionView(param1);
         }
         else if(param1 is IList)
         {
            this.collection = new ListCollectionView(IList(param1));
         }
         else if(param1 is XMLList)
         {
            this.collection = new XMLListCollection(param1 as XMLList);
         }
         else
         {
            _loc3_ = [param1];
            this.collection = new ArrayCollection(_loc3_);
         }
         this.iterator = this.collection.createCursor();
         this.mx_internal::collectionIterator = this.collection.createCursor();
         this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         var _loc2_:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         _loc2_.kind = CollectionEventKind.RESET;
         this.collectionChangeHandler(_loc2_);
         dispatchEvent(_loc2_);
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Bindable("editableChanged")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         this.mx_internal::editableChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("editableChanged"));
      }
      
      public function get enableIME() : Boolean
      {
         return this.editable;
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(param1:String) : void
      {
         this._imeMode = param1;
         if(this.textInput)
         {
            this.textInput.imeMode = this._imeMode;
         }
      }
      
      [Bindable("restrictChanged")]
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         this._restrict = param1;
         invalidateProperties();
         dispatchEvent(new Event("restrictChanged"));
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:CursorBookmark = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         this._selectedIndex = param1;
         if(param1 == -1)
         {
            this._selectedItem = null;
            this.selectedUID = null;
         }
         if(!this.collection || this.collection.length == 0)
         {
            this.mx_internal::selectedIndexChanged = true;
         }
         else if(param1 != -1)
         {
            param1 = Math.min(param1,this.collection.length - 1);
            _loc2_ = this.iterator.bookmark;
            _loc3_ = param1;
            this.iterator.seek(CursorBookmark.FIRST,_loc3_);
            _loc4_ = this.iterator.current;
            _loc5_ = this.itemToUID(_loc4_);
            this.iterator.seek(_loc2_,0);
            this._selectedIndex = param1;
            this._selectedItem = _loc4_;
            this.selectedUID = _loc5_;
         }
         this.mx_internal::selectionChanged = true;
         invalidateDisplayList();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         this.setSelectedItem(param1);
      }
      
      private function setSelectedItem(param1:Object, param2:Boolean = true) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedItem = param1;
            this.mx_internal::selectedItemChanged = true;
            invalidateDisplayList();
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:IViewCursor = this.collection.createCursor();
         var _loc5_:int = 0;
         do
         {
            if(param1 == _loc4_.current)
            {
               this._selectedIndex = _loc5_;
               this._selectedItem = param1;
               this.selectedUID = this.itemToUID(param1);
               this.mx_internal::selectionChanged = true;
               _loc3_ = true;
               break;
            }
         }
         while((++_loc4_).moveNext());
         
         if(!_loc3_)
         {
            this.selectedIndex = -1;
            this._selectedItem = null;
            this.selectedUID = null;
         }
         invalidateDisplayList();
      }
      
      [NonCommittingChangeEvent("change")]
      [Bindable("valueCommit")]
      [Bindable("collectionChange")]
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.mx_internal::textChanged = true;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function get textInputStyleFilters() : Object
      {
         return _textInputStyleFilters;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Object
      {
         if(this._editable)
         {
            return this.text;
         }
         var _loc1_:Object = this.selectedItem;
         if(_loc1_ == null || typeof _loc1_ != "object")
         {
            return _loc1_;
         }
         return _loc1_.data != null ? _loc1_.data : _loc1_.label;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ComboBase.mx_internal::createAccessibilityImplementation != null)
         {
            ComboBase.mx_internal::createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         super.createChildren();
         if(!this.mx_internal::border)
         {
            _loc1_ = getStyle("borderSkin");
            if(_loc1_)
            {
               this.mx_internal::border = new _loc1_();
               if(this.mx_internal::border is IFocusManagerComponent)
               {
                  IFocusManagerComponent(this.mx_internal::border).focusEnabled = false;
               }
               if(this.mx_internal::border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.mx_internal::border).styleName = this;
               }
               addChild(DisplayObject(this.mx_internal::border));
               if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
               {
                  this.mx_internal::border.visible = false;
               }
            }
         }
         if(!this.mx_internal::downArrowButton)
         {
            this.mx_internal::downArrowButton = new Button();
            this.mx_internal::downArrowButton.styleName = new StyleProxy(this,this.arrowButtonStyleFilters);
            this.mx_internal::downArrowButton.focusEnabled = false;
            this.mx_internal::downArrowButton.tabEnabled = false;
            addChild(this.mx_internal::downArrowButton);
            this.mx_internal::downArrowButton.addEventListener(FlexEvent.BUTTON_DOWN,this.downArrowButton_buttonDownHandler);
         }
         if(!this.textInput)
         {
            _loc2_ = getStyle("textInputStyleName");
            if(!_loc2_)
            {
               _loc2_ = new StyleProxy(this,this.textInputStyleFilters);
            }
            _loc3_ = getStyle("textInputClass");
            if(!_loc3_ || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
               this.textInput = new TextInput();
            }
            else
            {
               this.textInput = new _loc3_();
            }
            this.textInput.editable = this._editable;
            this.mx_internal::editableChanged = true;
            this.textInput.restrict = "^\x1b";
            this.textInput.focusEnabled = false;
            this.textInput.mouseEnabled = this.textInput.mouseChildren = this._editable;
            this.textInput.imeMode = this._imeMode;
            this.textInput.styleName = _loc2_;
            this.textInput.addEventListener(Event.CHANGE,this.textInput_changeHandler);
            this.textInput.addEventListener(FlexEvent.ENTER,this.textInput_enterHandler);
            this.textInput.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler);
            this.textInput.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler);
            this.textInput.addEventListener(FlexEvent.VALUE_COMMIT,this.textInput_valueCommitHandler);
            addChild(DisplayObject(this.textInput));
            this.textInput.move(0,0);
            this.textInput.parentDrawsFocus = true;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(this.mx_internal::downArrowButton)
         {
            this.mx_internal::downArrowButton.styleChanged(param1);
         }
         if(this.textInput)
         {
            this.textInput.styleChanged(param1);
         }
         if(Boolean(this.mx_internal::border) && this.mx_internal::border is ISimpleStyleClient)
         {
            ISimpleStyleClient(this.mx_internal::border).styleChanged(param1);
         }
         super.styleChanged(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         super.commitProperties();
         this.textInput.restrict = this._restrict;
         if(this.mx_internal::textChanged)
         {
            this.textInput.text = this._text;
            this.mx_internal::textChanged = false;
         }
         if(this.enabledChanged)
         {
            this.textInput.enabled = this._enabled;
            this.mx_internal::editableChanged = true;
            this.mx_internal::downArrowButton.enabled = this._enabled;
            this.enabledChanged = false;
         }
         if(this.mx_internal::editableChanged)
         {
            this.mx_internal::editableChanged = false;
            _loc1_ = this._editable;
            if(this.mx_internal::wrapDownArrowButton == false)
            {
               if(_loc1_)
               {
                  if(this.mx_internal::oldBorderStyle)
                  {
                     setStyle("borderStyle",this.mx_internal::oldBorderStyle);
                  }
               }
               else
               {
                  this.mx_internal::oldBorderStyle = getStyle("borderStyle");
                  setStyle("borderStyle","comboNonEdit");
               }
            }
            if(this.mx_internal::useFullDropdownSkin)
            {
               if(_loc1_ && getStyle("editableSkin") != null)
               {
                  this.mx_internal::downArrowButton.mx_internal::skinName = "editableSkin";
               }
               else
               {
                  this.mx_internal::downArrowButton.mx_internal::skinName = "skin";
               }
               this.mx_internal::downArrowButton.mx_internal::upSkinName = _loc1_ ? "editableUpSkin" : "upSkin";
               this.mx_internal::downArrowButton.mx_internal::overSkinName = _loc1_ ? "editableOverSkin" : "overSkin";
               this.mx_internal::downArrowButton.mx_internal::downSkinName = _loc1_ ? "editableDownSkin" : "downSkin";
               this.mx_internal::downArrowButton.mx_internal::disabledSkinName = _loc1_ ? "editableDisabledSkin" : "disabledSkin";
               this.mx_internal::downArrowButton.mx_internal::changeSkins();
               this.mx_internal::downArrowButton.invalidateDisplayList();
            }
            if(this.textInput)
            {
               this.textInput.editable = _loc1_;
               this.textInput.selectable = _loc1_;
               if(_loc1_)
               {
                  this.textInput.removeEventListener(MouseEvent.MOUSE_DOWN,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.MOUSE_UP,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.ROLL_OVER,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(MouseEvent.ROLL_OUT,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
               else
               {
                  this.textInput.addEventListener(MouseEvent.MOUSE_DOWN,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.MOUSE_UP,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.ROLL_OVER,this.textInput_mouseEventHandler);
                  this.textInput.addEventListener(MouseEvent.ROLL_OUT,this.textInput_mouseEventHandler);
                  this.textInput.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
               }
            }
         }
      }
      
      override protected function measure() : void
      {
         var _loc4_:Object = null;
         var _loc5_:EdgeMetrics = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.measure();
         var _loc1_:Number = getStyle("arrowButtonWidth");
         var _loc2_:Number = this.mx_internal::downArrowButton.getExplicitOrMeasuredHeight();
         if(Boolean(this.collection) && this.collection.length > 0)
         {
            _loc4_ = this.calculatePreferredSizeFromData(this.collection.length);
            _loc5_ = this.borderMetrics;
            _loc6_ = _loc4_.width + _loc5_.left + _loc5_.right + 8;
            _loc7_ = _loc4_.height + _loc5_.top + _loc5_.bottom + UITextField.mx_internal::TEXT_HEIGHT_PADDING;
            measuredMinWidth = measuredWidth = _loc6_ + _loc1_;
            measuredMinHeight = measuredHeight = Math.max(_loc7_,_loc2_);
         }
         else
         {
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
            measuredHeight = DEFAULT_MEASURED_HEIGHT;
         }
         var _loc3_:Number = getStyle("paddingTop") + getStyle("paddingBottom");
         measuredMinHeight += _loc3_;
         measuredHeight += _loc3_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc7_:EdgeMetrics = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = param1;
         var _loc4_:Number = param2;
         var _loc5_:Number = getStyle("arrowButtonWidth");
         var _loc6_:Number = Number(this.textInput.getExplicitOrMeasuredHeight());
         if(isNaN(_loc5_))
         {
            _loc5_ = 0;
         }
         if(this.mx_internal::wrapDownArrowButton)
         {
            _loc7_ = this.borderMetrics;
            _loc8_ = _loc4_ - _loc7_.top - _loc7_.bottom;
            this.mx_internal::downArrowButton.setActualSize(_loc8_,_loc8_);
            this.mx_internal::downArrowButton.move(_loc3_ - _loc5_ - _loc7_.right,_loc7_.top);
            if(this.mx_internal::border)
            {
               this.mx_internal::border.setActualSize(_loc3_,_loc4_);
            }
            this.textInput.setActualSize(_loc3_ - _loc5_,_loc6_);
         }
         else if(!this._editable && this.mx_internal::useFullDropdownSkin)
         {
            _loc9_ = getStyle("paddingTop");
            _loc10_ = getStyle("paddingBottom");
            this.mx_internal::downArrowButton.move(0,0);
            if(this.mx_internal::border)
            {
               this.mx_internal::border.setActualSize(_loc3_,_loc4_);
            }
            this.textInput.setActualSize(_loc3_ - _loc5_,_loc6_);
            this.textInput.showBorderAndBackground(false);
            this.textInput.move(this.textInput.x,(_loc4_ - _loc6_ - _loc9_ - _loc10_) / 2 + _loc9_);
            this.mx_internal::downArrowButton.setActualSize(param1,param2);
         }
         else
         {
            this.mx_internal::downArrowButton.move(_loc3_ - _loc5_,0);
            if(this.mx_internal::border)
            {
               this.mx_internal::border.setActualSize(_loc3_ - _loc5_,_loc4_);
            }
            this.textInput.setActualSize(_loc3_ - _loc5_,_loc4_);
            this.mx_internal::downArrowButton.setActualSize(_loc5_,param2);
            this.textInput.showBorderAndBackground(true);
         }
         if(this.mx_internal::selectedItemChanged)
         {
            this.selectedItem = this.selectedItem;
            this.mx_internal::selectedItemChanged = false;
            this.mx_internal::selectedIndexChanged = false;
         }
         if(this.mx_internal::selectedIndexChanged)
         {
            this.selectedIndex = this.selectedIndex;
            this.mx_internal::selectedIndexChanged = false;
         }
      }
      
      override public function setFocus() : void
      {
         if(Boolean(this.textInput) && this._editable)
         {
            this.textInput.setFocus();
         }
         else
         {
            super.setFocus();
         }
      }
      
      override protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == this.textInput || super.isOurFocus(param1);
      }
      
      protected function calculatePreferredSizeFromData(param1:int) : Object
      {
         return null;
      }
      
      protected function itemToUID(param1:Object) : String
      {
         if(!param1)
         {
            return "null";
         }
         return UIDUtil.getUID(param1);
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         super.focusOutHandler(param1);
         var _loc2_:IFocusManager = focusManager;
         if(Boolean(_loc2_) && param1.target == this)
         {
            _loc2_.defaultButtonEnabled = true;
         }
         if(this._editable)
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:CollectionEvent = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = false;
            _loc5_ = CollectionEvent(param1);
            if(_loc5_.kind == CollectionEventKind.ADD)
            {
               if(this.selectedIndex >= _loc5_.location)
               {
                  ++this._selectedIndex;
               }
            }
            if(_loc5_.kind == CollectionEventKind.REMOVE)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.items.length)
               {
                  _loc7_ = this.itemToUID(_loc5_.items[_loc6_]);
                  if(this.selectedUID == _loc7_)
                  {
                     this.mx_internal::selectionChanged = true;
                  }
                  _loc6_++;
               }
               if(this.mx_internal::selectionChanged)
               {
                  if(this._selectedIndex >= this.collection.length)
                  {
                     this._selectedIndex = this.collection.length - 1;
                  }
                  this.mx_internal::selectedIndexChanged = true;
                  _loc2_ = true;
                  invalidateDisplayList();
               }
               else if(this.selectedIndex >= _loc5_.location)
               {
                  --this._selectedIndex;
                  this.mx_internal::selectedIndexChanged = true;
                  _loc2_ = true;
                  invalidateDisplayList();
               }
            }
            if(_loc5_.kind == CollectionEventKind.REFRESH)
            {
               this.mx_internal::selectedItemChanged = true;
               _loc2_ = true;
            }
            invalidateDisplayList();
            if(_loc2_)
            {
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            }
         }
      }
      
      private function textInput_mouseEventHandler(param1:Event) : void
      {
         this.mx_internal::downArrowButton.dispatchEvent(param1);
      }
      
      protected function textInput_changeHandler(param1:Event) : void
      {
         this._text = this.textInput.text;
         if(this._selectedIndex != -1)
         {
            this._selectedIndex = -1;
            this._selectedItem = null;
            this.selectedUID = null;
         }
      }
      
      private function textInput_valueCommitHandler(param1:FlexEvent) : void
      {
         this._text = this.textInput.text;
         dispatchEvent(param1);
      }
      
      private function textInput_enterHandler(param1:FlexEvent) : void
      {
         dispatchEvent(param1);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      protected function downArrowButton_buttonDownHandler(param1:FlexEvent) : void
      {
      }
      
      mx_internal function getTextInput() : ITextInput
      {
         return this.textInput;
      }
      
      mx_internal function get ComboDownArrowButton() : Button
      {
         return this.mx_internal::downArrowButton;
      }
   }
}

