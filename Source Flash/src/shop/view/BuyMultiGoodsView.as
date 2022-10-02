package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.manager.ShopBuyManager;
   
   public class BuyMultiGoodsView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _commodityNumberText:FilterFrameText;
      
      private var _commodityPricesText1:FilterFrameText;
      
      private var _commodityPricesText2:FilterFrameText;
      
      private var _commodityPricesText3:FilterFrameText;
      
      private var _purchaseConfirmationBtn:BaseButton;
      
      private var _buyArray:Vector.<ShopCarItemInfo>;
      
      private var _cartList:VBox;
      
      private var _cartScroll:ScrollPanel;
      
      private var _frame:Frame;
      
      private var _innerBg1:Bitmap;
      
      private var _innerBg:Bitmap;
      
      private var _extraTextButton:BaseButton;
      
      public var dressing:Boolean = false;
      
      public function BuyMultiGoodsView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
         addChild(this._frame);
         this._cartList = new VBox();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewBg");
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PurchaseConfirmation");
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewItemList");
         this._extraTextButton = ComponentFactory.Instance.creatComponentByStylename("shop.PurchaseConfirmation");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this._frame.addToContent(this._bg);
         this._innerBg1 = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg1");
         this._frame.addToContent(this._innerBg1);
         this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityNumberText");
         this._frame.addToContent(this._commodityNumberText);
         this._innerBg = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg");
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText1");
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText2");
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText3");
         this._frame.addToContent(this._innerBg);
         this._frame.addToContent(this._commodityPricesText1);
         this._frame.addToContent(this._commodityPricesText2);
         this._frame.addToContent(this._commodityPricesText3);
         this._frame.addToContent(this._cartScroll);
         this._frame.addToContent(this._purchaseConfirmationBtn);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND,true);
      }
      
      protected function updateTxt() : void
      {
         var _loc1_:Array = ShopBuyManager.calcPrices(this._buyArray);
         this._commodityNumberText.text = String(this._buyArray.length);
         this._commodityPricesText1.text = String(_loc1_[1]);
         this._commodityPricesText2.text = String(_loc1_[2]);
         this._commodityPricesText3.text = String(_loc1_[3]);
      }
      
      private function initEvents() : void
      {
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__buyAvatar);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function removeEvents() : void
      {
         this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__buyAvatar);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.playButtonSound();
               this.dispose();
         }
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      private function __buyAvatar(param1:MouseEvent) : void
      {
         var _loc3_:ShopCarItemInfo = null;
         var _loc4_:Array = null;
         var _loc14_:ShopCartItem = null;
         var _loc15_:ShopCarItemInfo = null;
         var _loc16_:ShopCarItemInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Array = [];
         for each(_loc3_ in this._buyArray)
         {
            _loc2_.push(_loc3_);
         }
         _loc4_ = ShopManager.Instance.buyIt(_loc2_);
         if(_loc4_.length == 0)
         {
            for each(_loc15_ in this._buyArray)
            {
               if(_loc15_.getCurrentPrice().moneyValue > 0)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
            }
         }
         else if(_loc4_.length < this._buyArray.length)
         {
         }
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         var _loc10_:Array = [];
         var _loc11_:int = 0;
         while(_loc11_ < this._buyArray.length)
         {
            _loc16_ = this._buyArray[_loc11_];
            _loc5_.push(_loc16_.GoodsID);
            _loc6_.push(_loc16_.currentBuyType);
            _loc7_.push(_loc16_.Color);
            _loc9_.push(_loc16_.place);
            if(_loc16_.CategoryID == EquipType.FACE)
            {
               _loc10_.push(_loc16_.skin);
            }
            else
            {
               _loc10_.push("");
            }
            _loc8_.push(this.dressing);
            _loc11_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc5_,_loc6_,_loc7_,_loc9_,_loc8_,_loc10_);
         var _loc12_:Array = [];
         var _loc13_:int = 0;
         while(_loc13_ < this._cartList.numChildren)
         {
            _loc12_.push(this._cartList.getChildAt(_loc13_));
            _loc13_++;
         }
         for each(_loc14_ in _loc12_)
         {
            if(_loc4_.indexOf(_loc14_.shopItemInfo) > -1)
            {
               _loc14_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
               _loc14_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
               this._cartList.removeChild(_loc14_);
               _loc14_.dispose();
               this._buyArray.splice(this._buyArray.indexOf(_loc14_.shopItemInfo),1);
            }
         }
         if(this._cartList.numChildren == 0)
         {
            this.dispose();
         }
         else
         {
            this.updateTxt();
         }
      }
      
      public function setGoods(param1:Vector.<ShopCarItemInfo>) : void
      {
         var _loc2_:ShopCarItemInfo = null;
         var _loc3_:ShopCartItem = null;
         var _loc4_:ShopCartItem = null;
         while(this._cartList.numChildren > 0)
         {
            _loc3_ = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
            _loc3_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            _loc3_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
            this._cartList.removeChild(_loc3_);
            _loc3_.dispose();
         }
         this._buyArray = param1;
         for each(_loc2_ in this._buyArray)
         {
            _loc4_ = new ShopCartItem();
            _loc4_.shopItemInfo = _loc2_;
            _loc4_.setColor(_loc2_.Color);
            this._cartList.addChild(_loc4_);
            _loc4_.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            _loc4_.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         }
         this._cartScroll.invalidateViewport();
         this.updateTxt();
      }
      
      private function __conditionChange(param1:Event) : void
      {
         this.updateTxt();
      }
      
      private function __deleteItem(param1:Event) : void
      {
         var _loc2_:ShopCartItem = param1.currentTarget as ShopCartItem;
         var _loc3_:ShopCarItemInfo = _loc2_.shopItemInfo;
         _loc2_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         _loc2_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         this._cartList.removeChild(_loc2_);
         var _loc4_:int = this._buyArray.indexOf(_loc3_);
         this._buyArray.splice(_loc4_,1);
         this.updateTxt();
         this._cartScroll.invalidateViewport();
         if(this._buyArray.length < 1)
         {
            this.dispose();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:ShopCartItem = null;
         this.removeEvents();
         while(this._cartList.numChildren > 0)
         {
            _loc1_ = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
            _loc1_.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            _loc1_.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
            this._cartList.removeChild(_loc1_);
            _loc1_.dispose();
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._commodityNumberText);
         this._commodityNumberText = null;
         ObjectUtils.disposeObject(this._commodityPricesText1);
         this._commodityPricesText1 = null;
         ObjectUtils.disposeObject(this._commodityPricesText2);
         this._commodityPricesText2 = null;
         ObjectUtils.disposeObject(this._commodityPricesText3);
         this._commodityPricesText3 = null;
         ObjectUtils.disposeObject(this._purchaseConfirmationBtn);
         this._purchaseConfirmationBtn = null;
         this._buyArray = null;
         ObjectUtils.disposeObject(this._cartList);
         this._cartList = null;
         ObjectUtils.disposeObject(this._cartScroll);
         this._cartScroll = null;
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         ObjectUtils.disposeObject(this._bg);
         this._innerBg1 = null;
         ObjectUtils.disposeObject(this._innerBg1);
         this._innerBg = null;
         ObjectUtils.disposeObject(this._extraTextButton);
         this._extraTextButton = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
