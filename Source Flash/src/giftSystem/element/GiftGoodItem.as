package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import shop.view.ShopItemCell;
   
   public class GiftGoodItem extends Sprite implements ISelectable, Disposeable
   {
      
      public static const MONEY:uint = 2;
      
      public static const GIFT:uint = 3;
      
      public static const MEDAL:uint = 4;
       
      
      private var _selected:Boolean;
      
      private var _info:ShopItemInfo;
      
      private var _background:ScaleFrameImage;
      
      private var _icon:ScaleFrameImage;
      
      private var _itemCell:ShopItemCell;
      
      private var _giftName:FilterFrameText;
      
      private var _charmValue:FilterFrameText;
      
      private var _charmName:FilterFrameText;
      
      private var _moneyValue:FilterFrameText;
      
      private var _moneyName:FilterFrameText;
      
      private var _freeName:FilterFrameText;
      
      private var _freeValue:FilterFrameText;
      
      private var _presentBtn:BaseButton;
      
      public function GiftGoodItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._background = ComponentFactory.Instance.creatComponentByStylename("asset.giftGoodItem.background");
         this._icon = ComponentFactory.Instance.creatComponentByStylename("GiftGoodItem.GoodItemIcon");
         this._giftName = ComponentFactory.Instance.creat("GiftGoodItem.giftName");
         this._charmValue = ComponentFactory.Instance.creat("GiftGoodItem.charmValue");
         this._charmName = ComponentFactory.Instance.creat("GiftGoodItem.charmName");
         this._moneyValue = ComponentFactory.Instance.creat("GiftGoodItem.moneyValue");
         this._moneyName = ComponentFactory.Instance.creatComponentByStylename("GiftGoodItem.moneyName");
         this._freeName = ComponentFactory.Instance.creatComponentByStylename("GiftGoodItem.freeName");
         this._freeValue = ComponentFactory.Instance.creatComponentByStylename("GiftGoodItem.freeValue");
         this._presentBtn = ComponentFactory.Instance.creatComponentByStylename("GiftGoodItem.presentBtn");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,56,56);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 46;
         PositionUtils.setPos(this._itemCell,"giftGoodItem.itemCellPos");
         addChild(this._background);
         addChild(this._itemCell);
         addChild(this._icon);
         addChild(this._giftName);
         addChild(this._charmValue);
         addChild(this._charmName);
         addChild(this._moneyValue);
         addChild(this._moneyName);
         addChild(this._freeName);
         addChild(this._presentBtn);
         addChild(this._freeValue);
         this.upView();
         this._presentBtn.addEventListener(MouseEvent.CLICK,this.__showClearingInterface);
      }
      
      private function __showClearingInterface(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info.Label == 6 && parseInt(this._freeValue.text) <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.freeLimit"));
            return;
         }
         GiftController.Instance.openClearingInterface(this._info);
      }
      
      public function set info(param1:ShopItemInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         this._info = param1;
         this.upView();
      }
      
      public function get info() : ShopItemInfo
      {
         return this._info;
      }
      
      private function upView() : void
      {
         if(this._info == null)
         {
            this._itemCell.info = null;
         }
         else
         {
            this._itemCell.info = this._info.TemplateInfo;
         }
         if(this._itemCell.info)
         {
            this._giftName.visible = this._charmValue.visible = this._charmName.visible = this._moneyValue.visible = this._presentBtn.visible = true;
            this._giftName.text = this._itemCell.info.Name;
            this._charmValue.text = this._itemCell.info.Property2 + LanguageMgr.GetTranslation("shop.ShopIISaveFigurePanel.point");
            this._charmName.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charm");
            this._moneyName.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.money");
            this._moneyValue.text = this._info.getItemPrice(1).moneyValue.toString();
            this._icon.visible = this._info.Label == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            if(this._info.Label == 6)
            {
               this._icon.setFrame(7);
               this._background.setFrame(2);
               this._freeName.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.free");
               this.__upItemCount(null);
               this._info.addEventListener(Event.CHANGE,this.__upItemCount);
            }
            else
            {
               this._background.setFrame(1);
               this._icon.setFrame(this._info.Label);
            }
         }
         else
         {
            this._icon.visible = this._presentBtn.visible = false;
            this._background.setFrame(1);
         }
      }
      
      protected function __upItemCount(param1:Event) : void
      {
         this._freeValue.text = this._info.LimitCount > 0 ? this._info.LimitCount.toString() : "0";
      }
      
      override public function get height() : Number
      {
         return this._background.height;
      }
      
      override public function get width() : Number
      {
         return this._background.width;
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
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this._presentBtn.removeEventListener(MouseEvent.CLICK,this.__showClearingInterface);
         if(this._info && this._info.Label == 6)
         {
            this._info.removeEventListener(Event.CHANGE,this.__upItemCount);
         }
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = null;
         if(this._itemCell)
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(this._giftName)
         {
            ObjectUtils.disposeObject(this._giftName);
         }
         this._giftName = null;
         if(this._charmValue)
         {
            ObjectUtils.disposeObject(this._charmValue);
         }
         this._charmValue = null;
         if(this._charmName)
         {
            ObjectUtils.disposeObject(this._charmName);
         }
         this._charmName = null;
         if(this._moneyValue)
         {
            ObjectUtils.disposeObject(this._moneyValue);
         }
         this._moneyValue = null;
         if(this._moneyName)
         {
            ObjectUtils.disposeObject(this._moneyName);
         }
         this._moneyName = null;
         if(this._freeName)
         {
            ObjectUtils.disposeObject(this._freeName);
         }
         this._freeName = null;
         if(this._freeValue)
         {
            ObjectUtils.disposeObject(this._freeValue);
         }
         this._freeValue = null;
         if(this._presentBtn)
         {
            ObjectUtils.disposeObject(this._presentBtn);
         }
         this._presentBtn = null;
      }
   }
}
