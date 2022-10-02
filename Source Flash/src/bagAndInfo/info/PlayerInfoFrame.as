package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.view.GiftInfoView;
   import texpSystem.view.TexpInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
       
      
      private var _BG:Scale9CornerImage;
      
      private var _view:PlayerInfoView;
      
      private var _texpView:TexpInfoView;
      
      private var _giftView:GiftInfoView;
      
      private var _cardEquip:CardEquipView;
      
      private var _info:PlayerInfo;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _giftBtn:SelectedButton;
      
      private var _cardBtn:SelectedButton;
      
      private var _openTexp:Boolean;
      
      private var _openGift:Boolean;
      
      private var _openCard:Boolean;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardBtn");
         PositionUtils.setPos(this._infoBtn,"PlayerInfoFrame.infoBtnPos");
         PositionUtils.setPos(this._texpBtn,"PlayerInfoFrame.texpBtnPos");
         PositionUtils.setPos(this._giftBtn,"PlayerInfoFrame.giftBtnPos");
         PositionUtils.setPos(this._cardBtn,"PlayerInfoFrame.cardBtnPos");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._giftBtn);
         addToContent(this._cardBtn);
         addToContent(this._texpBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      private function __soundPlayer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case BagAndGiftFrame.GIFTVIEW:
               if(!this._openGift)
               {
                  if(this._info.ID != PlayerManager.Instance.Self.ID)
                  {
                     SocketManager.Instance.out.sendPlayerGift(this._info.ID);
                  }
                  this._openGift = true;
               }
               this.showGiftFrame();
               break;
            case BagAndGiftFrame.CARDVIEW:
               if(!this._openCard)
               {
                  SocketManager.Instance.out.getPlayerCardInfo(this._info.ID);
                  this._openCard = true;
               }
               this.showCardEquip();
               break;
            case BagAndGiftFrame.TEXPVIEW:
               this.showTexpFrame();
         }
      }
      
      private function setVisible(param1:int) : void
      {
         this._view.visible = param1 == BagAndGiftFrame.BAGANDINFO || param1 == BagAndGiftFrame.CARDVIEW;
         if(this._texpView)
         {
            this._texpView.visible = param1 == BagAndGiftFrame.TEXPVIEW;
         }
         if(this._giftView)
         {
            this._giftView.visible = param1 == BagAndGiftFrame.GIFTVIEW;
         }
         if(this._view.visible)
         {
            this._view.switchShowII(param1 == BagAndGiftFrame.CARDVIEW);
         }
      }
      
      private function showCardEquip() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.CARDVIEW);
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showTexpFrame() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoView.main");
               addToContent(this._texpView);
            }
            if(this._info)
            {
               this._texpView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.TEXPVIEW);
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
            return;
         }
      }
      
      private function __createTexp(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpFrame();
         }
      }
      
      private function showGiftFrame() : void
      {
         try
         {
            if(this._giftView == null)
            {
               this._giftView = new GiftInfoView();
               PositionUtils.setPos(this._giftView,"PlayerInfoFrame.giftViewPos");
               addToContent(this._giftView);
            }
            GiftController.Instance.canActive = false;
            if(this._info)
            {
               this._giftView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.GIFTVIEW);
            return;
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GIFT_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createGift);
            return;
         }
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GIFT_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            this.showGiftFrame();
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(this._view)
         {
            this._view.info = this._info;
         }
         if(this._texpView)
         {
            this._texpView.info = this._info;
         }
         if(this._giftView)
         {
            this._giftView.info = this._info;
         }
         if(this._info.Grade < 16 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._giftBtn.enable = false;
         }
         else
         {
            this._giftBtn.enable = true;
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._cardBtn.enable = false;
         }
         else
         {
            this._cardBtn.enable = true;
         }
         if(this._info.Grade < 10 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._texpBtn.enable = false;
         }
         else
         {
            this._texpBtn.enable = true;
         }
      }
      
      public function setAchivEnable(param1:Boolean) : void
      {
         this._view.setAchvEnable(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._infoBtn)
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(this._texpBtn)
         {
            ObjectUtils.disposeObject(this._texpBtn);
         }
         this._texpBtn = null;
         if(this._giftBtn)
         {
            ObjectUtils.disposeObject(this._giftBtn);
         }
         this._giftBtn = null;
         if(this._cardBtn)
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(this._view)
         {
            this._view.dispose();
         }
         this._view = null;
         if(this._texpView)
         {
            this._texpView.dispose();
         }
         this._texpView = null;
         if(this._giftView)
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         PlayerInfoViewControl.clearView();
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
