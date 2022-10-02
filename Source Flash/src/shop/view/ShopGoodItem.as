package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.events.TweenEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import labyrinth.view.LabyrinthFrame;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class ShopGoodItem extends Sprite implements ISelectable, Disposeable
   {
      
      public static const PAYTYPE_FREE:uint = 1;
      
      public static const PAYTYPE_GIFT:uint = 3;
      
      public static const PAYTYPE_MEDAL:uint = 4;
      
      public static const PAYTYPE_MONEY:uint = 2;
      
      private static const LIMIT_LABEL:uint = 6;
      
      private static const FREE_LIMIT_LABEL:uint = 7;
       
      
      protected var _payPaneGivingBtn:BaseButton;
      
      protected var _payPaneBuyBtn:BaseButton;
      
      protected var _payPaneGetBtn:BaseButton;
      
      protected var _itemBg:ScaleFrameImage;
      
      private var _shopItemCellBg:Bitmap;
      
      private var _itemCell:ShopItemCell;
      
      protected var _itemCellBtn:Sprite;
      
      protected var _itemCountTxt:FilterFrameText;
      
      protected var _itemNameTxt:FilterFrameText;
      
      protected var _itemPriceTxt:FilterFrameText;
      
      protected var _labelIcon:ScaleFrameImage;
      
      protected var _payType:ScaleFrameImage;
      
      protected var _selected:Boolean;
      
      protected var _shopItemInfo:ShopItemInfo;
      
      protected var _shopItemCellTypeBg:ScaleFrameImage;
      
      private var _timeline:TimelineMax;
      
      private var _isMouseOver:Boolean;
      
      protected var _lightMc:MovieClip;
      
      public function ShopGoodItem()
      {
         super();
         this.initContent();
         this.addEvent();
      }
      
      public function get payPaneGivingBtn() : BaseButton
      {
         return this._payPaneGivingBtn;
      }
      
      public function get payPaneBuyBtn() : BaseButton
      {
         return this._payPaneBuyBtn;
      }
      
      public function get payPaneGetBtn() : BaseButton
      {
         return this._payPaneGetBtn;
      }
      
      public function get itemBg() : ScaleFrameImage
      {
         return this._itemBg;
      }
      
      public function get itemCell() : ShopItemCell
      {
         return this._itemCell;
      }
      
      public function get itemCellBtn() : Sprite
      {
         return this._itemCellBtn;
      }
      
      protected function initContent() : void
      {
         this._itemBg = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemBg");
         this._payType = ComponentFactory.Instance.creatComponentByStylename("shop.GoodPayTypeLabel");
         this._payType.mouseChildren = false;
         this._payType.mouseEnabled = false;
         this._payPaneGivingBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PayPaneGivingBtn");
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PayPaneBuyBtn");
         this._payPaneGetBtn = ComponentFactory.Instance.creatComponentByStylename("shop.PayPaneGetBtn");
         this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemName");
         this._itemPriceTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemPrice");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("shop.GoodItemCount");
         this._itemCell = this.creatItemCell();
         this._labelIcon = ComponentFactory.Instance.creatComponentByStylename("shop.GoodLabelIcon");
         this._labelIcon.mouseChildren = false;
         this._labelIcon.mouseEnabled = false;
         this._shopItemCellTypeBg = ComponentFactory.Instance.creatComponentByStylename("shop.ShopItemCellTypeBg");
         this._itemCellBtn = new Sprite();
         this._itemCellBtn.buttonMode = true;
         this._itemCellBtn.addChild(this._itemCell);
         this._itemCellBtn.addChild(this._shopItemCellTypeBg);
         this._itemBg.setFrame(1);
         this._labelIcon.setFrame(1);
         this._payType.setFrame(1);
         addChild(this._itemBg);
         addChild(this._payPaneBuyBtn);
         addChild(this._payPaneGetBtn);
         addChild(this._payType);
         addChild(this._itemCellBtn);
         addChild(this._labelIcon);
         addChild(this._itemNameTxt);
         addChild(this._itemPriceTxt);
         addChild(this._itemCountTxt);
         this._timeline = new TimelineMax();
         this._timeline.addEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         var _loc1_:TweenLite = TweenLite.to(this._labelIcon,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(_loc1_);
         var _loc2_:TweenLite = TweenLite.to(this._itemCountTxt,0.25,{
            "alpha":0,
            "y":"-30"
         });
         this._timeline.append(_loc2_,-0.25);
         var _loc3_:TweenMax = TweenMax.from(this._shopItemCellTypeBg,0.1,{
            "autoAlpha":0,
            "y":"5"
         });
         this._timeline.append(_loc3_,-0.2);
         this._timeline.stop();
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,75,75);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      public function get shopItemInfo() : ShopItemInfo
      {
         return this._shopItemInfo;
      }
      
      public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         if(param1 == null)
         {
            this._shopItemInfo = null;
            this._itemCell.info = null;
         }
         else
         {
            this._shopItemInfo = param1;
            if(this._shopItemInfo)
            {
               PlayerManager.Instance.Self.removeEventListener(PlayerInfo.UPDATE_SHOP_FINALLY_TIME,this.updateGottenTime);
            }
            this._itemCell.info = param1.TemplateInfo;
         }
         if(this._itemCell.info != null)
         {
            this._itemCell.visible = true;
            this._itemCellBtn.visible = true;
            this._itemCellBtn.buttonMode = true;
            this._payType.visible = true;
            this._itemPriceTxt.visible = true;
            this._itemNameTxt.visible = true;
            this._itemCountTxt.visible = true;
            this._payPaneGivingBtn.visible = true;
            this._payPaneBuyBtn.visible = true;
            this._payPaneGetBtn.visible = false;
            this._itemNameTxt.text = String(this._itemCell.info.Name);
            this.initPrice();
            if(this._shopItemInfo.ShopID == 1)
            {
               this._itemBg.setFrame(1);
            }
            else if(this._shopItemInfo.ShopID == 94)
            {
               this._itemBg.setFrame(4);
            }
            else
            {
               this._itemBg.setFrame(2);
            }
            if(EquipType.dressAble(this._shopItemInfo.TemplateInfo))
            {
               this._shopItemCellTypeBg.setFrame(1);
            }
            else
            {
               this._shopItemCellTypeBg.setFrame(2);
            }
            this._labelIcon.visible = this._shopItemInfo.Label == 0 ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            this._labelIcon.setFrame(this._shopItemInfo.Label);
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
            PlayerManager.Instance.Self.addEventListener(PlayerInfo.UPDATE_SHOP_FINALLY_TIME,this.updateGottenTime);
            if(this._shopItemInfo.isFree && !LabyrinthFrame.flag)
            {
               this._payPaneGivingBtn.visible = false;
               this._payPaneBuyBtn.visible = false;
               this._payType.visible = false;
               this._itemPriceTxt.visible = false;
               this._itemCellBtn.buttonMode = false;
               this._payPaneGetBtn.visible = true;
               this.updateGottenTime();
            }
         }
         else
         {
            this._itemBg.setFrame(1);
            this._itemCellBtn.visible = false;
            this._labelIcon.visible = false;
            this._payType.visible = false;
            this._itemPriceTxt.visible = false;
            this._itemNameTxt.visible = false;
            this._itemCountTxt.visible = false;
            this._payPaneGivingBtn.visible = false;
            this._payPaneBuyBtn.visible = false;
            this._payPaneGetBtn.visible = false;
            PlayerManager.Instance.Self.removeEventListener(PlayerInfo.UPDATE_SHOP_FINALLY_TIME,this.updateGottenTime);
         }
         this.updateCount();
      }
      
      protected function setItemName() : void
      {
         if(this._itemCell.info != null)
         {
            if(this._itemCell.info.Name.length > 16)
            {
               this._itemNameTxt.text = this._itemCell.info.Name.substr(0,16) + "...";
               return;
            }
            this._itemNameTxt.text = String(this._itemCell.info.Name);
         }
      }
      
      protected function setItemCellSize() : void
      {
         this._payType.visible = false;
         this._itemCell.x = 1;
         this._itemCell.y = -2;
         this._itemCell.width = 72;
      }
      
      private function updateGottenTime(param1:Event = null) : void
      {
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = PlayerManager.Instance.Self.shopFinallyGottenTime;
         if(_loc3_.fullYear == _loc2_.fullYear && _loc3_.month == _loc2_.month && _loc3_.date == _loc2_.date)
         {
            this._payPaneGetBtn.enable = false;
         }
         else
         {
            this._payPaneGetBtn.enable = true;
         }
      }
      
      private function __updateShopItem(param1:Event) : void
      {
         this.updateCount();
      }
      
      private function checkType() : int
      {
         if(this._shopItemInfo)
         {
            return this._shopItemInfo.ShopID == 1 ? int(int(1)) : int(int(2));
         }
         return 1;
      }
      
      protected function initPrice() : void
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
               this._payPaneGivingBtn.visible = false;
               break;
            case Price.MEDAL:
               this._payType.setFrame(PAYTYPE_MEDAL);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).getOtherValue(EquipType.MEDAL));
               this._payPaneGivingBtn.visible = false;
               break;
            case Price.SCORE:
               this._payType.setFrame(PAYTYPE_MEDAL);
               this._itemPriceTxt.text = String(this._shopItemInfo.getItemPrice(1).getOtherValue(EquipType.MEDAL));
               this._payPaneGivingBtn.visible = false;
         }
      }
      
      private function updateCount() : void
      {
         if(this._shopItemInfo)
         {
            if(this._shopItemInfo.Label && (this._shopItemInfo.Label == LIMIT_LABEL || this._shopItemInfo.Label == FREE_LIMIT_LABEL))
            {
               if(this._itemBg && this._labelIcon && this._itemCountTxt)
               {
                  this._itemCountTxt.text = String(this._shopItemInfo.LimitCount);
               }
            }
            else if(this._itemBg && this._labelIcon && this._itemCountTxt)
            {
               this._itemCountTxt.visible = false;
               this._itemCountTxt.text = "0";
            }
         }
      }
      
      protected function addEvent() : void
      {
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneGivingBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneGetBtn.addEventListener(MouseEvent.CLICK,this.__payPaneGetBtnClick);
         this._itemCellBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function removeEvent() : void
      {
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneGivingBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         this._payPaneGetBtn.removeEventListener(MouseEvent.CLICK,this.__payPaneGetBtnClick);
         this._itemCellBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         this._itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      protected function __payPanelClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(this._shopItemInfo && this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         if(this._shopItemInfo != null)
         {
            SoundManager.instance.play("008");
            if(param1.currentTarget == this._payPaneGivingBtn)
            {
               ShopGiftsManager.Instance.buy(this._shopItemInfo.GoodsID);
            }
            else
            {
               ShopBuyManager.Instance.buy(this._shopItemInfo.GoodsID);
            }
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      private function __payPanelGivingClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("AlertDialog.ErrotTip"));
      }
      
      protected function __payPaneGetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.title"),LanguageMgr.GetTranslation("shop.view.ShopRightView.getSimpleAlert.msg"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECT,this._shopItemInfo,0));
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc3_ = new Array();
            _loc4_ = new Array();
            _loc5_ = new Array();
            _loc6_ = new Array();
            _loc7_ = new Array();
            _loc8_ = 0;
            while(_loc8_ < 1)
            {
               _loc3_.push(this._shopItemInfo.GoodsID);
               _loc4_.push(1);
               _loc5_.push("");
               _loc6_.push("");
               _loc7_.push("");
               _loc8_++;
            }
            SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc7_,_loc6_);
         }
      }
      
      protected function __itemClick(param1:MouseEvent) : void
      {
         if(!this._shopItemInfo)
         {
            return;
         }
         if(this._shopItemInfo.isFree)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._shopItemInfo.LimitCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.countOver"));
            return;
         }
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,this._shopItemInfo,1));
      }
      
      protected function __itemMouseOver(param1:MouseEvent) : void
      {
         if(this._shopItemInfo && this._shopItemInfo.isFree)
         {
            return;
         }
         if(!this._itemCell.info)
         {
            return;
         }
         if(this._lightMc)
         {
            addChild(this._lightMc);
         }
         parent.addChild(this);
         this._isMouseOver = true;
         this._timeline.play();
      }
      
      protected function __itemMouseOut(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._lightMc);
         if(this._shopItemInfo && this._shopItemInfo.isFree)
         {
            return;
         }
         if(!this._shopItemInfo)
         {
            return;
         }
         this._isMouseOver = false;
         this.__timelineComplete();
      }
      
      public function setItemLight(param1:MovieClip) : void
      {
         if(this._lightMc == param1)
         {
            return;
         }
         this._lightMc = param1;
         this._lightMc.mouseChildren = false;
         this._lightMc.mouseEnabled = false;
         this._lightMc.x = 3;
         this._lightMc.y = 3;
         this._lightMc.gotoAndPlay(1);
      }
      
      protected function __timelineComplete(param1:TweenEvent = null) : void
      {
         if(this._timeline.currentTime < this._timeline.totalDuration)
         {
            return;
         }
         if(this._isMouseOver)
         {
            return;
         }
         this._timeline.reverse();
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
         this._itemBg.setFrame(!!this._selected ? int(int(3)) : int(int(this.checkType())));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._shopItemInfo)
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         ObjectUtils.disposeAllChildren(this);
         PlayerManager.Instance.Self.removeEventListener(PlayerInfo.UPDATE_SHOP_FINALLY_TIME,this.updateGottenTime);
         this._timeline.removeEventListener(TweenEvent.COMPLETE,this.__timelineComplete);
         this._timeline = null;
         ObjectUtils.disposeObject(this._lightMc);
         this._lightMc = null;
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._shopItemCellBg);
         this._shopItemCellBg = null;
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._shopItemCellTypeBg);
         this._shopItemCellTypeBg = null;
         this._itemCountTxt = null;
         this._itemNameTxt = null;
         this._itemPriceTxt = null;
         this._labelIcon = null;
         this._payType = null;
         this._itemCellBtn = null;
         this._shopItemInfo = null;
         this._payPaneGivingBtn = null;
         this._payPaneBuyBtn = null;
      }
   }
}
