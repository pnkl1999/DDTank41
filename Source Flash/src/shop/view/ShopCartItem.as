package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class ShopCartItem extends Sprite implements Disposeable
   {
      
      public static const DELETE_ITEM:String = "deleteitem";
      
      public static const CONDITION_CHANGE:String = "conditionchange";
       
      
      protected var _bg:Bitmap;
      
      protected var _cartItemGroup:SelectedButtonGroup;
      
      protected var _cartItemSelectVBox:VBox;
      
      protected var _closeBtn:BaseButton;
      
      protected var _itemName:FilterFrameText;
      
      protected var _cell:ShopPlayerCell;
      
      protected var _shopItemInfo:ShopCarItemInfo;
      
      protected var _blueTF:TextFormat;
      
      protected var _yellowTF:TextFormat;
      
      public function ShopCartItem()
      {
         super();
         this.drawBackground();
         this.drawNameField();
         this.drawCellField();
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemCloseBtn");
         this._cartItemSelectVBox = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemSelectVBox");
         this._cartItemGroup = new SelectedButtonGroup();
         this._blueTF = ComponentFactory.Instance.model.getSet("shop.ShopCartItemPriceBlueTF");
         this._yellowTF = ComponentFactory.Instance.model.getSet("shop.ShopCartItemPriceYellowTF");
         addChild(this._closeBtn);
         addChild(this._cartItemSelectVBox);
         this.initListener();
      }
      
      public function get closeBtn() : BaseButton
      {
         return this._closeBtn;
      }
      
      protected function drawBackground() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.shop.CartItemBg");
         addChild(this._bg);
      }
      
      protected function drawNameField() : void
      {
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemName");
         addChild(this._itemName);
      }
      
      protected function drawCellField() : void
      {
         this._cell = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
         PositionUtils.setPos(this._cell,"shop.CartItemCellPoint");
         addChild(this._cell);
      }
      
      protected function initListener() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__closeClick);
      }
      
      protected function removeEvent() : void
      {
         if(this._closeBtn)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__closeClick);
         }
      }
      
      protected function __closeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(DELETE_ITEM));
      }
      
      protected function __cartItemGroupChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._shopItemInfo.currentBuyType = this._cartItemGroup.selectIndex + 1;
         dispatchEvent(new Event(CONDITION_CHANGE));
      }
      
      public function set shopItemInfo(param1:ShopCarItemInfo) : void
      {
         if(this._shopItemInfo != param1)
         {
            this._cell.info = param1.TemplateInfo;
            this._shopItemInfo = param1;
            if(param1 == null)
            {
               this._itemName.text = "";
            }
            else
            {
               this._itemName.text = String(param1.TemplateInfo.Name);
               this.cartItemSelectVBoxInit();
            }
         }
      }
      
      protected function cartItemSelectVBoxInit() : void
      {
         var _loc2_:SelectedCheckButton = null;
         if(this._cartItemGroup)
         {
            this._cartItemGroup.removeEventListener(Event.CHANGE,this.__cartItemGroupChange);
            this._cartItemGroup = null;
         }
         this._cartItemGroup = new SelectedButtonGroup();
         this._cartItemGroup.addEventListener(Event.CHANGE,this.__cartItemGroupChange);
         this._cartItemSelectVBox.disposeAllChildren();
         var _loc1_:int = 1;
         while(_loc1_ < 4)
         {
            if(this._shopItemInfo.getItemPrice(_loc1_).IsValid)
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("shop.CartItemSelectBtn");
               _loc2_.text = this._shopItemInfo.getItemPrice(_loc1_).toString() + "/" + this._shopItemInfo.getTimeToString(_loc1_);
               this._cartItemSelectVBox.addChild(_loc2_);
               this._cartItemGroup.addSelectItem(_loc2_);
            }
            _loc1_++;
         }
         this._cartItemGroup.selectIndex = this._shopItemInfo.currentBuyType - 1 < 1 ? int(int(0)) : int(int(this._shopItemInfo.currentBuyType - 1));
         if(this._cartItemSelectVBox.numChildren == 2)
         {
            this._cartItemSelectVBox.y = 18;
         }
         else if(this._cartItemSelectVBox.numChildren == 1)
         {
            this._cartItemSelectVBox.y = 33;
         }
      }
      
      public function get shopItemInfo() : ShopCarItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function get TemplateID() : int
      {
         if(this._cell.info == null)
         {
            return -1;
         }
         return this._cell.info.TemplateID;
      }
      
      public function setColor(param1:*) : void
      {
         this._cell.setColor(param1);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._cartItemSelectVBox = null;
         this._cartItemGroup = null;
         this._bg = null;
         this._closeBtn = null;
         this._itemName = null;
         this._cell = null;
         this._shopItemInfo = null;
         this._blueTF = null;
         this._yellowTF = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
