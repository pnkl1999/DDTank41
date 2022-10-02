package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import com.greensock.TimelineMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ShopRankingCellItem extends Sprite implements ISelectable, Disposeable
   {
      
      public static const PAYTYPE_FREE:uint = 1;
      
      public static const PAYTYPE_GIFT:uint = 3;
      
      public static const PAYTYPE_MEDAL:uint = 4;
      
      public static const PAYTYPE_MONEY:uint = 2;
      
      private static const LIMIT_LABEL:uint = 6;
       
      
      private var _payPaneGivingBtn:BaseButton;
      
      private var _payPaneBuyBtn:BaseButton;
      
      private var _itemCellBtn:Sprite;
      
      private var _itemBg:ScaleFrameImage;
      
      private var _itemCell:ShopItemCell;
      
      private var _itemCountTxt:FilterFrameText;
      
      private var _itemNameTxt:FilterFrameText;
      
      private var _itemPriceTxt:FilterFrameText;
      
      private var _payType:ScaleFrameImage;
      
      private var _selected:Boolean;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _shopItemCellBg:Bitmap;
      
      private var _shopItemCellTypeBg:ScaleFrameImage;
      
      private var _timeline:TimelineMax;
      
      private var _isMouseOver:Boolean;
      
      private var _lightMc:MovieClip;
      
      public function ShopRankingCellItem()
      {
         super();
         this.initContent();
      }
      
      public function get payPaneGivingBtn() : BaseButton
      {
         return this._payPaneGivingBtn;
      }
      
      public function get payPaneBuyBtn() : BaseButton
      {
         return this._payPaneBuyBtn;
      }
      
      public function get itemCellBtn() : Sprite
      {
         return this._itemCellBtn;
      }
      
      public function get itemBg() : ScaleFrameImage
      {
         return this._itemBg;
      }
      
      public function get itemCell() : ShopItemCell
      {
         return this._itemCell;
      }
      
      private function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("shop.RankingCellItemBg");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("shop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         PositionUtils.setPos(this._payType,"shop.GoodPayTypeLabelPos");
         this._payPaneGivingBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PayPaneGivingBtn");
         PositionUtils.setPos(this._payPaneGivingBtn,"shop.PayPaneGivingBtnPos");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PayPaneBuyBtn");
         PositionUtils.setPos(this._payPaneBuyBtn,"shop.PayPaneBuyBtnPos");
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemName");
         PositionUtils.setPos(this._itemNameTxt,"shop.GoodItemNamePos");
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemPrice");
         PositionUtils.setPos(this._itemPriceTxt,"shop.GoodItemPricePos");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemCount");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,75,75);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.scaleY = 0.5;
         this._itemCell.scaleX = 0.5;
         this._itemCell.x = 4;
         this._itemCell.y = 2;
         this._itemCellBtn = new Sprite();
         this._itemCellBtn.buttonMode = true;
         this._itemCellBtn.addChild(this._itemCell);
         this._itemBg.setFrame(1);
         this._payType.setFrame(1);
         addChild(this._itemBg);
         addChild(this._payType);
         addChild(this._payPaneBuyBtn);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemCellBtn);
         this.shopItemInfo = null;
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         if(param1 == null)
         {
            this._shopItemInfo = null;
            this._itemCell.info = null;
         }
         else
         {
            this._itemCell.info = param1.TemplateInfo;
            if(this._shopItemInfo)
            {
               this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
            }
            this._shopItemInfo = param1;
         }
         if(this._itemCell.info != null)
         {
            this._payType.visible = true;
            this._itemPriceTxt.visible = true;
            this._itemNameTxt.visible = true;
            this._itemCountTxt.visible = true;
            this._payPaneGivingBtn.visible = true;
            this._payPaneBuyBtn.visible = true;
            this._itemCellBtn.visible = true;
            if(this._itemCell.info.Name.toString().length > 13)
            {
               this._itemNameTxt.text = String(this._itemCell.info.Name).substr(0,13) + "...";
            }
            else
            {
               this._itemNameTxt.text = String(this._itemCell.info.Name);
            }
            this.initPrice();
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._payType.visible = false;
            this._itemPriceTxt.visible = false;
            this._itemNameTxt.visible = false;
            this._itemCountTxt.visible = false;
            this._payPaneGivingBtn.visible = false;
            this._payPaneBuyBtn.visible = false;
            this._itemCellBtn.visible = false;
         }
         this.updateCount();
      }
      
      private function __updateShopItem(param1:Event) : void
      {
         this.updateCount();
      }
      
      private function initPrice() : void
      {
         switch(this._shopItemInfo.getItemPrice(1).PriceType)
         {
            case Price.MONEY:
               this._payType.setFrame(PAYTYPE_MONEY);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).moneyValue);
               break;
            case Price.GIFT:
               this._payType.setFrame(PAYTYPE_GIFT);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).giftValue);
               break;
            case -5:
               this._payType.setFrame(PAYTYPE_MEDAL);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).getOtherValue(EquipType.MEDAL));
         }
      }
      
      private function updateCount() : void
      {
         if(this._shopItemInfo)
         {
            if(this._shopItemInfo.Label && this._shopItemInfo.Label == LIMIT_LABEL)
            {
               if(this._itemBg && this._itemCountTxt)
               {
                  this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
               }
            }
            else if(this._itemBg && this._itemCountTxt)
            {
               this._itemCountTxt.visible = false;
               this._itemCountTxt.text = "0";
            }
         }
      }
      
      public function mouseOver() : void
      {
         if(!this._itemCell.info)
         {
            return;
         }
         this._isMouseOver = true;
      }
      
      public function setItemLight(param1:MovieClip) : void
      {
         if(this._lightMc == param1 || !this._shopItemInfo)
         {
            return;
         }
         this._lightMc = param1;
         this._lightMc.mouseChildren = false;
         this._lightMc.mouseEnabled = false;
         this._lightMc.x = 3;
         this._lightMc.y = 2;
         this._lightMc.gotoAndPlay(1);
         addChild(this._lightMc);
      }
      
      public function mouseOut() : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         this._isMouseOver = false;
         ObjectUtils.disposeObject(this._lightMc);
         this._lightMc = null;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._itemBg.setFrame(!!this._selected ? int(int(2)) : int(int(this.checkType())));
      }
      
      private function checkType() : int
      {
         if(this._shopItemInfo)
         {
            return this._shopItemInfo.ShopID == 1 ? int(int(1)) : int(int(2));
         }
         return 1;
      }
      
      public function dispose() : void
      {
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._lightMc);
         this._lightMc = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         this._itemBg = null;
         this._itemCountTxt = null;
         this._itemNameTxt = null;
         this._itemPriceTxt = null;
         this._payType = null;
         this._shopItemInfo = null;
         this._payPaneGivingBtn = null;
         this._payPaneBuyBtn = null;
      }
   }
}
