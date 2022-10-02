package ddt.command
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyFrame extends Frame
   {
       
      
      public var canDispose:Boolean;
      
      private var _view:QuickBuyFrameView;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _submitButton:TextButton;
      
      private var _unitPrice:Number;
      
      private var _buyFrom:int;
      
      private var _recordLastBuyCount:Boolean;
      
      public function QuickBuyFrame()
      {
         super();
         this.canDispose = true;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._view = new QuickBuyFrameView();
         addToContent(this._view);
         this._submitButton = ComponentFactory.Instance.creatComponentByStylename("core.quickEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         this._view.addChild(this._submitButton);
         escEnable = true;
         enterEnable = true;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.doPay);
         this._view.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function removeEvnets() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(this._submitButton)
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.doPay);
         }
         if(this._view)
         {
            this._view.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         }
         removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberClose(param1:Event) : void
      {
         this.cancelMoney();
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         this.doPay(null);
      }
      
      public function setTitleText(param1:String) : void
      {
         titleText = param1;
      }
      
      public function set itemID(param1:int) : void
      {
         this._view.ItemID = param1;
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view._itemID);
         this.perPrice();
      }
      
      public function set stoneNumber(param1:int) : void
      {
         this._view.stoneNumber = param1;
      }
      
      public function set maxLimit(param1:int) : void
      {
         this._view.maxLimit = param1;
      }
      
      private function perPrice() : void
      {
         this._unitPrice = ShopManager.Instance.getMoneyShopItemByTemplateID(this._view.ItemID).getItemPrice(1).moneyValue;
      }
      
      private function doPay(param1:Event) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         SoundManager.instance.play("008");
         if(!this._shopItemInfo.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.quickDate"));
         }
         if(this._view.type == 0 || this._view.type == 3)
         {
            if(PlayerManager.Instance.Self.Money < this._view.stoneNumber * this._unitPrice)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               this.dispose();
               return;
            }
         }
         else if(this._view.type == 1)
         {
            if(!this._view.isBand && PlayerManager.Instance.Self.hardCurrency < this._view.stoneNumber * this._unitPrice)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
               return;
            }
         }
         else if(this._view.type == 2)
         {
            if(!this._view.isBand && PlayerManager.Instance.Self.Offer < this._view.stoneNumber * this._unitPrice)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ConsortiaShopItem.gongXunbuzu"));
               return;
            }
         }
         if(this._recordLastBuyCount)
         {
            SharedManager.Instance.lastBuyCount = this._view.stoneNumber;
         }
         if(this._view.ItemID == EquipType.GOLD_BOX)
         {
            SocketManager.Instance.out.sendQuickBuyGoldBox(this._view.stoneNumber);
         }
         else
         {
            _loc3_ = [];
            _loc4_ = [];
            _loc5_ = [];
            _loc6_ = [];
            _loc7_ = [];
            _loc8_ = [];
            _loc9_ = 0;
            while(_loc9_ < this._view.stoneNumber)
            {
               _loc3_.push(this._shopItemInfo.GoodsID);
               _loc4_.push(1);
               _loc5_.push("");
               _loc6_.push(false);
               _loc7_.push("");
               _loc8_.push(-1);
               _loc9_++;
            }
            SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_,this._buyFrom);
         }
         dispatchEvent(new ShortcutBuyEvent(this._view._itemID,this._view.stoneNumber));
         this.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.cancelMoney();
            ObjectUtils.disposeObject(this);
         }
         else if(param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.doPay(null);
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.doMoney();
         }
         else
         {
            this.cancelMoney();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function doMoney() : void
      {
         LeavePageManager.leaveToFillPath();
         dispatchEvent(new ShortcutBuyEvent(0,0,false,false,ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK));
      }
      
      private function cancelMoney() : void
      {
         dispatchEvent(new ShortcutBuyEvent(0,0,false,false,ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL));
      }
      
      public function set buyFrom(param1:int) : void
      {
         this._buyFrom = param1;
      }
      
      public function get buyFrom() : int
      {
         return this._buyFrom;
      }
      
      public function set recordLastBuyCount(param1:Boolean) : void
      {
         this._recordLastBuyCount = param1;
         if(this._recordLastBuyCount)
         {
            this._view.stoneNumber = SharedManager.Instance.lastBuyCount;
         }
      }
      
      public function setItemID(param1:int, param2:int, param3:int = 1) : void
      {
         this._view.setItemID(param1,param2,param3);
         this._shopItemInfo = ShopManager.Instance.getShopItemByTemplateID(this._view._itemID,param2);
         if(param2 == 1)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(1).hardCurrencyValue;
         }
         else if(param2 == 2)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(1).gesteValue;
         }
         else if(param2 == 3)
         {
            this._unitPrice = this._shopItemInfo.getItemPrice(param3).moneyValue;
         }
      }
      
      override public function dispose() : void
      {
         this._recordLastBuyCount = false;
         this.canDispose = false;
         super.dispose();
         this.removeEvnets();
         this._view = null;
         this._shopItemInfo = null;
         if(this._submitButton)
         {
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
