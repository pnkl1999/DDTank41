package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import shop.manager.ShopGiftsManager;
   import shop.view.BuySingleGoodsView;
   
   public class RoomTicketView extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _buyBtn:IconButton;
      
      private var _giftBtn:IconButton;
      
      private var _buyLight:MovieClip;
      
      private var _giftLight:MovieClip;
      
      private var _level:int;
      
      private var _ticketsID:Array;
      
      private var _ticketsFootballID:Array;
      
      private var _view:BuySingleGoodsView;
      
      private var _giftBtn1:Bitmap;
      
      public function RoomTicketView()
      {
         this._ticketsID = [EquipType.EASY_TICKET_ID,EquipType.NORMAL_TICKET_ID,EquipType.HARD_TICKET_ID,EquipType.HERO_TICKET_ID,EquipType.EPIC_TICKET_ID];
         this._ticketsFootballID = [0,EquipType.FOOTBALL_NORMAL_TICKET_ID,EquipType.FOOTBALL_HARD_TICKET_ID,EquipType.FOOTBALL_HERO_TICKET_ID,0];
         super();
         this.preInitializer();
         this.initializer();
         this.initialEvent();
      }
      
      private function preInitializer() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.Bg");
         this._buyLight = ComponentFactory.Instance.creat("asset.warriorsArena.buyButton.Light");
         this._giftLight = ComponentFactory.Instance.creat("asset.warriorsArena.giftButton.Light");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.buyButton");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("asset.warriorsArena.giftButton");
      }
      
      private function initializer() : void
      {
         addChild(this._bg);
         addChild(this._buyBtn);
         addChild(this._giftBtn);
         this._buyLight.mouseChildren = this._buyLight.mouseEnabled = false;
         this._buyLight.x = this._buyBtn.x;
         this._buyLight.y = this._buyBtn.y;
         addChild(this._buyLight);
         this._giftLight.mouseChildren = this._giftLight.mouseEnabled = false;
         this._giftLight.x = this._giftBtn.x;
         this._giftLight.y = this._giftBtn.y;
         addChild(this._giftLight);
         this.__updateHard(null);
      }
      
      private function initialEvent() : void
      {
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyBtnClick);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__onGiftBtnClick);
         RoomManager.Instance.current.addEventListener(RoomEvent.HARD_LEVEL_CHANGED,this.__updateHard);
      }
      
      private function __updateHard(param1:RoomEvent) : void
      {
         var _loc2_:int = RoomManager.Instance.current.hardLevel;
         if(_loc2_ == 0)
         {
            if(this._giftBtn)
            {
               this._giftBtn.mouseEnabled = false;
               this._giftBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._giftBtn1 = ComponentFactory.Instance.creatBitmap("asset.warriorsArena.giftButton.Text1");
               this._giftBtn1.x = 102;
               this._giftBtn1.y = 7;
               addChild(this._giftBtn1);
            }
            if(this._giftLight)
            {
               this._giftLight.visible = false;
            }
         }
         else
         {
            if(this._giftBtn)
            {
               this._giftBtn.mouseEnabled = true;
               this._giftBtn.filters = null;
            }
            if(this._giftLight)
            {
               this._giftLight.visible = true;
            }
         }
      }
      
      private function __onBuyBtnClick(param1:MouseEvent) : void
      {
         this._view = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         BuySingleGoodsView(this._view).goodsID = this._ticketsID[RoomManager.Instance.current.hardLevel];
         if(RoomManager.Instance.current.mapId == 14)
         {
            BuySingleGoodsView(this._view).goodsID = this._ticketsFootballID[RoomManager.Instance.current.hardLevel];
         }
         else if(RoomManager.Instance.current.mapId == 15001)
         {
            BuySingleGoodsView(this._view).goodsID = 201628;
         }
         else if(RoomManager.Instance.current.mapId == 16001)
         {
            BuySingleGoodsView(this._view).goodsID = 201629;
         }
         else
         {
            BuySingleGoodsView(this._view).goodsID = this._ticketsID[RoomManager.Instance.current.hardLevel];
         }
      }
      
      private function __onGiftBtnClick(param1:MouseEvent) : void
      {
         if(RoomManager.Instance.current.mapId == 14)
         {
            ShopGiftsManager.Instance.buy(this._ticketsFootballID[RoomManager.Instance.current.hardLevel],false,2);
         }
         else if(RoomManager.Instance.current.mapId == 15001)
         {
            ShopGiftsManager.Instance.buy(201628,false,2);
         }
         else if(RoomManager.Instance.current.mapId == 16001)
         {
            ShopGiftsManager.Instance.buy(201629,false,2);
         }
         else
         {
            ShopGiftsManager.Instance.buy(this._ticketsID[RoomManager.Instance.current.hardLevel],false,2);
         }
      }
      
      private function removeEvent() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyBtnClick);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__onGiftBtnClick);
      }
      
      private function __onGiftButtonClick(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this._giftLight);
         this._giftLight = null;
      }
      
      public function setLevel(param1:int = -1) : void
      {
         if(param1 > 0 && param1 <= this._ticketsID.length)
         {
            this._level = param1;
         }
      }
      
      public function giftBtnEnable() : void
      {
         var _loc1_:int = 0;
         if(RoomManager.Instance.current.mapId == 14)
         {
            _loc1_ = this._ticketsFootballID[RoomManager.Instance.current.hardLevel];
         }
         else
         {
            _loc1_ = this._ticketsID[RoomManager.Instance.current.hardLevel];
         }
         var _loc2_:ShopItemInfo = ShopManager.Instance.getGoodsByTemplateID(_loc1_);
         if(_loc2_ && String(_loc2_.GoodsID).slice(-2) == "02")
         {
            this._giftBtn.enable = false;
            this._giftLight.visible = false;
            this._giftBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._giftBtn.enable = true;
            this._giftLight.visible = true;
            this._giftBtn.filters = null;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._buyLight);
         this._buyLight = null;
         ObjectUtils.disposeObject(this._giftLight);
         this._giftLight = null;
         this.removeEvent();
         this._view = null;
         if(this._buyBtn.parent)
         {
            this._buyBtn.parent.removeChild(this._buyBtn);
         }
         this._buyBtn = null;
         if(this._giftBtn.parent)
         {
            this._giftBtn.parent.removeChild(this._giftBtn);
         }
         this._giftBtn = null;
         if(this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
         }
         this._bg = null;
      }
   }
}
