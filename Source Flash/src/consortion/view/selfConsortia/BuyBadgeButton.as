package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.utils.DateUtils;
   
   public class BuyBadgeButton extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _buyBadgeTxt:Bitmap;
      
      private var _badge:Badge;
      
      private var _badgeID:int;
      
      public function BuyBadgeButton()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:BadgeShopFrame = null;
         if(PlayerManager.Instance.Self.consortiaInfo.ChairmanID == PlayerManager.Instance.Self.ID)
         {
            SoundManager.instance.playButtonSound();
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortion.badgeShopFrame");
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND,true);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         filters = [];
      }
      
      private function initView() : void
      {
         buttonMode = PlayerManager.Instance.Self.consortiaInfo.ChairmanID == PlayerManager.Instance.Self.ID;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.buyBadgeBtnBg");
         this._buyBadgeTxt = ComponentFactory.Instance.creatBitmap("asset.consortion.buyBadgeBtnTxt");
         this._badge = new Badge(Badge.LARGE);
         addChild(this._bg);
         addChild(this._buyBadgeTxt);
         addChild(this._badge);
         PositionUtils.setPos(this._badge,"consortiaBadgeBtn.badge.pos");
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function get badgeID() : int
      {
         return this._badgeID;
      }
      
      public function set badgeID(param1:int) : void
      {
         if(this._badgeID == param1)
         {
            return;
         }
         this._badgeID = param1;
         this._buyBadgeTxt.visible = this._badgeID == 0;
         if(PlayerManager.Instance.Self.consortiaInfo.BadgeID > 0)
         {
            this._badge.buyDate = DateUtils.dealWithStringDate(PlayerManager.Instance.Self.consortiaInfo.BadgeBuyTime);
            ShowTipManager.Instance.addTip(this._badge);
         }
         this._badge.badgeID = param1;
         this._badge.visible = this._badgeID > 0;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this._badge);
         this._badge.dispose();
         this._badge = null;
         ObjectUtils.disposeObject(this._buyBadgeTxt);
         this._buyBadgeTxt = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
