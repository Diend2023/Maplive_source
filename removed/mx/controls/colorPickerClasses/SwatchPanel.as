package mx.controls.colorPickerClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.controls.ColorPicker;
   import mx.controls.TextInput;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.ITextInput;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.ColorPickerEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.skins.halo.SwatchPanelSkin;
   import mx.skins.halo.SwatchSkin;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class SwatchPanel extends UIComponent implements IFocusManagerContainer
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var textInput:ITextInput;
      
      mx_internal var textInputClass:Class;
      
      private var border:SwatchPanelSkin;
      
      private var preview:SwatchSkin;
      
      private var swatches:SwatchSkin;
      
      private var highlight:SwatchSkin;
      
      mx_internal var isOverGrid:Boolean = false;
      
      mx_internal var isOpening:Boolean = false;
      
      mx_internal var focusedIndex:int = -1;
      
      mx_internal var tweenUp:Boolean = false;
      
      private var initializing:Boolean = true;
      
      private var indexFlag:Boolean = false;
      
      private var lastIndex:int = -1;
      
      private var grid:Rectangle;
      
      private var rows:int;
      
      private var horizontalGap:Number;
      
      private var verticalGap:Number;
      
      private var columnCount:int;
      
      private var paddingLeft:Number;
      
      private var paddingRight:Number;
      
      private var paddingTop:Number;
      
      private var paddingBottom:Number;
      
      private var textFieldWidth:Number;
      
      private var previewWidth:Number;
      
      private var previewHeight:Number;
      
      private var swatchWidth:Number;
      
      private var swatchHeight:Number;
      
      private var swatchGridBorderSize:Number;
      
      private var cellOffset:Number = 1;
      
      private var itemOffset:Number = 3;
      
      private var _colorField:String = "color";
      
      private var _dataProvider:IList;
      
      private var _editable:Boolean = true;
      
      private var _labelField:String = "label";
      
      private var _selectedColor:uint = 0;
      
      private var _selectedIndex:int = 0;
      
      private var _showTextField:Boolean = true;
      
      public function SwatchPanel()
      {
         super();
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      override public function get height() : Number
      {
         return getExplicitOrMeasuredHeight();
      }
      
      override public function set height(param1:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         return getExplicitOrMeasuredWidth();
      }
      
      override public function set width(param1:Number) : void
      {
      }
      
      public function get colorField() : String
      {
         return this._colorField;
      }
      
      public function set colorField(param1:String) : void
      {
         this._colorField = param1;
      }
      
      public function get dataProvider() : Object
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:Object) : void
      {
         var _loc2_:IList = null;
         if(param1 is IList)
         {
            this._dataProvider = IList(param1);
         }
         else if(param1 is Array)
         {
            _loc2_ = new ArrayList(param1 as Array);
            param1 = _loc2_;
         }
         else
         {
            this._dataProvider = null;
         }
         if(!this.initializing)
         {
            if(this.length == 0 || isNaN(this.length))
            {
               this.highlight.visible = false;
               this._selectedIndex = -1;
            }
            this.refresh();
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         if(!this.initializing)
         {
            this.mx_internal::textInput.editable = param1;
         }
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         this._labelField = param1;
      }
      
      public function get length() : int
      {
         return this._dataProvider ? this._dataProvider.length : 0;
      }
      
      public function get selectedColor() : uint
      {
         return this._selectedColor;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         var _loc2_:int = 0;
         if(!this.indexFlag)
         {
            _loc2_ = this.findColorByName(param1);
            if(_loc2_ != -1)
            {
               this.mx_internal::focusedIndex = this.findColorByName(param1);
               this._selectedIndex = this.mx_internal::focusedIndex;
            }
            else
            {
               this.selectedIndex = -1;
            }
         }
         else
         {
            this.indexFlag = false;
         }
         if(param1 != this.selectedColor || !this.mx_internal::isOverGrid || this.mx_internal::isOpening)
         {
            this._selectedColor = param1;
            this.updateColor(param1);
            if(this.mx_internal::isOverGrid || this.mx_internal::isOpening)
            {
               this.setFocusOnSwatch(this.selectedIndex);
            }
            if(this.mx_internal::isOpening)
            {
               this.mx_internal::isOpening = false;
            }
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(param1 != this.selectedIndex && !this.initializing)
         {
            this.mx_internal::focusedIndex = param1;
            this._selectedIndex = this.mx_internal::focusedIndex;
            if(param1 >= 0)
            {
               this.indexFlag = true;
               this.selectedColor = this.getColor(param1);
            }
         }
      }
      
      public function get selectedItem() : Object
      {
         return this.dataProvider ? this.dataProvider.getItemAt(this.selectedIndex) : null;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != this.selectedItem)
         {
            if(typeof param1 == "object")
            {
               _loc2_ = Number(param1[this.colorField]);
            }
            else if(typeof param1 == "number")
            {
               _loc2_ = Number(param1);
            }
            this.selectedIndex = this.findColorByName(_loc2_);
         }
      }
      
      public function get showTextField() : Boolean
      {
         return this._showTextField;
      }
      
      public function set showTextField(param1:Boolean) : void
      {
         this._showTextField = param1;
         if(!this.initializing)
         {
            this.mx_internal::textInput.visible = param1;
         }
      }
      
      public function get defaultButton() : IFlexDisplayObject
      {
         return null;
      }
      
      public function set defaultButton(param1:IFlexDisplayObject) : void
      {
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Class = null;
         super.createChildren();
         if(!this.border)
         {
            this.border = new SwatchPanelSkin();
            this.border.styleName = this;
            this.border.name = "swatchPanelBorder";
            addChild(this.border);
         }
         if(!this.preview)
         {
            this.preview = new SwatchSkin();
            this.preview.styleName = this;
            this.preview.mx_internal::color = this.selectedColor;
            this.preview.name = "swatchPreview";
            this.preview.setStyle("swatchBorderSize",0);
            addChild(this.preview);
         }
         if(!this.mx_internal::textInput)
         {
            _loc1_ = getStyle("textInputClass");
            if(!_loc1_)
            {
               _loc1_ = this.mx_internal::textInputClass;
            }
            if(!_loc1_ || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
               this.mx_internal::textInput = new TextInput();
            }
            else
            {
               this.mx_internal::textInput = new this.mx_internal::textInputClass();
            }
            this.mx_internal::textInput.styleName = getStyle("textFieldStyleName");
            this.mx_internal::textInput.editable = this._editable;
            this.mx_internal::textInput.maxChars = 6;
            this.mx_internal::textInput.name = "inset";
            this.mx_internal::textInput.text = this.rgbToHex(this.selectedColor);
            this.mx_internal::textInput.restrict = "#xa-fA-F0-9";
            this.mx_internal::textInput.addEventListener(Event.CHANGE,this.textInput_changeHandler);
            this.mx_internal::textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.textInput_keyDownHandler);
            addChild(DisplayObject(this.mx_internal::textInput));
         }
         if(!this.swatches)
         {
            this.swatches = new SwatchSkin();
            this.swatches.styleName = this;
            this.swatches.mx_internal::colorField = this.colorField;
            this.swatches.name = "swatchGrid";
            this.swatches.addEventListener(MouseEvent.CLICK,this.swatches_clickHandler);
            addChild(this.swatches);
         }
         if(!this.highlight)
         {
            this.highlight = new SwatchSkin();
            this.highlight.styleName = this;
            this.highlight.visible = false;
            this.highlight.name = "swatchHighlight";
            addChild(this.highlight);
         }
         this.refresh();
         this.initializing = false;
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.swatches.mx_internal::updateGrid(IList(this.dataProvider));
         measuredWidth = Math.max(this.paddingLeft + this.paddingRight + this.swatches.width,100);
         measuredHeight = Math.max(this.paddingTop + this.previewHeight + this.itemOffset + this.paddingBottom + this.swatches.height,100);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.preview.mx_internal::updateSkin(this.selectedColor);
         this.preview.move(this.paddingLeft,this.paddingTop);
         this.mx_internal::textInput.setActualSize(this.textFieldWidth,this.previewHeight);
         this.mx_internal::textInput.move(this.paddingLeft + this.previewWidth + this.itemOffset,this.paddingTop);
         this.swatches.mx_internal::updateGrid(IList(this.dataProvider));
         this.swatches.move(this.paddingLeft,this.paddingTop + this.previewHeight + this.itemOffset);
         this.highlight.mx_internal::updateSkin(0);
         this.border.setActualSize(param1,param2);
         if(!this.grid)
         {
            this.grid = new Rectangle();
         }
         this.grid.left = this.swatches.x + this.swatchGridBorderSize;
         this.grid.top = this.swatches.y + this.swatchGridBorderSize;
         this.grid.right = this.swatches.x + this.swatchGridBorderSize + (this.swatchWidth - 1) * this.columnCount + 1 + this.horizontalGap * (this.columnCount - 1);
         this.grid.bottom = this.swatches.y + this.swatchGridBorderSize + (this.swatchHeight - 1) * this.rows + 1 + this.verticalGap * (this.rows - 1);
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         if(!this.initializing)
         {
            this.refresh();
         }
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
      }
      
      override public function setFocus() : void
      {
         if(this.showTextField && this.editable)
         {
            this.mx_internal::textInput.setFocus();
            this.mx_internal::textInput.text = this.rgbToHex(this.selectedColor);
         }
      }
      
      private function updateStyleCache() : void
      {
         this.horizontalGap = getStyle("horizontalGap");
         this.verticalGap = getStyle("verticalGap");
         this.columnCount = getStyle("columnCount");
         this.paddingLeft = getStyle("paddingLeft");
         this.paddingRight = getStyle("paddingRight");
         this.paddingTop = getStyle("paddingTop");
         this.paddingBottom = getStyle("paddingBottom");
         this.textFieldWidth = getStyle("textFieldWidth");
         this.previewWidth = getStyle("previewWidth");
         this.previewHeight = getStyle("previewHeight");
         this.swatchWidth = getStyle("swatchWidth");
         this.swatchHeight = getStyle("swatchHeight");
         this.swatchGridBorderSize = getStyle("swatchGridBorderSize");
         if(this.columnCount > this.length)
         {
            this.columnCount = this.length;
         }
         this.rows = Math.ceil(this.length / this.columnCount);
      }
      
      private function refresh() : void
      {
         this.updateStyleCache();
         this.updateDisplayList(unscaledWidth,unscaledHeight);
         invalidateSize();
      }
      
      private function updateColor(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.initializing || isNaN(param1))
         {
            return;
         }
         this.preview.mx_internal::updateSkin(param1);
         if(this.mx_internal::isOverGrid)
         {
            _loc2_ = null;
            if(this.mx_internal::focusedIndex >= 0 && typeof this.dataProvider.getItemAt(this.mx_internal::focusedIndex) == "object")
            {
               _loc2_ = this.dataProvider.getItemAt(this.mx_internal::focusedIndex)[this.labelField];
            }
            if(!(this.mx_internal::textInput is TextInput))
            {
               _loc3_ = this.mx_internal::textInput.selectionAnchorPosition;
               _loc4_ = this.mx_internal::textInput.selectionActivePosition;
            }
            this.mx_internal::textInput.text = _loc2_ != null && _loc2_.length != 0 ? _loc2_ : this.rgbToHex(param1);
            if(!(this.mx_internal::textInput is TextInput))
            {
               this.mx_internal::textInput.selectRange(_loc3_,_loc4_);
            }
         }
      }
      
      private function rgbToHex(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         var _loc3_:String = "00000" + _loc2_;
         var _loc4_:int = _loc3_.length;
         _loc3_ = _loc3_.substring(_loc4_ - 6,_loc4_);
         return _loc3_.toUpperCase();
      }
      
      private function findColorByName(param1:Number) : int
      {
         if(param1 == this.getColor(this.selectedIndex))
         {
            return this.selectedIndex;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.length)
         {
            if(param1 == this.getColor(_loc2_))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function getColor(param1:int) : uint
      {
         if(!this.dataProvider || this.dataProvider.length < 1 || param1 < 0 || param1 >= this.length)
         {
            return StyleManager.NOT_A_COLOR;
         }
         return uint(typeof this.dataProvider.getItemAt(param1) == "object" ? this.dataProvider.getItemAt(param1)[this.colorField] : this.dataProvider.getItemAt(param1));
      }
      
      private function setFocusOnSwatch(param1:int) : void
      {
         if(param1 < 0 || param1 > this.length - 1)
         {
            this.highlight.visible = false;
            return;
         }
         var _loc2_:Number = Math.floor(param1 / this.columnCount);
         var _loc3_:Number = param1 - _loc2_ * this.columnCount;
         var _loc4_:Number = this.swatchWidth * _loc3_ + this.horizontalGap * _loc3_ - this.cellOffset * _loc3_ + this.paddingLeft + this.swatchGridBorderSize;
         var _loc5_:Number = this.swatchHeight * _loc2_ + this.verticalGap * _loc2_ - this.cellOffset * _loc2_ + this.paddingTop + this.previewHeight + this.itemOffset + this.swatchGridBorderSize;
         this.highlight.move(_loc4_,_loc5_);
         this.highlight.visible = true;
         this.mx_internal::isOverGrid = true;
         this.updateColor(this.getColor(param1));
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.eventPhase != EventPhase.AT_TARGET || !enabled)
         {
            return;
         }
         if(this.mx_internal::focusedIndex == -1 || isNaN(this.mx_internal::focusedIndex))
         {
            this.mx_internal::focusedIndex = 0;
         }
         var _loc2_:int = Math.floor(this.mx_internal::focusedIndex / this.columnCount);
         var _loc3_:uint = uint(mx_internal::mapKeycodeForLayoutDirection(param1));
         switch(_loc3_)
         {
            case Keyboard.UP:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex - this.columnCount < 0 ? (this.rows - 1) * this.columnCount + this.mx_internal::focusedIndex + 1 : this.mx_internal::focusedIndex - this.columnCount;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.DOWN:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex + this.columnCount > this.length ? this.mx_internal::focusedIndex - 1 - (this.rows - 1) * this.columnCount : this.mx_internal::focusedIndex + this.columnCount;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.LEFT:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex < 1 ? this.length - 1 : this.mx_internal::focusedIndex - 1;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.RIGHT:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex >= this.length - 1 ? 0 : this.mx_internal::focusedIndex + 1;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.PAGE_UP:
               this.mx_internal::focusedIndex -= _loc2_ * this.columnCount;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.PAGE_DOWN:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex + (this.rows - 1) * this.columnCount - _loc2_ * this.columnCount;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.HOME:
               this.mx_internal::focusedIndex -= this.mx_internal::focusedIndex - _loc2_ * this.columnCount;
               this.mx_internal::isOverGrid = true;
               break;
            case Keyboard.END:
               this.mx_internal::focusedIndex = this.mx_internal::focusedIndex + (_loc2_ * this.columnCount - this.mx_internal::focusedIndex) + (this.columnCount - 1);
               this.mx_internal::isOverGrid = true;
         }
         if(this.mx_internal::focusedIndex < this.length && this.mx_internal::isOverGrid)
         {
            this.setFocusOnSwatch(this.mx_internal::focusedIndex);
            dispatchEvent(new Event("change"));
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:ColorPickerEvent = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(ColorPicker(owner).mx_internal::isDown && enabled)
         {
            if(mouseX > this.grid.left && mouseX < this.grid.right && mouseY > this.grid.top && mouseY < this.grid.bottom)
            {
               _loc3_ = Math.floor((Math.floor(mouseX) - (this.grid.left + this.verticalGap)) / (this.swatchWidth + this.horizontalGap - this.cellOffset));
               _loc4_ = Math.floor((Math.floor(mouseY) - this.grid.top) / (this.swatchHeight + this.verticalGap - this.cellOffset));
               _loc5_ = _loc4_ * this.columnCount + _loc3_;
               if(_loc3_ == -1)
               {
                  _loc5_++;
               }
               else if(_loc3_ > this.columnCount - 1)
               {
                  _loc5_--;
               }
               else if(_loc4_ > this.rows - 1)
               {
                  _loc5_ -= this.columnCount;
               }
               else if(_loc5_ < 0)
               {
                  _loc5_ += this.columnCount;
               }
               if((this.lastIndex != _loc5_ || this.highlight.visible == false) && _loc5_ < this.length)
               {
                  if(this.lastIndex != -1 && this.lastIndex != _loc5_)
                  {
                     _loc2_ = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                     _loc2_.index = this.lastIndex;
                     _loc2_.color = this.getColor(this.lastIndex);
                     dispatchEvent(_loc2_);
                  }
                  this.mx_internal::focusedIndex = _loc5_;
                  this.lastIndex = this.mx_internal::focusedIndex;
                  this.setFocusOnSwatch(this.mx_internal::focusedIndex);
                  _loc2_ = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER);
                  _loc2_.index = this.mx_internal::focusedIndex;
                  _loc2_.color = this.getColor(this.mx_internal::focusedIndex);
                  dispatchEvent(_loc2_);
               }
            }
            else
            {
               if(this.highlight.visible == true && this.mx_internal::isOverGrid && this.lastIndex != -1)
               {
                  this.highlight.visible = false;
                  _loc2_ = new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT);
                  _loc2_.index = this.lastIndex;
                  _loc2_.color = this.getColor(this.lastIndex);
                  dispatchEvent(_loc2_);
               }
               this.mx_internal::isOverGrid = false;
            }
         }
      }
      
      private function swatches_clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ColorPickerEvent = null;
         if(!enabled)
         {
            return;
         }
         if(mouseX > this.grid.left && mouseX < this.grid.right && mouseY > this.grid.top && mouseY < this.grid.bottom)
         {
            this.selectedIndex = this.mx_internal::focusedIndex;
            if(ColorPicker(owner).selectedIndex != this.selectedIndex)
            {
               ColorPicker(owner).selectedIndex = this.selectedIndex;
               _loc2_ = new ColorPickerEvent(ColorPickerEvent.CHANGE);
               _loc2_.index = this.selectedIndex;
               _loc2_.color = this.getColor(this.selectedIndex);
               ColorPicker(owner).dispatchEvent(_loc2_);
            }
            ColorPicker(owner).close();
         }
      }
      
      private function textInput_keyDownHandler(param1:KeyboardEvent) : void
      {
         ColorPicker(owner).dispatchEvent(param1);
      }
      
      private function textInput_changeHandler(param1:Event) : void
      {
         var _loc2_:String = ITextInput(param1.target).text;
         if(_loc2_.charAt(0) == "#")
         {
            this.mx_internal::textInput.maxChars = 7;
            _loc2_ = "0x" + _loc2_.substring(1);
         }
         else if(_loc2_.substring(0,2) == "0x")
         {
            this.mx_internal::textInput.maxChars = 8;
         }
         else
         {
            this.mx_internal::textInput.maxChars = 6;
            _loc2_ = "0x" + _loc2_;
         }
         this.highlight.visible = false;
         this.mx_internal::isOverGrid = false;
         this.selectedColor = Number(_loc2_);
         dispatchEvent(new Event("change"));
      }
   }
}

