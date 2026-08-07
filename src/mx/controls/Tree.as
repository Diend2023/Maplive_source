package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSelectionDataPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.controls.treeClasses.HierarchicalCollectionView;
   import mx.controls.treeClasses.HierarchicalViewCursor;
   import mx.controls.treeClasses.ITreeDataDescriptor;
   import mx.controls.treeClasses.ITreeDataDescriptor2;
   import mx.controls.treeClasses.TreeItemRenderer;
   import mx.controls.treeClasses.TreeListData;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFlexDisplayObject;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.ScrollEvent;
   import mx.events.TreeEvent;
   import mx.managers.DragManager;
   
   use namespace mx_internal;
   
   public class Tree extends List implements IIMESupport
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var IS_NEW_ROW_STYLE:Object = {
         "depthColors":true,
         "indentation":true,
         "disclosureOpenIcon":true,
         "disclosureClosedIcon":true,
         "folderOpenIcon":true,
         "folderClosedIcon":true,
         "defaultLeafIcon":true
      };
      
      private var opening:Boolean;
      
      private var tween:Object;
      
      private var maskList:Array;
      
      private var _userMaxHorizontalScrollPosition:Number = 0;
      
      private var eventPending:Object;
      
      private var eventAfterTween:Object;
      
      private var oldLength:int = -1;
      
      private var expandedItem:Object;
      
      private var bSelectedItemRemoved:Boolean = false;
      
      private var minScrollInterval:Number = 50;
      
      private var rowNameID:Number = 0;
      
      private var _editable:Boolean = false;
      
      private var dontEdit:Boolean = false;
      
      private var lastUserInteraction:Event;
      
      mx_internal var _dropData:Object;
      
      public var itemIcons:Object;
      
      mx_internal var isOpening:Boolean = false;
      
      private var rowIndex:int;
      
      private var rowsTweened:int;
      
      private var rowList:Array;
      
      mx_internal var collectionLength:int;
      
      mx_internal var wrappedCollection:ICollectionView;
      
      mx_internal var collectionThrowsIPE:Boolean;
      
      private var haveItemIndices:Boolean;
      
      private var lastTreeSeekPending:TreeSeekPending;
      
      private var bFinishArrowKeySelection:Boolean = false;
      
      private var proposedSelectedItem:Object;
      
      private var dataProviderChanged:Boolean = false;
      
      private var _dragMoveEnabled:Boolean = true;
      
      mx_internal var _dataDescriptor:ITreeDataDescriptor = new DefaultDataDescriptor();
      
      mx_internal var _showRoot:Boolean = true;
      
      mx_internal var showRootChanged:Boolean = false;
      
      mx_internal var _hasRoot:Boolean = false;
      
      mx_internal var _rootModel:ICollectionView;
      
      private var _openItems:Object = {};
      
      private var openItemsChanged:Boolean = false;
      
      public function Tree()
      {
         super();
         itemRenderer = new ClassFactory(TreeItemRenderer);
         editorXOffset = 12;
         editorWidthOffset = -12;
         addEventListener(TreeEvent.ITEM_OPENING,this.mx_internal::expandItemHandler,false,EventPriority.DEFAULT_HANDLER);
      }
      
      [Bindable("collectionChange")]
      override public function set dataProvider(param1:Object) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:Array = null;
         if(this.mx_internal::_rootModel)
         {
            this.mx_internal::_rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
         }
         if(typeof param1 == "string")
         {
            param1 = new XML(param1);
         }
         else if(param1 is XMLNode)
         {
            param1 = new XML(XMLNode(param1).toString());
         }
         else if(param1 is XMLList)
         {
            param1 = new XMLListCollection(param1 as XMLList);
         }
         if(param1 is XML)
         {
            this.mx_internal::_hasRoot = true;
            _loc2_ = new XMLList();
            _loc2_ += param1;
            this.mx_internal::_rootModel = new XMLListCollection(_loc2_);
         }
         else if(param1 is ICollectionView)
         {
            this.mx_internal::_rootModel = ICollectionView(param1);
            if(this.mx_internal::_rootModel.length == 1)
            {
               this.mx_internal::_hasRoot = true;
            }
         }
         else if(param1 is Array)
         {
            this.mx_internal::_rootModel = new ArrayCollection(param1 as Array);
         }
         else if(param1 is Object)
         {
            this.mx_internal::_hasRoot = true;
            _loc3_ = [];
            _loc3_.push(param1);
            this.mx_internal::_rootModel = new ArrayCollection(_loc3_);
         }
         else
         {
            this.mx_internal::_rootModel = new ArrayCollection();
         }
         this.dataProviderChanged = true;
         invalidateProperties();
      }
      
      override public function get dataProvider() : Object
      {
         if(this.mx_internal::_rootModel)
         {
            return this.mx_internal::_rootModel;
         }
         return null;
      }
      
      override public function get maxHorizontalScrollPosition() : Number
      {
         return this._userMaxHorizontalScrollPosition > 0 ? this._userMaxHorizontalScrollPosition : super.maxHorizontalScrollPosition;
      }
      
      override public function set maxHorizontalScrollPosition(param1:Number) : void
      {
         this._userMaxHorizontalScrollPosition = param1;
         param1 += this.getIndent();
         super.maxHorizontalScrollPosition = param1;
      }
      
      override public function get dragMoveEnabled() : Boolean
      {
         return this._dragMoveEnabled;
      }
      
      override public function set dragMoveEnabled(param1:Boolean) : void
      {
         this._dragMoveEnabled = param1;
      }
      
      [Bindable("firstVisibleItemChanged")]
      public function get firstVisibleItem() : Object
      {
         if(listItems.length > 0 && listItems[0].length > 0)
         {
            return listItems[0][0].data;
         }
         return null;
      }
      
      public function set firstVisibleItem(param1:Object) : void
      {
         var _loc2_:int = this.getItemIndex(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         verticalScrollPosition = Math.min(maxVerticalScrollPosition,_loc2_);
         dispatchEvent(new Event("firstVisibleItemChanged"));
      }
      
      public function set dataDescriptor(param1:ITreeDataDescriptor) : void
      {
         this.mx_internal::_dataDescriptor = param1;
      }
      
      public function get dataDescriptor() : ITreeDataDescriptor
      {
         return ITreeDataDescriptor(this.mx_internal::_dataDescriptor);
      }
      
      public function get showRoot() : Boolean
      {
         return this.mx_internal::_showRoot;
      }
      
      public function set showRoot(param1:Boolean) : void
      {
         if(this.mx_internal::_showRoot != param1)
         {
            this.mx_internal::_showRoot = param1;
            this.mx_internal::showRootChanged = true;
            invalidateProperties();
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return this.mx_internal::_hasRoot;
      }
      
      public function get openItems() : Object
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this._openItems)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function set openItems(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         if(param1 != null)
         {
            for(_loc2_ in this._openItems)
            {
               delete this._openItems[_loc2_];
            }
            for each(_loc3_ in param1)
            {
               this._openItems[itemToUID(_loc3_)] = _loc3_;
            }
            this.openItemsChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Tree.mx_internal::createAccessibilityImplementation != null)
         {
            Tree.mx_internal::createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:ICollectionView = null;
         var _loc2_:* = undefined;
         if(this.mx_internal::showRootChanged)
         {
            if(!this.mx_internal::_hasRoot)
            {
               this.mx_internal::showRootChanged = false;
            }
         }
         if(this.dataProviderChanged || this.mx_internal::showRootChanged || this.openItemsChanged)
         {
            this.dataProviderChanged = false;
            this.mx_internal::showRootChanged = false;
            if(!this.openItemsChanged)
            {
               this._openItems = {};
            }
            this.openItemsChanged = false;
            if(this.mx_internal::_rootModel && !this.mx_internal::_showRoot && this.mx_internal::_hasRoot)
            {
               _loc2_ = this.mx_internal::_rootModel.createCursor().current;
               if(_loc2_ != null && this.mx_internal::_dataDescriptor.isBranch(_loc2_,this.mx_internal::_rootModel) && this.mx_internal::_dataDescriptor.hasChildren(_loc2_,this.mx_internal::_rootModel))
               {
                  _loc1_ = this.mx_internal::getChildren(_loc2_,this.mx_internal::_rootModel);
               }
            }
            if(this.mx_internal::_rootModel)
            {
               super.dataProvider = this.mx_internal::wrappedCollection = this.mx_internal::_dataDescriptor is ITreeDataDescriptor2 ? ITreeDataDescriptor2(this.mx_internal::_dataDescriptor).getHierarchicalCollectionAdaptor(_loc1_ != null ? _loc1_ : this.mx_internal::_rootModel,itemToUID,this._openItems) : new HierarchicalCollectionView(_loc1_ != null ? _loc1_ : this.mx_internal::_rootModel,this.mx_internal::_dataDescriptor,itemToUID,this._openItems);
               this.mx_internal::wrappedCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(this.tween)
         {
            this.tween.endTween();
         }
         super.updateDisplayList(param1,param2);
         if(collection)
         {
            this.mx_internal::collectionLength = collection.length;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         if(param1 == null || param1 == "styleName" || Boolean(this.IS_NEW_ROW_STYLE[param1]))
         {
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         super.styleChanged(param1);
      }
      
      override public function showDropFeedback(param1:DragEvent) : void
      {
         var _loc5_:int = 0;
         super.showDropFeedback(param1);
         var _loc2_:EdgeMetrics = viewMetrics;
         var _loc3_:int = 0;
         this.updateDropData(param1);
         var _loc4_:int = 0;
         if(this.mx_internal::_dropData.parent)
         {
            _loc3_ = this.getItemIndex(iterator.current);
            _loc5_ = this.mx_internal::getItemDepth(this.mx_internal::_dropData.parent,Math.abs(_loc3_ - this.getItemIndex(this.mx_internal::_dropData.parent)));
            _loc4_ = (_loc5_ + 1) * getStyle("indentation");
         }
         else
         {
            _loc4_ = getStyle("indentation");
         }
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         mx_internal::dropIndicator.width = listContent.width - _loc4_;
         mx_internal::dropIndicator.x = _loc4_ + _loc2_.left + 2;
         if(this.mx_internal::_dropData.emptyFolder)
         {
            mx_internal::dropIndicator.y += this.mx_internal::_dropData.rowHeight / 2;
         }
      }
      
      override public function calculateDropIndex(param1:DragEvent = null) : int
      {
         if(param1)
         {
            this.updateDropData(param1);
         }
         return this.mx_internal::_dropData.rowIndex;
      }
      
      override protected function addDragData(param1:Object) : void
      {
         param1.addHandler(this.collapseSelectedItems,"treeItems");
      }
      
      override mx_internal function addClipMask(param1:Boolean) : void
      {
         var _loc2_:EdgeMetrics = viewMetrics;
         if(Boolean(horizontalScrollBar) && horizontalScrollBar.visible)
         {
            _loc2_.bottom -= horizontalScrollBar.minHeight;
         }
         if(Boolean(verticalScrollBar) && verticalScrollBar.visible)
         {
            _loc2_.right -= verticalScrollBar.minWidth;
         }
         listContent.scrollRect = new Rectangle(0,0,unscaledWidth - _loc2_.left - _loc2_.right,listContent.heightExcludingOffsets);
      }
      
      override mx_internal function removeClipMask() : void
      {
      }
      
      override protected function makeListData(param1:Object, param2:String, param3:int) : BaseListData
      {
         var _loc4_:TreeListData = new TreeListData(itemToLabel(param1),param2,this,param3);
         this.initListData(param1,_loc4_);
         return _loc4_;
      }
      
      override public function itemToIcon(param1:Object) : Class
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:Boolean = this.isItemOpen(param1);
         var _loc4_:Boolean = this.isBranch(param1);
         var _loc5_:String = itemToUID(param1);
         var _loc6_:Class = Boolean(this.itemIcons) && Boolean(this.itemIcons[_loc5_]) ? this.itemIcons[_loc5_][_loc3_ ? "iconID2" : "iconID"] : null;
         if(_loc6_)
         {
            return _loc6_;
         }
         if(iconFunction != null)
         {
            return iconFunction(param1);
         }
         if(_loc4_)
         {
            return getStyle(_loc3_ ? "folderOpenIcon" : "folderClosedIcon");
         }
         if(param1 is XML)
         {
            try
            {
               if(param1[iconField].length() != 0)
               {
                  _loc2_ = String(param1[iconField]);
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(param1 is Object)
         {
            try
            {
               if(Boolean(iconField) && Boolean(param1[iconField]))
               {
                  _loc2_ = param1[iconField];
               }
               else if(param1.icon)
               {
                  _loc2_ = param1.icon;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(_loc2_ == null)
         {
            _loc2_ = getStyle("defaultLeafIcon");
         }
         if(_loc2_ is Class)
         {
            return _loc2_;
         }
         if(_loc2_ is String)
         {
            _loc6_ = Class(systemManager.getDefinitionByName(String(_loc2_)));
            if(_loc6_)
            {
               return _loc6_;
            }
            return document[_loc2_];
         }
         return Class(_loc2_);
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc1_:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!_loc1_)
         {
            _loc1_ = new FlexSprite();
            _loc1_.name = "rowBGs";
            _loc1_.mouseEnabled = false;
            listContent.addChildAt(_loc1_,0);
         }
         var _loc4_:Boolean = false;
         _loc3_ = getStyle("depthColors");
         if(_loc3_)
         {
            _loc4_ = true;
         }
         else
         {
            _loc9_ = getStyle("alternatingItemColors");
            if(_loc9_)
            {
               _loc3_ = _loc9_ is Array ? _loc9_ as Array : [_loc9_];
            }
         }
         _loc2_ = getStyle("backgroundColor");
         if(_loc2_ === undefined)
         {
            _loc2_ = 16777215;
         }
         if(!_loc3_ || _loc3_.length == 0)
         {
            while(_loc1_.numChildren > _loc8_)
            {
               _loc1_.removeChildAt(_loc1_.numChildren - 1);
            }
            return;
         }
         styleManager.getColorNames(_loc3_);
         var _loc5_:int = 0;
         var _loc6_:int = verticalScrollPosition;
         var _loc7_:int = 0;
         _loc8_ = int(listItems.length);
         for(; _loc5_ < _loc8_; _loc5_++,_loc6_++)
         {
            if(_loc4_)
            {
               try
               {
                  if(listItems[_loc5_][0])
                  {
                     _loc10_ = this.mx_internal::getItemDepth(listItems[_loc5_][0].data,_loc5_);
                     _loc11_ = _loc3_[_loc10_ - 1] ? uint(_loc3_[_loc10_ - 1]) : uint(_loc2_);
                     drawRowBackground(_loc1_,_loc7_++,rowInfo[_loc5_].y,rowInfo[_loc5_].height,_loc11_,_loc5_);
                  }
                  else
                  {
                     drawRowBackground(_loc1_,_loc7_++,rowInfo[_loc5_].y,rowInfo[_loc5_].height,uint(_loc2_),_loc5_);
                  }
               }
               catch(e:Error)
               {
               }
               continue;
            }
            drawRowBackground(_loc1_,_loc7_++,rowInfo[_loc5_].y,rowInfo[_loc5_].height,_loc3_[_loc6_ % _loc3_.length],_loc6_);
         }
         while(_loc1_.numChildren > _loc8_)
         {
            _loc1_.removeChildAt(_loc1_.numChildren - 1);
         }
      }
      
      public function setItemIcon(param1:Object, param2:Class, param3:Class) : void
      {
         if(!this.itemIcons)
         {
            this.itemIcons = {};
         }
         if(!param3)
         {
            param3 = param2;
         }
         this.itemIcons[itemToUID(param1)] = {
            "iconID":param2,
            "iconID2":param3
         };
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      private function isBranch(param1:Object) : Boolean
      {
         if(param1 != null)
         {
            return this.mx_internal::_dataDescriptor.isBranch(param1,iterator.view);
         }
         return false;
      }
      
      mx_internal function getChildren(param1:Object, param2:Object) : ICollectionView
      {
         return this.mx_internal::_dataDescriptor.getChildren(param1,param2);
      }
      
      mx_internal function getItemDepth(param1:Object, param2:int) : int
      {
         if(!collection)
         {
            return 0;
         }
         if(!iterator)
         {
            listContent.iterator = collection.createCursor();
         }
         if(iterator.current == param1)
         {
            return this.getCurrentCursorDepth();
         }
         var _loc3_:CursorBookmark = iterator.bookmark;
         iterator.seek(_loc3_,param2);
         var _loc4_:int = this.getCurrentCursorDepth();
         iterator.seek(_loc3_,0);
         return _loc4_;
      }
      
      private function getCurrentCursorDepth() : int
      {
         if(this.mx_internal::_dataDescriptor is ITreeDataDescriptor2)
         {
            return ITreeDataDescriptor2(this.mx_internal::_dataDescriptor).getNodeDepth(iterator.current,iterator,this.mx_internal::_rootModel);
         }
         return HierarchicalViewCursor(iterator).currentDepth;
      }
      
      private function getVisibleChildrenCount(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:IViewCursor = null;
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:String = itemToUID(param1);
         if(this._openItems[_loc3_] && this.mx_internal::_dataDescriptor.isBranch(param1,iterator.view) && this.mx_internal::_dataDescriptor.hasChildren(param1,iterator.view))
         {
            _loc4_ = this.mx_internal::getChildren(param1,iterator.view);
         }
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.createCursor();
            while(!_loc5_.afterLast)
            {
               _loc2_++;
               _loc3_ = itemToUID(_loc5_.current);
               if(this._openItems[_loc3_])
               {
                  _loc2_ += this.getVisibleChildrenCount(_loc5_.current);
               }
               _loc5_.moveNext();
            }
         }
         return _loc2_;
      }
      
      public function isItemOpen(param1:Object) : Boolean
      {
         var _loc2_:String = itemToUID(param1);
         return this._openItems[_loc2_] != null;
      }
      
      private function makeMask() : DisplayObject
      {
         var _loc1_:Shape = new FlexShape();
         _loc1_.name = "mask";
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16777215);
         _loc2_.moveTo(0,0);
         _loc2_.lineTo(0,10);
         _loc2_.lineTo(10,10);
         _loc2_.lineTo(10,0);
         _loc2_.lineTo(0,0);
         _loc2_.endFill();
         listContent.addChild(_loc1_);
         return _loc1_;
      }
      
      public function expandItem(param1:Object, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:Event = null) : void
      {
         var bSelected:Boolean;
         var bHighlight:Boolean;
         var bCaret:Boolean;
         var uid:String;
         var bookmark:CursorBookmark;
         var event:CollectionEvent;
         var rC:int;
         var rowsToMove:int;
         var dur:Number;
         var i:int = 0;
         var newRowIndex:int = 0;
         var rowData:BaseListData = null;
         var tmpMask:DisplayObject = null;
         var tmpRowInfo:Object = null;
         var row:Array = null;
         var n:int = 0;
         var eventArr:Array = null;
         var renderer:IListItemRenderer = null;
         var xx:Number = NaN;
         var ww:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var delta:int = 0;
         var maxDist:Number = NaN;
         var oE:Function = null;
         var di:IDropInListItemRenderer = null;
         var treeListData:TreeListData = null;
         var data:Object = null;
         var referenceRowInfo:ListRowInfo = null;
         var rh:Number = NaN;
         var more:Boolean = false;
         var valid:Boolean = false;
         var startY:Number = NaN;
         var maskY:Number = NaN;
         var maskX:Number = NaN;
         var indicator:Object = null;
         var item:Object = param1;
         var open:Boolean = param2;
         var animate:Boolean = param3;
         var dispatchEvent:Boolean = param4;
         var cause:Event = param5;
         if(iterator == null)
         {
            return;
         }
         if(cause)
         {
            this.lastUserInteraction = cause;
         }
         this.expandedItem = item;
         listContent.mx_internal::allowItemSizeChangeNotification = false;
         bSelected = false;
         bHighlight = false;
         bCaret = false;
         uid = itemToUID(item);
         if(!this.isBranch(item) || this.isItemOpen(item) == open || this.mx_internal::isOpening)
         {
            return;
         }
         if(itemEditorInstance)
         {
            endEdit(ListEventReason.OTHER);
         }
         this.oldLength = this.mx_internal::collectionLength;
         bookmark = iterator.bookmark;
         event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,true,CollectionEventKind.mx_internal::EXPAND);
         event.items = [item];
         if(open)
         {
            this._openItems[uid] = item;
            collection.dispatchEvent(event);
            this.rowsTweened = Math.abs(this.oldLength - collection.length);
         }
         else
         {
            delete this._openItems[uid];
            collection.dispatchEvent(event);
            this.rowsTweened = Math.abs(this.oldLength - collection.length);
         }
         if(this.isItemVisible(item))
         {
            if(visibleData[uid])
            {
               n = int(listItems.length);
               this.rowIndex = 0;
               while(this.rowIndex < n)
               {
                  if(rowInfo[this.rowIndex].uid == uid)
                  {
                     ++this.rowIndex;
                     break;
                  }
                  ++this.rowIndex;
               }
            }
            rC = int(listItems.length);
            rowsToMove = this.rowsTweened;
            dur = getStyle("openDuration");
            if(animate && this.rowIndex < rC && rowsToMove > 0 && rowsToMove < 20 && dur != 0)
            {
               if(this.tween)
               {
                  this.tween.endTween();
               }
               renderer = listItems[this.rowIndex - 1][0];
               if(renderer is IDropInListItemRenderer)
               {
                  di = IDropInListItemRenderer(renderer);
                  treeListData = TreeListData(di.listData);
                  treeListData = TreeListData(this.makeListData(treeListData.item,treeListData.uid,treeListData.rowIndex));
                  di.listData = treeListData;
                  renderer.data = renderer.data;
               }
               this.opening = open;
               this.mx_internal::isOpening = true;
               this.maskList = [];
               this.rowList = [];
               xx = getStyle("paddingLeft") - horizontalScrollPosition;
               ww = Number(renderer.width);
               yy = 0;
               delta = this.rowIndex;
               maxDist = 0;
               if(open)
               {
                  newRowIndex = this.rowIndex;
                  maxDist = listContent.height - rowInfo[this.rowIndex].y;
                  iterator.seek(CursorBookmark.CURRENT,delta);
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     data = iterator.current;
                     if(freeItemRenderers.length)
                     {
                        renderer = freeItemRenderers.pop();
                     }
                     else
                     {
                        renderer = createItemRenderer(data);
                        renderer.owner = this;
                        renderer.styleName = listContent;
                        listContent.addChild(DisplayObject(renderer));
                     }
                     uid = itemToUID(data);
                     rowData = this.makeListData(data,uid,this.rowIndex + i);
                     rowMap[renderer.name] = rowData;
                     if(renderer is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(renderer).listData = data ? rowData : null;
                     }
                     renderer.data = data;
                     renderer.enabled = enabled;
                     if(data)
                     {
                        visibleData[uid] = renderer;
                        renderer.visible = true;
                     }
                     else
                     {
                        renderer.visible = false;
                     }
                     renderer.explicitWidth = ww;
                     if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                     {
                        IInvalidating(renderer).invalidateSize();
                     }
                     UIComponentGlobals.mx_internal::layoutManager.validateClient(renderer,true);
                     hh = Math.ceil(variableRowHeight ? renderer.getExplicitOrMeasuredHeight() + mx_internal::cachedPaddingTop + mx_internal::cachedPaddingBottom : rowHeight);
                     rh = Number(renderer.getExplicitOrMeasuredHeight());
                     renderer.setActualSize(ww,variableRowHeight ? rh : rowHeight - mx_internal::cachedPaddingTop - mx_internal::cachedPaddingBottom);
                     renderer.move(xx,yy + mx_internal::cachedPaddingTop);
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     if(data)
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy += hh;
                     rowInfo.splice(this.rowIndex + i,0,tmpRowInfo);
                     row = [];
                     row.push(renderer);
                     listItems.splice(this.rowIndex + i,0,row);
                     if(i < rowsToMove - 1)
                     {
                        try
                        {
                           iterator.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           rowsToMove = i + 1;
                           break;
                        }
                     }
                     i++;
                  }
                  this.rowsTweened = i;
                  referenceRowInfo = rowInfo[this.rowIndex + this.rowsTweened];
                  i = 0;
                  while(i < this.rowsTweened)
                  {
                     renderer = listItems[this.rowIndex + i][0];
                     renderer.move(renderer.x,renderer.y - (yy - referenceRowInfo.y));
                     rowInfo[this.rowIndex + i].y -= yy - referenceRowInfo.y;
                     tmpMask = this.makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = referenceRowInfo.y;
                     tmpMask.width = ww;
                     tmpMask.height = yy;
                     listItems[this.rowIndex + i][0].mask = tmpMask;
                     i++;
                  }
               }
               else
               {
                  more = true;
                  valid = true;
                  startY = yy = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height;
                  i = this.rowIndex;
                  while(i < this.rowIndex + rowsToMove && i < rC)
                  {
                     maxDist += rowInfo[i].height;
                     this.rowList.push({"item":listItems[i][0]});
                     tmpMask = this.makeMask();
                     tmpMask.x = xx;
                     tmpMask.y = listItems[this.rowIndex][0].y;
                     tmpMask.width = ww;
                     tmpMask.height = maxDist;
                     listItems[i][0].mask = tmpMask;
                     i++;
                  }
                  rowsToMove = i - this.rowIndex;
                  rowInfo.splice(this.rowIndex,rowsToMove);
                  listItems.splice(this.rowIndex,rowsToMove);
                  iterator.seek(CursorBookmark.CURRENT,listItems.length);
                  more = iterator != null && !iterator.afterLast && iteratorValid;
                  maxDist += yy;
                  i = 0;
                  while(i < rowsToMove && yy < maxDist)
                  {
                     uid = null;
                     data = null;
                     renderer = null;
                     valid = more;
                     data = more ? iterator.current : null;
                     if(valid)
                     {
                        if(freeItemRenderers.length)
                        {
                           renderer = freeItemRenderers.pop();
                        }
                        else
                        {
                           renderer = createItemRenderer(data);
                           renderer.owner = this;
                           renderer.styleName = listContent;
                           listContent.addChild(DisplayObject(renderer));
                        }
                        uid = itemToUID(data);
                        rowData = this.makeListData(data,uid,rC - rowsToMove + i);
                        rowMap[renderer.name] = rowData;
                        if(renderer is IDropInListItemRenderer)
                        {
                           IDropInListItemRenderer(renderer).listData = data ? rowData : null;
                        }
                        renderer.data = data;
                        renderer.enabled = enabled;
                        if(data)
                        {
                           visibleData[uid] = renderer;
                           renderer.visible = true;
                        }
                        else
                        {
                           renderer.visible = false;
                        }
                        renderer.explicitWidth = ww;
                        if(renderer is IInvalidating && (wordWrapChanged || variableRowHeight))
                        {
                           IInvalidating(renderer).invalidateSize();
                        }
                        UIComponentGlobals.mx_internal::layoutManager.validateClient(renderer,true);
                        hh = Math.ceil(variableRowHeight ? renderer.getExplicitOrMeasuredHeight() + mx_internal::cachedPaddingTop + mx_internal::cachedPaddingBottom : rowHeight);
                        rh = Number(renderer.getExplicitOrMeasuredHeight());
                        renderer.setActualSize(ww,variableRowHeight ? rh : rowHeight - mx_internal::cachedPaddingTop - mx_internal::cachedPaddingBottom);
                        renderer.move(xx,yy + mx_internal::cachedPaddingTop);
                     }
                     else if(!variableRowHeight)
                     {
                        hh = this.rowIndex + i > 0 ? Number(rowInfo[this.rowIndex + i - 1].height) : rowHeight;
                     }
                     else if(this.rowList[i])
                     {
                        hh = Math.ceil(this.rowList[i].item.getExplicitOrMeasuredHeight() + mx_internal::cachedPaddingTop + mx_internal::cachedPaddingBottom);
                     }
                     else
                     {
                        hh = rowHeight;
                     }
                     bSelected = selectedData[uid] != null;
                     bHighlight = highlightUID == uid;
                     bCaret = caretUID == uid;
                     tmpRowInfo = new ListRowInfo(yy,hh,uid,data);
                     rowInfo.push(tmpRowInfo);
                     if(data)
                     {
                        drawItem(renderer,bSelected,bHighlight,bCaret);
                     }
                     yy += hh;
                     if(valid)
                     {
                        row = [];
                        row.push(renderer);
                        listItems.push(row);
                     }
                     else
                     {
                        listItems.push([]);
                     }
                     if(more)
                     {
                        try
                        {
                           more = iterator.moveNext();
                        }
                        catch(e:ItemPendingError)
                        {
                           more = false;
                        }
                     }
                     i++;
                  }
                  maskY = this.rowList[0].item.y - getStyle("paddingTop");
                  maskX = this.rowList[0].item.x - getStyle("paddingLeft");
                  i = 0;
                  while(i < this.rowList.length)
                  {
                     indicator = selectionIndicators[itemToUID(this.rowList[i].item.data)];
                     if(indicator)
                     {
                        tmpMask = this.makeMask();
                        tmpMask.x = maskX;
                        tmpMask.y = maskY;
                        tmpMask.width = this.rowList[i].item.width + getStyle("paddingLeft") + getStyle("paddingRight");
                        tmpMask.height = this.rowList[i].item.y + this.rowList[i].item.height + getStyle("paddingTop") + getStyle("paddingBottom") - maskY;
                        selectionIndicators[itemToUID(this.rowList[i].item.data)].mask = tmpMask;
                     }
                     i++;
                  }
               }
               iterator.seek(bookmark,0);
               rC = int(this.rowList.length);
               i = 0;
               while(i < rC)
               {
                  this.rowList[i].itemOldY = this.rowList[i].item.y;
                  i++;
               }
               rC = int(listItems.length);
               i = this.rowIndex;
               while(i < rC)
               {
                  if(listItems[i].length)
                  {
                     rowInfo[i].itemOldY = listItems[i][0].y;
                  }
                  rowInfo[i].oldY = rowInfo[i].y;
                  i++;
               }
               dur *= Math.max(rowsToMove / 5,1);
               if(dispatchEvent)
               {
                  this.eventAfterTween = item;
               }
               this.tween = new Tween(this,0,open ? yy : startY - yy,dur,5);
               oE = getStyle("openEasingFunction") as Function;
               if(oE != null)
               {
                  this.tween.easingFunction = oE;
               }
               UIComponent.suspendBackgroundProcessing();
               UIComponentGlobals.mx_internal::layoutManager.validateNow();
            }
            else
            {
               if(dispatchEvent)
               {
                  this.mx_internal::dispatchTreeEvent(open ? TreeEvent.ITEM_OPEN : TreeEvent.ITEM_CLOSE,item,visibleData[itemToUID(item)],this.lastUserInteraction);
                  this.lastUserInteraction = null;
               }
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            if(!wordWrap && initialized)
            {
               super.maxHorizontalScrollPosition = this._userMaxHorizontalScrollPosition > 0 ? this._userMaxHorizontalScrollPosition + this.getIndent() : super.maxHorizontalScrollPosition;
            }
            listContent.mx_internal::allowItemSizeChangeNotification = variableRowHeight;
            return;
         }
         eventArr = open ? this.buildUpCollectionEvents(true) : this.buildUpCollectionEvents(false);
         i = 0;
         while(i < eventArr.length)
         {
            collection.dispatchEvent(eventArr[i]);
            i++;
         }
      }
      
      mx_internal function onTweenUpdate(param1:Object) : void
      {
         var _loc2_:IFlexDisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Sprite = null;
         _loc3_ = int(listItems.length);
         _loc4_ = this.rowIndex;
         while(_loc4_ < _loc3_)
         {
            if(listItems[_loc4_].length)
            {
               _loc2_ = IFlexDisplayObject(listItems[_loc4_][0]);
               _loc6_ = Number(_loc2_.y);
               _loc2_.move(_loc2_.x,rowInfo[_loc4_].itemOldY + param1);
               _loc5_ = _loc2_.y - _loc6_;
            }
            _loc7_ = selectionIndicators[rowInfo[_loc4_].uid];
            rowInfo[_loc4_].y += _loc5_;
            if(_loc7_)
            {
               _loc7_.y += _loc5_;
            }
            _loc4_++;
         }
         _loc3_ = int(this.rowList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = null;
            _loc2_ = IFlexDisplayObject(this.rowList[_loc4_].item);
            if(rowMap[_loc2_.name] != null)
            {
               _loc7_ = selectionIndicators[BaseListData(rowMap[_loc2_.name]).uid];
            }
            _loc6_ = Number(_loc2_.y);
            _loc2_.move(_loc2_.x,this.rowList[_loc4_].itemOldY + param1);
            _loc5_ = _loc2_.y - _loc6_;
            if(_loc7_)
            {
               _loc7_.y += _loc5_;
            }
            _loc4_++;
         }
      }
      
      mx_internal function onTweenEnd(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:IDropInListItemRenderer = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:DisplayObject = null;
         UIComponent.resumeBackgroundProcessing();
         this.mx_internal::onTweenUpdate(param1);
         var _loc5_:int = int(listItems.length);
         this.mx_internal::isOpening = false;
         if(collection)
         {
            _loc8_ = this.opening ? this.buildUpCollectionEvents(true) : this.buildUpCollectionEvents(false);
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               collection.dispatchEvent(_loc8_[_loc2_]);
               _loc2_++;
            }
         }
         if(this.opening)
         {
            _loc9_ = -1;
            _loc2_ = this.rowIndex;
            while(_loc2_ < _loc5_)
            {
               if(listItems[_loc2_].length)
               {
                  _loc3_ = listItems[_loc2_][0];
                  _loc10_ = _loc3_.mask;
                  if(_loc10_)
                  {
                     listContent.removeChild(_loc10_);
                     _loc3_.mask = null;
                  }
                  rowMap[_loc3_.name].rowIndex = _loc2_;
                  if(_loc3_ is IDropInListItemRenderer)
                  {
                     _loc4_ = IDropInListItemRenderer(_loc3_);
                     if(_loc4_.listData)
                     {
                        _loc4_.listData.rowIndex = _loc2_;
                        _loc4_.listData = _loc4_.listData;
                     }
                  }
                  if(_loc3_.y > listContent.height)
                  {
                     addToFreeItemRenderers(_loc3_);
                     _loc6_ = itemToUID(_loc3_.data);
                     if(selectionIndicators[_loc6_])
                     {
                        _loc7_ = selectionIndicators[_loc6_];
                        if(_loc7_)
                        {
                           _loc10_ = _loc7_.mask;
                           if(_loc10_)
                           {
                              listContent.removeChild(_loc10_);
                              _loc7_.mask = null;
                           }
                        }
                        removeIndicators(_loc6_);
                     }
                     delete rowMap[_loc3_.name];
                     if(_loc9_ < 0)
                     {
                        _loc9_ = _loc2_;
                     }
                  }
               }
               else if(rowInfo[_loc2_].y >= listContent.height)
               {
                  if(_loc9_ < 0)
                  {
                     _loc9_ = _loc2_;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ >= 0)
            {
               rowInfo.splice(_loc9_);
               listItems.splice(_loc9_);
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.rowList.length)
            {
               _loc10_ = this.rowList[_loc2_].item.mask;
               if(_loc10_)
               {
                  listContent.removeChild(_loc10_);
                  this.rowList[_loc2_].item.mask = null;
               }
               addToFreeItemRenderers(this.rowList[_loc2_].item);
               _loc6_ = itemToUID(this.rowList[_loc2_].item.data);
               if(selectionIndicators[_loc6_])
               {
                  _loc7_ = selectionIndicators[_loc6_];
                  if(_loc7_)
                  {
                     _loc10_ = _loc7_.mask;
                     if(_loc10_)
                     {
                        listContent.removeChild(_loc10_);
                        _loc7_.mask = null;
                     }
                  }
                  removeIndicators(_loc6_);
               }
               delete rowMap[this.rowList[_loc2_].item.name];
               _loc2_++;
            }
            _loc2_ = this.rowIndex;
            while(_loc2_ < _loc5_)
            {
               if(listItems[_loc2_].length)
               {
                  _loc3_ = listItems[_loc2_][0];
                  rowMap[_loc3_.name].rowIndex = _loc2_;
                  if(_loc3_ is IDropInListItemRenderer)
                  {
                     _loc4_ = IDropInListItemRenderer(_loc3_);
                     if(_loc4_.listData)
                     {
                        _loc4_.listData.rowIndex = _loc2_;
                        _loc4_.listData = _loc4_.listData;
                     }
                  }
               }
               _loc2_++;
            }
         }
         if(this.eventAfterTween)
         {
            this.mx_internal::dispatchTreeEvent(this.isItemOpen(this.eventAfterTween) ? TreeEvent.ITEM_OPEN : TreeEvent.ITEM_CLOSE,this.eventAfterTween,visibleData[itemToUID(this.eventAfterTween)],this.lastUserInteraction);
            this.lastUserInteraction = null;
            this.eventAfterTween = false;
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
         this.tween = null;
      }
      
      private function buildUpCollectionEvents(param1:Boolean) : Array
      {
         var _loc2_:CollectionEvent = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc10_:ICollectionView = null;
         var _loc11_:IViewCursor = null;
         var _loc12_:Boolean = false;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:int = this.getItemIndex(this.expandedItem);
         if(param1)
         {
            _loc10_ = this.mx_internal::getChildren(this.expandedItem,iterator.view);
            if(!_loc10_)
            {
               return [];
            }
            _loc11_ = _loc10_.createCursor();
            _loc12_ = true;
            while(!_loc11_.afterLast)
            {
               _loc6_.push(_loc11_.current);
               _loc11_.moveNext();
            }
         }
         else
         {
            _loc13_ = [];
            _loc14_ = 0;
            _loc13_ = this.getOpenChildrenStack(this.expandedItem,_loc13_);
            while(_loc14_ < _loc13_.length)
            {
               _loc3_ = 0;
               while(_loc3_ < selectedItems.length)
               {
                  if(selectedItems[_loc3_] == _loc13_[_loc14_])
                  {
                     this.bSelectedItemRemoved = true;
                  }
                  _loc3_++;
               }
               _loc7_.push(_loc13_[_loc14_]);
               _loc14_++;
            }
         }
         if(_loc6_.length > 0)
         {
            _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc2_.kind = CollectionEventKind.ADD;
            _loc2_.location = _loc9_ + 1;
            _loc2_.items = _loc6_;
            _loc8_.push(_loc2_);
         }
         if(_loc7_.length > 0)
         {
            _loc2_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc2_.kind = CollectionEventKind.REMOVE;
            _loc2_.location = _loc9_ + 1;
            _loc2_.items = _loc7_;
            _loc8_.push(_loc2_);
         }
         return _loc8_;
      }
      
      private function getIndent() : Number
      {
         var _loc2_:String = null;
         var _loc1_:Number = 0;
         for(_loc2_ in this._openItems)
         {
            _loc1_ = Math.max(this.getParentStack(this._openItems[_loc2_]).length + 1,_loc1_);
         }
         return _loc1_ * getStyle("indentation");
      }
      
      override public function isItemVisible(param1:Object) : Boolean
      {
         var _loc3_:String = null;
         if(visibleData[itemToUID(param1)])
         {
            return true;
         }
         var _loc2_:Object = this.getParentItem(param1);
         if(_loc2_)
         {
            _loc3_ = itemToUID(_loc2_);
            if(Boolean(visibleData[_loc3_]) && Boolean(this._openItems[_loc3_]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:IViewCursor = collection.createCursor();
         var _loc3_:int = 0;
         while(_loc2_.current !== param1)
         {
            if(!(++_loc2_).moveNext())
            {
               break;
            }
         }
         _loc2_.seek(CursorBookmark.FIRST,0);
         return _loc3_;
      }
      
      private function getIndexItem(param1:int) : Object
      {
         var _loc2_:IViewCursor = collection.createCursor();
         var _loc3_:int = param1;
         while(_loc2_.moveNext())
         {
            if(_loc3_ == 0)
            {
               return _loc2_.current;
            }
            _loc3_--;
         }
         return null;
      }
      
      public function expandChildrenOf(param1:Object, param2:Boolean) : void
      {
         var _loc3_:ICollectionView = null;
         var _loc4_:IViewCursor = null;
         if(iterator == null)
         {
            return;
         }
         if(this.isBranch(param1))
         {
            this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,param1,null,null,param2,false,true);
            if(param1 != null && this.mx_internal::_dataDescriptor.isBranch(param1,iterator.view) && this.mx_internal::_dataDescriptor.hasChildren(param1,iterator.view))
            {
               _loc3_ = this.mx_internal::getChildren(param1,iterator.view);
            }
            if(_loc3_)
            {
               _loc4_ = _loc3_.createCursor();
               while(!_loc4_.afterLast)
               {
                  if(this.isBranch(_loc4_.current))
                  {
                     this.expandChildrenOf(_loc4_.current,param2);
                  }
                  _loc4_.moveNext();
               }
            }
         }
      }
      
      public function getParentItem(param1:Object) : *
      {
         if(param1 == null)
         {
            return null;
         }
         if(Boolean(param1) && Boolean(collection))
         {
            if(this.mx_internal::_dataDescriptor is ITreeDataDescriptor2)
            {
               return ITreeDataDescriptor2(this.mx_internal::_dataDescriptor).getParent(param1,this.mx_internal::wrappedCollection,this.mx_internal::_rootModel);
            }
            return HierarchicalCollectionView(collection).getParentItem(param1);
         }
         return null;
      }
      
      private function getParentStack(param1:Object) : Array
      {
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:* = this.getParentItem(param1);
         while(_loc3_)
         {
            _loc2_.push(_loc3_);
            _loc3_ = this.getParentItem(_loc3_);
         }
         return _loc2_;
      }
      
      private function getOpenChildrenStack(param1:Object, param2:Array) : Array
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return param2;
         }
         var _loc4_:ICollectionView = this.mx_internal::getChildren(param1,iterator.view);
         if(!_loc4_)
         {
            return [];
         }
         var _loc5_:IViewCursor = _loc4_.createCursor();
         while(!_loc5_.afterLast)
         {
            _loc3_ = _loc5_.current;
            param2.push(_loc3_);
            if(this.isBranch(_loc3_) && this.isItemOpen(_loc3_))
            {
               this.getOpenChildrenStack(_loc3_,param2);
            }
            _loc5_.moveNext();
         }
         return param2;
      }
      
      private function getChildIndexInParent(param1:Object, param2:Object) : int
      {
         var _loc4_:IViewCursor = null;
         var _loc5_:ICollectionView = null;
         var _loc3_:int = 0;
         if(!param1)
         {
            _loc4_ = ICollectionView(iterator.view).createCursor();
            while(!_loc4_.afterLast)
            {
               if(param2 === _loc4_.current)
               {
                  break;
               }
               (++_loc4_).moveNext();
            }
         }
         else if(param1 != null && this.mx_internal::_dataDescriptor.isBranch(param1,iterator.view) && this.mx_internal::_dataDescriptor.hasChildren(param1,iterator.view))
         {
            _loc5_ = this.mx_internal::getChildren(param1,iterator.view);
            if(_loc5_.contains(param2))
            {
               _loc4_ = _loc5_.createCursor();
               while(!_loc4_.afterLast)
               {
                  if(param2 === _loc4_.current)
                  {
                     break;
                  }
                  _loc4_.moveNext();
                  _loc3_++;
               }
            }
         }
         return _loc3_;
      }
      
      private function collapseSelectedItems() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc1_:ArrayCollection = new ArrayCollection(selectedItems);
         var _loc2_:int = 0;
         while(_loc2_ < selectedItems.length)
         {
            _loc3_ = selectedItems[_loc2_];
            _loc4_ = this.getParentStack(_loc3_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc1_.contains(_loc4_[_loc5_]))
               {
                  _loc6_ = _loc1_.getItemIndex(_loc3_);
                  _loc7_ = _loc1_.removeItemAt(_loc6_);
                  break;
               }
               _loc5_++;
            }
            _loc2_++;
         }
         return _loc1_.source;
      }
      
      private function updateDropData(param1:DragEvent) : void
      {
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc2_:int = int(rowInfo.length);
         var _loc3_:int = 0;
         var _loc4_:int = int(rowInfo[_loc3_].height);
         var _loc5_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         while(Boolean(rowInfo[_loc3_]) && _loc5_.y >= _loc4_)
         {
            if(_loc3_ != rowInfo.length - 1)
            {
               _loc4_ = ++_loc4_ + rowInfo[_loc3_].height;
            }
            else
            {
               _loc4_ += rowInfo[_loc3_].height;
               _loc3_++;
            }
         }
         var _loc6_:Number = _loc3_ < rowInfo.length ? Number(rowInfo[_loc3_].y) : rowInfo[_loc3_ - 1].y + rowInfo[_loc3_ - 1].height;
         var _loc7_:Number = _loc5_.y - _loc6_;
         var _loc8_:Number = _loc3_ < rowInfo.length ? Number(rowInfo[_loc3_].height) : Number(rowInfo[_loc3_ - 1].height);
         _loc3_ += verticalScrollPosition;
         var _loc11_:Boolean = false;
         var _loc12_:int = collection ? collection.length : 0;
         var _loc13_:Object = _loc3_ > mx_internal::_verticalScrollPosition && _loc3_ <= _loc12_ ? listItems[_loc3_ - mx_internal::_verticalScrollPosition - 1][0].data : null;
         var _loc14_:Object = _loc3_ - verticalScrollPosition < rowInfo.length && _loc3_ < _loc12_ ? listItems[_loc3_ - mx_internal::_verticalScrollPosition][0].data : null;
         var _loc15_:Object = collection ? this.getParentItem(_loc13_) : null;
         var _loc16_:Object = collection ? this.getParentItem(_loc14_) : null;
         if(_loc7_ > _loc8_ * 0.5 && this.isItemOpen(_loc14_) && this.mx_internal::_dataDescriptor.isBranch(_loc14_,iterator.view) && (!this.mx_internal::_dataDescriptor.hasChildren(_loc14_,iterator.view) || this.mx_internal::_dataDescriptor.getChildren(_loc14_,iterator.view).length == 0))
         {
            _loc9_ = _loc14_;
            _loc10_ = 0;
            _loc11_ = true;
         }
         else if(!_loc13_ && !_loc3_ == _loc2_)
         {
            _loc9_ = collection ? this.getParentItem(_loc14_) : null;
            _loc10_ = _loc14_ ? this.getChildIndexInParent(_loc9_,_loc14_) : 0;
            _loc3_ = 0;
         }
         else if(Boolean(_loc14_) && _loc16_ == _loc13_)
         {
            _loc9_ = _loc13_;
            _loc10_ = 0;
         }
         else if(Boolean(_loc13_) && Boolean(_loc14_) && _loc15_ == _loc16_)
         {
            _loc9_ = collection ? this.getParentItem(_loc13_) : null;
            _loc10_ = iterator ? this.getChildIndexInParent(_loc9_,_loc14_) : 0;
         }
         else if(Boolean(_loc13_) && _loc7_ < _loc8_ * 0.5)
         {
            _loc9_ = _loc15_;
            _loc10_ = this.getChildIndexInParent(_loc9_,_loc13_) + 1;
         }
         else if(!_loc14_)
         {
            _loc9_ = null;
            if(_loc3_ - verticalScrollPosition == 0)
            {
               _loc10_ = 0;
            }
            else if(collection)
            {
               _loc10_ = collection.length;
            }
            else
            {
               _loc10_ = 0;
            }
         }
         else
         {
            _loc9_ = _loc16_;
            _loc10_ = this.getChildIndexInParent(_loc9_,_loc14_);
         }
         this.mx_internal::_dropData = {
            "parent":_loc9_,
            "index":_loc10_,
            "localX":param1.localX,
            "localY":param1.localY,
            "emptyFolder":_loc11_,
            "rowHeight":_loc8_,
            "rowIndex":_loc3_
         };
      }
      
      protected function initListData(param1:Object, param2:TreeListData) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:Boolean = this.isItemOpen(param1);
         var _loc4_:Boolean = this.isBranch(param1);
         var _loc5_:String = itemToUID(param1);
         param2.disclosureIcon = getStyle(_loc3_ ? "disclosureOpenIcon" : "disclosureClosedIcon");
         param2.open = _loc3_;
         param2.hasChildren = _loc4_;
         param2.depth = this.mx_internal::getItemDepth(param1,param2.rowIndex);
         param2.indent = (param2.depth - 1) * getStyle("indentation");
         param2.item = param1;
         param2.icon = this.itemToIcon(param1);
      }
      
      override protected function layoutEditor(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = int(rowMap[editedItemRenderer.name].indent);
         itemEditorInstance.move(param1 + _loc5_,param2);
         itemEditorInstance.setActualSize(param3 - _loc5_,param4);
      }
      
      override protected function scrollHandler(param1:Event) : void
      {
         if(this.mx_internal::isOpening)
         {
            return;
         }
         if(param1 is ScrollEvent)
         {
            super.scrollHandler(param1);
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:ListEvent = null;
         var _loc3_:Point = null;
         var _loc6_:IListItemRenderer = null;
         var _loc7_:* = false;
         var _loc8_:Object = null;
         var _loc9_:ICollectionView = null;
         var _loc10_:IViewCursor = null;
         if(this.mx_internal::isOpening)
         {
            param1.stopImmediatePropagation();
            return;
         }
         if(itemEditorInstance)
         {
            return;
         }
         var _loc4_:uint = uint(mx_internal::mapKeycodeForLayoutDirection(param1));
         var _loc5_:Object = selectedItem;
         if(param1.ctrlKey)
         {
            super.keyDownHandler(param1);
         }
         else if(_loc4_ == Keyboard.SPACE)
         {
            if(caretIndex != selectedIndex)
            {
               _loc6_ = indexToItemRenderer(caretIndex);
               if(_loc6_)
               {
                  drawItem(_loc6_);
               }
               caretIndex = selectedIndex;
            }
            if(this.isBranch(_loc5_))
            {
               _loc7_ = !this.isItemOpen(_loc5_);
               this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc5_,null,param1,_loc7_,true,true);
            }
            param1.stopImmediatePropagation();
         }
         else if(_loc4_ == Keyboard.LEFT)
         {
            if(this.isItemOpen(_loc5_))
            {
               this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc5_,null,param1,false,true,true);
            }
            else
            {
               _loc8_ = this.getParentItem(_loc5_);
               if(_loc8_)
               {
                  this.proposedSelectedItem = _loc8_;
                  this.finishArrowKeySelection();
               }
            }
            param1.stopImmediatePropagation();
         }
         else if(_loc4_ == Keyboard.RIGHT)
         {
            if(this.isBranch(_loc5_))
            {
               if(this.isItemOpen(_loc5_))
               {
                  if(_loc5_)
                  {
                     _loc9_ = this.mx_internal::getChildren(_loc5_,iterator.view);
                     if(_loc9_)
                     {
                        _loc10_ = _loc9_.createCursor();
                        if(_loc10_.current)
                        {
                           this.proposedSelectedItem = _loc10_.current;
                        }
                     }
                     else
                     {
                        this.proposedSelectedItem = null;
                     }
                  }
                  else
                  {
                     selectedItem = this.proposedSelectedItem = null;
                  }
                  this.finishArrowKeySelection();
               }
               else
               {
                  this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc5_,null,param1,true,true,true);
               }
            }
            param1.stopImmediatePropagation();
         }
         else if(_loc4_ == Keyboard.NUMPAD_MULTIPLY)
         {
            this.expandChildrenOf(_loc5_,!this.isItemOpen(_loc5_));
         }
         else if(_loc4_ == Keyboard.NUMPAD_ADD)
         {
            if(this.isBranch(_loc5_))
            {
               if(!this.isItemOpen(_loc5_))
               {
                  this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc5_,null,param1,true,true,true);
               }
            }
         }
         else if(_loc4_ == Keyboard.NUMPAD_SUBTRACT)
         {
            if(this.isItemOpen(_loc5_))
            {
               this.mx_internal::dispatchTreeEvent(TreeEvent.ITEM_OPENING,_loc5_,null,param1,false,true,true);
            }
         }
         else
         {
            super.keyDownHandler(param1);
         }
      }
      
      private function finishArrowKeySelection() : void
      {
         var _loc1_:ListEvent = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         this.bFinishArrowKeySelection = false;
         if(this.proposedSelectedItem)
         {
            selectedItem = this.proposedSelectedItem;
         }
         if(selectedItem === this.proposedSelectedItem || !this.proposedSelectedItem)
         {
            _loc1_ = new ListEvent(ListEvent.CHANGE);
            _loc1_.itemRenderer = indexToItemRenderer(selectedIndex);
            _loc2_ = itemRendererToIndices(_loc1_.itemRenderer);
            if(_loc2_)
            {
               _loc1_.rowIndex = _loc2_.y;
               _loc1_.columnIndex = _loc2_.x;
            }
            dispatchEvent(_loc1_);
            _loc3_ = this.getItemIndex(selectedItem);
            if(_loc3_ != caretIndex)
            {
               caretIndex = selectedIndex;
            }
            if(_loc3_ < mx_internal::_verticalScrollPosition)
            {
               verticalScrollPosition = _loc3_;
            }
         }
         else
         {
            this.bFinishArrowKeySelection = true;
         }
      }
      
      override protected function mouseOverHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseOverHandler(param1);
         }
      }
      
      override protected function mouseOutHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseOutHandler(param1);
         }
      }
      
      override protected function mouseClickHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseClickHandler(param1);
         }
      }
      
      override protected function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseDoubleClickHandler(param1);
         }
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseDownHandler(param1);
         }
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseUpHandler(param1);
         }
      }
      
      override protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(!this.tween)
         {
            super.mouseWheelHandler(param1);
         }
      }
      
      override protected function dragEnterHandler(param1:DragEvent) : void
      {
         var event:DragEvent = param1;
         if(event.isDefaultPrevented())
         {
            return;
         }
         mx_internal::lastDragEvent = event;
         this.haveItemIndices = false;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               DragManager.acceptDragDrop(this);
               DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
               this.showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragEnterHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      override protected function dragOverHandler(param1:DragEvent) : void
      {
         var event:DragEvent = param1;
         if(event.isDefaultPrevented())
         {
            return;
         }
         mx_internal::lastDragEvent = event;
         try
         {
            if(iteratorValid && event.dragSource.hasFormat("treeItems"))
            {
               if(this.mx_internal::collectionThrowsIPE)
               {
                  this.checkItemIndices(event);
               }
               DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
               this.showDropFeedback(event);
               return;
            }
         }
         catch(e:ItemPendingError)
         {
            if(!lastTreeSeekPending)
            {
               lastTreeSeekPending = new TreeSeekPending(event,dragOverHandler);
               e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,lastTreeSeekPending));
            }
         }
         catch(e1:Error)
         {
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      private function seekPendingDuringDragFailureHandler(param1:Object, param2:TreeSeekPending) : void
      {
      }
      
      private function seekPendingDuringDragResultHandler(param1:Object, param2:TreeSeekPending) : void
      {
         this.lastTreeSeekPending = null;
         if(mx_internal::lastDragEvent)
         {
            param2.retryFunction(param2.event);
         }
      }
      
      private function checkItemIndices(param1:DragEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(this.haveItemIndices)
         {
            return;
         }
         if((param1.action == DragManager.MOVE || param1.action == DragManager.NONE) && this.dragMoveEnabled)
         {
            if(param1.dragInitiator == this)
            {
               _loc2_ = param1.dragSource.dataForFormat("treeItems") as Array;
               _loc3_ = int(_loc2_.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this.getParentItem(_loc2_[_loc4_]);
                  this.getChildIndexInParent(_loc5_,_loc2_[_loc4_]);
                  _loc4_++;
               }
               this.haveItemIndices = true;
            }
         }
      }
      
      override protected function dragDropHandler(param1:DragEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(param1);
         if(param1.dragSource.hasFormat("treeItems"))
         {
            _loc2_ = param1.dragSource.dataForFormat("treeItems") as Array;
            if(param1.action == DragManager.MOVE && this.dragMoveEnabled)
            {
               if(param1.dragInitiator == this)
               {
                  this.calculateDropIndex(param1);
                  _loc8_ = int(this.mx_internal::_dropData.index);
                  _loc9_ = this.getParentStack(this.mx_internal::_dropData.parent);
                  _loc9_.unshift(this.mx_internal::_dropData.parent);
                  _loc4_ = int(_loc2_.length);
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc6_ = this.getParentItem(_loc2_[_loc3_]);
                     _loc5_ = this.getChildIndexInParent(_loc6_,_loc2_[_loc3_]);
                     for each(_loc7_ in _loc9_)
                     {
                        if(_loc2_[_loc3_] === _loc7_)
                        {
                           return;
                        }
                     }
                     this.mx_internal::removeChildItem(_loc6_,_loc2_[_loc3_],_loc5_);
                     if(_loc6_ == this.mx_internal::_dropData.parent && _loc5_ < this.mx_internal::_dropData.index)
                     {
                        _loc8_--;
                     }
                     this.mx_internal::addChildItem(this.mx_internal::_dropData.parent,_loc2_[_loc3_],_loc8_);
                     _loc3_++;
                  }
                  return;
               }
            }
            if(param1.action == DragManager.COPY)
            {
               if(!this.dataProvider)
               {
                  this.dataProvider = [];
                  validateNow();
               }
               _loc4_ = int(_loc2_.length);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc10_ = copyItemWithUID(_loc2_[_loc3_]);
                  this.mx_internal::addChildItem(this.mx_internal::_dropData.parent,_loc10_,this.mx_internal::_dropData.index);
                  _loc3_++;
               }
            }
         }
         mx_internal::lastDragEvent = null;
      }
      
      override protected function dragCompleteHandler(param1:DragEvent) : void
      {
         var items:Array = null;
         var parent:* = undefined;
         var index:int = 0;
         var i:int = 0;
         var n:int = 0;
         var targetTree:Tree = null;
         var item:Object = null;
         var event:DragEvent = param1;
         mx_internal::isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         mx_internal::resetDragScrolling();
         try
         {
            if(event.dragSource.hasFormat("treeItems"))
            {
               if(event.action == DragManager.MOVE && this.dragMoveEnabled)
               {
                  if(event.relatedObject != this)
                  {
                     items = event.dragSource.dataForFormat("treeItems") as Array;
                     n = int(items.length);
                     i = 0;
                     while(i < n)
                     {
                        parent = this.getParentItem(items[i]);
                        index = this.getChildIndexInParent(parent,items[i]);
                        this.mx_internal::removeChildItem(parent,items[i],index);
                        i++;
                     }
                     if(event.relatedObject is Tree)
                     {
                        targetTree = Tree(event.relatedObject);
                        if(!targetTree.dataProvider)
                        {
                           targetTree.dataProvider = [];
                           targetTree.validateNow();
                        }
                        n = int(items.length);
                        i = 0;
                        while(i < n)
                        {
                           item = items[i];
                           targetTree.mx_internal::addChildItem(targetTree.mx_internal::_dropData.parent,item,targetTree.mx_internal::_dropData.index);
                           i++;
                        }
                     }
                  }
                  clearSelected(false);
               }
            }
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(seekPendingDuringDragResultHandler,seekPendingDuringDragFailureHandler,new TreeSeekPending(event,dragCompleteHandler)));
         }
         mx_internal::lastDragEvent = null;
      }
      
      mx_internal function addChildItem(param1:Object, param2:Object, param3:Number) : Boolean
      {
         return this.mx_internal::_dataDescriptor.addChildAt(param1,param2,param3,iterator.view);
      }
      
      mx_internal function removeChildItem(param1:Object, param2:Object, param3:Number) : Boolean
      {
         return this.mx_internal::_dataDescriptor.removeChildAt(param1,param2,param3,iterator.view);
      }
      
      mx_internal function dispatchTreeEvent(param1:String, param2:Object, param3:IListItemRenderer, param4:Event = null, param5:Boolean = true, param6:Boolean = true, param7:Boolean = true) : void
      {
         var _loc8_:TreeEvent = null;
         if(param1 == TreeEvent.ITEM_OPENING)
         {
            _loc8_ = new TreeEvent(TreeEvent.ITEM_OPENING,false,true);
            _loc8_.opening = param5;
            _loc8_.animate = param6;
            _loc8_.dispatchEvent = param7;
         }
         if(!_loc8_)
         {
            _loc8_ = new TreeEvent(param1);
         }
         _loc8_.item = param2;
         _loc8_.itemRenderer = param3;
         _loc8_.triggerEvent = param4;
         dispatchEvent(_loc8_);
      }
      
      override protected function collectionChangeHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:CollectionEvent = null;
         if(iterator == null)
         {
            return;
         }
         if(param1 is CollectionEvent)
         {
            _loc4_ = CollectionEvent(param1);
            if(_loc4_.kind == CollectionEventKind.mx_internal::EXPAND)
            {
               param1.stopPropagation();
            }
            if(_loc4_.kind == CollectionEventKind.UPDATE)
            {
               param1.stopPropagation();
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            else
            {
               super.collectionChangeHandler(param1);
            }
         }
      }
      
      override protected function adjustAfterRemove(param1:Array, param2:int, param3:Boolean) : Boolean
      {
         var _loc4_:int = int(selectedItems.length);
         var _loc5_:Boolean = param3;
         var _loc6_:int = int(param1.length);
         if(mx_internal::_selectedIndex > param2)
         {
            mx_internal::_selectedIndex -= _loc6_;
            _loc5_ = true;
         }
         if(this.bSelectedItemRemoved && _loc4_ < 1)
         {
            mx_internal::_selectedIndex = this.getItemIndex(this.expandedItem);
            _loc5_ = true;
            mx_internal::bSelectionChanged = true;
            mx_internal::bSelectedIndexChanged = true;
            invalidateDisplayList();
         }
         return _loc5_;
      }
      
      mx_internal function expandItemHandler(param1:TreeEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.type == TreeEvent.ITEM_OPENING)
         {
            this.expandItem(param1.item,param1.opening,param1.animate,param1.dispatchEvent,param1.triggerEvent);
         }
      }
      
      override mx_internal function selectionDataPendingResultHandler(param1:Object, param2:ListBaseSelectionDataPending) : void
      {
         super.mx_internal::selectionDataPendingResultHandler(param1,param2);
         if(this.bFinishArrowKeySelection && selectedItem === this.proposedSelectedItem)
         {
            this.finishArrowKeySelection();
         }
      }
   }
}

import mx.events.DragEvent;

class TreeSeekPending
{
   
   public var event:DragEvent;
   
   public var retryFunction:Function;
   
   public function TreeSeekPending(param1:DragEvent, param2:Function)
   {
      super();
      this.event = param1;
      this.retryFunction = param2;
   }
}
