package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuySingleGoodsView extends Sprite implements Disposeable
   {
       
      
      private var _frame:Frame;
      
      private var _shopCartItem:ShopCartItem;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText3:FilterFrameText;
      
      private var _purchaseConfirmationBtn:BaseButton;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _goodsID:int;
      
      private var _commodityPricesText2Label:FilterFrameText;
      
      public function BuySingleGoodsView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("core.shop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         var _loc1_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("core.shop.CheckOutViewBg");
         this._frame.addToContent(_loc1_);
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("core.shop.PurchaseConfirmation");
         this._frame.addToContent(this._purchaseConfirmationBtn);
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg");
         PositionUtils.setPos(_loc2_,"shop.CheckOutViewBgPos");
         this._frame.addToContent(_loc2_);
         var _loc3_:GradientText = ComponentFactory.Instance.creatComponentByStylename("vipName");
         PositionUtils.setPos(_loc3_,"shop.ShopBuyManagerTextImgPos");
         _loc3_.text = LanguageMgr.GetTranslation("shop.manager.ShopBuyManager.textImg");
         this._frame.addToContent(_loc3_);
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.shop.NumberSelecter");
         this._frame.addToContent(this._numberSelecter);
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         this._commodityPricesText1.text = "0";
         this._commodityPricesText2Label = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CommodityPricesText2Label");
         this._commodityPricesText2Label.text = LanguageMgr.GetTranslation("shop.CheckOutView.CommodityPricesText2Label");
         PositionUtils.setPos(this._commodityPricesText2Label,"ddtshop.commodityPricesText2LabelPos");
         this._frame.addToContent(this._commodityPricesText2Label);
         PositionUtils.setPos(this._commodityPricesText1,"shop.commodityPricesText1Pos");
         this._frame.addToContent(this._commodityPricesText1);
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         this._commodityPricesText2.text = "0";
         PositionUtils.setPos(this._commodityPricesText2,"shop.commodityPricesText2Pos");
         this._frame.addToContent(this._commodityPricesText2);
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("core.shop.CommodityPricesText");
         this._commodityPricesText3.text = "0";
         PositionUtils.setPos(this._commodityPricesText3,"shop.commodityPricesText3Pos");
         this._frame.addToContent(this._commodityPricesText3);
         addChild(this._frame);
      }
      
      public function set goodsID(param1:int) : void
      {
         if(this._shopCartItem)
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
            this._shopCartItem.dispose();
         }
         this._goodsID = param1;
         var _loc2_:ShopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._goodsID);
         if(!_loc2_)
         {
            _loc2_ = ShopManager.Instance.getGoodsByTemplateID(this._goodsID);
         }
         var _loc3_:ShopCarItemInfo = new ShopCarItemInfo(_loc2_.GoodsID,_loc2_.TemplateID);
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         this._shopCartItem = new ShopCartItem();
         PositionUtils.setPos(this._shopCartItem,"shop.shopCartItemPos");
         this._shopCartItem.closeBtn.visible = false;
         this._shopCartItem.shopItemInfo = _loc3_;
         this._shopCartItem.setColor(_loc3_.Color);
         this._frame.addToContent(this._shopCartItem);
         this._shopCartItem.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         this.updateCommodityPrices();
      }
      
      private function addEvent() : void
      {
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._numberSelecter.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function removeEvent() : void
      {
         if(this._purchaseConfirmationBtn)
         {
            this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         }
         if(this._numberSelecter)
         {
            this._numberSelecter.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         }
         if(this._shopCartItem)
         {
            this._shopCartItem.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__shopCartItemChange);
         }
         if(this._frame)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
      }
      
      private function updateCommodityPrices() : void
      {
         if(this._shopCartItem.shopItemInfo.getCurrentPrice().PriceType == Price.HARD_CURRENCY)
         {
            this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().hardCurrencyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2Label.text = Price.HARD_CURRENCY_TO_STRING;
         }
         else
         {
            this._commodityPricesText1.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText2.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().giftValue * this._numberSelecter.currentValue).toString();
            this._commodityPricesText3.text = (this._shopCartItem.shopItemInfo.getCurrentPrice().medalValue * this._numberSelecter.currentValue).toString();
         }
      }
      
      protected function __purchaseConfirmationBtnClick(param1:MouseEvent) : void
      {
         var _loc9_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = this._shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         if(PlayerManager.Instance.Self.Money < _loc2_ && _loc2_ != 0)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._purchaseConfirmationBtn.enable = false;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:int = 0;
         while(_loc8_ < this._numberSelecter.currentValue)
         {
            _loc9_ = this._shopCartItem.shopItemInfo;
            _loc3_.push(_loc9_.GoodsID);
            _loc4_.push(_loc9_.currentBuyType);
            _loc5_.push("");
            _loc6_.push("");
            _loc7_.push("");
            _loc8_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc7_,_loc6_);
      }
      
      protected function onBuyedGoods(param1:CrazyTankSocketEvent) : void
      {
         this._purchaseConfirmationBtn.enable = true;
         param1.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ != 0)
         {
            this.dispose();
         }
      }
      
      protected function __numberSelecterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateCommodityPrices();
      }
      
      protected function __shopCartItemChange(param1:Event) : void
      {
         this.updateCommodityPrices();
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         ObjectUtils.disposeObject(this._shopCartItem);
         this._shopCartItem = null;
         ObjectUtils.disposeObject(this._commodityPricesText1);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText2);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText3);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
         this._purchaseConfirmationBtn = null;
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         if(this._commodityPricesText2Label)
         {
            ObjectUtils.disposeObject(this._commodityPricesText2Label);
         }
         this._commodityPricesText2Label = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
