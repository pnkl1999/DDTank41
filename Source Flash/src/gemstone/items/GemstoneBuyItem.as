package gemstone.items
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GemstoneBuyItem extends Sprite
   {
       
      
      private var _itemID:int;
      
      private var _needDispatchEvent:Boolean;
      
      private var _storeTab:int;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var tipData:GoodTipInfo;
      
      private var _cell:BagCell;
      
      private var _txt:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      public function GemstoneBuyItem()
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
      
      private function initliziItemTemplate() : void
      {
         this._itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._shopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         var _loc1_:GoodTipInfo = new GoodTipInfo();
         _loc1_.itemInfo = this._itemInfo;
         _loc1_.isBalanceTip = false;
         _loc1_.typeIsSecond = false;
         this.tipData = _loc1_;
         this._btn = ComponentFactory.Instance.creatComponentByStylename("gemstone.buy.btn");
         addChild(this._btn);
         mouseChildren = false;
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.CLICK,this.clickHander);
      }
      
      protected function clickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc2_.itemID = this._itemID;
         _loc2_.buyFrom = this._storeTab;
         _loc2_.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         _loc2_.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
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
      
      public function setText(param1:String) : void
      {
         this._txt.text = param1;
      }
      
      public function dispose() : void
      {
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
