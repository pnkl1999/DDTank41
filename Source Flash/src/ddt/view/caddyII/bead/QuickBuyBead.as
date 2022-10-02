package ddt.view.caddyII.bead
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyBead extends BaseAlerFrame
   {
       
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<QuickBuyItem>;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _money:int;
      
      private var _clickNumber:int;
      
      private var _cellId:Array;
      
      private var _selectedItem:QuickBuyItem;
      
      public function QuickBuyBead()
      {
         this._cellId = [EquipType.BEAD_ATTACK,EquipType.BEAD_DEFENSE,EquipType.BEAD_ATTRIBUTE];
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("bead.quickBox");
         var _loc1_:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont1");
         var _loc2_:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont2");
         var _loc3_:Image = ComponentFactory.Instance.creatComponentByStylename("bead.quickMoneyBG");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("bead.moneyTxt");
         addToContent(_loc1_);
         addToContent(_loc2_);
         addToContent(_loc3_);
         addToContent(this._moneyTxt);
         this.creatCell();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         var _loc1_:QuickBuyItem = null;
         removeEventListener(FrameEvent.RESPONSE,this._response);
         for each(_loc1_ in this._cellItems)
         {
            _loc1_.removeEventListener(Event.CHANGE,this._numberChange);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc1_.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            _loc1_.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
         }
      }
      
      private function creatCell() : void
      {
         var _loc2_:QuickBuyItem = null;
         this._cellItems = new Vector.<QuickBuyItem>();
         this._list.beginChanges();
         var _loc1_:int = 0;
         while(_loc1_ < this._cellId.length)
         {
            _loc2_ = new QuickBuyItem();
            _loc2_.itemID = this._cellId[_loc1_];
            _loc2_.addEventListener(Event.CHANGE,this._numberChange);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc2_.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            _loc2_.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
            this._list.addChild(_loc2_);
            this._cellItems.push(_loc2_);
            _loc1_++;
         }
         this._list.commitChanges();
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:QuickBuyItem = param1.currentTarget as QuickBuyItem;
         this.selectedItem = _loc2_;
      }
      
      private function _response(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.money > 0)
            {
               if(PlayerManager.Instance.Self.Money < this.money)
               {
                  ObjectUtils.disposeObject(this);
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
                  return;
               }
               this.buy();
               ObjectUtils.disposeObject(this);
            }
            else
            {
               this._showTip();
            }
         }
         else
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function _numberChange(param1:Event) : void
      {
         var _loc3_:QuickBuyItem = null;
         var _loc4_:QuickBuyItem = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._cellItems)
         {
            _loc2_ += _loc3_.count * ShopManager.Instance.getMoneyShopItemByTemplateID(_loc3_.info.TemplateID).getItemPrice(1).moneyValue;
         }
         this.money = _loc2_;
         _loc4_ = param1.currentTarget as QuickBuyItem;
         this.selectedItem = _loc4_;
      }
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         if(this.money > 0)
         {
            this.buy();
            ObjectUtils.disposeObject(this);
         }
         else
         {
            this._showTip();
         }
      }
      
      private function buy() : void
      {
         var _loc7_:QuickBuyItem = null;
         var _loc8_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         for each(_loc7_ in this._cellItems)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_.count)
            {
               _loc1_.push(ShopManager.Instance.getMoneyShopItemByTemplateID(_loc7_.info.TemplateID).GoodsID);
               _loc2_.push(1);
               _loc3_.push("");
               _loc4_.push(false);
               _loc5_.push("");
               _loc6_.push(-1);
               _loc8_++;
            }
         }
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc6_,_loc4_,_loc5_,5);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.showFillFrame();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function _showTip() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.quickNode"));
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
      
      public function set clickNumber(param1:int) : void
      {
         if(param1 >= 0)
         {
            this._clickNumber = param1;
            this._cellItems[this._clickNumber].count = 1;
            this._cellItems[this._clickNumber].setFocus();
         }
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
         this.clickNumber = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuickBuyItem = null;
         this.removeEvents();
         for each(_loc1_ in this._cellItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cellItems = null;
         this._cellId = null;
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
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get selectedItem() : QuickBuyItem
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:QuickBuyItem) : void
      {
         var _loc2_:QuickBuyItem = this._selectedItem;
         this._selectedItem = param1;
         this._selectedItem.selected = true;
         if(_loc2_ && this._selectedItem != _loc2_)
         {
            _loc2_.selected = false;
         }
      }
   }
}
