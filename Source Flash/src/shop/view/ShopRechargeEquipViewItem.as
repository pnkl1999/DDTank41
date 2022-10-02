package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class ShopRechargeEquipViewItem extends ShopCartItem implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
       
      
      private var _moneyRadioBtn:SelectedCheckButton;
      
      private var _giftRadioBtn:SelectedCheckButton;
      
      private var _isDelete:Boolean = false;
      
      private var _radioGroup:SelectedButtonGroup;
      
      private var _shopItems:Array;
      
      public function ShopRechargeEquipViewItem()
      {
         super();
         this.init();
         this.initEventListener();
      }
      
      private function init() : void
      {
         this._radioGroup = new SelectedButtonGroup();
         this._moneyRadioBtn = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewItemMoneyRadioBtn");
         this._giftRadioBtn = ComponentFactory.Instance.creatComponentByStylename("shop.RechargeViewItemGiftRadioBtn");
         PositionUtils.setPos(_itemName,"shop.RechargeViewItemNamePos");
         this._radioGroup.addSelectItem(this._moneyRadioBtn);
         this._radioGroup.addSelectItem(this._giftRadioBtn);
         this._radioGroup.selectIndex = 0;
         addChild(this._moneyRadioBtn);
         addChild(this._giftRadioBtn);
      }
      
      private function initEventListener() : void
      {
         this._moneyRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._giftRadioBtn.addEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         _cell.info = param1;
         this._shopItems = ShopManager.Instance.getShopRechargeItemByTemplateId(param1.TemplateID);
         _shopItemInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._shopItems.length)
         {
            if(this._shopItems[_loc2_].getItemPrice(1).IsMoneyType)
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_loc2_]);
               break;
            }
            _loc2_++;
         }
         if(_shopItemInfo == null)
         {
            _shopItemInfo = this.fillToShopCarInfo(this._shopItems[0]);
         }
         this.resetRadioBtn();
         cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         _itemName.text = param1.Name;
      }
      
      private function __selectRadioBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.currentTarget == this._moneyRadioBtn)
         {
            this.updateCurrentShopItem(Price.MONEY);
         }
         else if(param1.currentTarget == this._giftRadioBtn)
         {
            this.updateCurrentShopItem(Price.GIFT);
         }
         cartItemSelectVBoxInit();
         _cartItemGroup.selectIndex = _cartItemSelectVBox.numChildren - 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function get currentShopItem() : ShopCarItemInfo
      {
         return _shopItemInfo;
      }
      
      public function get isDelete() : Boolean
      {
         return this._isDelete;
      }
      
      private function updateCurrentShopItem(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._shopItems.length)
         {
            if(this._shopItems[_loc2_].getItemPrice(1).PriceType == param1)
            {
               _shopItemInfo = this.fillToShopCarInfo(this._shopItems[_loc2_]);
               break;
            }
            _loc2_++;
         }
      }
      
      private function resetRadioBtn() : void
      {
         this._moneyRadioBtn.enable = this._moneyRadioBtn.selected = false;
         this._giftRadioBtn.enable = this._giftRadioBtn.selected = false;
         var _loc1_:int = 0;
         while(_loc1_ < this._shopItems.length)
         {
            if(this._shopItems[_loc1_].getItemPrice(1).IsMixed || this._shopItems[_loc1_].getItemPrice(2).IsMixed)
            {
               throw new Error("续费价格填错了！！！");
            }
            if(this._shopItems[_loc1_].getItemPrice(1).IsMoneyType)
            {
               this._moneyRadioBtn.enable = true;
            }
            else if(this._shopItems[_loc1_].getItemPrice(1).IsGiftType)
            {
               this._giftRadioBtn.enable = true;
            }
            _loc1_++;
         }
         if(_shopItemInfo.getItemPrice(1).IsMoneyType)
         {
            this._moneyRadioBtn.selected = true;
         }
         else if(_shopItemInfo.getItemPrice(1).IsGiftType)
         {
            this._giftRadioBtn.selected = true;
         }
      }
      
      override protected function __closeClick(param1:MouseEvent) : void
      {
         var evt:MouseEvent = null;
         evt = param1;
         SoundManager.instance.play("008");
         filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         this._isDelete = true;
         mouseChildren = false;
         evt.stopPropagation();
         addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            SoundManager.instance.play("008");
            mouseChildren = true;
            _isDelete = false;
            filters = null;
            dispatchEvent(new Event(CONDITION_CHANGE));
            removeEventListener(MouseEvent.CLICK,arguments.callee);
         });
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      private function fillToShopCarInfo(param1:ShopItemInfo) : ShopCarItemInfo
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:ShopCarItemInfo = new ShopCarItemInfo(param1.GoodsID,param1.TemplateID,_cell.info.CategoryID);
         ObjectUtils.copyProperties(_loc2_,param1);
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._moneyRadioBtn.removeEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         this._giftRadioBtn.removeEventListener(MouseEvent.CLICK,this.__selectRadioBtn);
         ObjectUtils.disposeAllChildren(this);
         this._moneyRadioBtn = null;
         this._giftRadioBtn = null;
         this._shopItems = null;
      }
   }
}
