package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.ShopController;
   import shop.ShopModel;
   
   public class ShopCheckOutView extends Sprite implements Disposeable
   {
      
      public static const COUNT:uint = 3;
      
      public static const GIFT:uint = 1;
      
      public static const LACK:uint = 1;
      
      public static const MEDAL:uint = 2;
      
      public static const MONEY:uint = 0;
      
      public static const PLAYER:uint = 0;
      
      public static const PRESENT:int = 2;
      
      public static const PURCHASE:int = 1;
      
      public static const SAVE:int = 3;
       
      
      private var _bg:Scale9CornerImage;
      
      protected var _commodityNumberText:FilterFrameText;
      
      protected var _commodityPricesText1:FilterFrameText;
      
      protected var _commodityPricesText2:FilterFrameText;
      
      protected var _commodityPricesText3:FilterFrameText;
      
      protected var _purchaseConfirmationBtn:BaseButton;
      
      protected var _giftsBtn:BaseButton;
      
      protected var _saveImageBtn:BaseButton;
      
      private var _buyArray:Array;
      
      protected var _cartList:VBox;
      
      private var _cartScroll:ScrollPanel;
      
      private var _controller:ShopController;
      
      protected var _frame:Frame;
      
      private var _giveArray:Array;
      
      protected var _innerBg1:Bitmap;
      
      private var _innerBg:Bitmap;
      
      private var _model:ShopModel;
      
      private var _tempList:Array;
      
      private var _type:int;
      
      private var _extraTextButton:BaseButton;
      
      private var _isDisposed:Boolean;
      
      private var shopPresent:ShopPresentView;
      
      protected var _list:Array;
      
      private var _shopPresentClearingFrame:ShopPresentClearingFrame;
      
      public function ShopCheckOutView()
      {
         this._buyArray = new Array();
         this._giveArray = new Array();
         super();
      }
      
      protected function drawFrame() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("shop.Shop.car");
         addChild(this._frame);
      }
      
      protected function drawItemCountField() : void
      {
         this._innerBg1 = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg1");
         this._frame.addToContent(this._innerBg1);
         this._commodityNumberText = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityNumberText");
         this._frame.addToContent(this._commodityNumberText);
      }
      
      protected function drawPayListField() : void
      {
         this._innerBg = ComponentFactory.Instance.creatBitmap("asset.shop.CheckOutViewBg");
         this._commodityPricesText1 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText1");
         this._commodityPricesText2 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText2");
         this._commodityPricesText3 = ComponentFactory.Instance.creatComponentByStylename("shop.CommodityPricesText3");
         this._frame.addToContent(this._innerBg);
         this._frame.addToContent(this._commodityPricesText1);
         this._frame.addToContent(this._commodityPricesText2);
         this._frame.addToContent(this._commodityPricesText3);
      }
      
      protected function init() : void
      {
         this._cartList = new VBox();
         this.drawFrame();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewBg");
         this._purchaseConfirmationBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PurchaseConfirmation");
         this._purchaseConfirmationBtn.visible = false;
         this._giftsBtn = ComponentFactory.Instance.creatComponentByStylename("shop.GiftsBtn");
         this._giftsBtn.visible = false;
         this._saveImageBtn = ComponentFactory.Instance.creatComponentByStylename("shop.SaveImageBtn");
         this._saveImageBtn.visible = false;
         this._cartScroll = ComponentFactory.Instance.creatComponentByStylename("shop.CheckOutViewItemList");
         this._extraTextButton = ComponentFactory.Instance.creatComponentByStylename("shop.PurchaseConfirmation");
         this._cartScroll.setView(this._cartList);
         this._cartScroll.vScrollProxy = ScrollPanel.ON;
         this._cartList.spacing = 5;
         this._cartList.strictSize = 80;
         this._cartList.isReverAdd = true;
         this._frame.addToContent(this._bg);
         this.drawItemCountField();
         this.drawPayListField();
         this._frame.addToContent(this._cartScroll);
         this._frame.addToContent(this._purchaseConfirmationBtn);
         this._frame.addToContent(this._giftsBtn);
         this._frame.addToContent(this._saveImageBtn);
         this.setList(this._tempList);
         this.updateTxt();
         if(this._type == SAVE)
         {
            this._saveImageBtn.visible = true;
         }
         else if(this._type == PURCHASE)
         {
            this._purchaseConfirmationBtn.visible = true;
         }
         else if(this._type == PRESENT)
         {
            this._giftsBtn.visible = true;
         }
      }
      
      protected function initEvent() : void
      {
         this._extraTextButton.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
         this._purchaseConfirmationBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._saveImageBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._giftsBtn.addEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
      }
      
      protected function __purchaseConfirmationBtnClick(param1:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._type == SAVE)
         {
            if(this._model.canBuyLeastOneGood(this._model.currentTempList))
            {
               this.saveFigureCheckOut();
               this._model.clearCurrentTempList(!!this._model.fittingSex ? int(int(1)) : int(int(2)));
            }
            else if(this._model.currentTempList.some(this.isMoneyGoods))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
            }
         }
         else
         {
            if(this._type == PURCHASE)
            {
               if(this._model.canBuyLeastOneGood(this._model.allItems))
               {
                  this.shopCarCheckOut();
               }
               else if(this._model.allItems.some(this.isMoneyGoods))
               {
                  LeavePageManager.showFillFrame();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.lackCoin"));
               }
               return;
            }
            if(this._type == PRESENT)
            {
               this.presentCheckOut();
            }
         }
      }
      
      protected function addItemEvent(param1:ShopCartItem) : void
      {
         param1.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         param1.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
      }
      
      protected function removeItemEvent(param1:ShopCartItem) : void
      {
         param1.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         param1.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
      }
      
      public function setList(param1:Array) : void
      {
         var _loc2_:ShopCarItemInfo = null;
         var _loc3_:ShopCartItem = null;
         var _loc4_:ShopCartItem = null;
         while(this._cartList.numChildren > 0)
         {
            _loc3_ = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
            this.removeItemEvent(_loc3_);
            this._cartList.removeChild(_loc3_);
            _loc3_.dispose();
            _loc3_ = null;
         }
         this._list = param1;
         for each(_loc2_ in param1)
         {
            _loc4_ = this.createShopItem();
            _loc4_.shopItemInfo = _loc2_;
            _loc4_.setColor(_loc2_.Color);
            this._cartList.addChild(_loc4_);
            this.addItemEvent(_loc4_);
         }
         this._cartScroll.invalidateViewport();
         this.updateTxt();
      }
      
      protected function createShopItem() : ShopCartItem
      {
         return new ShopCartItem();
      }
      
      public function setup(param1:ShopController, param2:ShopModel, param3:Array, param4:int) : void
      {
         this._controller = param1;
         this._model = param2;
         this._tempList = param3;
         this._type = param4;
         this._isDisposed = false;
         this.visible = true;
         this.init();
         this.initEvent();
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
         if(this._type == SAVE)
         {
            this._controller.removeTempEquip(_loc3_);
            this.updateTxt();
            this._cartScroll.invalidateViewport();
            if(this._model.currentTempList.length == 0)
            {
               this.dispose();
            }
         }
         if(this._type == PURCHASE)
         {
            this._controller.removeFromCar(_loc3_);
            this.updateTxt();
            this._cartScroll.invalidateViewport();
            if(this._model.allItems.length == 0)
            {
               this.dispose();
            }
         }
         if(this._type == PRESENT)
         {
            this._controller.removeFromCar(_loc3_);
            this._tempList.splice(this._tempList.indexOf(_loc3_),1);
            this.updateTxt();
            this._cartScroll.invalidateViewport();
            if(this._tempList.length == 0)
            {
               this.dispose();
            }
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function get extraButton() : BaseButton
      {
         return this._extraTextButton;
      }
      
      protected function removeEvent() : void
      {
         this._extraTextButton.removeEventListener(MouseEvent.CLICK,this.__dispatchFrameEvent);
         this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GOODS_PRESENT,this.onPresent);
         this._purchaseConfirmationBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._saveImageBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
         this._giftsBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseConfirmationBtnClick);
      }
      
      private function __dispatchFrameEvent(param1:MouseEvent) : void
      {
         this._frame.dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
      }
      
      private function isMoneyGoods(param1:*, param2:int, param3:Array) : Boolean
      {
         if(param1 is ShopItemInfo)
         {
            return ShopItemInfo(param1).getItemPrice(1).IsMoneyType;
         }
         return false;
      }
      
      private function notPresentGoods() : Array
      {
         var _loc2_:ShopCarItemInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._tempList)
         {
            if(this._giveArray.indexOf(_loc2_) == -1)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function onBuyedGoods(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:ShopCarItemInfo = null;
         var _loc5_:int = 0;
         param1.pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = false;
         if(_loc2_ != 0)
         {
            if(this._type == SAVE)
            {
               this._model.clearCurrentTempList(!!this._model.fittingSex ? int(int(1)) : int(int(2)));
            }
            else if(this._type == PURCHASE)
            {
               this._model.clearAllitems();
            }
         }
         else if(this._type == SAVE)
         {
            this._model.clearCurrentTempList(!!this._model.fittingSex ? int(int(1)) : int(int(2)));
            for each(_loc4_ in this._model.currentLeftList)
            {
               this._model.addTempEquip(_loc4_);
            }
            this.setList(this._model.currentTempList);
            if(this._model.currentTempList.length < 1)
            {
               _loc3_ = true;
            }
         }
         else if(this._type == PURCHASE)
         {
            _loc5_ = 0;
            while(_loc5_ < this._buyArray.length)
            {
               this._model.removeFromShoppingCar(this._buyArray[_loc5_] as ShopCarItemInfo);
               _loc5_++;
            }
            this.setList(this._model.allItems);
            if(this._model.allItems.length < 1)
            {
               _loc3_ = true;
            }
         }
         if(_loc2_ != 0)
         {
            this.dispose();
         }
         else if(_loc3_)
         {
            this.dispose();
         }
      }
      
      private function onPresent(param1:CrazyTankSocketEvent) : void
      {
         this._shopPresentClearingFrame.presentBtn.enable = true;
         this._shopPresentClearingFrame.dispose();
         this._shopPresentClearingFrame = null;
         this.visible = true;
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = 0;
         while(_loc3_ < this._giveArray.length)
         {
            this._model.removeFromShoppingCar(this._giveArray[_loc3_] as ShopCarItemInfo);
            this._tempList.splice(this._tempList.indexOf(this._giveArray[_loc3_] as ShopCarItemInfo),1);
            _loc3_++;
         }
         if(this._tempList.length == 0)
         {
            this.dispose();
            return;
         }
         if(this._tempList.length > 0)
         {
            this.setList(this.notPresentGoods());
            return;
         }
      }
      
      private function presentCheckOut() : void
      {
         this._giveArray = ShopManager.Instance.giveGift(this._model.allItems,this._model.Self);
         this._model.pickOutLeftItems(this._giveArray);
         if(this._giveArray.length > 0)
         {
            this._shopPresentClearingFrame = ComponentFactory.Instance.creatComponentByStylename("core.shop.ShopPresentClearingFrame");
            this._shopPresentClearingFrame.show();
            this._shopPresentClearingFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            this._shopPresentClearingFrame.addEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            this.visible = false;
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      private function __shopPresentClearingFrameResponseHandler(param1:FrameEvent) : void
      {
         this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            StageReferance.stage.focus = this._frame;
            this.visible = true;
         }
      }
      
      protected function __presentBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._shopPresentClearingFrame.nameInput.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._shopPresentClearingFrame.nameInput.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         this._shopPresentClearingFrame.presentBtn.enable = false;
         this._controller.presentItems(this._tempList,this._shopPresentClearingFrame.textArea.text,this._shopPresentClearingFrame.nameInput.text);
      }
      
      private function saveFigureCheckOut() : void
      {
         this._buyArray = ShopManager.Instance.buyIt(this._model.currentTempList);
         this._model.pickOutLeftItems(this._buyArray);
         this._controller.buyItems(this._model.currentTempList,true,this._model.currentModel.Skin);
      }
      
      private function shopCarCheckOut() : void
      {
         this._buyArray = ShopManager.Instance.buyIt(this._model.allItems);
         this._model.pickOutLeftItems(this._buyArray);
         this._controller.buyItems(this._model.allItems,false);
      }
      
      protected function updateTxt() : void
      {
         var _loc1_:Array = this._type == SAVE ? this._model.currentTempList : this._model.allItems;
         if(this._type == PRESENT)
         {
            _loc1_ = this._tempList;
         }
         var _loc2_:Array = this._model.calcPrices(_loc1_);
         this._commodityNumberText.text = String(_loc1_.length);
         this._commodityPricesText1.text = String(_loc2_[MONEY + 1]);
         this._commodityPricesText2.text = String(_loc2_[GIFT + 1]);
         this._commodityPricesText3.text = String(_loc2_[MEDAL + 1]);
      }
      
      public function dispose() : void
      {
         var _loc1_:ShopCartItem = null;
         if(this._shopPresentClearingFrame)
         {
            if(this._shopPresentClearingFrame.presentBtn)
            {
               this._shopPresentClearingFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
            }
            this._shopPresentClearingFrame.removeEventListener(FrameEvent.RESPONSE,this.__shopPresentClearingFrameResponseHandler);
            this._shopPresentClearingFrame.dispose();
            this._shopPresentClearingFrame = null;
         }
         if(!this._isDisposed)
         {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            while(this._cartList.numChildren > 0)
            {
               _loc1_ = this._cartList.getChildAt(this._cartList.numChildren - 1) as ShopCartItem;
               this.removeItemEvent(_loc1_);
               this._cartList.removeChild(_loc1_);
               _loc1_.dispose();
               _loc1_ = null;
            }
            this._extraTextButton.dispose();
            this._extraTextButton = null;
            this._bg = null;
            this._buyArray = null;
            this._cartList = null;
            this._cartScroll = null;
            this._controller = null;
            this._giveArray = null;
            this._innerBg = null;
            this._frame = null;
            this.shopPresent = null;
            this._commodityNumberText = null;
            this._commodityPricesText1 = null;
            this._commodityPricesText2 = null;
            this._commodityPricesText3 = null;
            this._purchaseConfirmationBtn = null;
            this._giftsBtn = null;
            this._saveImageBtn = null;
            this._innerBg1 = null;
            this._innerBg = null;
            this._model = null;
            if(parent)
            {
               parent.removeChild(this);
            }
            this._isDisposed = true;
         }
      }
   }
}
