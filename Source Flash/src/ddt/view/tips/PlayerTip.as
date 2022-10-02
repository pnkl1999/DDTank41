package ddt.view.tips
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.info.PlayerInfoViewControl;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.player.BasePlayer;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.system.System;
   import flash.utils.Timer;
   import im.IMController;
   import im.IMFriendPhotoCell;
   import room.RoomManager;
   import vip.VipController;
   
   public class PlayerTip extends Sprite implements Disposeable
   {
      
      public static const CHALLENGE:String = "challenge";
      
      public static const X_MARGINAL:int = 10;
      
      public static const Y_MARGINAL:int = 20;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var btnChallenge:IconButton;
      
      private var _chanllageEnable:Boolean = false;
      
      private var _currentData:Object;
      
      private var _info:BasePlayer;
      
      private var _btnAddFriend:IconButton;
      
      private var _btnCopyName:IconButton;
      
      private var _btnDemote:TextButton;
      
      private var _btnExpel:TextButton;
      
      private var _btnInvite:TextButton;
      
      private var _btnPromote:TextButton;
      
      private var _btnPresentGift:IconButton;
      
      private var _btnPrivateChat:IconButton;
      
      private var _btnPropose:BaseButton;
      
      private var _btnViewInfo:IconButton;
      
      private var _btnAcademy:IconButton;
      
      private var _One_one_chat:IconButton;
      
      private var _transferFriend:IconButton;
      
      private var _nameTxt:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _clubTxt:FilterFrameText;
      
      private var _iconBtnsContainer:VBox;
      
      private var _bottomBtnsContainer:Sprite;
      
      private var _bottomBg:Bitmap;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _photo:IMFriendPhotoCell;
      
      private var _friendGroup:FriendGroupTip;
      
      private var _timer:Timer;
      
      private var _friendOver:Boolean = false;
      
      public function PlayerTip()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bottomBtnsContainer = new Sprite();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("playerTip.BG");
         this._line = ComponentFactory.Instance.creatComponentByStylename("playerTip.line");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("playerTip.NameTxt");
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("playerTip.VipIcon");
         this._clubTxt = ComponentFactory.Instance.creatComponentByStylename("playerTip.ClubTxt");
         this._iconBtnsContainer = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemContainer");
         this.btnChallenge = ComponentFactory.Instance.creatComponentByStylename("playerTip.Challenge");
         this._btnPresentGift = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemPresentGift");
         this._btnAddFriend = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemMakeFriend");
         this._btnPrivateChat = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemPrivateChat");
         this._btnCopyName = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemCopyName");
         this._btnViewInfo = ComponentFactory.Instance.creatComponentByStylename("playerTip.ItemInfo");
         this._btnAcademy = ComponentFactory.Instance.creatComponentByStylename("playerTip.academyIcon");
         this._One_one_chat = ComponentFactory.Instance.creatComponentByStylename("playerTip.OneOnOneChat");
         this._transferFriend = ComponentFactory.Instance.creatComponentByStylename("PlayerTip.transferFriend");
         this._btnPropose = ComponentFactory.Instance.creatComponentByStylename("playerTip.ProposeBtn");
         this._bottomBg = ComponentFactory.Instance.creatBitmap("asset.playerTip.PlayerTipBottomBg");
         this._btnInvite = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipInviteBtn");
         this._btnPromote = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipPromoteBtn");
         this._btnDemote = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipDemoteBtn");
         this._btnExpel = ComponentFactory.Instance.creatComponentByStylename("playerTip.PlayerTipExpelBtn");
         PositionUtils.setPos(this._bottomBtnsContainer,"playerTip.BottomPos");
         this._btnInvite.text = LanguageMgr.GetTranslation("tank.menu.Invite");
         this._btnPromote.text = LanguageMgr.GetTranslation("tank.menu.Up");
         this._btnDemote.text = LanguageMgr.GetTranslation("tank.menu.Down");
         this._btnExpel.text = LanguageMgr.GetTranslation("tank.menu.fire");
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
         addChild(this._bg);
         addChild(this._line);
         addChild(this._clubTxt);
         this._iconBtnsContainer.addChild(this.btnChallenge);
         this._iconBtnsContainer.addChild(this._btnPresentGift);
         this._iconBtnsContainer.addChild(this._btnAddFriend);
         this._iconBtnsContainer.addChild(this._btnPrivateChat);
         this._iconBtnsContainer.addChild(this._btnCopyName);
         this._iconBtnsContainer.addChild(this._btnViewInfo);
         this._iconBtnsContainer.addChild(this._btnAcademy);
         this._iconBtnsContainer.addChild(this._One_one_chat);
         this._iconBtnsContainer.addChild(this._transferFriend);
         addChild(this._iconBtnsContainer);
         if(PathManager.solveChurchEnable())
         {
            addChild(this._btnPropose);
         }
         this._bottomBtnsContainer.addChild(this._bottomBg);
         this._bottomBtnsContainer.addChild(this._btnInvite);
         this._bottomBtnsContainer.addChild(this._btnPromote);
         this._bottomBtnsContainer.addChild(this._btnDemote);
         this._bottomBtnsContainer.addChild(this._btnExpel);
         addChild(this._bottomBtnsContainer);
         this._friendGroup = new FriendGroupTip();
         PositionUtils.setPos(this._friendGroup,"groupTip.pos");
         this._timer = new Timer(200);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this.btnChallenge.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnPropose.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnInvite.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnPromote.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnDemote.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnExpel.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnPresentGift.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnAddFriend.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnPrivateChat.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnCopyName.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnViewInfo.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._btnAcademy.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._One_one_chat.addEventListener(MouseEvent.CLICK,this.__buttonsClick);
         this._transferFriend.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this._transferFriend.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this._friendGroup.addEventListener(MouseEvent.MOUSE_OVER,this.__friendOverHandler);
         this._friendGroup.addEventListener(MouseEvent.MOUSE_OUT,this.__friendOutHandler);
         this._friendGroup.addEventListener(MouseEvent.CLICK,this.__friendClickHandler);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._friendGroup.addEventListener(Event.ADDED_TO_STAGE,this.__groupAddToStage);
      }
      
      protected function __groupAddToStage(param1:Event) : void
      {
         PositionUtils.setPos(this._friendGroup,"groupTip.pos");
         if(this.y + 211 + this._friendGroup.height > StageReferance.stageHeight)
         {
            this._friendGroup.y = StageReferance.stageHeight - this._friendGroup.height - this.y;
         }
      }
      
      protected function __friendClickHandler(param1:MouseEvent) : void
      {
         removeChild(this._friendGroup);
         this._timer.stop();
         this.hide();
      }
      
      protected function __friendOverHandler(param1:MouseEvent) : void
      {
         this._friendOver = true;
      }
      
      protected function __friendOutHandler(param1:MouseEvent) : void
      {
         this._friendOver = false;
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         if(!this._friendOver)
         {
            removeChild(this._friendGroup);
            this._timer.stop();
         }
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._friendGroup.update(this._info.NickName);
         addChild(this._friendGroup);
         this._timer.stop();
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      public function dispose() : void
      {
      }
      
      public function hide() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get info() : BasePlayer
      {
         return this._info;
      }
      
      public function set playerInfo(param1:BasePlayer) : void
      {
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropChange);
         }
         this._info = param1;
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPropChange);
         this.update();
      }
      
      public function proposeEnable(param1:Boolean) : void
      {
         this._btnPropose.enable = param1;
      }
      
      public function setSelfDisable(param1:Boolean) : void
      {
         if(param1)
         {
            this._btnPrivateChat.enable = this._btnAddFriend.enable = this._btnPropose.enable = this.btnChallenge.enable = this._btnPresentGift.enable = false;
            this._btnPrivateChat.alpha = this._btnAddFriend.alpha = this._btnPropose.alpha = this.btnChallenge.alpha = this._btnPresentGift.alpha = 0.7;
         }
         else
         {
            if(this.checkShowPresent())
            {
               this._btnPresentGift.enable = false;
               this._btnPresentGift.alpha = 0.7;
            }
            else
            {
               this._btnPresentGift.enable = true;
               this._btnPresentGift.alpha = 1;
            }
            this._btnPrivateChat.enable = this._btnAddFriend.enable = this._btnPropose.enable = this.btnChallenge.enable = true;
            this._btnPrivateChat.alpha = this._btnAddFriend.alpha = this._btnPropose.alpha = this.btnChallenge.alpha = 1;
         }
      }
      
      private function checkShowPresent() : Boolean
      {
         if(PlayerManager.Instance.Self.Grade < 16)
         {
            return true;
         }
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.AUCTION || StateManager.currentStateType == StateType.SHOP || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            return true;
         }
         if(!StateManager.isExitRoom(StateManager.currentStateType))
         {
            if(RoomManager.Instance.findRoomPlayer(PlayerManager.Instance.Self.ID).isReady || RoomManager.Instance.findRoomPlayer(PlayerManager.Instance.Self.ID).isViewer || RoomManager.Instance.current.started)
            {
               return true;
            }
         }
         return false;
      }
      
      public function show(param1:int) : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER);
         var _loc2_:Point = new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY);
         x = _loc2_.x - this._bg.width;
         y = param1 - this._bg.height - (!!this._bottomBtnsContainer.visible ? this._bottomBg.height : 0);
         if(x < X_MARGINAL)
         {
            x = X_MARGINAL;
         }
         if(y < Y_MARGINAL)
         {
            y = Y_MARGINAL;
         }
         this._btnPropose.enable = !PlayerManager.Instance.Self.IsMarried && !this._info.IsMarried && PlayerManager.Instance.Self.Sex != this._info.Sex;
      }
      
      public function update() : void
      {
         var _loc1_:BasePlayer = null;
         if(this._info)
         {
            this._nameTxt.text = this._info.NickName;
            if(this._info.ID == PlayerManager.Instance.Self.ID)
            {
               _loc1_ = PlayerManager.Instance.Self;
            }
            else
            {
               _loc1_ = this._info;
            }
            if(_loc1_.IsVIP)
            {
               ObjectUtils.disposeObject(this._vipName);
               this._vipName = VipController.instance.getVipNameTxt(138,_loc1_.typeVIP);
               this._vipName.x = this._nameTxt.x;
               this._vipName.y = this._nameTxt.y;
               this._vipName.text = this._nameTxt.text;
               addChild(this._vipName);
               DisplayUtils.removeDisplay(this._nameTxt);
            }
            else
            {
               addChild(this._nameTxt);
               DisplayUtils.removeDisplay(this._vipName);
            }
            if(_loc1_.ID == PlayerManager.Instance.Self.ID || _loc1_.IsVIP)
            {
               this._vipIcon.setInfo(_loc1_);
               if(_loc1_.IsVIP || PlayerManager.Instance.Self.IsVIP)
               {
                  this._vipIcon.filters = null;
               }
               else
               {
                  this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               addChild(this._vipIcon);
            }
            else if(contains(this._vipIcon))
            {
               removeChild(this._vipIcon);
            }
            this._clubTxt.text = LanguageMgr.GetTranslation("tank.menu.ClubName") + (!!Boolean(_loc1_.ConsortiaName) ? _loc1_.ConsortiaName : "");
         }
         else
         {
            this._nameTxt.text = this._vipName.text = this._clubTxt.text = "";
         }
         if(_loc1_.ID == PlayerManager.Instance.Self.ID || _loc1_.Grade < 5 || PlayerManager.Instance.Self.Grade < 5)
         {
            this._One_one_chat.enable = false;
            this._One_one_chat.alpha = 0.7;
         }
         else
         {
            this._One_one_chat.enable = true;
            this._One_one_chat.alpha = 1;
         }
         if(_loc1_.ID == PlayerManager.Instance.Self.ID)
         {
            this.btnChallenge.enable = false;
         }
         else
         {
            this.btnChallenge.enable = StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON_LIST ? Boolean(Boolean(true)) : Boolean(Boolean(false));
            if(this.btnChallenge.enable)
            {
               this.btnChallenge.enable = PlayerManager.Instance.Self.Grade >= 12;
            }
            if(!this.btnChallenge.enable)
            {
               this.btnChallenge.alpha = 0.7;
            }
            else
            {
               this.btnChallenge.alpha = 1;
            }
         }
         if(PlayerManager.Instance.hasInFriendList(this._info.ID) && this._info.ID != PlayerManager.Instance.Self.ID)
         {
            this._transferFriend.enable = true;
            this._transferFriend.alpha = 1;
         }
         else
         {
            this._transferFriend.enable = false;
            this._transferFriend.alpha = 0.7;
         }
         if(_loc1_ && _loc1_.DutyLevel > PlayerManager.Instance.Self.DutyLevel && _loc1_.ID != PlayerManager.Instance.Self.ID)
         {
            if(_loc1_.ConsortiaID != 0 && _loc1_.ConsortiaID == PlayerManager.Instance.Self.ConsortiaID)
            {
               this._btnExpel.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._6_Expel);
               this._btnExpel.enable = true;
               this._btnPromote.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._12_UpGrade);
               this._btnPromote.enable = _loc1_.DutyLevel != 2;
               this._btnDemote.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._12_UpGrade);
               this._btnDemote.enable = _loc1_.DutyLevel != 5;
               this._btnInvite.visible = false;
            }
            else
            {
               this._btnPromote.visible = false;
               this._btnDemote.visible = false;
               this._btnExpel.visible = false;
            }
            this._bottomBtnsContainer.visible = this._btnExpel.visible || this._btnInvite.visible || this._btnPromote.visible || this._btnDemote.visible;
         }
         else
         {
            this._btnPromote.visible = false;
            this._btnDemote.visible = false;
            this._btnExpel.visible = false;
            this._bottomBtnsContainer.visible = false;
            if(_loc1_.ConsortiaID == 0 && PlayerManager.Instance.Self.ConsortiaID != 0 && _loc1_.ConsortiaName == "" && _loc1_.ID != PlayerManager.Instance.Self.ID)
            {
               this._btnInvite.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._2_Invite) && _loc1_.ConsortiaID == 0;
               this._bottomBtnsContainer.visible = this._btnInvite.visible;
            }
         }
         if((_loc1_.apprenticeshipState == AcademyManager.NONE_STATE || _loc1_.apprenticeshipState == AcademyManager.MASTER_STATE) && _loc1_.ID != PlayerManager.Instance.Self.ID && _loc1_.ID != PlayerManager.Instance.Self.masterID && _loc1_.Grade >= AcademyManager.TARGET_PLAYER_MIN_LEVEL)
         {
            this._btnAcademy.enable = true;
            this._btnAcademy.alpha = 1;
         }
         else
         {
            this._btnAcademy.enable = false;
            this._btnAcademy.alpha = 0.7;
         }
         if(PlayerManager.isShowPHP)
         {
            if(!this._photo)
            {
               this._photo = new IMFriendPhotoCell();
               PositionUtils.setPos(this._photo,"playerTip.PhotoPos");
               addChild(this._photo);
            }
            this._photo.userID = String(_loc1_.LoginName);
         }
      }
      
      private function __buttonsClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(this._info)
         {
            switch(param1.currentTarget)
            {
               case this._btnPromote:
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  SocketManager.Instance.out.sendConsortiaMemberGrade(this._info.ID,true);
                  break;
               case this._btnDemote:
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  SocketManager.Instance.out.sendConsortiaMemberGrade(this._info.ID,false);
                  break;
               case this._btnExpel:
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.DeleteMemberFrame.titleText"),LanguageMgr.GetTranslation("tank.menu.fireConfirm",this._info.NickName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
                  break;
               case this._btnInvite:
                  if(PlayerManager.Instance.Self.bagLocked)
                  {
                     BaglockedManager.Instance.show();
                     return;
                  }
                  if(this._info.Grade < 7)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
                  }
                  else
                  {
                     SocketManager.Instance.out.sendConsortiaInvate(this._info.NickName);
                  }
                  break;
               case this._btnPropose:
                  ChurchManager.instance.sendValidateMarry(this._info);
                  break;
               case this.btnChallenge:
                  dispatchEvent(new Event(CHALLENGE));
                  break;
               case this._btnPrivateChat:
                  this.hide();
                  ChatManager.Instance.privateChatTo(this._info.NickName,this._info.ID);
                  break;
               case this._btnViewInfo:
                  this.hide();
                  PlayerInfoViewControl.viewByID(this._info.ID);
                  PlayerInfoViewControl.isOpenFromBag = false;
                  break;
               case this._btnAddFriend:
                  this.hide();
                  IMController.Instance.addFriend(this._info.NickName);
                  break;
               case this._btnCopyName:
                  System.setClipboard(this._info.NickName);
                  break;
               case this._btnPresentGift:
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW,this._info.NickName);
                  break;
               case this._btnAcademy:
                  this.requestApprentice();
                  break;
               case this._One_one_chat:
                  this.hide();
                  IMController.Instance.alertPrivateFrame(this._info.ID);
            }
         }
      }
      
      private function requestApprentice() : void
      {
         if(AcademyManager.Instance.compareState(this._info,PlayerManager.Instance.Self))
         {
            if(PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN)
            {
               if(AcademyManager.Instance.isFreezes(false))
               {
                  AcademyFrameManager.Instance.showAcademyRequestApprenticeFrame(this._info);
               }
            }
            else if(AcademyManager.Instance.isFreezes(true))
            {
               AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._info);
            }
         }
      }
      
      private function lookUpEffort() : void
      {
         if(PlayerManager.Instance.Self.ID != this._info.ID)
         {
            EffortManager.Instance.lookUpEffort(this._info.ID);
         }
         else if(!EffortManager.Instance.getMainFrameVisible())
         {
            EffortManager.Instance.isSelf = true;
            EffortManager.Instance.switchVisible();
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendConsortiaOut(this._info.ID);
         }
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function __mouseClick(param1:Event) : void
      {
         this.hide();
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
      }
      
      private function __onPropChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["DutyLevel"])
         {
            this._btnPromote.enable = this._info.DutyLevel != 2;
            this._btnDemote.enable = this._info.DutyLevel != 5;
            this._btnExpel.enable = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._6_Expel);
         }
      }
      
      private function __sendBandChat(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendForbidSpeak(this._info.ID,true);
      }
      
      private function __sendNoBandChat(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendForbidSpeak(this._info.ID,false);
      }
      
      private function ok() : void
      {
         SocketManager.Instance.out.sendConsortiaOut(this._info.ID);
      }
   }
}
