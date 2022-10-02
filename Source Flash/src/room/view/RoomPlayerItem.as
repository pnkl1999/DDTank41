package room.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.bagStore.BagStore;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.RoomEvent;
   import ddt.events.WebSpeedEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.FaceContainer;
   import ddt.view.academyCommon.academyIcon.AcademyIcon;
   import ddt.view.character.RoomCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.GradeContainer;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.model.GameInfo;
   import im.IMController;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import vip.VipController;
   
   public class RoomPlayerItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _guild:Bitmap;
      
      private var _hitArea:Sprite;
      
      private var _kickOutBtn:SimpleBitmapButton;
      
      private var _viewInfoBtn:SimpleBitmapButton;
      
      private var _addFriendBtn:SimpleBitmapButton;
      
      private var _hostPic:Bitmap;
      
      private var _guildName:FilterFrameText;
      
      private var _playerName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _signal:ScaleFrameImage;
      
      private var _signalExplain:ScaleFrameImage;
      
      private var _ready:Bitmap;
      
      private var _face:FaceContainer;
      
      private var _chatballview:ChatBallPlayer;
      
      private var _chracter:RoomCharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _academyIcon:AcademyIcon;
      
      private var _badge:Badge;
      
      private var _iconContainer:VBox;
      
      private var _info:RoomPlayer;
      
      private var _opened:Boolean;
      
      private var _place:int;
      
      private var _roomPlayerItemPet:RoomPlayerItemPet;
      
      private var _petHeadFrameBg:Bitmap;
      
      private var _switchInEnabled:Boolean;
      
      private var _characterContainer:Sprite;
      
      public function RoomPlayerItem(param1:int)
      {
         super();
         this._place = param1;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc2_:Point = null;
         this._chatballview = new ChatBallPlayer();
         PositionUtils.setPos(this._chatballview,"room.PlayerItemChatBallPos");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.RoomPlayerItemGBAsset");
         this._bg.setFrame(1);
         addChild(this._bg);
         this._hitArea = ComponentFactory.Instance.creatCustomObject("asset.room.playerItemClickArea");
         var _loc1_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomPlayerItem.hitRect");
         this._hitArea.graphics.beginFill(0,0);
         this._hitArea.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         this._hitArea.graphics.endFill();
         this._hitArea.buttonMode = true;
         addChild(this._hitArea);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("room.playerItemNameTxt");
         this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.RoomPlayerItem.ViewInfoButton");
         this._kickOutBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.RoomPlayerItem.kickOutButton");
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.view.RoomPlayerItem.addFriendButton");
         this._viewInfoBtn.transparentEnable = this._kickOutBtn.transparentEnable = this._addFriendBtn.transparentEnable = true;
         this._addFriendBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.addFriend");
         this._viewInfoBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
         this._kickOutBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom");
         addChild(this._viewInfoBtn);
         addChild(this._kickOutBtn);
         addChild(this._addFriendBtn);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.roomPlayerItem.iconContainer");
         addChild(this._iconContainer);
         this._guildName = ComponentFactory.Instance.creatComponentByStylename("room.playerItemGuildNamtTxt");
         addChild(this._guildName);
         this._guild = ComponentFactory.Instance.creatBitmap("asset.room.view.roomPlayerItemGuildTxtAsset");
         addChild(this._guild);
         this._face = ComponentFactory.Instance.creatCustomObject("asset.room.playerItemFace");
         addChild(this._face);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("room.roomPlayerItem.facePos");
         if(RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
         {
            if(this._place % 2 == 1)
            {
               this._face.scaleX = 1;
               this._face.x = _loc2_.x;
            }
            else
            {
               this._face.scaleX = -1;
               this._face.x = _loc2_.y;
            }
         }
         else
         {
            this._face.scaleX = -1;
            this._face.x = _loc2_.y;
         }
      }
      
      private function updatePet() : void
      {
         if(this._info && this._info.playerInfo && this._info.playerInfo.currentPet && this._info.playerInfo.currentPet.IsEquip)
         {
            if(!this._roomPlayerItemPet)
            {
               this._petHeadFrameBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.playerItem.petHeadFrame");
               PositionUtils.setPos(this._petHeadFrameBg,"asset.ddtroom.playerItem.petHeadFramePos");
               addChild(this._petHeadFrameBg);
               this._roomPlayerItemPet = new RoomPlayerItemPet(this._petHeadFrameBg.width,this._petHeadFrameBg.height);
               PositionUtils.setPos(this._roomPlayerItemPet,"assets.ddtroom.roomPlayerItemPetPos");
               this._roomPlayerItemPet.mouseChildren = false;
               this._roomPlayerItemPet.mouseEnabled = true;
               this._roomPlayerItemPet.useHandCursor = true;
               this._roomPlayerItemPet.buttonMode = true;
               addChild(this._roomPlayerItemPet);
            }
            this._roomPlayerItemPet.updateView(this._info.playerInfo.currentPet);
         }
         else
         {
            this.removePet();
         }
      }
      
      private function removePet() : void
      {
         if(this._petHeadFrameBg)
         {
            ObjectUtils.disposeObject(this._petHeadFrameBg);
         }
         this._petHeadFrameBg = null;
         if(this._roomPlayerItemPet)
         {
            ObjectUtils.disposeObject(this._roomPlayerItemPet);
         }
         this._roomPlayerItemPet = null;
      }
      
      public function set switchInEnabled(param1:Boolean) : void
      {
         this._switchInEnabled = param1;
         if(this._switchInEnabled && this._opened)
         {
            this._hitArea.visible = this._switchInEnabled;
         }
      }
      
      private function initEvents() : void
      {
         this._viewInfoBtn.addEventListener(MouseEvent.CLICK,this.__viewClickHandler);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriendHandler);
         this._kickOutBtn.addEventListener(MouseEvent.CLICK,this.__kickOutHandler);
         this._hitArea.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         RoomManager.Instance.current.addEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         BagStore.instance.addEventListener(BagStore.OPEN_BAGSTORE,this.__openStoreHandler);
         BagStore.instance.addEventListener(BagStore.CLOSE_BAGSTORE,this.__closeStoreHandler);
         RoomManager.Instance.current.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateButton);
         this._chatballview.addEventListener(Event.COMPLETE,this.onComplete);
      }
      
      private function __showExplain(param1:MouseEvent) : void
      {
         this._signalExplain.visible = true;
         this._signalExplain.setFrame(this._signal.getFrame);
      }
      
      private function __hideExplain(param1:MouseEvent) : void
      {
         this._signalExplain.visible = false;
      }
      
      private function __closeStoreHandler(param1:Event) : void
      {
         if(this._chracter)
         {
            this._chracter.playAnimation();
         }
      }
      
      private function __openStoreHandler(param1:Event) : void
      {
         if(this._chracter)
         {
            this._chracter.stopAnimation();
         }
      }
      
      private function removeEvents() : void
      {
         this._viewInfoBtn.removeEventListener(MouseEvent.CLICK,this.__viewClickHandler);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriendHandler);
         this._kickOutBtn.removeEventListener(MouseEvent.CLICK,this.__kickOutHandler);
         this._hitArea.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         RoomManager.Instance.current.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         BagStore.instance.removeEventListener(BagStore.OPEN_BAGSTORE,this.__openStoreHandler);
         BagStore.instance.removeEventListener(BagStore.CLOSE_BAGSTORE,this.__closeStoreHandler);
         RoomManager.Instance.current.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__updateButton);
         if(this._info)
         {
            this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
            this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,this.__updateWebSpeed);
         }
         this._chatballview.removeEventListener(Event.COMPLETE,this.onComplete);
      }
      
      private function __viewClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         PlayerTipManager.show(this._info.playerInfo,localToGlobal(new Point(0,0)).y);
      }
      
      private function __addFriendHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         IMController.Instance.addFriend(this._info.playerInfo.NickName);
      }
      
      private function __kickOutHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         GameInSocketOut.sendGameRoomKick(this._place);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info)
         {
            PlayerInfoViewControl.view(this._info.playerInfo);
         }
         else
         {
            if(this._switchInEnabled && !RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
               GameInSocketOut.sendGameRoomPlaceState(RoomManager.Instance.current.selfRoomPlayer.place,-1,true,this._place);
               return;
            }
            if(this._opened)
            {
               if(RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)
               {
                  if(RoomManager.Instance.canCloseItem(this))
                  {
                     GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(int(0)) : int(int(-1)));
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.position"));
                  }
               }
               else
               {
                  GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(int(0)) : int(int(-1)));
               }
            }
            else if(PlayerManager.Instance.Self.Grade >= 6)
            {
               GameInSocketOut.sendGameRoomPlaceState(this._place,!!this._opened ? int(int(0)) : int(int(-1)));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.cantOpenMuti"));
            }
         }
      }
      
      private function __startHandler(param1:RoomEvent) : void
      {
         this.updateButtons();
      }
      
      private function __updateButton(param1:RoomPlayerEvent) : void
      {
         this.updateButtons();
      }
      
      private function onComplete(param1:Event) : void
      {
         if(this._chatballview.parent)
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
      }
      
      private function __infoStateChange(param1:RoomPlayerEvent) : void
      {
         this.updatePlayerState();
         this.updateButtons();
      }
      
      private function __playerInfoChange(param1:PlayerPropertyEvent) : void
      {
         this.updateInfoView();
      }
      
      private function __getFace(param1:ChatEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         if(_loc2_["playerid"] == this._info.playerInfo.ID)
         {
            this._face.setFace(_loc2_["faceid"]);
         }
         addChild(this._face);
      }
      
      private function __getChat(param1:ChatEvent) : void
      {
         if(this._info == null)
         {
            return;
         }
         var _loc2_:ChatData = ChatData(param1.data).clone();
         if(_loc2_.senderID == this._info.playerInfo.ID && (_loc2_.channel == ChatInputView.CURRENT || _loc2_.channel == ChatInputView.TEAM))
         {
            addChild(this._chatballview);
            _loc2_.msg = Helpers.deCodeString(_loc2_.msg);
            this._chatballview.setText(_loc2_.msg,this._info.playerInfo.paopaoType);
         }
      }
      
      public function set info(param1:RoomPlayer) : void
      {
         var _loc2_:GameInfo = null;
         var _loc3_:GradeContainer = null;
         if(this._info)
         {
            this._info.removeEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
            this._info.webSpeedInfo.removeEventListener(WebSpeedEvent.STATE_CHANE,this.__updateWebSpeed);
            this._info = null;
            this._face.clearFace();
         }
         this._info = param1;
         if(this._info == null)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
               this.switchInEnabled = true;
            }
         }
         if(this._info)
         {
            _loc2_ = GameManager.Instance.Current;
            if(_loc2_ != null && _loc2_.hasNextMission && (RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON))
            {
               _loc2_.viewerToLiving(this._info.playerInfo.ID);
            }
            this._info.addEventListener(RoomPlayerEvent.READY_CHANGE,this.__infoStateChange);
            this._info.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__infoStateChange);
            this._info.playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
            this._info.webSpeedInfo.addEventListener(WebSpeedEvent.STATE_CHANE,this.__updateWebSpeed);
         }
         if(this._info && this._info.isSelf)
         {
            if(PlayerManager.Instance.Self.isUpGradeInGame && PlayerManager.Instance.Self.Grade > 15)
            {
               _loc3_ = new GradeContainer();
               _loc3_.playerGrade();
               _loc3_.x = 50;
               _loc3_.y = 30;
               addChild(_loc3_);
               PlayerManager.Instance.Self.isUpGradeInGame = false;
            }
         }
         this.updateView();
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      private function __updateWebSpeed(param1:WebSpeedEvent) : void
      {
      }
      
      private function updateView() : void
      {
         this.updateBackground();
         this.updateInfoView();
         this.updateButtons();
         this.updatePlayerState();
      }
      
      private function updateBackground() : void
      {
         if(this._info)
         {
            if(RoomManager.Instance.current.isYellowBg())
            {
               this._bg.setFrame(5);
            }
            else
            {
               this._bg.setFrame(this._info.team + 2);
            }
         }
         else
         {
            this._bg.setFrame(!!this._opened ? int(int(1)) : int(int(2)));
            if(this._chatballview.parent)
            {
               this._chatballview.parent.removeChild(this._chatballview);
            }
         }
      }
      
      private function updateInfoView() : void
      {
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._marriedIcon);
         this._marriedIcon = null;
         ObjectUtils.disposeObject(this._academyIcon);
         this._academyIcon = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         if(this._ready && this._ready.visible)
         {
            this._ready.visible = false;
         }
         if(this._info)
         {
            if(this._characterContainer == null)
            {
               if(this._chracter == null)
               {
                  this._chracter = this._info.roomCharater;
               }
               this._info.resetCharacter();
               this._chracter.x = 20;
               this._characterContainer = new Sprite();
               this._characterContainer.addChild(this._chracter);
               this._characterContainer.x = 121;
               this._characterContainer.y = 32;
               this._chracter.show(false,this._info.team == 2 ? int(int(1)) : int(int(-1)));
               this._chracter.setShowLight(true);
               this._chracter.showGun = true;
               this._chracter.playAnimation();
               if(this._info.team == 2)
               {
                  this._characterContainer.x = 11;
               }
               addChildAt(this._characterContainer,1);
            }
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("roomPlayerItemLevelIcon");
               addChild(this._levelIcon);
            }
            this._levelIcon.setInfo(this._info.playerInfo.Grade,this._info.playerInfo.Repute,this._info.playerInfo.WinCount,this._info.playerInfo.TotalCount,this._info.playerInfo.FightPower,this._info.playerInfo.Offer,true,false);
            if(this._info.isSelf)
            {
               this._levelIcon.allowClick();
            }
            if(this._info.playerInfo.ID == PlayerManager.Instance.Self.ID || this._info.playerInfo.IsVIP)
            {
               if(this._vipIcon == null)
               {
                  this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.room.VipIcon");
                  this._vipIcon.setInfo(this._info.playerInfo);
                  this._iconContainer.addChild(this._vipIcon);
                  if(!this._info.playerInfo.IsVIP)
                  {
                     this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                  }
                  else
                  {
                     this._vipIcon.filters = null;
                  }
               }
            }
            else if(this._vipIcon)
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            this._playerName.text = this._info.playerInfo.NickName;
            if(this._info.playerInfo.IsVIP)
            {
               ObjectUtils.disposeObject(this._vipName);
               this._vipName = VipController.instance.getVipNameTxt(106,this._info.playerInfo.typeVIP);
               this._vipName.x = this._playerName.x;
               this._vipName.y = this._playerName.y;
               this._vipName.text = this._playerName.text;
               addChild(this._vipName);
               DisplayUtils.removeDisplay(this._playerName);
            }
            else
            {
               addChild(this._playerName);
               DisplayUtils.removeDisplay(this._vipName);
            }
            this._guildName.text = !!Boolean(this._info.playerInfo.ConsortiaName) ? this._info.playerInfo.ConsortiaName : "";
            this._guild.visible = true;
            if(this._info.isReady)
            {
               if(!this._ready)
               {
                  this._ready = ComponentFactory.Instance.creatBitmap("asset.room.view.roomPlayerItemReadyIconAsset");
               }
               addChild(this._ready);
               this._ready.visible = true;
            }
            else if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
            if(this._info.playerInfo.SpouseID > 0)
            {
               if(this._marriedIcon == null)
               {
                  this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.room.MarriedIcon");
                  this._iconContainer.addChild(this._marriedIcon);
               }
               this._marriedIcon.tipData = {
                  "nickName":this._info.playerInfo.SpouseName,
                  "gender":this._info.playerInfo.Sex
               };
            }
            else
            {
               if(this._marriedIcon != null)
               {
                  this._marriedIcon.dispose();
               }
               this._marriedIcon = null;
            }
            if(this._info.playerInfo.shouldShowAcademyIcon())
            {
               if(!this._academyIcon)
               {
                  this._academyIcon = ComponentFactory.Instance.creatCustomObject("room.roomPlayerItem.AcademyIcon");
                  this._iconContainer.addChild(this._academyIcon);
               }
               this._academyIcon.tipData = this._info.playerInfo;
            }
            else if(this._academyIcon)
            {
               this._academyIcon.dispose();
               this._academyIcon = null;
            }
            if(this._info.playerInfo.ConsortiaID > 0 && this._info.playerInfo.badgeID > 0)
            {
               if(this._badge == null)
               {
                  this._badge = new Badge();
                  this._badge.showTip = true;
                  this._iconContainer.addChild(this._badge);
               }
               this._badge.badgeID = this._info.playerInfo.badgeID;
               this._badge.tipData = this._info.playerInfo.ConsortiaName;
            }
            else
            {
               if(this._badge)
               {
                  this._badge.dispose();
               }
               this._badge = null;
            }
            this.updatePet();
         }
         else
         {
            if(this._characterContainer)
            {
               removeChild(this._characterContainer);
            }
            if(this._chracter != null && this._characterContainer.contains(this._chracter))
            {
               this._characterContainer.removeChild(this._chracter);
            }
            this._characterContainer = null;
            this._chracter = null;
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._marriedIcon);
            this._marriedIcon = null;
            ObjectUtils.disposeObject(this._academyIcon);
            this._academyIcon = null;
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            this._guildName.text = "";
            this._guild.visible = false;
            this._playerName.text = "";
            this.removePet();
            DisplayUtils.removeDisplay(this._vipName);
         }
      }
      
      public function updateButtons() : void
      {
         if(this._info)
         {
            this._viewInfoBtn.visible = this._addFriendBtn.visible = this._kickOutBtn.visible = this._hitArea.visible = true;
            if(this._info.isSelf)
            {
               this._kickOutBtn.enable = false;
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
               if(RoomManager.Instance.current.started)
               {
                  this._kickOutBtn.enable = false;
               }
               else
               {
                  this._kickOutBtn.enable = true;
               }
            }
            else
            {
               this._kickOutBtn.enable = false;
            }
         }
         else
         {
            if(RoomManager.Instance.current.started)
            {
               this._hitArea.visible = false;
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._switchInEnabled && this._opened)
            {
               this._hitArea.visible = true;
            }
            else if(RoomManager.Instance.current.type == RoomInfo.SCORE_ROOM || RoomManager.Instance.current.type == RoomInfo.RANK_ROOM)
            {
               this._hitArea.visible = false;
            }
            else
            {
               this._hitArea.visible = RoomManager.Instance.current.selfRoomPlayer.isHost;
            }
            this._viewInfoBtn.visible = this._addFriendBtn.visible = this._kickOutBtn.visible = false;
         }
      }
      
      private function updatePlayerState() : void
      {
         if(this._info)
         {
            if(this._info.isReady)
            {
               if(!this._ready)
               {
                  this._ready = ComponentFactory.Instance.creatBitmap("asset.room.view.roomPlayerItemReadyIconAsset");
               }
               addChild(this._ready);
               this._ready.visible = true;
            }
            else if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
            if(this._info.isHost)
            {
               if(!this._hostPic)
               {
                  this._hostPic = ComponentFactory.Instance.creatBitmap("asset.room.view.roomPlayerItemHostAsset");
               }
               addChild(this._hostPic);
               this._hostPic.visible = true;
            }
            else if(this._hostPic && this._hostPic.visible)
            {
               this._hostPic.visible = false;
            }
         }
         else
         {
            if(this._hostPic && this._hostPic.visible)
            {
               this._hostPic.visible = false;
            }
            if(this._ready && this._ready.visible)
            {
               this._ready.visible = false;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._bg.dispose();
         this._bg = null;
         this._kickOutBtn.dispose();
         this._kickOutBtn = null;
         this._viewInfoBtn.dispose();
         this._viewInfoBtn = null;
         this._addFriendBtn.dispose();
         this._addFriendBtn = null;
         if(this._hostPic)
         {
            if(this._hostPic.parent)
            {
               this._hostPic.parent.removeChild(this._hostPic);
            }
            this._hostPic.bitmapData.dispose();
         }
         this._hostPic = null;
         this._guildName.dispose();
         this._guildName = null;
         removeChild(this._guild);
         this._guild.bitmapData.dispose();
         this._guild = null;
         this._playerName.dispose();
         this._playerName = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this._signal = null;
         this._signalExplain = null;
         if(this._ready)
         {
            removeChild(this._ready);
            this._ready.bitmapData.dispose();
         }
         this._ready = null;
         if(this._characterContainer)
         {
            removeChild(this._characterContainer);
         }
         if(this._chracter != null && this._characterContainer.contains(this._chracter))
         {
            this._characterContainer.removeChild(this._chracter);
         }
         this._characterContainer = null;
         this._chracter = null;
         if(this._levelIcon)
         {
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(this._vipIcon)
         {
            this._vipIcon.dispose();
         }
         this._vipIcon = null;
         if(this._marriedIcon)
         {
            this._marriedIcon.dispose();
         }
         this._marriedIcon = null;
         if(this._face)
         {
            this._face.dispose();
         }
         this._face = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         if(this._chatballview)
         {
            this._chatballview.dispose();
         }
         this._chatballview = null;
         ObjectUtils.disposeObject(this._academyIcon);
         this._academyIcon = null;
         this._info = null;
         this.removePet();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get opened() : Boolean
      {
         return this._opened;
      }
      
      public function set opened(param1:Boolean) : void
      {
         this._opened = param1;
         this.updateView();
      }
   }
}
