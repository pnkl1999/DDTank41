package bagAndInfo.bag
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BagEquipListView extends BagListView
   {
       
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      protected var _pageUpBtn:BagPageButton;
      
      protected var _pageDownBtn:BagPageButton;
      
      public function BagEquipListView(param1:int, param2:int = 31, param3:int = 127, param4:int = 7, param5:int = 1)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         _page = param5;
         this.initPageBtn();
         BagAndInfoManager.Instance.addEventListener("bagpage",this.__pageChange);
         super(param1,param4);
      }
      
      private function initPageBtn() : void
      {
         this._pageUpBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.upBtn");
         this._pageUpBtn.addEventListener("click",this.__onPageChange);
         this._pageDownBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.downBtn");
         this._pageDownBtn.addEventListener("click",this.__onPageChange);
      }
      
      override protected function createCells() : void
      {
         var _loc1_:int = 0;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         if(_page == 2)
         {
            this.creatCell(79);
         }
         _loc1_ = this._startIndex;
         while(_loc1_ < this._stopIndex)
         {
            this.creatCell(_loc1_);
            _loc1_++;
         }
         if(_loc1_ == this._stopIndex)
         {
            if(_page == 1)
            {
               if(this._pageDownBtn && this._pageDownBtn.parent)
               {
                  this._pageDownBtn.parent.removeChild(this._pageDownBtn);
               }
               addChild(this._pageUpBtn);
            }
            else if(_page == 2)
            {
               if(this._pageUpBtn && this._pageUpBtn.parent)
               {
                  this._pageUpBtn.parent.removeChild(this._pageUpBtn);
               }
               addChild(this._pageDownBtn);
            }
         }
      }
      
      private function creatCell(param1:int) : void
      {
         var _loc2_:BagCell = CellFactory.instance.createBagCell(param1) as BagCell;
         _loc2_.mouseOverEffBoolean = false;
         addChild(_loc2_);
         _loc2_.addEventListener("interactive_click",this.__clickHandler);
         _loc2_.addEventListener("interactive_double_click",this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(_loc2_);
         _loc2_.bagType = _bagType;
         _loc2_.addEventListener("lockChanged",__cellChanged);
         _cells[_loc2_.place] = _loc2_;
         _cellVec.push(_loc2_);
      }
      
      protected function __pageChange(param1:CellEvent) : void
      {
         var _loc2_:DragEffect = param1.data as DragEffect;
         if(!(_loc2_.data is InventoryItemInfo) || _loc2_.data.BagType != 0)
         {
            return;
         }
         DragManager.startDrag(_loc2_.source.getSource(),_loc2_.data,(_loc2_.source as BaseCell).createDragImg(),stage.mouseX,stage.mouseY,"move",false);
         this.__onPageChange(null);
      }
      
      private function __onPageChange(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc7_:int = 0;
         var _loc6_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = _cells;
         for each(_loc2_ in _cells)
         {
            _loc2_.removeEventListener("interactive_click",this.__clickHandler);
            _loc2_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc2_);
            _loc2_.removeEventListener("lockChanged",__cellChanged);
         }
         _loc7_ = 0;
         _loc6_ = _cells;
         for each(_loc3_ in _cells)
         {
            _loc3_.removeEventListener("interactive_click",this.__clickHandler);
            _loc3_.removeEventListener("lockChanged",__cellChanged);
            _loc3_.removeEventListener("mouseOver",_cellOverEff);
            _loc3_.removeEventListener("mouseOut",_cellOutEff);
            _loc3_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc3_);
            _loc3_.dispose();
         }
         _cells = null;
         _cellVec = null;
         if(_page == 1)
         {
            _page = 2;
            this._startIndex = 80;
            this._stopIndex = 127;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.Bag);
         }
         else
         {
            _page = 1;
            this._startIndex = 31;
            this._stopIndex = 79;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.Bag);
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent("doubleclick",param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(param1.currentTarget)
         {
            dispatchEvent(new CellEvent("itemclick",param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      protected function __cellClick(param1:MouseEvent) : void
      {
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(_page == 2 && param1 == 79)
         {
            if(param2 == null)
            {
               _cells[param1].info = null;
               return;
            }
            if(param2.Count == 0)
            {
               _cells[param1].info = null;
            }
            else
            {
               _cells[param1].info = param2;
            }
         }
         else if(param1 >= this._startIndex && param1 < this._stopIndex)
         {
            if(param2 == null)
            {
               _cells[param1].info = null;
               return;
            }
            if(param2.Count == 0)
            {
               _cells[param1].info = null;
            }
            else
            {
               _cells[param1].info = param2;
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         BagAndInfoManager.Instance.removeEventListener("bagpage",this.__pageChange);
         if(this._pageUpBtn)
         {
            this._pageUpBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageUpBtn);
            this._pageUpBtn = null;
         }
         if(this._pageDownBtn)
         {
            this._pageDownBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageDownBtn);
            this._pageDownBtn = null;
         }
         var _loc2_:* = _cells;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener("interactive_click",this.__clickHandler);
            _loc1_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            _loc1_.removeEventListener("lockChanged",__cellChanged);
         }
         _cellMouseOverBg = null;
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
