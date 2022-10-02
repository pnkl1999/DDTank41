package auctionHouse.view
{
   import bagAndInfo.bag.BagEquipListView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class AuctionBagEquipListView extends BagEquipListView
   {
       
      
      public function AuctionBagEquipListView(param1:int, param2:int = 31, param3:int = 79, param4:int = 7, param5:int = 1)
      {
         _startIndex = param2;
         _stopIndex = param3;
         _page = param5;
         super(param1,param2,param3);
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
         _loc1_ = _startIndex;
         while(_loc1_ < _stopIndex)
         {
            this.creatCell(_loc1_);
            _loc1_++;
         }
         if(_loc1_ == _stopIndex)
         {
            if(_page == 1)
            {
               if(_pageDownBtn && _pageDownBtn.parent)
               {
                  _pageDownBtn.parent.removeChild(_pageDownBtn);
               }
               addChild(_pageUpBtn);
            }
            else if(_page == 2)
            {
               if(_pageUpBtn && _pageUpBtn.parent)
               {
                  _pageUpBtn.parent.removeChild(_pageUpBtn);
               }
               addChild(_pageDownBtn);
            }
         }
      }
      
      private function creatCell(param1:int) : void
      {
         var _loc2_:BagCell = CellFactory.instance.createBagCell(param1) as BagCell;
         _loc2_.mouseOverEffBoolean = false;
         addChild(_loc2_);
         _loc2_.addEventListener("interactive_click",__clickHandler);
         _loc2_.addEventListener("interactive_double_click",__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(_loc2_);
         _loc2_.bagType = _bagType;
         _loc2_.addEventListener("lockChanged",__cellChanged);
         _cells[_loc2_.place] = _loc2_;
         _cellVec.push(_loc2_);
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc3_:* = undefined;
         if(_bagdata != null)
         {
            _bagdata.removeEventListener("update",this.__updateGoods);
         }
         _bagdata = param1;
         var _loc2_:Array = [];
         var _loc4_:* = _bagdata.items;
         for(_loc3_ in _bagdata.items)
         {
            if(_cells[_loc3_] != null && _bagdata.items[_loc3_].IsBinds == false)
            {
               _cells[_loc3_].info = _bagdata.items[_loc3_];
               _loc2_.push(_cells[_loc3_]);
            }
         }
         _bagdata.addEventListener("update",this.__updateGoods);
         this._cellsSort(_loc2_);
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
            _loc2_.removeEventListener("interactive_click",__clickHandler);
            _loc2_.removeEventListener("interactive_double_click",__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc2_);
            _loc2_.removeEventListener("lockChanged",__cellChanged);
         }
         _loc7_ = 0;
         _loc6_ = _cells;
         for each(_loc3_ in _cells)
         {
            _loc3_.removeEventListener("interactive_click",__clickHandler);
            _loc3_.removeEventListener("lockChanged",__cellChanged);
            _loc3_.removeEventListener("mouseOver",_cellOverEff);
            _loc3_.removeEventListener("mouseOut",_cellOutEff);
            _loc3_.removeEventListener("interactive_double_click",__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc3_);
            _loc3_.dispose();
         }
         _cells = null;
         _cellVec = null;
         if(_page == 1)
         {
            _page = 2;
            _startIndex = 80;
            _stopIndex = 127;
            _cellVec = [];
            this.createCells();
            this.setData(PlayerManager.Instance.Self.Bag);
         }
         else
         {
            _page = 1;
            _startIndex = 31;
            _stopIndex = 79;
            _cellVec = [];
            this.createCells();
            this.setData(PlayerManager.Instance.Self.Bag);
         }
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         var _loc4_:Dictionary = param1.changedSlots;
         var _loc5_:* = _loc4_;
         for each(_loc3_ in _loc4_)
         {
            _loc2_ = _bagdata.getItemAt(_loc3_.Place);
            if(_loc2_ && _loc2_.IsBinds == false)
            {
               setCellInfo(_loc2_.Place,_loc2_);
            }
            else
            {
               setCellInfo(_loc3_.Place,null);
            }
            dispatchEvent(new Event("change"));
         }
      }
      
      private function _cellsSort(param1:Array) : void
      {
         var _loc6_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:int = 0;
         var _loc2_:* = null;
         if(param1.length <= 0)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc4_ = param1[_loc6_].x;
            _loc5_ = param1[_loc6_].y;
            _loc3_ = _cellVec.indexOf(param1[_loc6_]);
            _loc2_ = _cellVec[_loc6_];
            param1[_loc6_].x = _loc2_.x;
            param1[_loc6_].y = _loc2_.y;
            _loc2_.x = _loc4_;
            _loc2_.y = _loc5_;
            _cellVec[_loc6_] = param1[_loc6_];
            _cellVec[_loc3_] = _loc2_;
            _loc6_++;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         if(_pageUpBtn)
         {
            _pageUpBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(_pageUpBtn);
            _pageUpBtn = null;
         }
         if(_pageDownBtn)
         {
            _pageDownBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(_pageDownBtn);
            _pageDownBtn = null;
         }
         var _loc2_:* = _cells;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener("interactive_click",__clickHandler);
            _loc1_.removeEventListener("interactive_double_click",__doubleClickHandler);
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
