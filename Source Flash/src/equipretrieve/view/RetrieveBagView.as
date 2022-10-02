package equipretrieve.view
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveModel;
   import flash.display.Shape;
   import flash.events.Event;
   
   public class RetrieveBagView extends BagView
   {
       
      
      public function RetrieveBagView()
      {
         super();
         isNeedCard(false);
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
         if(_settingLockBtn)
         {
            _settingLockBtn.enable = false;
         }
         if(_trieveBtn)
         {
            _trieveBtn.enable = false;
         }
         if(_continueBtn)
         {
            _continueBtn.enable = false;
         }
         _settingLockBtn.visible = false;
         _sortBagBtn.visible = false;
         _trieveBtn.visible = false;
         _goodsNumInfoText.visible = false;
         _goodsNumTotalText.visible = false;
      }
      
      override protected function initBackGround() : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("retrieveBagBGAsset");
         addChild(_bg);
         _bgShape = new Shape();
         _bgShape.graphics.beginFill(15262671,1);
         _bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         _bgShape.graphics.endFill();
         _bgShape.x = 11;
         _bgShape.y = 50;
         addChild(_bgShape);
      }
      
      override protected function updateLockState() : void
      {
         _settingLockBtn.visible = false;
         _settedLockBtn.visible = false;
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new RetrieveBagEquipListView(0);
         _proplist = new RetrieveBagListView(1);
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
      
      override protected function initEvent() : void
      {
         _equiplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         _equiplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,__listChange);
         _equiplist.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
         _proplist.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _proplist.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
         _btnGroup.addEventListener(Event.CHANGE,__tabClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL,__useColorShell);
      }
      
      override public function setBagType(param1:int) : void
      {
         super.setBagType(param1);
         _sellBtn.enable = _breakBtn.enable = _continueBtn.enable = false;
      }
      
      override protected function __cellDoubleClick(param1:CellEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc2_:RetrieveBagcell = param1.data as RetrieveBagcell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         var _loc5_:int = !!PlayerManager.Instance.Self.Sex ? int(int(1)) : int(int(2));
         if(!_loc2_.locked)
         {
            RetrieveController.Instance.cellDoubleClick(_loc2_);
         }
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
               RetrieveController.Instance.shine = true;
            }
         }
      }
      
      private function _stopDrag(param1:CellEvent) : void
      {
         RetrieveController.Instance.shine = false;
      }
      
      public function resultPoint(param1:int, param2:Number, param3:Number) : void
      {
         this.setBagType(param1);
         if(param1 == EQUIP)
         {
            RetrieveModel.Instance.setresultCell(RetrieveBagEquipListView(_equiplist).returnNullPoint(param2,param3));
         }
         else if(param1 == PROP)
         {
            RetrieveModel.Instance.setresultCell(RetrieveBagListView(_proplist).returnNullPoint(param2,param3));
         }
      }
   }
}
