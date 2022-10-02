package worldboss.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopPlayerCell;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossBuffInfo;
   
   public class BuffCartItem extends Sprite implements Disposeable
   {
       
      
      private var _buffInfo:WorldBossBuffInfo;
      
      private var _bg:DisplayObject;
      
      private var _itemCellBg:DisplayObject;
      
      private var _verticalLine:Image;
      
      private var _itemName:FilterFrameText;
      
      private var _description:FilterFrameText;
      
      private var _cell:ShopPlayerCell;
      
      private var _buffIconLoader:BitmapLoader;
      
      private var _buffIcon:Bitmap;
      
      private var _payPaneBuyBtn:BaseButton;
      
      private var _itemPrice:FilterFrameText;
      
      private var _moneyBitmap:Bitmap;
      
      private var _isBuyText:FilterFrameText;
      
      private var _autoBuySelectedBtn:SelectedCheckButton;
      
      private var _isAlreadyBuy:Boolean = false;
      
      private var _isAllSelected:Boolean = false;
      
      public function BuffCartItem()
      {
         super();
         this.drawBackground();
         this.drawNameField();
         this.drawCellField();
         this.init();
         this.addEvent();
      }
      
      protected function drawBackground() : void
      {
//         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemBg");
         this._itemCellBg = ComponentFactory.Instance.creat("ddtshop.CartItemCellBg");
         this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("ddtshop.VerticalLine");
//         addChild(this._bg);
         addChild(this._verticalLine);
         addChild(this._itemCellBg);
      }
      
      protected function drawNameField() : void
      {
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("worldboss.buffCartItemName");
         this._description = ComponentFactory.Instance.creatComponentByStylename("worldboss.buffCartDescription");
         addChild(this._itemName);
         addChild(this._description);
      }
      
      protected function drawCellField() : void
      {
         this._cell = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
		 this._cell.x = 10;
		 this._cell.y = 10;
//         PositionUtils.setPos(this._cell,"ddtshop.CartItemCellPoint");
         addChild(this._cell);
      }
      
      private function init() : void
      {
         this._payPaneBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PayPaneBuyBtn");
         PositionUtils.setPos(this._payPaneBuyBtn,"worldboss.buffCartItem.bugBtn");
         addChild(this._payPaneBuyBtn);
         this._moneyBitmap = ComponentFactory.Instance.creatBitmap("asset.shop.PayPanelMoneyIcon");
         PositionUtils.setPos(this._moneyBitmap,"worldboss.buffCartItem.moneyBitmapPos");
         addChild(this._moneyBitmap);
         this._itemPrice = ComponentFactory.Instance.creatComponentByStylename("worldboss.buff.price");
         addChild(this._itemPrice);
         this._isBuyText = ComponentFactory.Instance.creatComponentByStylename("worldbossBuffIsBuyText");
         this._isBuyText.text = LanguageMgr.GetTranslation("worldboss.buyBuff.haveBuy");
         addChild(this._isBuyText);
         this._isBuyText.visible = false;
         this._autoBuySelectedBtn = ComponentFactory.Instance.creatComponentByStylename("worldbossAutoBuySelected");
         this._autoBuySelectedBtn.text = LanguageMgr.GetTranslation("worldboss.buyBuff.autoBuy");
         addChild(this._autoBuySelectedBtn);
      }
      
      private function updateStatus() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < WorldBossManager.Instance.bossInfo.myPlayerVO.buffs.length)
         {
            if(this.buffID == WorldBossManager.Instance.bossInfo.myPlayerVO.buffs[_loc1_])
            {
               this.changeStatusBuy();
               return;
            }
            _loc1_++;
         }
      }
      
      private function _buffIconComplete(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this._buffIconComplete);
            ObjectUtils.disposeObject(this._buffIcon);
            this._buffIcon = null;
            this._buffIcon = param1.loader.content as Bitmap;
            addChild(this._buffIcon);
            PositionUtils.setPos(this._buffIcon,"worldboss.buffCartItem.Iconpos");
            this._buffIcon.height = 60;
            this._buffIcon.width = 60;
         }
      }
      
      private function addEvent() : void
      {
         this._autoBuySelectedBtn.addEventListener(Event.SELECT,this.__autoBuyBuff);
         this._payPaneBuyBtn.addEventListener(MouseEvent.CLICK,this.__payBuyBuff);
      }
      
      protected function __autoBuyBuff(param1:Event) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         if(this._autoBuySelectedBtn.selected)
         {
            if(PlayerManager.Instance.Self.Money < this._buffInfo.price)
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               this._autoBuySelectedBtn.selected = false;
               WorldBossManager.Instance.isBuyBuffAlert = false;
               return;
            }
            if(WorldBossManager.Instance.isBuyBuffAlert)
            {
               this.autoBuy();
               return;
            }
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("worldboss.buyBuff.autoBuyConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         else
         {
            WorldBossManager.Instance.autoBuyBuffs.remove(this._buffInfo.ID);
         }
         dispatchEvent(new Event(Event.SELECT));
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         WorldBossManager.Instance.isBuyBuffAlert = true;
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               WorldBossManager.Instance.isBuyBuffAlert = false;
               this._autoBuySelectedBtn.selected = false;
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.autoBuy();
         }
         Frame(param1.currentTarget).dispose();
      }
      
      private function autoBuy() : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this._autoBuySelectedBtn.selected = false;
            WorldBossManager.Instance.isBuyBuffAlert = false;
            return;
         }
         WorldBossManager.Instance.autoBuyBuffs.add(this._buffInfo.ID,this._buffInfo);
         dispatchEvent(new Event(Event.SELECT));
      }
      
      private function removeEvent() : void
      {
         this._autoBuySelectedBtn.removeEventListener(Event.SELECT,this.__autoBuyBuff);
         this._payPaneBuyBtn.removeEventListener(MouseEvent.CLICK,this.__payBuyBuff);
      }
      
      private function __selectedBuff(param1:Event) : void
      {
         if(this._isAllSelected)
         {
            this._isAllSelected = false;
            return;
         }
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function selected(param1:Boolean) : void
      {
         this._isAllSelected = true;
         this._autoBuySelectedBtn.selected = param1;
      }
      
      private function __payBuyBuff(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._buffInfo.costID == -1)
         {
            if(PlayerManager.Instance.Self.Money >= this._buffInfo.price)
            {
               SocketManager.Instance.out.sendBuyWorldBossBuff([this._buffInfo.ID]);
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
         }
         else
         {
            _loc3_ = 0;
            for each(_loc4_ in PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(this._buffInfo.costID))
            {
               _loc3_ += _loc4_.Count;
            }
            if(_loc3_ >= this._buffInfo.price)
            {
               SocketManager.Instance.out.sendBuyWorldBossBuff([this._buffInfo.ID]);
            }
            else
            {
               _loc5_ = ItemManager.Instance.getTemplateById(this._buffInfo.costID);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.buyBuff.lackItem",_loc5_.Name));
            }
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      public function set buffItemInfo(param1:WorldBossBuffInfo) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         this._buffInfo = param1;
         this._itemName.text = this._buffInfo.name;
         this._description.text = this._buffInfo.decription;
         if(this._buffInfo.costID == -1)
         {
            this._itemPrice.text = LanguageMgr.GetTranslation("worldboss.buyBuff.eachMoney",this._buffInfo.price.toString(),"1");
         }
         else
         {
            _loc2_ = ItemManager.Instance.getTemplateById(this._buffInfo.costID);
            this._itemPrice.text = LanguageMgr.GetTranslation("worldboss.buyBuff.eachItem",this._buffInfo.price.toString(),_loc2_.Name,"1");
            PositionUtils.setPos(this._itemPrice,"worldboss.buffCartItem.costItemMoneyTxt");
            this._moneyBitmap.visible = false;
         }
         this._buffIconLoader = LoaderManager.Instance.creatLoader(WorldBossRoomView.getImagePath(this._buffInfo.ID),BaseLoader.BITMAP_LOADER);
         this._buffIconLoader.addEventListener(LoaderEvent.COMPLETE,this._buffIconComplete);
         LoaderManager.Instance.startLoad(this._buffIconLoader);
         this.updateStatus();
      }
      
      public function changeStatusBuy() : void
      {
         this._isAlreadyBuy = true;
         this._isBuyText.visible = true;
         this._autoBuySelectedBtn.visible = false;
         this._payPaneBuyBtn.visible = false;
      }
      
      public function get IsSelected() : Boolean
      {
         return this._isAlreadyBuy || this._autoBuySelectedBtn.selected;
      }
      
      public function get price() : int
      {
         return this._buffInfo.price;
      }
      
      public function get buffID() : int
      {
         return this._buffInfo.ID;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemCellBg = null;
         this._verticalLine = null;
         this._itemName = null;
         this._cell = null;
         this._buffIconLoader = null;
         this._buffIcon = null;
         this._payPaneBuyBtn = null;
         this._itemPrice = null;
         this._moneyBitmap = null;
      }
   }
}
