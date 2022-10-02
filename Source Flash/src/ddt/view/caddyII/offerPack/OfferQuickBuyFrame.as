package ddt.view.caddyII.offerPack
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OfferQuickBuyFrame extends BaseAlerFrame
   {
       
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<OfferQuickCell>;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _selectNumber:NumberSelecter;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _money:int;
      
      private var _select:int = -1;
      
      private var _selectCell:OfferQuickCell;
      
      private var _shopInfoList:Vector.<ShopItemInfo>;
      
      private var _itemTempLateID:Array;
      
      public function OfferQuickBuyFrame()
      {
         this._itemTempLateID = [EquipType.OFFER_PACK_I,EquipType.OFFER_PACK_II,EquipType.OFFER_PACK_III,EquipType.OFFER_PACK_IV,EquipType.OFFER_PACK_V];
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("offer.quickBox");
         var _loc1_:Image = ComponentFactory.Instance.creatComponentByStylename("offer.quickFont1");
         var _loc2_:Image = ComponentFactory.Instance.creatComponentByStylename("offer.quickFont2");
         var _loc3_:Image = ComponentFactory.Instance.creatComponentByStylename("offer.quickMoneyBG");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("offer.moneyTxt");
         this._selectNumber = ComponentFactory.Instance.creatCustomObject("offer.numberSelecter",[1]);
         this._selectNumber.number = 1;
         this._itemGroup = new SelectedButtonGroup();
         addToContent(_loc1_);
         addToContent(_loc2_);
         addToContent(_loc3_);
         addToContent(this._moneyTxt);
         addToContent(this._selectNumber);
         this.initShopInfo();
         this.createCell();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._selectNumber.addEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._selectNumber.removeEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function initShopInfo() : void
      {
         var _loc2_:Vector.<ShopItemInfo> = null;
         var _loc3_:ShopItemInfo = null;
         this._shopInfoList = new Vector.<ShopItemInfo>();
         var _loc1_:int = 1;
         while(_loc1_ < 6)
         {
            _loc2_ = ShopManager.Instance.consortiaShopLevelTemplates(_loc1_);
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.TemplateInfo.CategoryID == 11)
               {
                  this._shopInfoList.push(_loc3_);
               }
            }
            _loc1_++;
         }
      }
      
      private function createCell() : void
      {
         var _loc2_:OfferQuickCell = null;
         this._list.beginChanges();
         var _loc1_:int = 0;
         while(_loc1_ < this._itemTempLateID.length)
         {
            _loc2_ = new OfferQuickCell();
            _loc2_.info = ItemManager.Instance.getTemplateById(this._itemTempLateID[_loc1_]);
            _loc2_.addEventListener(MouseEvent.CLICK,this._itemClick);
            this._itemGroup.addSelectItem(_loc2_);
            this._list.addChild(_loc2_);
            _loc1_++;
         }
         this._list.commitChanges();
      }
      
      private function removeListChildEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._list.numChildren)
         {
            this._list.getChildAt(_loc1_).removeEventListener(MouseEvent.CLICK,this._itemClick);
            _loc1_++;
         }
      }
      
      private function _numberChange(param1:Event) : void
      {
         this.money = this._selectNumber.number * this._shopInfoList[this.select].getItemPrice(1).gesteValue;
      }
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         this.buy();
         ObjectUtils.disposeObject(this);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.buy();
         }
         ObjectUtils.disposeObject(this);
      }
      
      private function _itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._selectCell = param1.currentTarget as OfferQuickCell;
         this.select = this._list.getChildIndex(this._selectCell);
         this._selectNumber.number = 1;
      }
      
      private function buy() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.offer.noConsortia"));
            return;
         }
         if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel < this._shopInfoList[this.select].ShopID - 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.checkMoney"));
            return;
         }
         if(PlayerManager.Instance.Self.Offer < this._shopInfoList[this.select].getItemPrice(1).gesteValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.offer.noOffer"));
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < this._selectNumber.number)
         {
            _loc1_.push(this._shopInfoList[this.select].GoodsID);
            _loc2_.push(1);
            _loc3_.push("");
            _loc4_.push(false);
            _loc5_.push("");
            _loc6_.push(-1);
            _loc7_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc6_,_loc4_,_loc5_,0);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      public function set money(param1:int) : void
      {
         this._money = param1;
         this._moneyTxt.text = String(this._money);
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set select(param1:int) : void
      {
         if(this._select == param1)
         {
            return;
         }
         this._select = param1;
         this._itemGroup.selectIndex = this._select;
         this._numberChange(null);
      }
      
      public function get select() : int
      {
         return this._select;
      }
      
      public function show(param1:int) : void
      {
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         _loc2_.data = this._list;
         _loc2_.submitLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         _loc2_.showCancel = false;
         _loc2_.moveEnable = false;
         info = _loc2_;
         addToContent(this._list);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.select = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:OfferQuickCell = null;
         this.removeListChildEvent();
         this.removeEvents();
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._moneyTxt)
         {
            ObjectUtils.disposeObject(this._moneyTxt);
         }
         this._moneyTxt = null;
         if(this._selectNumber)
         {
            ObjectUtils.disposeObject(this._selectNumber);
         }
         this._selectNumber = null;
         if(this._selectCell)
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(this._itemGroup)
         {
            ObjectUtils.disposeObject(this._itemGroup);
         }
         this._itemGroup = null;
         for each(_loc1_ in this._cellItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cellItems = null;
         this._shopInfoList = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
