package store.forge.wishBead
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class WishBeadBagListView extends BagListView
   {
       
      
      public function WishBeadBagListView(param1:int, param2:int = 7, param3:int = 49)
      {
         super(param1,param2,param3);
         if(param1 == BagInfo.EQUIPBAG)
         {
            WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
            WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE,this.equipMoveHandler);
            WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         var _loc2_:WishBeadEquipListCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = 0;
         while(_loc1_ < _cellNum)
         {
            _loc2_ = this.createBagCell(_loc1_);
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            _cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : WishBeadEquipListCell
      {
         var _loc4_:WishBeadEquipListCell = new WishBeadEquipListCell(param1,param2,param3);
         this.fillTipProp(_loc4_);
         return _loc4_;
      }
      
      private function fillTipProp(param1:ICell) : void
      {
         param1.tipDirctions = "7,6,2,1,5,4,0,3,6";
         param1.tipGapV = 10;
         param1.tipGapH = 10;
         param1.tipStyle = "core.GoodsTip";
      }
      
      private function equipMoveHandler(param1:WishBeadEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.info;
         var _loc3_:int = 0;
         while(_loc3_ < _cellNum)
         {
            if(_cells[_loc3_].info == _loc2_)
            {
               _cells[_loc3_].info = null;
               break;
            }
            _loc3_++;
         }
      }
      
      private function equipMoveHandler2(param1:WishBeadEvent) : void
      {
         var _loc4_:BagCell = null;
         var _loc2_:InventoryItemInfo = param1.info;
         if(param1.moveType == 2)
         {
            for each(_loc4_ in _cells)
            {
               if(_loc4_.info == _loc2_)
               {
                  return;
               }
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < _cellNum)
         {
            if(!_cells[_loc3_].info)
            {
               _cells[_loc3_].info = _loc2_;
               break;
            }
            _loc3_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc4_:* = null;
         var _loc5_:String = null;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         clearDataCells();
         _bagdata = param1;
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         for(_loc4_ in _bagdata.items)
         {
            _loc3_.push(_loc4_);
         }
         _loc3_.sort(Array.NUMERIC);
         for each(_loc5_ in _loc3_)
         {
            if(_cells[_loc2_] != null)
            {
               if(_bagdata.items[_loc5_].BagType == 0 && _bagdata.items[_loc5_].Place < 17)
               {
                  _cells[_loc2_].isUsed = true;
               }
               else
               {
                  _cells[_loc2_].isUsed = false;
               }
               _bagdata.items[_loc5_].isMoveSpace = true;
               _cells[_loc2_].info = _bagdata.items[_loc5_];
            }
            _loc2_++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      override public function dispose() : void
      {
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}
