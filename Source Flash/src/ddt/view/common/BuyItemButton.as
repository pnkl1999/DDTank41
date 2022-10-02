package ddt.view.common
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuyItemButton extends BaseButton
   {
       
      
      protected var _itemInfo:ItemTemplateInfo;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      private var _needDispatchEvent:Boolean;
      
      private var _storeTab:int;
      
      private var _itemID:int;
      
      public function BuyItemButton()
      {
         super();
      }
      
      public function setup(param1:int, param2:int, param3:Boolean = false) : void
      {
         this._itemID = param1;
         this._storeTab = param2;
         this._needDispatchEvent = param3;
         this.initliziItemTemplate();
      }
      
      protected function initliziItemTemplate() : void
      {
         this._itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         var _loc1_:GoodTipInfo = new GoodTipInfo();
         _loc1_.itemInfo = this._itemInfo;
         _loc1_.isBalanceTip = false;
         _loc1_.typeIsSecond = false;
         tipData = _loc1_;
      }
      
      override protected function __onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         if(_enable)
         {
            param1.stopImmediatePropagation();
            if(useLogID != 0 && ComponentSetting.SEND_USELOG_ID != null)
            {
               ComponentSetting.SEND_USELOG_ID(useLogID);
            }
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < this._shopItemInfo.getItemPrice(1).moneyValue)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
               _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
               _loc2_.itemID = this._itemID;
               _loc2_.buyFrom = this._storeTab;
               _loc2_.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
               _loc2_.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
         }
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this._needDispatchEvent)
         {
            dispatchEvent(new ShortcutBuyEvent(param1.ItemID,param1.ItemNum));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._itemInfo = null;
         this._shopItemInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
