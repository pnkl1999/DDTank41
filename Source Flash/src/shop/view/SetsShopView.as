package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SetsShopView extends ShopCheckOutView
   {
       
      
      private var _allCheckBox:SelectedCheckButton;
      
      private var _setsPrice:int = 999;
      
      private var _selectedAll:Boolean = true;
      
      private var _totalPrice:int;
      
      public function SetsShopView()
      {
         super();
      }
      
      public function initialize(param1:Array) : void
      {
         this.init();
         this.initEvent();
         setList(param1);
         _commodityPricesText3.text = "0";
         _commodityPricesText2.text = "0";
         _purchaseConfirmationBtn.visible = true;
      }
      
      override protected function init() : void
      {
         super.init();
         this._allCheckBox = ComponentFactory.Instance.creatComponentByStylename("SetsShopCheckBox");
         _frame.addToContent(this._allCheckBox);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._allCheckBox.addEventListener(Event.SELECT,this.__allSelected);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._allCheckBox.removeEventListener(Event.SELECT,this.__allSelected);
      }
      
      private function __allSelected(param1:Event) : void
      {
         var _loc2_:SetsShopItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         SoundManager.instance.play("008");
         if(this._allCheckBox.selected)
         {
            _loc3_ = 0;
            while(_loc3_ < _cartList.numChildren)
            {
               _loc2_ = _cartList.getChildAt(_loc3_) as SetsShopItem;
               if(_loc2_)
               {
                  _loc2_.selected = true;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _cartList.numChildren)
            {
               _loc2_ = _cartList.getChildAt(_loc4_) as SetsShopItem;
               if(_loc2_)
               {
                  _loc2_.selected = false;
               }
               _loc4_++;
            }
         }
         this.updateTxt();
      }
      
      override protected function addItemEvent(param1:ShopCartItem) : void
      {
         super.addItemEvent(param1);
         param1.addEventListener(Event.SELECT,this.__itemSelectedChanged);
      }
      
      private function __itemSelectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateTxt();
      }
      
      override protected function removeItemEvent(param1:ShopCartItem) : void
      {
         super.removeItemEvent(param1);
         param1.removeEventListener(Event.SELECT,this.__itemSelectedChanged);
      }
      
      override protected function drawFrame() : void
      {
         super.drawFrame();
         _frame.titleText = LanguageMgr.GetTranslation("shop.SetsTitle");
      }
      
      override protected function drawItemCountField() : void
      {
         _innerBg1 = ComponentFactory.Instance.creatBitmap("asset.shop.SetsListBack");
         _frame.addToContent(_innerBg1);
      }
      
      override protected function createShopItem() : ShopCartItem
      {
         return new SetsShopItem();
      }
      
      override protected function updateTxt() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:SetsShopItem = null;
         this._totalPrice = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _cartList.numChildren)
         {
            _loc4_ = _cartList.getChildAt(_loc3_) as SetsShopItem;
            if(_loc4_)
            {
               _loc2_++;
               if(_loc4_.selected)
               {
                  this._totalPrice += _loc4_.shopItemInfo.AValue1;
                  _loc1_++;
               }
            }
            _loc3_++;
         }
         if(_loc2_ > 0 && _loc1_ >= _loc2_)
         {
            _commodityPricesText1.text = this._setsPrice.toString();
            this._totalPrice = this._setsPrice;
         }
         else if(_loc2_ > 0)
         {
            _commodityPricesText1.text = this._totalPrice.toString();
         }
         if(_loc1_ > 0)
         {
            _purchaseConfirmationBtn.enable = true;
         }
         else
         {
            _purchaseConfirmationBtn.enable = false;
         }
      }
      
      override protected function __purchaseConfirmationBtnClick(param1:MouseEvent = null) : void
      {
         var _loc2_:SetsShopItem = null;
         var _loc5_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this._totalPrice)
         {
            _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc5_.moveEnable = false;
            _loc5_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _cartList.numChildren)
         {
            _loc2_ = _cartList.getChildAt(_loc4_) as SetsShopItem;
            if(_loc2_ && _loc2_.selected)
            {
               _loc3_.push(_loc2_.shopItemInfo.GoodsID);
            }
            _loc4_++;
         }
         SocketManager.Instance.out.sendUseCard(-1,-1,_loc3_,1);
         ObjectUtils.disposeObject(this);
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
   }
}
