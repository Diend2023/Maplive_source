package mx.controls.treeClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.controls.Tree;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IToolTip;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.events.TreeEvent;
   import mx.utils.PopUpUtil;
   
   use namespace mx_internal;
   
   public class TreeItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var listOwner:Tree;
      
      private var _data:Object;
      
      protected var disclosureIcon:IFlexDisplayObject;
      
      protected var icon:IFlexDisplayObject;
      
      protected var label:IUITextField;
      
      private var _listData:TreeListData;
      
      public function TreeItemRenderer()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         if(!mx_internal::validateBaselinePosition())
         {
            return NaN;
         }
         return this.label.y + this.label.baselinePosition;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         invalidateProperties();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(param1:BaseListData) : void
      {
         this._listData = TreeListData(param1);
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.mx_internal::createLabel(-1);
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,this.toolTipShowHandler);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Class = null;
         var _loc3_:* = undefined;
         var _loc4_:SpriteAsset = null;
         var _loc5_:Class = null;
         super.commitProperties();
         if(hasFontContextChanged() && this.label != null)
         {
            _loc1_ = getChildIndex(DisplayObject(this.label));
            this.mx_internal::removeLabel();
            this.mx_internal::createLabel(_loc1_);
         }
         if(this.icon)
         {
            removeChild(DisplayObject(this.icon));
            this.icon = null;
         }
         if(this.disclosureIcon)
         {
            this.disclosureIcon.removeEventListener(MouseEvent.MOUSE_DOWN,this.disclosureIcon_mouseDownHandler);
            this.disclosureIcon.removeEventListener(MouseEvent.CLICK,this.disclosureIcon_clickHandler);
            removeChild(DisplayObject(this.disclosureIcon));
            this.disclosureIcon = null;
         }
         if(this._data != null)
         {
            this.listOwner = Tree(this._listData.owner);
            if(this._listData.disclosureIcon)
            {
               _loc2_ = this._listData.disclosureIcon;
               _loc3_ = new _loc2_();
               if(!(_loc3_ is InteractiveObject))
               {
                  _loc4_ = new SpriteAsset();
                  _loc4_.addChild(_loc3_ as DisplayObject);
                  this.disclosureIcon = _loc4_ as IFlexDisplayObject;
               }
               else
               {
                  this.disclosureIcon = _loc3_;
               }
               if(this.disclosureIcon is ILayoutDirectionElement)
               {
                  ILayoutDirectionElement(this.disclosureIcon).layoutDirection = null;
               }
               addChild(this.disclosureIcon as DisplayObject);
               this.disclosureIcon.addEventListener(MouseEvent.MOUSE_DOWN,this.disclosureIcon_mouseDownHandler);
               this.disclosureIcon.addEventListener(MouseEvent.CLICK,this.disclosureIcon_clickHandler);
            }
            if(this._listData.icon)
            {
               _loc5_ = this._listData.icon;
               this.icon = new _loc5_();
               addChild(DisplayObject(this.icon));
            }
            this.label.text = this._listData.label;
            this.label.multiline = this.listOwner.variableRowHeight;
            this.label.wordWrap = this.listOwner.wordWrap;
         }
         else
         {
            this.label.text = " ";
            toolTip = null;
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = this._data ? this._listData.indent : 0;
         if(this.disclosureIcon)
         {
            _loc1_ += this.disclosureIcon.width;
         }
         if(this.icon)
         {
            _loc1_ += this.icon.measuredWidth;
         }
         if(this.label.width < 4 || this.label.height < 4)
         {
            this.label.width = 4;
            this.label.height = 16;
         }
         if(isNaN(explicitWidth))
         {
            _loc1_ += this.label.getExplicitOrMeasuredWidth();
            measuredWidth = _loc1_;
            measuredHeight = this.label.getExplicitOrMeasuredHeight();
         }
         else
         {
            this.label.width = Math.max(explicitWidth - _loc1_,4);
            measuredHeight = this.label.getExplicitOrMeasuredHeight();
            if(Boolean(this.icon) && this.icon.measuredHeight > measuredHeight)
            {
               measuredHeight = this.icon.measuredHeight;
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this._data ? this._listData.indent : 0;
         if(this.disclosureIcon)
         {
            this.disclosureIcon.x = _loc3_;
            _loc3_ = this.disclosureIcon.x + this.disclosureIcon.width;
            this.disclosureIcon.setActualSize(this.disclosureIcon.width,this.disclosureIcon.height);
            this.disclosureIcon.visible = this._data ? this._listData.hasChildren : false;
         }
         if(this.icon)
         {
            this.icon.x = _loc3_;
            _loc3_ = this.icon.x + this.icon.measuredWidth;
            this.icon.setActualSize(this.icon.measuredWidth,this.icon.measuredHeight);
         }
         this.label.x = _loc3_;
         this.label.setActualSize(param1 - _loc3_,measuredHeight);
         var _loc4_:String = getStyle("verticalAlign");
         if(_loc4_ == "top")
         {
            this.label.y = 0;
            if(this.icon)
            {
               this.icon.y = 0;
            }
            if(this.disclosureIcon)
            {
               this.disclosureIcon.y = 0;
            }
         }
         else if(_loc4_ == "bottom")
         {
            this.label.y = param2 - this.label.height + 2;
            if(this.icon)
            {
               this.icon.y = param2 - this.icon.height;
            }
            if(this.disclosureIcon)
            {
               this.disclosureIcon.y = param2 - this.disclosureIcon.height;
            }
         }
         else
         {
            this.label.y = (param2 - this.label.height) / 2;
            if(this.icon)
            {
               this.icon.y = (param2 - this.icon.height) / 2;
            }
            if(this.disclosureIcon)
            {
               this.disclosureIcon.y = (param2 - this.disclosureIcon.height) / 2;
            }
         }
         if(Boolean(this.data) && Boolean(parent))
         {
            if(!enabled)
            {
               _loc5_ = getStyle("disabledColor");
            }
            else if(this.listOwner.isItemHighlighted(this.listData.uid))
            {
               _loc5_ = getStyle("textRollOverColor");
            }
            else if(this.listOwner.isItemSelected(this.listData.uid))
            {
               _loc5_ = getStyle("textSelectedColor");
            }
            else
            {
               _loc5_ = getStyle("color");
            }
            this.label.setColor(_loc5_);
         }
         if(this._data != null)
         {
            if(this.listOwner.showDataTips)
            {
               if(this.label.textWidth > this.label.width || this.listOwner.dataTipFunction != null)
               {
                  toolTip = this.listOwner.itemToDataTip(this._data);
               }
               else
               {
                  toolTip = null;
               }
            }
            else
            {
               toolTip = null;
            }
         }
      }
      
      mx_internal function createLabel(param1:int) : void
      {
         if(!this.label)
         {
            this.label = IUITextField(createInFontContext(UITextField));
            this.label.styleName = this;
            if(param1 == -1)
            {
               addChild(DisplayObject(this.label));
            }
            else
            {
               addChildAt(DisplayObject(this.label),param1);
            }
         }
      }
      
      mx_internal function removeLabel() : void
      {
         if(this.label != null)
         {
            removeChild(DisplayObject(this.label));
            this.label = null;
         }
      }
      
      private function toolTipShowHandler(param1:ToolTipEvent) : void
      {
         var _loc2_:IToolTip = param1.toolTip;
         var _loc3_:Point = PopUpUtil.positionOverComponent(DisplayObject(this.label),systemManager,_loc2_.width,_loc2_.height,height / 2);
         _loc2_.move(_loc3_.x,_loc3_.y);
      }
      
      private function disclosureIcon_mouseDownHandler(param1:Event) : void
      {
         param1.stopPropagation();
         if(this.listOwner.mx_internal::isOpening || !this.listOwner.enabled)
         {
            return;
         }
         var _loc2_:Boolean = this._listData.open;
         this._listData.open = !_loc2_;
         this.listOwner.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,this._listData.item,this,param1,!_loc2_,true,true);
      }
      
      private function disclosureIcon_clickHandler(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      mx_internal function getLabel() : IUITextField
      {
         return this.label;
      }
      
      mx_internal function getDisclosureIcon() : IFlexDisplayObject
      {
         return this.disclosureIcon;
      }
   }
}

