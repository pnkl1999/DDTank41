package latentEnergy
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
   
   public class LatentEnergyBagListView extends BagListView
   {
       
      
      private var _autoExpandV:Boolean;
      
      public function LatentEnergyBagListView(param1:int, param2:int = 7, param3:int = 49, param4:Boolean = false)
      {
         this._autoExpandV = param4;
         super(param1,param2,param3);
         if(param1 == BagInfo.EQUIPBAG)
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = 0;
         while(_loc1_ < _cellNum)
         {
            this.addCell(_loc1_);
            _loc1_++;
         }
      }
      
      private function addCell(param1:int) : void
      {
         var _loc2_:LatentEnergyEquipListCell = this.createBagCell(param1);
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
      }
      
      private function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : LatentEnergyEquipListCell
      {
         var _loc4_:LatentEnergyEquipListCell = new LatentEnergyEquipListCell(param1,param2,param3);
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
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
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
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
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
         if(this.autoExpandV && _cellVec.length < _bagdata.items.length)
         {
            _loc4_ = _bagdata.items.length - _cellVec.length;
            _loc5_ = _cellVec.length;
            _loc6_ = 0;
            if(_bagdata.items.length % 7 > 0)
            {
               _loc6_ = 7 - _bagdata.items.length % 7;
            }
            _loc7_ = _loc5_;
            while(_loc7_ < _loc5_ + _loc4_ + _loc6_)
            {
               this.addCell(_loc7_);
               _loc7_++;
            }
            _cellNum = _cellVec.length;
         }
         var _loc2_:int = 0;
         for(_loc3_ in _bagdata.items)
         {
            if(_cells[_loc2_] != null)
            {
               _bagdata.items[_loc3_].isMoveSpace = true;
               _cells[_loc2_].info = _bagdata.items[_loc3_];
            }
            _loc2_++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      public function get autoExpandV() : Boolean
      {
         return this._autoExpandV;
      }
      
      public function set autoExpandV(param1:Boolean) : void
      {
         this._autoExpandV = param1;
      }
      
      override public function dispose() : void
      {
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}
