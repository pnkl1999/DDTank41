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
   
   public class BagProListView extends BagListView
   {
       
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      protected var _pageUpBtn:BagPageButton;
      
      protected var _pageDownBtn:BagPageButton;
      
      public function BagProListView(param1:int, param2:int = 31, param3:int = 80, param4:int = 7, param5:int = 1)
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
         var _loc2_:int = 0;
         var _loc1_:* = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         _loc2_ = this._startIndex;
         while(_loc2_ < this._stopIndex)
         {
            _loc1_ = CellFactory.instance.createBagCell(_loc2_) as BagCell;
            _loc1_.mouseOverEffBoolean = false;
            addChild(_loc1_);
            _loc1_.addEventListener("interactive_click",this.__clickHandler);
            _loc1_.addEventListener("mouseOver",_cellOverEff);
            _loc1_.addEventListener("mouseOut",_cellOutEff);
            _loc1_.addEventListener("interactive_double_click",this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc1_);
            _loc1_.addEventListener("lockChanged",__cellChanged);
            _loc1_.bagType = _bagType;
            _loc1_.addEventListener("lockChanged",__cellChanged);
            _cells[_loc1_.place] = _loc1_;
            _cellVec.push(_loc1_);
            _loc2_++;
         }
         if(_loc2_ == this._stopIndex)
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
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent("itemclick",param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      protected function __pageChange(param1:CellEvent) : void
      {
         var _loc2_:DragEffect = param1.data as DragEffect;
         if(!(_loc2_.data is InventoryItemInfo) || _loc2_.data.BagType != 1)
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
            this._startIndex = 48;
            this._stopIndex = 96;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.PropBag);
         }
         else
         {
            _page = 1;
            this._startIndex = 0;
            this._stopIndex = 48;
            _cellVec = [];
            this.createCells();
            setData(PlayerManager.Instance.Self.PropBag);
         }
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param1 >= this._startIndex && param1 < this._stopIndex)
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
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
