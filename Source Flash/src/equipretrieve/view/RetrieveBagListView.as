package equipretrieve.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveModel;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class RetrieveBagListView extends BagListView
   {
       
      
      public function RetrieveBagListView(param1:int, param2:int = 7)
      {
         super(param1,param2);
      }
      
      override protected function createCells() : void
      {
         var _loc2_:RetrieveBagcell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = 0;
         while(_loc1_ < 49)
         {
            _loc2_ = new RetrieveBagcell(_loc1_);
            _loc2_.mouseOverEffBoolean = false;
            addChild(_loc2_);
            _loc2_.bagType = _bagType;
            _loc2_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc2_.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
            DoubleClickManager.Instance.enableDoubleClick(_loc2_);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[_loc2_.place] = _loc2_;
            _cellVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function _stopDrag(param1:CellEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,param1.currentTarget));
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false,param1.ctrlKey));
         }
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc3_:* = null;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         _bagdata = param1;
         var _loc2_:Array = new Array();
         for(_loc3_ in _bagdata.items)
         {
            if(_cells[_loc3_] != null && _bagdata.items[_loc3_] && ItemManager.Instance.getTemplateById(_bagdata.items[_loc3_].TemplateID).CanRecycle != 0)
            {
               _cells[_loc3_].info = _bagdata.items[_loc3_];
               _loc2_.push(_cells[_loc3_]);
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
         this._cellsSort(_loc2_);
      }
      
      override public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         if(param2 == null)
         {
            _cells[String(param1)].info = null;
            return;
         }
         if(param2.Count > 0 && ItemManager.Instance.getTemplateById(param2.TemplateID).CanRecycle != 0)
         {
            _cells[String(param1)].info = param2;
         }
         else
         {
            _cells[String(param1)].info = null;
         }
      }
      
      private function _cellsSort(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:BagCell = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc5_ = 0;
         _loc6_ = null;
         if(param1.length <= 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_].x;
            _loc4_ = param1[_loc2_].y;
            _loc5_ = _cellVec.indexOf(param1[_loc2_]);
            _loc6_ = _cellVec[_loc2_];
            param1[_loc2_].x = _loc6_.x;
            param1[_loc2_].y = _loc6_.y;
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _cellVec[_loc2_] = param1[_loc2_];
            _cellVec[_loc5_] = _loc6_;
            _loc2_++;
         }
      }
      
      public function returnNullPoint(param1:Number, param2:Number) : Object
      {
         var _loc3_:Point = new Point(0,0);
         var _loc4_:Object = new Object();
         var _loc5_:int = 0;
         while(_loc5_ < 49)
         {
            if(_bagdata.items[_loc5_] == null)
            {
               _loc3_.x = this.localToGlobal(new Point(_cells[_loc5_].x,_cells[_loc5_].y)).x;
               _loc3_.y = this.localToGlobal(new Point(_cells[_loc5_].x,_cells[_loc5_].y)).y;
               _loc4_.point = _loc3_;
               _loc4_.bagType = BagInfo.PROPBAG;
               _loc4_.place = _loc5_;
               _loc4_.cell = _cells[_loc5_];
               return _loc4_;
            }
            _loc5_++;
         }
         _loc3_.x = RetrieveModel.EmailX;
         _loc3_.y = RetrieveModel.EmailY;
         _loc4_.point = _loc3_;
         _loc4_.bagType = BagInfo.PROPBAG;
         _loc4_.place = _loc5_;
         _loc4_.cell = _cells[_loc5_];
         RetrieveModel.Instance.isFull = true;
         return _loc4_;
      }
      
      override public function dispose() : void
      {
         DoubleClickManager.Instance.clearTarget();
         super.dispose();
      }
   }
}
