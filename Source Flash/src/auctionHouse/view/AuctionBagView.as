package auctionHouse.view
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class AuctionBagView extends BagView
   {
       
      
      public function AuctionBagView()
      {
         super();
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0,31,79,7,_equipBagPage);
         _proplist = new AuctionBagListView(1,0,48,7);
         _equiplist.x = _proplist.x = 14;
         _equiplist.y = _proplist.y = 54;
         _equiplist.width = _proplist.width = 330;
         _equiplist.height = _proplist.height = 320;
         _proplist.visible = false;
         _lists = [_equiplist,_proplist];
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_proplist);
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(_breakBtn)
         {
            _breakBtn.enable = false;
         }
         if(_sellBtn)
         {
            _sellBtn.enable = false;
         }
         if(_keySetBtn)
         {
            _keySetBtn.enable = false;
         }
         if(_sortBagBtn)
         {
            _sortBagBtn.enable = false;
         }
         if(_trieveBtn)
         {
            _trieveBtn.enable = false;
         }
         if(_continueBtn)
         {
            _continueBtn.enable = false;
         }
      }
      
      override public function setBagType(param1:int) : void
      {
         _breakBtn.enable = false;
         if(_bagType == param1)
         {
            return;
         }
         _bagType = param1;
         _btnGroup.selectIndex = _bagType;
         _equiplist.visible = _bagType == EQUIP;
         _proplist.visible = !_equiplist.visible;
         setBagCountShow(_bagType);
         this.set_breakBtn_enable();
      }
      
      override protected function adjustEvent() : void
      {
      }
      
      override protected function __cellOpen(param1:Event) : void
      {
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(_loc2_)
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               _loc2_.dragStart();
            }
         }
      }
   }
}
