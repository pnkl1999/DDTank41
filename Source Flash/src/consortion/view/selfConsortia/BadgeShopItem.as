package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.BadgeInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BadgeShopItem extends Sprite implements Disposeable
   {
       
      
      private var _badge:Badge;
      
      private var _btn:SimpleBitmapButton;
      
      private var _nametxt:FilterFrameText;
      
      private var _day:FilterFrameText;
      
      private var _pay:FilterFrameText;
      
      private var _info:BadgeInfo;
      
      private var _bg:Bitmap;
      
      private var _alert:BaseAlerFrame;
      
      public function BadgeShopItem(param1:BadgeInfo)
      {
         super();
         this._info = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consotiaii.badgeShopItemBg");
         addChild(this._bg);
         this._badge = new Badge(Badge.NORMAL);
         this._badge.badgeID = this._info.BadgeID;
         PositionUtils.setPos(this._badge,"badgeshopItem.pos");
         ShowTipManager.Instance.addTip(this._badge);
         this._nametxt = ComponentFactory.Instance.creatComponentByStylename("consortion.badgeShopItem.name");
         addChild(this._nametxt);
         this._nametxt.text = this._info.BadgeName;
         this._btn = ComponentFactory.Instance.creatComponentByStylename("consortion.buyBadgeItemBtn");
         this._day = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItemBtn.day");
         this._pay = ComponentFactory.Instance.creatComponentByStylename("consortion.shopItemBtn.Pay");
         addChild(this._badge);
         addChild(this._btn);
         this._btn.addChild(this._day);
         this._btn.addChild(this._pay);
         this._pay.text = this._info.Cost.toString() + LanguageMgr.GetTranslation("consortia.Money");
         this._day.text = this._info.ValidDate.toString() + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         if(PlayerManager.Instance.Self.consortiaInfo.Level < this._info.LimitLevel)
         {
            this._bg.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.consortiaInfo.Level >= this._info.LimitLevel)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.Riches >= this._info.Cost)
            {
               if(this._alert)
               {
                  this._alert.removeEventListener(FrameEvent.RESPONSE,this.onResponse);
                  ObjectUtils.disposeObject(this._alert);
               }
               this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.common.AddPricePanel.pay"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this._alert.addEventListener(FrameEvent.RESPONSE,this.onResponse);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough1"));
               ConsortionModelControl.Instance.alertTaxFrame();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.buyBadge.levelTooLow"));
         }
      }
      
      private function onResponse(param1:FrameEvent) : void
      {
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.onResponse);
         this._alert.dispose();
         this._alert = null;
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendBuyBadge(this._info.BadgeID);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.onResponse);
            this._alert.dispose();
         }
         this._alert = null;
         ShowTipManager.Instance.removeTip(this._badge);
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._nametxt);
         this._nametxt = null;
         ObjectUtils.disposeObject(this._day);
         this._day = null;
         ObjectUtils.disposeObject(this._pay);
         this._pay = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
