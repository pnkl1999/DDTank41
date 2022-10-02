package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class PetBagListView extends BagListView
   {
      
      public static const PET_BAG_CAPABILITY:int = 96;
       
      
      private var _allBagData:BagInfo;
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      private var _pageBtn:BagPageButton;
      
      public function PetBagListView(param1:int, param2:int = 0, param3:int = 48, param4:int = 7, param5:int = 1)
      {
         this._startIndex = param2;
         this._stopIndex = param3;
         _page = param5;
         super(param1,param4,49);
      }
      
      override public function setData(param1:BagInfo) : void
      {
         if(_bagdata != null)
         {
            _bagdata.removeEventListener("update",this.__updateGoods);
         }
         _bagdata = param1;
         this._allBagData = param1;
         _bagdata.addEventListener("update",this.__updateGoods);
         this.sortItems();
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
               this._pageBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.upBtn");
            }
            else
            {
               this._pageBtn = ComponentFactory.Instance.creatComponentByStylename("core.bag.downBtn");
            }
            this._pageBtn.addEventListener("click",this.__onPageChange);
            addChild(this._pageBtn);
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
      
      private function __onPageChange(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc7_:int = 0;
         var _loc6_:* = undefined;
         var _loc3_:* = undefined;
         if(this._pageBtn)
         {
            this._pageBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageBtn);
            this._pageBtn = null;
         }
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
            this.setData(PlayerManager.Instance.Self.PropBag);
         }
         else
         {
            _page = 1;
            this._startIndex = 0;
            this._stopIndex = 48;
            _cellVec = [];
            this.createCells();
            this.setData(PlayerManager.Instance.Self.PropBag);
         }
      }
      
      private function sortItems() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:Array = [];
         var _loc4_:* = _bagdata.items;
         for(_loc3_ in _bagdata.items)
         {
            _loc1_ = _bagdata.items[_loc3_];
            if(_cells[_loc3_] != null && _loc1_)
            {
               if(_loc1_.CategoryID == 34 || _loc1_.CategoryID == 32)
               {
                  BaseCell(_cells[_loc3_]).info = _loc1_;
                  _loc2_.push(_cells[_loc3_]);
               }
            }
         }
         this._cellsSort(_loc2_);
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(!_bagdata)
         {
            return;
         }
         var _loc4_:Dictionary = param1.changedSlots;
         var _loc5_:* = _loc4_;
         for each(_loc3_ in _loc4_)
         {
            _loc2_ = _bagdata.getItemAt(_loc3_.Place);
            if(_loc2_ && _loc2_.CategoryID == 34)
            {
               this.setCellInfo(_loc3_.Place,_loc2_);
            }
            else
            {
               this.setCellInfo(_loc3_.Place,null);
            }
         }
         this.sortItems();
         dispatchEvent(new Event("change"));
      }
      
      private function updateFoodBagList() : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc2_:BagInfo = new BagInfo(BagInfo.PROPBAG,PET_BAG_CAPABILITY);
         var _loc4_:DictionaryData = new DictionaryData();
         var _loc1_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < PET_BAG_CAPABILITY)
         {
            _loc3_ = this._allBagData.items[_loc5_.toString()];
            if(_cells[_loc5_] != null)
            {
               if(_loc3_ && _loc3_.CategoryID == 34)
               {
                  _loc3_.isMoveSpace = false;
                  _cells[_loc1_].info = _loc3_;
                  _loc4_.add(_loc1_,_loc3_);
                  _loc1_++;
               }
            }
            _loc5_++;
         }
         _loc2_.items = _loc4_;
         _bagdata = _loc2_;
      }
      
      private function getItemIndex(param1:InventoryItemInfo) : int
      {
         var _loc4_:* = undefined;
         var _loc3_:* = null;
         var _loc2_:int = -1;
         var _loc5_:* = _bagdata.items;
         for(_loc4_ in _bagdata.items)
         {
            _loc3_ = _bagdata.items[_loc4_] as InventoryItemInfo;
            if(param1.Place == _loc3_.Place)
            {
               _loc2_ = _loc4_;
               break;
            }
         }
         return _loc2_;
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
         if(this._pageBtn)
         {
            this._pageBtn.removeEventListener("click",this.__onPageChange);
            ObjectUtils.disposeObject(this._pageBtn);
            this._pageBtn = null;
         }
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
