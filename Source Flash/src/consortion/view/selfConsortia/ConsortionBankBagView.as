package consortion.view.selfConsortia
{
   import bagAndInfo.bag.BagEquipListView;
   import bagAndInfo.bag.BagProListView;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import equipretrieve.RetrieveController;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ConsortionBankBagView extends BagView
   {
      
      private static var LIST_WIDTH:int = 330;
      
      private static var LIST_HEIGHT:int = 320;
       
      
      private var _bank:ConsortionBankListView;
      
      private var BG:Scale9CornerImage;
      
      private var title:Bitmap;
      
      private var smallBg:MutipleImage;
      
      private var numBg:Bitmap;
      
      public function ConsortionBankBagView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.setData(PlayerManager.Instance.Self);
         PositionUtils.setPos(_equipBtn,"consortion.bank.equipPos");
         PositionUtils.setPos(_propBtn,"consortion.bank.propPos");
         PositionUtils.setPos(_cardBtn,"consortion.bank.cardPos");
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(_keySetBtn && _isSkillCanUse())
         {
            _keySetBtn.enable = true;
         }
         if(_sortBagBtn)
         {
            _sortBagBtn.enable = true;
         }
      }
      
      override protected function set_text_location() : void
      {
         if(_goldText)
         {
            _goldText.y += 31;
         }
         if(_moneyText)
         {
            _moneyText.y += 31;
         }
         if(_giftText)
         {
            _giftText.y += 31;
         }
         if(_medalField)
         {
            _medalField.y += 31;
         }
      }
      
      override protected function set_btn_location() : void
      {
         _goldButton.y += 32;
         _giftButton.y += 32;
         _moneyButton.y += 32;
         _medalButton.y += 32;
         _sellBtn.y += 32;
         _continueBtn.y += 32;
         _breakBtn.y += 32;
         _keySetBtn.y += 32;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._bank.addEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.addEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,this.__listChange);
         _proplist.addEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._bank.removeEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.removeEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         _proplist.removeEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
      }
      
      override protected function initBackGround() : void
      {
         this.BG = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBag.bg");
         this._bank = new ConsortionBankListView(11,PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
         PositionUtils.setPos(this._bank,"consortion.bank.Pos");
         this.title = ComponentFactory.Instance.creatBitmap("asset.consortion.bank.title");
         this.smallBg = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBag.mutiple");
         _bgShape = new Shape();
         _bgShape.graphics.beginFill(15262671,1);
         _bgShape.graphics.drawRoundRect(0,0,327,328,2,2);
         _bgShape.graphics.endFill();
         _bgShape.x = 10;
         _bgShape.y = 80;
         addChild(this.BG);
         addChild(_bgShape);
         addChild(this._bank);
         addChild(this.title);
         addChild(this.smallBg);
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new BagEquipListView(0,31,79,7,_equipBagPage);
         _proplist = new BagProListView(1,0,48);
         PositionUtils.setPos(_equiplist,"consortion.bank.listPos");
         PositionUtils.setPos(_proplist,"consortion.bank.listPos");
         _equiplist.width = _proplist.width = LIST_WIDTH;
         _equiplist.height = _proplist.height = LIST_HEIGHT;
         _proplist.visible = false;
         _lists = [_equiplist,_proplist];
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_proplist);
      }
      
      override protected function __listChange(param1:Event) : void
      {
         if(param1.currentTarget == _equiplist)
         {
            setBagType(BagInfo.EQUIPBAG);
         }
         else
         {
            setBagType(BagInfo.PROPBAG);
         }
      }
      
      override protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = this._bank.checkConsortiaStoreCell();
         if(_loc2_ > 0)
         {
            if(_loc2_ == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
            }
            else if(_loc2_ == 2 || _loc2_ == 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick.msg"));
            }
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         var _loc3_:BagCell = param1.data as BagCell;
         var _loc4_:InventoryItemInfo = _loc3_.info as InventoryItemInfo;
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
         var _loc6_:int = !!PlayerManager.Instance.Self.Sex ? int(int(1)) : int(int(2));
         if(!_loc3_.locked)
         {
            SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,BagInfo.CONSORTIA,-1);
         }
      }
      
      override protected function ___trieveBtnClick(param1:MouseEvent) : void
      {
         super.___trieveBtnClick(param1);
         RetrieveController.Instance.isBagOpen = false;
      }
      
      private function __bankCellClick(param1:CellEvent) : void
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
      
      private function __bankCellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BagCell = param1.data as BagCell;
         var _loc3_:InventoryItemInfo = _loc2_.itemInfo;
         SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this.getItemBagType(_loc3_),-1,_loc3_.Count);
      }
      
      private function getItemBagType(param1:InventoryItemInfo) : int
      {
         if(EquipType.isBelongToPropBag(param1))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
      
      private function __upConsortiaStroeLevel(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["StoreLevel"])
         {
            this.__addToStageHandler(null);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._bank.upLevel(PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
      }
      
      public function setData(param1:SelfInfo) : void
      {
         _equiplist.setData(param1.Bag);
         _proplist.setData(param1.PropBag);
         this._bank.setData(param1.ConsortiaBag);
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Point = null;
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
               if(_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 107);
               }
               else
               {
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      override protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = LanguageMgr.GetTranslation("bagAndInfo.consortionBag.sortBagClick.isSegistration");
         AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc2_.dispose();
         var _loc3_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.CONSORTIA);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(CONSORTION,_loc3_,0,_loc3_.items.length,true);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               PlayerManager.Instance.Self.PropBag.sortBag(CONSORTION,_loc3_,0,_loc3_.items.length,false);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._bank)
         {
            this._bank.dispose();
         }
         this._bank = null;
         if(this.BG)
         {
            ObjectUtils.disposeObject(this.BG);
         }
         this.BG = null;
         if(this.title)
         {
            ObjectUtils.disposeObject(this.title);
         }
         this.title = null;
         if(this.smallBg)
         {
            ObjectUtils.disposeObject(this.smallBg);
         }
         this.smallBg = null;
         if(this.numBg)
         {
            ObjectUtils.disposeObject(this.numBg);
         }
         this.numBg = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
