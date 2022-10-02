package ddt.view.caddyII.bead
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
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
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class CardBoxQuickBuy extends BaseAlerFrame
   {
       
      
      private var _item:QuickBuyItem;
      
      private var _font1:Image;
      
      private var _font2:Image;
      
      private var _moneyBG:Image;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _money:int;
      
      public function CardBoxQuickBuy()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         _loc1_.submitLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         _loc1_.showCancel = false;
         _loc1_.moveEnable = false;
         info = _loc1_;
         this._item = new QuickBuyItem();
         this._item.itemID = EquipType.MYSTICAL_CARDBOX;
         PositionUtils.setPos(this._item,"cardBoxQuickBuy.pos");
         this._item.count = 1;
         this._font1 = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont1");
         PositionUtils.setPos(this._font1,"cardBoxQuickBuy.font1pos");
         this._font2 = ComponentFactory.Instance.creatComponentByStylename("bead.quickFont2");
         PositionUtils.setPos(this._font2,"cardBoxQuickBuy.font2pos");
         this._moneyBG = ComponentFactory.Instance.creatComponentByStylename("bead.quickMoneyBG");
         PositionUtils.setPos(this._moneyBG,"cardBoxQuickBuy.moneyBGpos");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("bead.moneyTxt");
         PositionUtils.setPos(this._moneyTxt,"cardBoxQuickBuy.moneyTxtpos");
         addToContent(this._item);
         addToContent(this._font1);
         addToContent(this._font2);
         addToContent(this._moneyBG);
         addToContent(this._moneyTxt);
         this._numberChange(null);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._item.removeEventListener(Event.CHANGE,this._numberChange);
         this._item.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._item.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._item.addEventListener(Event.CHANGE,this._numberChange);
         this._item.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
         this._item.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
      }
      
      private function _numberChange(param1:Event) : void
      {
         this.money = this._item.count * ShopManager.Instance.getMoneyShopItemByTemplateID(this._item.info.TemplateID).getItemPrice(1).moneyValue;
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
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
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
      
      private function _showTip() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.quickNumber"));
      }
      
      private function buy() : void
      {
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < this._item.count)
         {
            _loc1_.push(ShopManager.Instance.getMoneyShopItemByTemplateID(this._item.info.TemplateID).GoodsID);
            _loc2_.push(1);
            _loc3_.push("");
            _loc4_.push(false);
            _loc5_.push("");
            _loc6_.push(-1);
            _loc7_++;
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
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._item)
         {
            ObjectUtils.disposeObject(this._item);
         }
         this._item = null;
         if(this._font1)
         {
            ObjectUtils.disposeObject(this._font1);
         }
         this._font1 = null;
         if(this._font2)
         {
            ObjectUtils.disposeObject(this._font2);
         }
         this._font2 = null;
         if(this._moneyBG)
         {
            ObjectUtils.disposeObject(this._moneyBG);
         }
         this._moneyBG = null;
         if(this._moneyTxt)
         {
            ObjectUtils.disposeObject(this._moneyTxt);
         }
         this._moneyTxt = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
