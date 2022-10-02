package store.fineStore.view.pageBringUp
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.LockableBagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CEvent;
   import ddt.events.CellEvent;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import latentEnergy.LatentEnergyEvent;
   import latentEnergy.LatentEnergyManager;
   import store.FineBringUpController;
   
   public class FineBringUpBagListView extends BagListView
   {
       
      
      public function FineBringUpBagListView(param1:int, param2:int = 7, param3:int = 49)
      {
         super(param1,param2,param3);
         FineBringUpController.getInstance().addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         FineBringUpController.getInstance().addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         FineBringUpController.getInstance().addEventListener(FineBringUpController.UPDATE_ITEM_LOCK_STATUS,this.onItemLockStatusUpdate);
      }
      
      protected function onItemLockStatusUpdate(param1:CEvent) : void
      {
      }
      
      override protected function createCells() : void
      {
         var _loc1_:LockableBagCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc2_:int = 0;
         while(_loc2_ < _cellNum)
         {
            _loc1_ = LockableBagCell(CellFactory.instance.creteLockableBagCell(_loc2_));
            _loc1_.lockDisplayObject = ComponentFactory.Instance.creatBitmap("asset.store.bringup.lock");
            PositionUtils.setPos(_loc1_.lockDisplayObject,"storeBringUp.cellLockPos");
            _loc1_.mouseOverEffBoolean = false;
            addChild(_loc1_);
            _loc1_.bagType = _bagType;
            _loc1_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            _loc1_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(_loc1_);
            _loc1_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc1_.place] = _loc1_;
            _cellVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(FineBringUpController.getInstance().usingLock == true)
         {
            return;
         }
         var _loc2_:LockableBagCell = param1.target as LockableBagCell;
         if(_loc2_.info && _loc2_.info.FusionType == 0)
         {
            FineBringUpController.getInstance().isTopLevel();
            return;
         }
         super.__doubleClickHandler(param1);
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(FineBringUpController.getInstance().usingLock == true)
         {
            return;
         }
         var _loc2_:LockableBagCell = param1.target as LockableBagCell;
         if(_loc2_.info && _loc2_.info.FusionType == 0)
         {
            FineBringUpController.getInstance().isTopLevel();
            return;
         }
         super.__clickHandler(param1);
      }
      
      private function equipMoveHandler(param1:LatentEnergyEvent) : void
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
         SocketManager.Instance.out.sendMoveGoods(param1.info.BagType,param1.info.Place,BagInfo.STOREBAG,0);
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = param1.info;
         if(param1.moveType == 2)
         {
            for each(_loc2_ in _cells)
            {
               if(_loc2_.info == _loc3_)
               {
                  return;
               }
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < _cellNum)
         {
            if(!_cells[_loc4_].info)
            {
               _cells[_loc4_].info = _loc3_;
               break;
            }
            _loc4_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:InventoryItemInfo = null;
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
         var _loc4_:Dictionary = FineBringUpController.getInstance().getPlaceMap();
         for(_loc2_ in _loc4_)
         {
            _loc3_ = FineBringUpController.getInstance().getItem(_loc4_[_loc2_]);
            if(_loc3_)
            {
               _loc3_.isMoveSpace = true;
            }
            _cells[_loc2_].info = _loc3_;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      override public function dispose() : void
      {
         FineBringUpController.getInstance().removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         FineBringUpController.getInstance().removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         FineBringUpController.getInstance().removeEventListener(FineBringUpController.UPDATE_ITEM_LOCK_STATUS,this.onItemLockStatusUpdate);
         super.dispose();
      }
   }
}
