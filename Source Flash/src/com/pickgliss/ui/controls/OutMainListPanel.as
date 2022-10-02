package com.pickgliss.ui.controls
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.cell.IListCellFactory;
   import com.pickgliss.ui.controls.list.ListDataEvent;
   import com.pickgliss.ui.controls.list.ListDataListener;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class OutMainListPanel extends Component implements ListDataListener
   {
       
      
      private var P_vScrollbar:String = "vScrollBar";
      
      private var P_vScrollbarInnerRect:String = "vScrollBarInnerRect";
      
      private var P_cellFactory:String = "cellFactory";
      
      private var _cellsContainer:Sprite;
      
      private var _vScrollbarStyle:String;
      
      private var _vScrollbar:Scrollbar;
      
      private var _vScrollbarInnerRectString:String;
      
      private var _vScrollbarInnerRect:InnerRectangle;
      
      private var _factoryStyle:String;
      
      private var _factory:IListCellFactory;
      
      private var _model:VectorListModel;
      
      private var _cells:Vector.<IListCell>;
      
      private var _presentPos:int;
      
      private var _needNum:int;
      
      public function OutMainListPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initEvent();
         this._presentPos = 0;
         this._cells = new Vector.<IListCell>();
         this._model = new VectorListModel();
         this._model.addListDataListener(this);
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._vScrollbar)
         {
            this._cellsContainer.addChild(this._vScrollbar);
         }
         this._cellsContainer = new Sprite();
         addChild(this._cellsContainer);
      }
      
      public function get vectorListModel() : VectorListModel
      {
         return this._model;
      }
      
      public function contentsChanged(param1:ListDataEvent) : void
      {
         this.changeDate();
      }
      
      public function intervalAdded(param1:ListDataEvent) : void
      {
         this.syncScrollBar();
      }
      
      public function intervalRemoved(param1:ListDataEvent) : void
      {
         this.syncScrollBar();
      }
      
      private function syncScrollBar() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = this._factory.getCellHeight();
         this._needNum = Math.floor(_height / _loc1_);
         if(this._vScrollbar != null)
         {
            _loc2_ = this._needNum * this._factory.getCellHeight();
            _loc3_ = this._presentPos * this._factory.getCellHeight();
            _loc4_ = this._factory.getCellHeight() * this._model.elements.length;
            this._vScrollbar.unitIncrement = this._factory.getCellHeight();
            this._vScrollbar.blockIncrement = this._factory.getCellHeight();
            this._vScrollbar.getModel().setRangeProperties(_loc3_,_loc2_,0,_loc4_,false);
         }
         this.changeDate();
      }
      
      private function changeDate() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._needNum)
         {
            this._cells[_loc1_].setCellValue(this._model.elements[this._presentPos + _loc1_]);
            _loc1_++;
         }
      }
      
      private function createCells() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IListCell = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<IListCell> = null;
         var _loc7_:int = 0;
         var _loc1_:int = this._factory.getCellHeight();
         this._needNum = Math.floor(_height / _loc1_);
         if(this._cells.length == this._needNum)
         {
            return;
         }
         if(this._cells.length < this._needNum)
         {
            _loc2_ = this._needNum - this._cells.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.createNewCell();
               _loc4_.y = this._factory.getCellHeight() * _loc3_;
               this.addCellToContainer(_loc4_);
               _loc3_++;
            }
         }
         else
         {
            _loc5_ = this._needNum;
            _loc6_ = this._cells.splice(_loc5_,this._cells.length - _loc5_);
            _loc7_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               this.removeCellFromContainer(_loc6_[_loc7_]);
               _loc7_++;
            }
         }
      }
      
      protected function createNewCell() : IListCell
      {
         if(this._factory == null)
         {
            return null;
         }
         return this._factory.createNewCell();
      }
      
      protected function addCellToContainer(param1:IListCell) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.__onItemInteractive);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.__onItemInteractive);
         this._cells.push(this._cellsContainer.addChild(param1.asDisplayObject()));
      }
      
      protected function __onItemInteractive(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:IListCell = param1.currentTarget as IListCell;
         var _loc3_:int = this._model.indexOf(_loc2_.getCellValue());
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               _loc4_ = ListItemEvent.LIST_ITEM_CLICK;
               break;
            case MouseEvent.DOUBLE_CLICK:
               _loc4_ = ListItemEvent.LIST_ITEM_DOUBLE_CLICK;
               break;
            case MouseEvent.MOUSE_DOWN:
               _loc4_ = ListItemEvent.LIST_ITEM_MOUSE_DOWN;
               break;
            case MouseEvent.MOUSE_UP:
               _loc4_ = ListItemEvent.LIST_ITEM_MOUSE_UP;
               break;
            case MouseEvent.ROLL_OVER:
               _loc4_ = ListItemEvent.LIST_ITEM_ROLL_OVER;
               break;
            case MouseEvent.ROLL_OUT:
               _loc4_ = ListItemEvent.LIST_ITEM_ROLL_OUT;
         }
         dispatchEvent(new ListItemEvent(_loc2_,_loc2_.getCellValue(),_loc4_,_loc3_));
      }
      
      protected function removeAllCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            this.removeCellFromContainer(this._cells[_loc1_]);
            _loc1_++;
         }
         this._cells = new Vector.<IListCell>();
      }
      
      protected function removeCellFromContainer(param1:IListCell) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.__onItemInteractive);
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.__onItemInteractive);
         ObjectUtils.disposeObject(param1);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._needNum > 0)
         {
            _loc2_ = Math.floor(param1.delta / this._needNum);
            _loc3_ = this._presentPos - _loc2_;
            if(_loc3_ > this._model.elements.length - this._needNum)
            {
               _loc3_ = this._model.elements.length - this._needNum;
            }
            else if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            if(this._presentPos == _loc3_)
            {
               return;
            }
            this._presentPos = _loc3_;
            this.syncScrollBar();
         }
      }
      
      public function set vScrollbarInnerRectString(param1:String) : void
      {
         if(this._vScrollbarInnerRectString == param1)
         {
            return;
         }
         this._vScrollbarInnerRectString = param1;
         this._vScrollbarInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._vScrollbarInnerRectString));
         onPropertiesChanged(this.P_vScrollbarInnerRect);
      }
      
      public function set vScrollbarStyle(param1:String) : void
      {
         if(this._vScrollbarStyle == param1)
         {
            return;
         }
         this._vScrollbarStyle = param1;
         this.vScrollbar = ComponentFactory.Instance.creat(this._vScrollbarStyle);
      }
      
      public function get vScrollbar() : Scrollbar
      {
         return this._vScrollbar;
      }
      
      public function set vScrollbar(param1:Scrollbar) : void
      {
         if(this._vScrollbar == param1)
         {
            return;
         }
         if(this._vScrollbar)
         {
            this._vScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._vScrollbar);
         }
         this._vScrollbar = param1;
         this._vScrollbar.addStateListener(this.__onScrollValueChange);
         onPropertiesChanged(this.P_vScrollbar);
      }
      
      protected function __onScrollValueChange(param1:InteractiveEvent) : void
      {
         var _loc2_:int = Math.floor(this._vScrollbar.getModel().getValue() / this._factory.getCellHeight());
         if(_loc2_ == this._presentPos)
         {
            return;
         }
         this._presentPos = _loc2_;
         this.syncScrollBar();
      }
      
      public function set factoryStyle(param1:String) : void
      {
         if(this._factoryStyle == param1)
         {
            return;
         }
         this._factoryStyle = param1;
         var _loc2_:Array = param1.split("|");
         var _loc3_:String = _loc2_[0];
         var _loc4_:Array = ComponentFactory.parasArgs(_loc2_[1]);
         this._factory = ClassUtils.CreatInstance(_loc3_,_loc4_);
         onPropertiesChanged(this.P_cellFactory);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[this.P_cellFactory])
         {
            this.createCells();
         }
         if(_changedPropeties[this.P_vScrollbar] || _changedPropeties[this.P_vScrollbarInnerRect])
         {
            this.layoutComponent();
         }
      }
      
      protected function layoutComponent() : void
      {
         if(this._vScrollbar)
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._vScrollbar,this._vScrollbarInnerRect,_width,_height);
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.removeAllCell();
         if(this._vScrollbar)
         {
            this._vScrollbar.removeStateListener(this.__onScrollValueChange);
            ObjectUtils.disposeObject(this._vScrollbar);
         }
         this._vScrollbar = null;
         if(this._cellsContainer)
         {
            ObjectUtils.disposeObject(this._cellsContainer);
         }
         this._cellsContainer = null;
         if(this._model)
         {
            this._model.removeListDataListener(this);
         }
         this._model = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
