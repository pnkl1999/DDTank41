package consortion.view.selfConsortia
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.events.CellEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ConsortionBankListView extends BagListView
   {
      
      private static var MAX_LINE_NUM:int = 10;
       
      
      private var _bankLevel:int;
      
      public function ConsortionBankListView(param1:int, param2:int = 0)
      {
         super(param1,MAX_LINE_NUM);
      }
      
      public function upLevel(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BagCell = null;
         if(param1 == this._bankLevel)
         {
            return;
         }
         var _loc2_:int = this._bankLevel;
         while(_loc2_ < param1)
         {
            _loc3_ = 0;
            while(_loc3_ < MAX_LINE_NUM)
            {
               _loc4_ = _loc2_ * MAX_LINE_NUM + _loc3_;
               _loc5_ = _cells[_loc4_] as BagCell;
               _loc5_.grayFilters = false;
               _loc5_.mouseEnabled = true;
               _loc3_++;
            }
            _loc2_++;
         }
         this._bankLevel = param1;
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(param1.currentTarget)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,param1.currentTarget,false,false));
         }
      }
      
      private function __resultHandler(param1:MouseEvent) : void
      {
      }
      
      override protected function createCells() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BagCell = null;
         _cells = new Dictionary();
         var _loc1_:int = 0;
         while(_loc1_ < MAX_LINE_NUM)
         {
            _loc2_ = 0;
            while(_loc2_ < MAX_LINE_NUM)
            {
               _loc3_ = _loc1_ * MAX_LINE_NUM + _loc2_;
               _loc4_ = CellFactory.instance.createBagCell(_loc3_) as BagCell;
               addChild(_loc4_);
               _loc4_.bagType = _bagType;
               _loc4_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               _loc4_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               DoubleClickManager.Instance.enableDoubleClick(_loc4_);
               _loc4_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
               _cells[_loc4_.place] = _loc4_;
               if(this._bankLevel <= _loc1_)
               {
                  _loc4_.grayFilters = true;
                  _loc4_.mouseEnabled = false;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function checkConsortiaStoreCell() : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BagCell = null;
         if(this._bankLevel == 0)
         {
            return 1;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._bankLevel)
         {
            _loc2_ = 0;
            while(_loc2_ < MAX_LINE_NUM)
            {
               _loc3_ = _loc1_ * MAX_LINE_NUM + _loc2_;
               _loc4_ = _cells[_loc3_] as BagCell;
               if(!_loc4_.info)
               {
                  return 0;
               }
               _loc2_++;
            }
            _loc1_++;
         }
         if(this._bankLevel == MAX_LINE_NUM)
         {
            return 2;
         }
         return 3;
      }
      
      override public function dispose() : void
      {
         var _loc1_:BagCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            _loc1_.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         }
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
