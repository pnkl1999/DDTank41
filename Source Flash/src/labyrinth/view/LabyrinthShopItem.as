package labyrinth.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import labyrinth.LabyrinthManager;
   import shop.view.ShopGoodItem;
   
   public class LabyrinthShopItem extends ShopGoodItem
   {
       
      
      protected var _explanation:FilterFrameText;
      
      private var _frame:BuyFrame;
      
      public function LabyrinthShopItem()
      {
         super();
      }
      
      override protected function initContent() : void
      {
         super.initContent();
         _itemBg.setFrame(4);
         _payPaneBuyBtn.x = 135;
         _payPaneBuyBtn.y = 55;
         _payPaneGetBtn.x = 135;
         _payPaneGetBtn.y = 55;
         _itemNameTxt.x = 73;
         this._explanation = UICreatShortcut.creatTextAndAdd("labyrinth.view.LabyrinthShopItem.explanationText",LanguageMgr.GetTranslation("labyrinth.view.LabyrinthShopItem.explanationText",1),this);
         this._explanation.visible = false;
         setItemCellSize();
         _shopItemCellTypeBg.parent.removeChild(_shopItemCellTypeBg);
      }
      
      override protected function initPrice() : void
      {
         _itemPriceTxt.text = String(_shopItemInfo.getItemPrice(1).hardCurrencyValue);
         _payType.setFrame(PAYTYPE_GIFT);
         _payPaneGivingBtn.visible = false;
      }
      
      override public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         super.shopItemInfo = param1;
         setItemName();
         setItemCellSize();
         _itemBg.setFrame(4);
         this.updateCircumscribe();
      }
      
      protected function updateCircumscribe() : void
      {
         if(!_shopItemInfo)
         {
            this._explanation.visible = false;
            _payPaneBuyBtn.visible = false;
         }
         else if(_shopItemInfo.LimitGrade <= LabyrinthManager.Instance.model.myProgress)
         {
            this._explanation.visible = false;
            _payPaneBuyBtn.visible = true;
            _itemCellBtn.filters = null;
         }
         else
         {
            this._explanation.visible = true;
            this._explanation.text = LanguageMgr.GetTranslation("labyrinth.view.LabyrinthShopItem.explanationText",_shopItemInfo.LimitGrade);
            this._explanation.y = 58;
            _payPaneBuyBtn.visible = false;
            _itemCellBtn.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
      }
      
      override protected function __payPanelClick(param1:MouseEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(LabyrinthManager.Instance.buyFrameEnable)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc2_.setItemID(shopItemInfo.TemplateID,1);
            _loc2_.buyFrom = 0;
            _loc2_.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            _loc2_.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            this.buy();
         }
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(param1.ItemID,param1.ItemNum));
      }
      
      protected function __onframeEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.buy();
         }
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onframeEvent);
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
      }
      
      private function buy() : void
      {
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         _loc1_.push(shopItemInfo.GoodsID);
         _loc2_.push(1);
         _loc3_.push("");
         _loc4_.push("");
         _loc5_.push("");
         _loc6_.push(1);
         _loc7_.push("");
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc5_,_loc4_,null,0,_loc6_,_loc7_);
      }
   }
}
