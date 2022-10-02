package room.view.roomView
{
   import LimitAward.LimitAwardButton;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QueueManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.RoomPlayerItem;
   import room.view.bigMapInfoPanel.MatchRoomBigMapInfoPanel;
   import room.view.smallMapInfoPanel.MatchRoomSmallMapInfoPanel;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import trainer.view.VaneTipView;
   import league.manager.LeagueManager;
   import com.pickgliss.ui.text.FilterFrameText;
   
   public class MatchRoomView extends BaseRoomView
   {
      
      private static const MATCH_NPC:int = 40;
      
      private static const BOTH_MODE_ALERT_TIME:int = 60;
      
      private static const DISABLE_RETURN:int = 20;
      
      private static const MATCH_NPC_ENABLE:Boolean = false;
       
      
      private var _bigMapInfoPanel:MatchRoomBigMapInfoPanel;
      
      private var _smallMapInfoPanel:MatchRoomSmallMapInfoPanel;
      
      private var _rightBg:Scale9CornerImage;
      
      private var _playerItemContainer:SimpleTileList;
      
      private var _crossZoneBtn:SelectedButton;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _timerII:Timer;
      
      private var _alert1:BaseAlerFrame;
      
      private var _alert2:BaseAlerFrame;
	  
	  private var _leagueTxt:FilterFrameText;
      
      public function MatchRoomView(param1:RoomInfo)
      {
         this._timerII = new Timer(1000);
         super(param1);
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.addEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.addEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.addEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.addEventListener(TimerEvent.TIMER,this.__onTimer);
         addEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         EliteGameController.Instance.addEventListener(EliteGameEvent.READY_TIME_OVER,this.__eliteTimeHandler);
      }
      
      protected function __eliteTimeHandler(param1:EliteGameEvent) : void
      {
         __startClick(null);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_NPC,this.__onFightNpc);
         _info.removeEventListener(RoomEvent.ALLOW_CROSS_CHANGE,this.__crossZoneChangeHandler);
         this._bigMapInfoPanel.removeEventListener(RoomEvent.TWEENTY_SEC,this.__onTweentySec);
         this._crossZoneBtn.removeEventListener(MouseEvent.CLICK,this.__crossZoneClick);
         this._timerII.removeEventListener(TimerEvent.TIMER,this.__onTimer);
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         EliteGameController.Instance.removeEventListener(EliteGameEvent.READY_TIME_OVER,this.__eliteTimeHandler);
         if(this._alert1)
         {
            this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(this._alert2)
         {
            this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         }
      }
      
      private function __loadWeakGuild(param1:Event) : void
      {
         var _loc2_:VaneTipView = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__loadWeakGuild);
         if(!WeakGuildManager.Instance.switchUserGuide)
         {
            return;
         }
         this.showStart();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_TIP) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VANE_OPEN))
         {
            _loc2_ = ComponentFactory.Instance.creat("trainer.vane.mainFrame");
            _loc2_.show();
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHALLENGE_TIP) && PlayerManager.Instance.Self.Grade >= 12)
         {
            this.userGuideAlert(Step.CHALLENGE_TIP,"room.view.roomView.MatchRoomView.challengeTip");
         }
      }
      
      private function showStart() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.START_GAME_TIP))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.START_GAME,-45,"trainer.startGameArrowPos","asset.trainer.startGameTipAsset","trainer.startGameTipPos",this);
         }
      }
      
      private function showWait() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.START_GAME_TIP))
         {
            NewHandContainer.Instance.clearArrowByID(-1);
            NewHandContainer.Instance.showArrow(ArrowType.WAIT_GAME,-45,"trainer.startGameArrowPos","asset.trainer.txtWait","trainer.startGameTipPos",this);
         }
      }
      
      private function userGuideAlert(param1:int, param2:String) : void
      {
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(param2),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__responseTip);
         SocketManager.Instance.out.syncWeakStep(param1);
      }
      
      private function __responseTip(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__responseTip);
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __crossZoneChangeHandler(param1:RoomEvent) : void
      {
         this._crossZoneBtn.selected = _info.isCrossZone;
         if(_info.isCrossZone)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.kuaqu"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView.cross.benqu"));
         }
      }
      
      private function __onTweentySec(param1:RoomEvent) : void
      {
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            return;
         }
         _cancelBtn.enable = true;
      }
      
      private function __onTimer(param1:TimerEvent) : void
      {
         if(MATCH_NPC_ENABLE && this._timerII.currentCount == MATCH_NPC && _info.selfRoomPlayer.isHost)
         {
            this.showMatchNpc();
         }
         if((_info.gameMode == RoomInfo.GUILD_MODE || _info.gameMode == RoomInfo.GUILD_LEAGE_MODE) && this._timerII.currentCount == BOTH_MODE_ALERT_TIME && _info.selfRoomPlayer.isHost)
         {
            this.showBothMode();
         }
      }
      
      private function showMatchNpc() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc1_.data = LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle");
         this._alert1 = AlertManager.Instance.alert("SimpleAlert",_loc1_,LayerManager.ALPHA_BLOCKGOUND);
         this._alert1.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:ChatData = null;
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            _loc2_ = new ChatData();
            _loc2_.channel = ChatInputView.SYS_TIP;
            _loc2_.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(_loc2_);
         }
         this._alert1.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._alert1.dispose();
      }
      
      override protected function __startHandler(param1:RoomEvent) : void
      {
         super.__startHandler(param1);
         NewHandContainer.Instance.clearArrowByID(-1);
         if(_info.started)
         {
            this._timerII.start();
            this.showWait();
         }
         else
         {
            this._timerII.stop();
            this._timerII.reset();
            this.showStart();
         }
      }
      
      private function showBothMode() : void
      {
         this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.PickupPanel.ChangeStyle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._alert2.addEventListener(FrameEvent.RESPONSE,this.__onResponseII);
      }
      
      private function __onResponseII(param1:FrameEvent) : void
      {
         var _loc2_:ChatData = null;
         SoundManager.instance.play("008");
         this._alert2.removeEventListener(FrameEvent.RESPONSE,this.__onResponseII);
         this._alert2.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendGameStyle(2);
            _loc2_ = new ChatData();
            _loc2_.channel = ChatInputView.SYS_TIP;
            _loc2_.msg = LanguageMgr.GetTranslation("tank.room.UpdateGameStyle");
            ChatManager.Instance.chat(_loc2_);
         }
      }
      
      private function __crossZoneClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendGameRoomSetUp(_info.mapId,_info.type,false,_info.roomPass,_info.roomName,3,0,0,!_info.isCrossZone,0);
         this._crossZoneBtn.selected = _info.isCrossZone;
      }
      
      private function __onFightNpc(param1:CrazyTankSocketEvent) : void
      {
         this.showMatchNpc();
      }
      
      override protected function updateButtons() : void
      {
         super.updateButtons();
         this._crossZoneBtn.enable = _info.selfRoomPlayer.isHost && !_info.started;
         this._smallMapInfoPanel._actionStatus = _info.selfRoomPlayer.isHost && !_info.started && _info.type != RoomInfo.RANK_ROOM && _info.type != RoomInfo.SCORE_ROOM;
         if(_info.type == RoomInfo.SCORE_ROOM || _info.type == RoomInfo.RANK_ROOM)
         {
            _inviteBtn.enable = false;
            this._crossZoneBtn.enable = false;
         }
         if(_info.type == RoomInfo.RANK_ROOM)
         {
            _startBtn.removeEventListener(MouseEvent.CLICK,__startClick);
            _startBtn.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            _startBtn.gotoAndStop(1);
            _startBtn.buttonMode = false;
            _prepareBtn.enabled = false;
            _cancelBtn.enable = false;
         }
      }
      
      override protected function initView() : void
      {
         if(QueueManager.facebookResumeEnable)
         {
            QueueManager.resumeFaceBookFeed();
         }
         this._bigMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.matchRoomBigMapInfoPanel");
         this._bigMapInfoPanel.info = _info;
         addChild(this._bigMapInfoPanel);
         this._smallMapInfoPanel = ComponentFactory.Instance.creatCustomObject("room.matchRoomSmallMapInfoPanel");
         this._smallMapInfoPanel.info = _info;
         addChild(this._smallMapInfoPanel);
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("asset.room.roomBg");
         addChild(this._rightBg);
         this._crossZoneBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.crossZoneButton");
         this._crossZoneBtn.selected = _info.isCrossZone;
         addChild(this._crossZoneBtn);
         if(BossBoxManager.instance.isShowBoxButton())
         {
            this._boxButton = new SmallBoxButton(SmallBoxButton.PVP_ROOM_POINT);
            addChild(this._boxButton);
         }
		 if(LeagueManager.instance.maxCount != -1 && PlayerManager.Instance.Self.Grade >= 20)
		 {
			 this._leagueTxt = ComponentFactory.Instance.creatComponentByStylename("league.restCount.tipTxt");
			 this._leagueTxt.text = LanguageMgr.GetTranslation("ddt.league.restCountTipTxt",LeagueManager.instance.restCount.toString(),LeagueManager.instance.maxCount.toString());
			 addChild(this._leagueTxt);
		 }
         if(CalendarManager.getInstance().checkEventInfo() && PlayerManager.Instance.Self.Grade >= 8)
         {
            if(!this._limitAwardButton)
            {
               this._limitAwardButton = new LimitAwardButton(LimitAwardButton.PVP_ROOM_POINT);
               addChild(this._limitAwardButton);
            }
         }
         super.initView();
      }
      
      override protected function initTileList() : void
      {
         var _loc2_:Point = null;
         var _loc4_:RoomPlayerItem = null;
         super.initTileList();
         this._playerItemContainer = new SimpleTileList(2);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("room.matchRoom.listSpace");
         this._playerItemContainer.hSpace = _loc1_.x;
         this._playerItemContainer.vSpace = _loc1_.y;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("asset.room.playerListPos");
         this._playerItemContainer.x = this._rightBg.x + _loc2_.x;
         this._playerItemContainer.y = this._rightBg.y + _loc2_.y;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc4_ = new RoomPlayerItem(_loc3_);
            this._playerItemContainer.addChild(_loc4_);
            _playerItems.push(_loc4_);
            _loc3_++;
         }
         addChild(this._playerItemContainer);
         if(isViewerRoom)
         {
            PositionUtils.setPos(_viewerItems[0],"asset.matchroom.ViewerItemPos");
            addChild(_viewerItems[0]);
         }
      }
      
      override protected function __addPlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.isFirstIn)
         {
            SoundManager.instance.play("158");
         }
         if(_loc2_.isViewer)
         {
            _viewerItems[_loc2_.place - 8].info = _loc2_;
         }
         else
         {
            _playerItems[_loc2_.place].info = _loc2_;
         }
         this.updateButtons();
      }
      
      override protected function __removePlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         if(_loc2_.place >= 8)
         {
            _viewerItems[_loc2_.place - 8].info = null;
         }
         else
         {
            _playerItems[_loc2_.place].info = null;
         }
         _loc2_.dispose();
         this.updateButtons();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._boxButton)
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         if(this._limitAwardButton)
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         this._boxButton = null;
         this._bigMapInfoPanel.dispose();
         this._bigMapInfoPanel = null;
         this._smallMapInfoPanel.dispose();
         this._smallMapInfoPanel = null;
         this._rightBg.dispose();
         this._rightBg = null;
         this._playerItemContainer.dispose();
         this._playerItemContainer = null;
         this._crossZoneBtn.dispose();
         this._crossZoneBtn = null;
         if(this._alert1)
         {
            this._alert1.dispose();
         }
         this._alert1 = null;
         if(this._alert2)
         {
            this._alert2.dispose();
         }
         this._alert2 = null;
		 if(this._leagueTxt)
		 {
			 ObjectUtils.disposeObject(this._leagueTxt);
		 }
		 this._leagueTxt = null;
      }
   }
}
