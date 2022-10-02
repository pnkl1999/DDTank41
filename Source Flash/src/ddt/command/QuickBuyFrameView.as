package ddt.command
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class QuickBuyFrameView extends Sprite implements Disposeable
   {
       
      
      private var _number:NumberSelecter;
      
      private var _itemTemplateInfo:ItemTemplateInfo;
      
      private var _shopItem:ShopItemInfo;
      
      private var _cell:BaseCell;
      
      private var totalText:FilterFrameText;
      
      public var _itemID:int;
      
      private var _stoneNumber:int = 1;
      
      private var _price:int;
      
      private var _type:int = 0;
      
      private var _time:int = 1;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _bandMoney:FilterFrameText;
      
      protected var _isBand:Boolean;
      
      public function QuickBuyFrameView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get isBand() : Boolean
      {
         return this._isBand;
      }
      
      public function set isBand(param1:Boolean) : void
      {
         this._isBand = param1;
      }
      
      private function initView() : void
      {
         var _loc1_:Image = null;
         var _loc3_:Sprite = null;
         _loc1_ = null;
         _loc3_ = null;
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("core.QuickBuyCellBG");
         addChild(_loc1_);
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.core.QuickBuyMoneyTip");
         addChild(_loc2_);
         this._number = ComponentFactory.Instance.creatCustomObject("core.numberSelecter");
         addChild(this._number);
         _loc3_ = new Sprite();
         _loc3_.addChild(ComponentFactory.Instance.creatBitmap("asset.core.EquipCellBG"));
         this.totalText = ComponentFactory.Instance.creatComponentByStylename("core.quickPriceText");
         addChild(this.totalText);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.selected = true;
         this._selectedBtn.x = 83;
         this._selectedBtn.y = 101;
         this._selectedBtn.enable = false;
         this._selectedBtn.visible = false;
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.seletedHander);
         this._isBand = false;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.enable = true;
         this._selectedBandBtn.selected = false;
         this._selectedBandBtn.x = 183;
         this._selectedBandBtn.y = 101;
         this._selectedBandBtn.visible = false;
         this._selectedBandBtn.addEventListener(MouseEvent.CLICK,this.selectedBandHander);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.x = 55;
         this._moneyTxt.y = 107;
         this._moneyTxt.text = LanguageMgr.GetTranslation("money");
         this._moneyTxt.visible = false;
         this._bandMoney = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoney.x = 173;
         this._bandMoney.y = 107;
         this._bandMoney.text = LanguageMgr.GetTranslation("ddt.bandMoney");
         this._bandMoney.visible = false;
         this._cell = new BaseCell(_loc3_);
         this._cell.x = _loc1_.x + 4;
         this._cell.y = _loc1_.y + 4;
         addChild(this._cell);
         this._cell.tipDirctions = "7,0";
      }
      
      private function initEvents() : void
      {
         this._number.addEventListener(Event.CHANGE,this.selectHandler);
         this._number.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function selectHandler(param1:Event) : void
      {
         this._stoneNumber = this._number.number;
         this.refreshNumText();
      }
      
      protected function selectedBandHander(param1:MouseEvent) : void
      {
         if(this._selectedBandBtn.selected)
         {
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
         }
         else
         {
            this._isBand = false;
         }
         this.refreshNumText();
      }
      
      protected function seletedHander(param1:MouseEvent) : void
      {
         if(this._selectedBtn.selected)
         {
            this._isBand = false;
            this._selectedBandBtn.selected = false;
            this._selectedBandBtn.enable = true;
            this._selectedBtn.enable = false;
         }
         else
         {
            this._isBand = true;
         }
         this.refreshNumText();
      }
      
      private function _numberClose(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function set ItemID(param1:int) : void
      {
         this._itemID = param1;
         if(this._itemID == EquipType.STRENGTH_STONE4)
         {
            this._stoneNumber = 3;
         }
         else
         {
            this._stoneNumber = 1;
         }
         this._number.number = this._stoneNumber;
         this._shopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(this._itemID);
         this.initInfo();
         this.refreshNumText();
      }
      
      public function set stoneNumber(param1:int) : void
      {
         this._stoneNumber = param1;
         this._number.number = this._stoneNumber;
         this.refreshNumText();
      }
      
      public function get stoneNumber() : int
      {
         return this._stoneNumber;
      }
      
      public function get ItemID() : int
      {
         return this._itemID;
      }
      
      public function set maxLimit(param1:int) : void
      {
         this._number.maximum = param1;
      }
      
      private function initInfo() : void
      {
         this._itemTemplateInfo = ItemManager.Instance.getTemplateById(this._itemID);
         this._cell.info = this._itemTemplateInfo;
      }
      
      private function refreshNumText() : void
      {
         switch(this._type)
         {
            case 0:
               this._price = this._shopItem == null ? int(int(0)) : int(int(this._shopItem.getItemPrice(1).moneyValue));
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
               break;
            case 1:
               this._price = this._shopItem == null ? int(int(0)) : int(int(this._shopItem.getItemPrice(1).hardCurrencyValue));
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthShopFrame.text1");
               PositionUtils.setPos(this.totalText,"dt.labyrinth.LabyrinthShopFrame.text1");
               break;
            case 2:
               this._price = this._shopItem == null ? int(int(0)) : int(int(this._shopItem.getItemPrice(1).gesteValue));
               this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("gongxun");
               break;
            case 3:
               this._price = this._shopItem == null ? int(int(0)) : int(int(this._shopItem.getItemPrice(this._time).moneyValue));
               if(this._isBand)
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.bandStipple");
               }
               else
               {
                  this.totalText.text = String(this._stoneNumber * this._price) + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionBrowseView.stipple");
               }
               break;
            case 5:
               this._price = this._shopItem == null ? int(int(0)) : int(int(this._shopItem.getItemPrice(1).scoreValue));
               this.totalText.text = String(this._stoneNumber * this._price) + Price.SCORETOSTRING;
         }
      }
      
      public function setItemID(param1:int, param2:int, param3:int, param4:ShopItemInfo = null) : void
      {
         this._itemID = param1;
         this._type = param2;
         this._time = param3;
         this._shopItem = ShopManager.Instance.getShopItemByTemplateID(this._itemID,this._type);
         if(this._itemID == EquipType.STRENGTH_STONE4)
         {
            this._stoneNumber = 3;
         }
         else
         {
            this._stoneNumber = 1;
         }
         this._number.number = this._stoneNumber;
         if(param2 == 1 || param2 == 2 || param2 == 4 || param2 == 5 || param2 == 6)
         {
            this._moneyTxt.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = false;
         }
         else if(param2 == 3)
         {
            this._selectedBandBtn.selected = true;
            this._isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.selected = false;
            this._selectedBtn.enable = true;
            this._number.ennable = false;
            this._moneyTxt.visible = this._selectedBtn.visible = this._selectedBandBtn.visible = true;
         }
         this.initInfo();
         this.refreshNumText();
         this.hideSelectedBand();
         this.hideSelectedBand();
      }
      
      public function hideSelectedBand() : void
      {
         this._selectedBandBtn.visible = false;
         this._bandMoney.visible = false;
         this._moneyTxt.x += 50;
         this._selectedBtn.x += 50;
         this._selectedBtn.selected = true;
         this._selectedBandBtn.selected = false;
         this._selectedBandBtn.enable = false;
         this._selectedBtn.enable = false;
         this._isBand = false;
         this.refreshNumText();
      }
      
      public function hideSelected() : void
      {
         this._selectedBtn.visible = false;
         this._moneyTxt.visible = false;
         this._bandMoney.x -= 50;
         this._selectedBandBtn.x -= 50;
         this._selectedBandBtn.selected = true;
         this._selectedBtn.selected = false;
         this._selectedBandBtn.enable = false;
         this._selectedBtn.enable = false;
         this._isBand = true;
         this.refreshNumText();
      }
      
      public function dispose() : void
      {
         if(this._number)
         {
            this._number.removeEventListener(Event.CANCEL,this.selectHandler);
            this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            ObjectUtils.disposeObject(this._number);
         }
         if(this.totalText)
         {
            ObjectUtils.disposeObject(this.totalText);
         }
         this.totalText = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         this._number = null;
         this._itemTemplateInfo = null;
         this._shopItem = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
