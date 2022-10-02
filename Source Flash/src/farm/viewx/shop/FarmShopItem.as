package farm.viewx.shop
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.manager.ShopBuyManager;
   import shop.view.ShopItemCell;
   
   public class FarmShopItem extends Sprite implements Disposeable
   {
       
      
      private var _payPaneBuyBtn:BaseButton;
      
      private var _payPaneBuyBtnHotArea:Sprite;
      
      private var _itemBg:Bitmap;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _canBuy:Boolean = true;
      
      private var _shopType:int = 0;
      
      public function FarmShopItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      protected function initContent() : void
      {
         buttonMode = true;
         this._itemBg = ComponentFactory.Instance.creatBitmap("assets.farmShop.goodItemBg");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("farmshop.PayPaneBuyBtn");
         this._payPaneBuyBtnHotArea = new Sprite();
         this._payPaneBuyBtnHotArea.graphics.beginFill(0,0);
         this._payPaneBuyBtnHotArea.graphics.drawRect(0,0,78,96);
         this._payPaneBuyBtnHotArea.mouseEnabled = false;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,60,60);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 50;
         PositionUtils.setPos(this._itemCell,"farm.shopItem.pos");
         addChild(this._itemBg);
         addChild(this._itemCell);
         addChild(this._payPaneBuyBtn);
         addChild(this._payPaneBuyBtnHotArea);
      }
      
      protected function addEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outhandler);
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OVER,this.__payPaneOver);
         this._payPaneBuyBtnHotArea.addEventListener(MouseEvent.MOUSE_OUT,this.__payPaneOut);
      }
      
      protected function __payPaneOut(param1:MouseEvent) : void
      {
         ShowTipManager.Instance.removeTip(this._payPaneBuyBtn);
      }
      
      protected function __payPaneOver(param1:MouseEvent) : void
      {
         if(this._shopItemInfo && this._shopItemInfo.LimitGrade > PlayerManager.Instance.Self.Grade)
         {
            this._payPaneBuyBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this._payPaneBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy",this._shopItemInfo.LimitGrade);
            this._payPaneBuyBtn.tipDirctions = "3,7,6";
            ShowTipManager.Instance.showTip(this._payPaneBuyBtn);
         }
         else if(!this.canBuyFert())
         {
            this._payPaneBuyBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this._payPaneBuyBtn.tipData = LanguageMgr.GetTranslation("ddt.shop.MinBuyFertLevel",ServerConfigManager.instance.getPrivilegeMinLevel(ServerConfigManager.PRIVILEGE_CANBUYFERT));
            this._payPaneBuyBtn.tipDirctions = "3,7,6";
            ShowTipManager.Instance.showTip(this._payPaneBuyBtn);
         }
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         if(!this._canBuy)
         {
            return;
         }
         filters = null;
      }
      
      protected function __outhandler(param1:MouseEvent) : void
      {
         if(!this._canBuy)
         {
            return;
         }
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function removeEvent() : void
      {
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OVER,this.__payPaneOver);
         this._payPaneBuyBtnHotArea.removeEventListener(MouseEvent.MOUSE_OUT,this.__payPaneOut);
      }
      
      public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         if(this._shopItemInfo == param1)
         {
            return;
         }
         this._shopItemInfo = param1;
         if(param1)
         {
            this._itemCell.info = param1.TemplateInfo;
         }
         else
         {
            this._itemCell.info = null;
         }
         this.updateBtn();
      }
      
      private function invalidateItemCell() : void
      {
         this._payPaneBuyBtn.enable = false;
         this._payPaneBuyBtnHotArea.mouseEnabled = true;
         this.mouseEnabled = false;
         this.buttonMode = false;
         this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._canBuy = false;
      }
      
      private function canBuyFert() : Boolean
      {
         return PlayerManager.Instance.Self.VIPLevel >= ServerConfigManager.instance.getPrivilegeMinLevel(ServerConfigManager.PRIVILEGE_CANBUYFERT) && PlayerManager.Instance.Self.IsVIP;
      }
      
      private function updateBtn() : void
      {
         if(this._shopItemInfo && PlayerManager.Instance.Self.Grade < this._shopItemInfo.LimitGrade)
         {
            this.invalidateItemCell();
         }
         else if(this._shopItemInfo && this._shopItemInfo.TemplateInfo.CategoryID == 32 && this._shopItemInfo.TemplateInfo.Property7 == "1")
         {
            if(!this.canBuyFert())
            {
               this.invalidateItemCell();
            }
         }
         else
         {
            this._payPaneBuyBtn.enable = true;
            this._payPaneBuyBtnHotArea.mouseEnabled = false;
            this.mouseEnabled = true;
            this.buttonMode = true;
            this.filters = null;
            this._canBuy = true;
         }
      }
      
      protected function __payPanelClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._canBuy)
         {
            return;
         }
         if(this._shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            ShopBuyManager.Instance.buyFarmShop(this._shopItemInfo.GoodsID,this._shopType);
         }
      }
      
      public function get shopType() : int
      {
         return this._shopType;
      }
      
      public function set shopType(param1:int) : void
      {
         if(this._shopType == param1)
         {
            return;
         }
         this._shopType = param1;
         this.updateBtnText();
      }
      
      private function updateBtnText() : void
      {
         if(this._shopType == ShopType.FARM_SEED_TYPE)
         {
            this._payPaneBuyBtn.backStyle = "asset.ddtshop.PayPaneBuyBtn";
            PositionUtils.setPos(this._payPaneBuyBtn,"asset.ddtshop.PayPaneBuyBtnPos");
         }
         else if(this._shopType == ShopType.FARM_PETEGG_TYPE)
         {
            this._payPaneBuyBtn.backStyle = "assets.farmShop.exchange";
            PositionUtils.setPos(this._payPaneBuyBtn,"asset.ddtshop.exchangePos");
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._payPaneBuyBtn)
         {
            ObjectUtils.disposeObject(this._payPaneBuyBtn);
         }
         this._payPaneBuyBtn = null;
         if(this._payPaneBuyBtnHotArea)
         {
            ObjectUtils.disposeObject(this._payPaneBuyBtnHotArea);
         }
         this._payPaneBuyBtnHotArea = null;
         if(this._itemBg)
         {
            ObjectUtils.disposeObject(this._itemBg);
         }
         this._itemBg = null;
         if(this._itemCell)
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
