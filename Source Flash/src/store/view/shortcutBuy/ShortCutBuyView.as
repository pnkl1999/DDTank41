package store.view.shortcutBuy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShortCutBuyView extends Sprite implements Disposeable
   {
      
      public static const ADD_NUMBER_Y:int = 40;
      
      public static const ADD_TOTALTEXT_Y:int = 20;
       
      
      private var _templateItemIDList:Array;
      
      private var _moneySelectBtn:SelectedCheckButton;
      
      private var _giftSelectBtn:SelectedCheckButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ShortcutBuyList;
      
      private var _num:NumberSelecter;
      
      private var priceStr:String;
      
      private var totalText:FilterFrameText;
      
      private var bg:MutipleImage;
      
      private var _showRadioBtn:Boolean = true;
      
      private var _memoryItemID:int;
      
      private var _firstShow:Boolean = true;
      
      public function ShortCutBuyView(param1:Array, param2:Boolean)
      {
         super();
         this._templateItemIDList = param1;
         this._showRadioBtn = param2;
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         var _loc2_:Bitmap = null;
         _loc2_ = null;
         this.bg = ComponentFactory.Instance.creatComponentByStylename("store.ShortCutViewBG");
         addChild(this.bg);
         this._moneySelectBtn = ComponentFactory.Instance.creatComponentByStylename("store.MoneySelectBtn");
         addChild(this._moneySelectBtn);
         this._giftSelectBtn = ComponentFactory.Instance.creatComponentByStylename("store.GiftSelectBtn");
         addChild(this._giftSelectBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._moneySelectBtn);
         this._btnGroup.addSelectItem(this._giftSelectBtn);
         this._btnGroup.selectIndex = 0;
         this.bg.visible = this._moneySelectBtn.visible = this._giftSelectBtn.visible = this._showRadioBtn;
         this._list = ComponentFactory.Instance.creatCustomObject("store.ShortcutBuyList");
         this._list.setup(this._templateItemIDList);
         this._memoryItemID = SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID.toString()];
         var _loc1_:ShopItemInfo = ShopManager.Instance.getShopItemByGoodsID(this._memoryItemID);
         if(_loc1_ && this._templateItemIDList.indexOf(_loc1_.TemplateID) > -1)
         {
            this._list.selectedItemID = _loc1_.TemplateID;
         }
         else
         {
            this._list.selectedItemID = this._templateItemIDList[0];
         }
         if(_loc1_ && _loc1_.getItemPrice(1).IsGiftType && this._templateItemIDList.indexOf(_loc1_.TemplateID) > -1)
         {
            this._btnGroup.selectIndex = 1;
         }
         addChild(this._list);
         this._num = ComponentFactory.Instance.creatCustomObject("store.shortNumber");
         this._num.y = this._list.y + this._list.height + ADD_NUMBER_Y;
         addChild(this._num);
         _loc2_ = ComponentFactory.Instance.creatBitmap("asset.store.shortCutPayTip");
         addChild(_loc2_);
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("store.totalText");
         this.totalText.y = this._num.y + this._num.height + ADD_TOTALTEXT_Y;
         _loc2_.y = this.totalText.y + 3;
         addChild(this.totalText);
         this.updateCost();
      }
      
      private function initEvents() : void
      {
         this._list.addEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.addEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.addEventListener(MouseEvent.CLICK,this.clickHandlerDian);
         this._giftSelectBtn.addEventListener(Event.SELECT,this.selectHandler);
         this._giftSelectBtn.addEventListener(MouseEvent.CLICK,this.clickHandlerLi);
         this._num.addEventListener(Event.CHANGE,this.selectHandler);
         this._num.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function removeEvents() : void
      {
         this._list.removeEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.removeEventListener(Event.SELECT,this.selectHandler);
         this._moneySelectBtn.removeEventListener(MouseEvent.CLICK,this.clickHandlerDian);
         this._giftSelectBtn.removeEventListener(Event.SELECT,this.selectHandler);
         this._giftSelectBtn.removeEventListener(MouseEvent.CLICK,this.clickHandlerLi);
         this._num.removeEventListener(Event.CHANGE,this.selectHandler);
         this._num.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function _numberClose(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function clickHandlerDian(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.priceStr = "0" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
         this._firstShow = false;
         this.updateCost();
      }
      
      private function clickHandlerLi(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.priceStr = "0" + LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken");
         this._firstShow = false;
         this.updateCost();
      }
      
      private function selectHandler(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         this.updateCost();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateCost() : void
      {
         if(this._firstShow)
         {
            this.priceStr = "0" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
         }
         if(this.currentShopItem != null)
         {
            this.priceStr = this.totalPrice.toString();
         }
         this.totalText.text = this.priceStr;
      }
      
      public function get List() : ShortcutBuyList
      {
         return this._list;
      }
      
      public function get currentShopItem() : ShopItemInfo
      {
         var _loc1_:ShopItemInfo = null;
         if(this._moneySelectBtn.selected)
         {
            _loc1_ = ShopManager.Instance.getMoneyShopItemByTemplateID(this._list.selectedItemID);
         }
         else
         {
            _loc1_ = ShopManager.Instance.getGiftShopItemByTemplateID(this._list.selectedItemID);
         }
         return _loc1_;
      }
      
      public function get currentNum() : int
      {
         return this._num.number;
      }
      
      public function get totalPrice() : ItemPrice
      {
         var _loc1_:ItemPrice = new ItemPrice(null,null,null);
         if(this.currentShopItem)
         {
            _loc1_ = this.currentShopItem.getItemPrice(1).multiply(this._num.number);
         }
         return _loc1_;
      }
      
      public function get totalMoney() : int
      {
         return this.totalPrice.moneyValue;
      }
      
      public function get totalGift() : int
      {
         return this.totalPrice.giftValue;
      }
      
      public function get totalNum() : int
      {
         return this._num.number;
      }
      
      public function save() : void
      {
         SharedManager.Instance.StoreBuyInfo[PlayerManager.Instance.Self.ID] = this.currentShopItem.GoodsID;
         SharedManager.Instance.save();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._moneySelectBtn)
         {
            ObjectUtils.disposeObject(this._moneySelectBtn);
         }
         this._moneySelectBtn = null;
         if(this._giftSelectBtn)
         {
            ObjectUtils.disposeObject(this._giftSelectBtn);
         }
         this._giftSelectBtn = null;
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._num)
         {
            ObjectUtils.disposeObject(this._num);
         }
         this._num = null;
         if(this.totalText)
         {
            ObjectUtils.disposeObject(this.totalText);
         }
         this.totalText = null;
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         this._templateItemIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
