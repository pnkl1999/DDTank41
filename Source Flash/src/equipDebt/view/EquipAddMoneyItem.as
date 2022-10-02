package equipDebt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class EquipAddMoneyItem extends Sprite implements Disposeable
   {
       
      
      public const CLOSE:String = "close";
      
      public const CHANG:String = "chang";
      
      protected var _bg:Bitmap;
      
      private var _cell:EquipCell;
      
      private var _nameText:TextField;
      
      private var _cartItemSelectVBox:VBox;
      
      private var _cartItemGroup:SelectedButtonGroup;
      
      private var _closeBtn:BaseButton;
      
      private var _goods:InventoryItemInfo;
      
      private var _pointBtn0:MutipleImage;
      
      private var _pointBtn1:MutipleImage;
      
      public function EquipAddMoneyItem()
      {
         super();
         this.setViewOne();
         this.addEvent();
      }
      
      private function setViewOne() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.shop.CartItemBg");
         this._cell = ComponentFactory.Instance.creatCustomObject("equipDebt.view.EquipCell");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("equipDebt.view._nameText");
         this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemSelectVBox");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemCloseBtn");
         this._pointBtn0 = ComponentFactory.Instance.creatComponentByStylename("equipDebt.ItemInfoBtn0");
         this._pointBtn1 = ComponentFactory.Instance.creatComponentByStylename("equipDebt.ItemInfoBtn1");
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._nameText);
         addChild(this._cartItemSelectVBox);
         addChild(this._closeBtn);
         addChild(this._pointBtn0);
         addChild(this._pointBtn1);
         this._cartItemGroup = new SelectedButtonGroup();
      }
      
      private function addEvent() : void
      {
         this._pointBtn0.addEventListener(MouseEvent.CLICK,this.clickPointBtn0);
         this._pointBtn1.addEventListener(MouseEvent.CLICK,this.clickPointBtn1);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.clickCloseBtn);
      }
      
      private function removeEvent() : void
      {
         this._pointBtn0.removeEventListener(MouseEvent.CLICK,this.clickPointBtn0);
         this._pointBtn1.removeEventListener(MouseEvent.CLICK,this.clickPointBtn1);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.clickCloseBtn);
      }
      
      private function clickCloseBtn(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(this.CLOSE));
      }
      
      private function clickItemGroup(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(this.CHANG));
      }
      
      private function clickPointBtn0(param1:MouseEvent) : void
      {
         this._pointBtn0.setFrame(2);
         this._pointBtn1.setFrame(1);
         this.updataItem(0);
      }
      
      private function clickPointBtn1(param1:MouseEvent) : void
      {
         this._pointBtn0.setFrame(1);
         this._pointBtn1.setFrame(2);
         this.updataItem(1);
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         var _loc2_:Array = null;
         _loc2_ = null;
         var _loc4_:SelectedCheckButton = null;
         this._goods = param1;
         this._cell.info = param1;
         this._nameText.text = param1.Name;
         _loc2_ = ShopManager.Instance.getShopRechargeItemByTemplateId(param1.TemplateID);
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemSelectBtn");
            _loc4_.text = ShopItemInfo(_loc2_[0]).getItemPrice(_loc3_ + 1).moneyValue.toString() + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.stipple") + ShopItemInfo(_loc2_[0]).getTimeToString(_loc3_ + 1);
            this._cartItemSelectVBox.addChild(_loc4_);
            this._cartItemGroup.addSelectItem(_loc4_);
            _loc3_++;
         }
         this._pointBtn0.visible = false;
         this._pointBtn1.visible = false;
         if(_loc2_[0] != null)
         {
            this._pointBtn0.visible = true;
         }
         if(_loc2_[1] != null)
         {
            this._pointBtn1.visible = true;
         }
         this.clickPointBtn0(new MouseEvent("*"));
         this._cartItemGroup.selectIndex = 0;
         this._cartItemSelectVBox.addEventListener(MouseEvent.CLICK,this.clickItemGroup);
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._goods;
      }
      
      public function getshopInfo(param1:int) : ShopItemInfo
      {
         var _loc2_:Array = null;
         _loc2_ = ShopManager.Instance.getShopRechargeItemByTemplateId(this._cell.info.TemplateID);
         return _loc2_[param1];
      }
      
      public function get shopID() : int
      {
         return this._cartItemGroup.selectIndex + 1;
      }
      
      private function updataItem(param1:int = 0) : void
      {
         var _loc2_:Array = null;
         _loc2_ = ShopManager.Instance.getShopRechargeItemByTemplateId(this._goods.TemplateID);
         var _loc3_:int = 0;
         while(_loc3_ < this._cartItemSelectVBox.numChildren)
         {
            SelectedCheckButton(this._cartItemSelectVBox.getChildAt(_loc3_)).text = ShopItemInfo(_loc2_[param1]).getItemPrice(_loc3_ + 1).moneyValue.toString() + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.stipple") + ShopItemInfo(_loc2_[param1]).getTimeToString(_loc3_ + 1);
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         if(this._cartItemSelectVBox)
         {
            this._cartItemSelectVBox.dispose();
         }
         if(this._bg)
         {
            removeChild(this._bg);
         }
         if(this._cell)
         {
            this._cell.dispose();
         }
         if(this._nameText)
         {
            removeChild(this._nameText);
         }
         this._cartItemSelectVBox = null;
         this._bg = null;
         this._cell = null;
         this._nameText = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
