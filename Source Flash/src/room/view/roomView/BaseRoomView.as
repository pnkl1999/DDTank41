package room.view.roomView
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.RoomEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import invite.InviteFrame;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.RoomRightPropView;
   import room.view.RoomViewerItem;
   import trainer.controller.NewHandQueue;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class BaseRoomView extends Sprite implements Disposeable
   {
      
      protected static const HURRY_UP_TIME:int = 30;
      
      protected static const KICK_TIME:int = 60;
      
      protected static const KICK_TIMEII:int = 300;
      
      protected static const KICK_TIMEIII:int = 1200;
       
      
      protected var _hostTimer:Timer;
      
      protected var _normalTimer:Timer;
      
      protected var _info:RoomInfo;
      
      protected var _roomPropView:RoomRightPropView;
      
      protected var _startBtn:MovieClip;
      
      protected var _prepareBtn:MovieClip;
      
      protected var _cancelBtn:SimpleBitmapButton;
      
      protected var _inviteBtn:SimpleBitmapButton;
      
      protected var _inviteFrame:InviteFrame;
      
      protected var _startInvite:Boolean = false;
      
      protected var _playerItems:Array;
      
      protected var _viewerItems:Vector.<RoomViewerItem>;
      
      public function BaseRoomView(param1:RoomInfo)
      {
         super();
         this._info = param1;
         this.initTimer();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         this._startBtn = ComponentFactory.Instance.creatCustomObject("room.startButton");
         addChild(this._startBtn);
         this._prepareBtn = ComponentFactory.Instance.creatCustomObject("room.prepButton");
         addChild(this._prepareBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.cancelButton");
         addChild(this._cancelBtn);
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.inviteButton");
         addChild(this._inviteBtn);
         this._roomPropView = ComponentFactory.Instance.creatCustomObject("asset.room.roomPropView");
         addChild(this._roomPropView);
         this._prepareBtn.buttonMode = true;
         this._startBtn.buttonMode = true;
         this.initTileList();
         this.initPlayerItems();
         this.updateButtons();
      }
      
      private function initTimer() : void
      {
         this._hostTimer = new Timer(1000);
         this._normalTimer = new Timer(1000);
         if(!this._info || !this._info.selfRoomPlayer)
         {
            return;
         }
         if(!this._info.selfRoomPlayer.isHost)
         {
            this.startNormalTimer();
         }
         else if(this._info.isAllReady())
         {
            this.startHostTimer();
         }
      }
      
      protected function updateButtons() : void
      {
         this.updateTimer();
         this._startBtn.visible = this._info.selfRoomPlayer.isHost && !this._info.started;
         this._prepareBtn.visible = !this._info.selfRoomPlayer.isHost && !this._info.selfRoomPlayer.isReady;
         this._cancelBtn.visible = !!this._info.selfRoomPlayer.isHost ? Boolean(Boolean(this._info.started)) : Boolean(Boolean(this._info.selfRoomPlayer.isReady));
         this._cancelBtn.enable = this._info.selfRoomPlayer.isHost || !this._info.started;
         this._inviteBtn.enable = !this._info.started;
         if(this._info.isAllReady())
         {
            this._startBtn.addEventListener(MouseEvent.CLICK,this.__startClick);
            this._startBtn.filters = null;
            this._startBtn.play();
            this._startBtn.buttonMode = true;
         }
         else
         {
            this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startClick);
            this._startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            this._startBtn.gotoAndStop(1);
            this._startBtn.buttonMode = false;
         }
         if(this._info.selfRoomPlayer.isViewer)
         {
            this._prepareBtn.visible = false;
            this._cancelBtn.visible = true;
            this._cancelBtn.enable = false;
         }
      }
      
      protected function initTileList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomViewerItem = null;
         this._playerItems = [];
         if(this.isViewerRoom)
         {
            this._viewerItems = new Vector.<RoomViewerItem>();
            _loc1_ = 8;
            while(_loc1_ < 10)
            {
               if(this._info.type == RoomInfo.MATCH_ROOM)
               {
                  _loc2_ = new RoomViewerItem(_loc1_);
               }
               else
               {
                  _loc2_ = new RoomViewerItem(_loc1_,RoomViewerItem.SHORT);
               }
               this._viewerItems.push(_loc2_);
               _loc1_++;
            }
         }
      }
      
      protected function get isViewerRoom() : Boolean
      {
         return this._info.type == RoomInfo.CHALLENGE_ROOM || this._info.type == RoomInfo.MATCH_ROOM || this._info.type == RoomInfo.DUNGEON_ROOM || this._info.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._info.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || this._info.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || this._info.type == 47 || this._info.type == 48;
      }
      
      protected function initPlayerItems() : void
      {
         var _loc2_:RoomPlayerItem = null;
         var _loc3_:RoomViewerItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._playerItems.length)
         {
            _loc2_ = this._playerItems[_loc1_] as RoomPlayerItem;
            _loc2_.info = this._info.findPlayerByPlace(_loc1_);
            _loc2_.opened = this._info.placesState[_loc1_] != 0;
            _loc1_++;
         }
         if(this.isViewerRoom)
         {
            _loc1_ = 0;
            while(_loc1_ < 2)
            {
               if(this._viewerItems && this._viewerItems[_loc1_])
               {
                  _loc3_ = this._viewerItems[_loc1_] as RoomViewerItem;
                  _loc3_.info = this._info.findPlayerByPlace(_loc1_ + 8);
                  _loc3_.opened = this._info.placesState[_loc1_ + 8] != 0;
               }
               _loc1_++;
            }
         }
      }
      
      protected function initEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomViewerItem = null;
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__inviteClick);
         this._info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__updatePlayerItems);
         this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__updateState);
         this._info.addEventListener(RoomEvent.ADD_PLAYER,this.__addPlayer);
         this._info.addEventListener(RoomEvent.REMOVE_PLAYER,this.__removePlayer);
         this._info.addEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__startClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelClick);
         this._prepareBtn.addEventListener(MouseEvent.CLICK,this.__prepareClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(this.isViewerRoom)
         {
            _loc1_ = 0;
            while(_loc1_ < 2)
            {
               if(this._viewerItems && this._viewerItems[_loc1_])
               {
                  _loc2_ = this._viewerItems[_loc1_];
                  this._viewerItems[_loc1_].addEventListener(RoomEvent.VIEWER_ITEM_INFO_SET,this.__switchClickEnabled);
               }
               _loc1_++;
            }
         }
      }
      
      private function __switchClickEnabled(param1:RoomEvent) : void
      {
         var _loc3_:RoomPlayerItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._playerItems.length)
         {
            _loc3_ = this._playerItems[_loc2_] as RoomPlayerItem;
            _loc3_.switchInEnabled = param1.params[0] == 1;
            _loc2_++;
         }
      }
      
      private function __loadWeakGuild(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(PlayerManager.Instance.Self.Grade == 4 && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GET_ZXC_ITEM))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.GET_ZXC_ITEM,-45,"trainer.getZxcItemArrowPos","asset.trainer.getZxcItemTipAsset","trainer.getZxcItemTipPos",this);
            SocketManager.Instance.out.syncWeakStep(Step.GET_ZXC_ITEM);
         }
      }
      
      protected function __inviteClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._inviteFrame != null)
         {
            this.__onInviteComplete(null);
         }
         else
         {
            if(RoomManager.Instance.current.placeCount < 1)
            {
               if(RoomManager.Instance.current.players.length > 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
               }
               return;
            }
            this.startInvite();
         }
      }
      
      protected function startInvite() : void
      {
         if(!this._startInvite && this._inviteFrame == null)
         {
            this._startInvite = true;
            this.loadInviteRes();
         }
      }
      
      private function loadInviteRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.INVITE);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onInviteResComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.INVITE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
            if(this._startInvite && this._inviteFrame == null)
            {
               this._inviteFrame = ComponentFactory.Instance.creatComponentByStylename("InviteFrame");
               LayerManager.Instance.addToLayer(this._inviteFrame,LayerManager.GAME_BASE_LAYER);
               this._inviteFrame.addEventListener(Event.COMPLETE,this.__onInviteComplete);
               this._startInvite = false;
            }
         }
      }
      
      private function __onInviteComplete(param1:Event) : void
      {
         this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
         ObjectUtils.disposeObject(this._inviteFrame);
         this._inviteFrame = null;
      }
      
      private function __onInviteResError(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
      }
      
      protected function removeEvents() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomViewerItem = null;
         this._info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,this.__updatePlayerItems);
         this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,this.__updateState);
         this._info.removeEventListener(RoomEvent.ADD_PLAYER,this.__addPlayer);
         this._info.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__removePlayer);
         this._info.removeEventListener(RoomEvent.STARTED_CHANGED,this.__startHandler);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelClick);
         this._hostTimer.removeEventListener(TimerEvent.TIMER,this.__onHostTimer);
         this._normalTimer.removeEventListener(TimerEvent.TIMER,this.__onTimerII);
         this._prepareBtn.removeEventListener(MouseEvent.CLICK,this.__prepareClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(this.isViewerRoom)
         {
            _loc1_ = 0;
            while(_loc1_ < 2)
            {
               if(this._viewerItems && this._viewerItems[_loc1_])
               {
                  _loc2_ = this._viewerItems[_loc1_];
                  this._viewerItems[_loc1_].removeEventListener(RoomEvent.VIEWER_ITEM_INFO_SET,this.__switchClickEnabled);
               }
               _loc1_++;
            }
         }
      }
      
      private function updateTimer() : void
      {
         if(this._info.selfRoomPlayer.isHost && this._startBtn.buttonMode == !this._info.isAllReady())
         {
            this.resetHostTimer();
         }
         if(!this._info.selfRoomPlayer.isHost && this._prepareBtn.visible == this._info.selfRoomPlayer.isReady)
         {
            this.resetNormalTimer();
         }
      }
      
      protected function __updatePlayerItems(param1:RoomEvent) : void
      {
         var _loc3_:RoomPlayerItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._playerItems.length)
         {
            _loc3_ = this._playerItems[_loc2_] as RoomPlayerItem;
            _loc3_.opened = this._info.placesState[_loc2_] != 0;
            _loc2_++;
         }
         if(this.isViewerRoom)
         {
            if(this._viewerItems)
            {
               if(this._viewerItems[0])
               {
                  this._viewerItems[0].opened = this._info.placesState[8] != 0;
               }
               if(this._viewerItems[1])
               {
                  this._viewerItems[1].opened = this._info.placesState[9] != 0;
               }
            }
         }
         this.initPlayerItems();
         this.updateButtons();
      }
      
      protected function __updateState(param1:RoomEvent) : void
      {
         this.updateButtons();
         if(this._info.selfRoomPlayer.isHost)
         {
            this.startHostTimer();
            this.stopNormalTimer();
            if(!this._info.isAllReady() && this._info.started)
            {
               GameInSocketOut.sendCancelWait();
               this._info.started = false;
               SoundManager.instance.stop("007");
            }
            if(this._info.started)
            {
               MainToolBar.Instance.setRoomStartState();
            }
            else
            {
               MainToolBar.Instance.enableAll();
            }
         }
         else
         {
            this.stopHostTimer();
            this.startNormalTimer();
            if(this._info.selfRoomPlayer.isReady)
            {
               MainToolBar.Instance.setRoomStartState();
            }
            else if(!this._info.selfRoomPlayer.isViewer)
            {
               MainToolBar.Instance.enableAll();
            }
         }
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.BAG_ROOM);
         NewHandQueue.Instance.dispose();
      }
      
      protected function __addPlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.isFirstIn)
         {
            SoundManager.instance.play("158");
         }
         if(_loc2_.place >= 8)
         {
            this._viewerItems[_loc2_.place - 8].info = _loc2_;
         }
         else
         {
            this._playerItems[_loc2_.place].info = _loc2_;
         }
         this.updateButtons();
      }
      
      protected function __removePlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.place >= 8)
         {
            this._viewerItems[_loc2_.place - 8].info = null;
         }
         else
         {
            this._playerItems[_loc2_.place].info = null;
         }
         _loc2_.dispose();
         this.updateButtons();
      }
      
      protected function __startClick(param1:MouseEvent) : void
      {
         if(!this._info.isAllReady())
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.checkCanStartGame())
         {
            this.startGame();
            this._info.started = true;
         }
      }
      
      protected function __prepareClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         this.prepareGame();
      }
      
      protected function prepareGame() : void
      {
         GameInSocketOut.sendPlayerState(1);
      }
      
      protected function startGame() : void
      {
         this._startInvite = false;
         GameInSocketOut.sendGameStart();
      }
      
      protected function __cancelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._info.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendCancelWait();
         }
         else if(this._info.started)
         {
            GameInSocketOut.sendCancelWait();
         }
         else
         {
            GameInSocketOut.sendPlayerState(0);
         }
      }
      
      protected function checkCanStartGame() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this._info.selfRoomPlayer.isViewer)
         {
            return _loc1_;
         }
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      protected function academyDungeonAllow() : Boolean
      {
         var _loc2_:RoomPlayer = null;
         var _loc3_:RoomPlayer = null;
         var _loc1_:int = 0;
         if(RoomManager.Instance.current.players.length < 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
            return false;
         }
         for each(_loc2_ in RoomManager.Instance.current.players)
         {
            if(_loc2_.playerInfo.apprenticeshipState == AcademyManager.NONE_STATE && !_loc2_.isViewer)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning1"));
               return false;
            }
            if((_loc2_.playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || _loc2_.playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE || _loc2_.playerInfo.apprenticeshipState == AcademyManager.APPRENTICE_STATE) && !_loc2_.isViewer)
            {
               _loc1_++;
            }
         }
         if(_loc1_ < 2)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning4"));
            return false;
         }
         _loc1_ = 0;
         for each(_loc3_ in RoomManager.Instance.current.players)
         {
            if((_loc3_.playerInfo.apprenticeshipState == AcademyManager.MASTER_STATE || _loc3_.playerInfo.apprenticeshipState == AcademyManager.MASTER_FULL_STATE) && !_loc3_.isViewer)
            {
               _loc1_++;
               if(_loc1_ > 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning3"));
                  return false;
               }
            }
         }
         if(_loc1_ == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.roomStart.academy.warning2"));
            return false;
         }
         return true;
      }
      
      protected function __startHandler(param1:RoomEvent) : void
      {
         this.updateButtons();
         if(this._info.started)
         {
            this.stopHostTimer();
            MainToolBar.Instance.setRoomStartState();
            SoundManager.instance.stop("007");
         }
         else
         {
            if(this._info.selfRoomPlayer.isHost && this._info.isAllReady())
            {
               this.startHostTimer();
            }
            if(this._info.selfRoomPlayer.isHost)
            {
               MainToolBar.Instance.enableAll();
            }
            else
            {
               if(this._info.selfRoomPlayer.isViewer)
               {
                  MainToolBar.Instance.setRoomStartState();
                  MainToolBar.Instance.setReturnEnable(true);
                  return;
               }
               if(this._info.selfRoomPlayer.isReady)
               {
                  MainToolBar.Instance.setRoomStartState();
               }
               else
               {
                  MainToolBar.Instance.enableAll();
               }
            }
         }
      }
      
      protected function startHostTimer() : void
      {
         if(!this._hostTimer.running)
         {
            this._hostTimer.start();
            this._hostTimer.addEventListener(TimerEvent.TIMER,this.__onHostTimer);
         }
      }
      
      protected function startNormalTimer() : void
      {
         if(!this._normalTimer.running)
         {
            this._normalTimer.start();
            this._normalTimer.addEventListener(TimerEvent.TIMER,this.__onTimerII);
         }
      }
      
      protected function stopHostTimer() : void
      {
         this._hostTimer.reset();
         this._hostTimer.removeEventListener(TimerEvent.TIMER,this.__onHostTimer);
         SoundManager.instance.stop("007");
      }
      
      protected function stopNormalTimer() : void
      {
         this._normalTimer.reset();
         this._normalTimer.removeEventListener(TimerEvent.TIMER,this.__onTimerII);
         SoundManager.instance.stop("007");
      }
      
      protected function resetHostTimer() : void
      {
         this.stopHostTimer();
         this.startHostTimer();
         SoundManager.instance.stop("007");
      }
      
      protected function resetNormalTimer() : void
      {
         this.stopNormalTimer();
         this.startNormalTimer();
         SoundManager.instance.stop("007");
      }
      
      protected function __onTimerII(param1:TimerEvent) : void
      {
         if(!this._info.selfRoomPlayer.isHost && !this._info.selfRoomPlayer.isViewer)
         {
            if(this._normalTimer.currentCount >= HURRY_UP_TIME && !this._info.selfRoomPlayer.isReady)
            {
               if(!TaskManager.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      protected function __onHostTimer(param1:TimerEvent) : void
      {
         if(this._info.selfRoomPlayer.isHost && !this._info.isOpenBoss && !this._info.mapId == 12016)
         {
            if(this._hostTimer.currentCount >= KICK_TIMEIII && this._info.players.length - this._info.currentViewerCnt > 1)
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount >= KICK_TIMEII && this._info.players.length - this._info.currentViewerCnt == 1)
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount >= KICK_TIME && this._info.players.length - this._info.currentViewerCnt > 1 && this._info.currentViewerCnt == 0 && this._info.isAllReady())
            {
               this.kickHandler();
            }
            else if(this._hostTimer.currentCount == KICK_TIMEIII - 30 && this._info.players.length - this._info.currentViewerCnt > 1 || this._hostTimer.currentCount == KICK_TIMEII - 30 && this._info.players.length - this._info.currentViewerCnt == 1 || this._hostTimer.currentCount == KICK_TIME - 30 && this._info.players.length - this._info.currentViewerCnt > 1 && this._info.currentViewerCnt == 0 && this._info.isAllReady())
            {
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.Timeout"));
            }
            else if(this._hostTimer.currentCount >= HURRY_UP_TIME && this._info.isAllReady())
            {
               if(!TaskManager.isShow)
               {
                  if(!SoundManager.instance.isPlaying("007"))
                  {
                     SoundManager.instance.play("007",false,true);
                  }
               }
               else
               {
                  SoundManager.instance.stop("007");
               }
            }
         }
      }
      
      protected function kickHandler() : void
      {
         ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.room.RoomIIView2.kick"));
         if(this._info.type == RoomInfo.DUNGEON_ROOM || this._info.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._info.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
         else
         {
            StateManager.setState(StateType.ROOM_LIST);
         }
         PlayerManager.Instance.Self.unlockAllBag();
      }
      
      public function dispose() : void
      {
         var _loc1_:RoomPlayerItem = null;
         var _loc2_:RoomViewerItem = null;
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_ZXC_ITEM);
         this.removeEvents();
         this._roomPropView.dispose();
         this._roomPropView = null;
         if(this._startBtn.parent)
         {
            this._startBtn.parent.removeChild(this._startBtn);
         }
         this._startBtn.stop();
         this._startBtn = null;
         if(this._prepareBtn.parent)
         {
            this._prepareBtn.parent.removeChild(this._prepareBtn);
         }
         this._prepareBtn.stop();
         this._cancelBtn.dispose();
         this._cancelBtn = null;
         this._inviteBtn.dispose();
         this._inviteBtn = null;
         if(this._inviteFrame)
         {
            this._inviteFrame.dispose();
         }
         this._inviteFrame = null;
         if(this._viewerItems)
         {
            for each(_loc2_ in this._viewerItems)
            {
               _loc2_.dispose();
               _loc2_ = null;
            }
         }
         this._viewerItems = null;
         for each(_loc1_ in this._playerItems)
         {
            _loc1_.dispose();
         }
         this._playerItems = null;
         this._hostTimer.stop();
         this._hostTimer = null;
         this._normalTimer.stop();
         this._normalTimer = null;
         this._info = null;
         SoundManager.instance.stop("007");
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
